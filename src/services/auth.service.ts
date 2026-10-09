import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import * as userRepository from '../repositories/user.repository';
import * as doctorRepository from '../repositories/doctor.repository';
import { HttpError } from '../utils/HttpError';
import { env } from '../config/env';
import { LoginResult, PublicUser, RegisterDoctorData } from '../types';

const hashPassword = async (password: string): Promise<string> => {
  return bcrypt.hash(password, 10);
};

export const login = async (email: string, password: string): Promise<LoginResult> => {
  const user = await userRepository.findByEmail(email);

  if (!user || !(await bcrypt.compare(password, user.password))) {
    throw new HttpError(401, 'Credenciales inválidas');
  }

  const doctor = await userRepository.findDoctorByUserId(user.id_usuario);
  const role: 'user' | 'doctor' = doctor ? 'doctor' : 'user';

  const token = jwt.sign(
    { sub: user.id_usuario, role, doctorId: doctor?.id_doctor },
    env.JWT_SECRET,
    { expiresIn: env.JWT_EXPIRES_IN as jwt.SignOptions['expiresIn'] }
  );

  return {
    token,
    user: {
      id_usuario: user.id_usuario,
      nombre: user.nombre,
      apellido: user.apellido,
      fecha_nacimiento: user.fecha_nacimiento,
      email: user.email,
      activo: user.activo,
      role,
      doctorId: doctor?.id_doctor,
    },
  };
};

export const registerUser = async (data: { nombre: string; apellido: string; fecha_nacimiento: string; email: string; password: string }): Promise<LoginResult> => {
  const existing = await userRepository.findByEmail(data.email);
  if (existing) {
    throw new HttpError(409, 'El email ya está registrado');
  }

  const passwordHash = await hashPassword(data.password);
  const userId = await userRepository.createUserOnly({
    nombre: data.nombre,
    apellido: data.apellido,
    fecha_nacimiento: data.fecha_nacimiento,
    email: data.email,
    password: passwordHash,
  });

  const user = await userRepository.findById(userId);
  if (!user) throw new HttpError(500, 'Error al crear usuario');

  const token = jwt.sign(
    { sub: user.id_usuario, role: 'user' },
    env.JWT_SECRET,
    { expiresIn: env.JWT_EXPIRES_IN as jwt.SignOptions['expiresIn'] }
  );

  return { token, user: { ...user, role: 'user' } };
};

export const registerDoctor = async (data: RegisterDoctorData): Promise<LoginResult> => {
  const existing = await userRepository.findByEmail(data.email);
  if (existing) {
    throw new HttpError(409, 'El email ya está registrado');
  }

  if (!(await doctorRepository.specialtyExists(data.id_especialidad))) {
    throw new HttpError(400, 'La especialidad seleccionada no es válida');
  }
  if (!(await doctorRepository.locationExists(data.clinicLocationId))) {
    throw new HttpError(400, 'La ubicación seleccionada no es válida');
  }

  const passwordHash = await hashPassword(data.password);
  const result = await userRepository.createDoctorWithClinic({
    ...data,
    password: passwordHash,
  });

  const user = await userRepository.findById(result.userId);
  if (!user) throw new HttpError(500, 'Error al crear doctor');

  const token = jwt.sign(
    { sub: user.id_usuario, role: 'doctor', doctorId: result.doctorId },
    env.JWT_SECRET,
    { expiresIn: env.JWT_EXPIRES_IN as jwt.SignOptions['expiresIn'] }
  );

  return { token, user: { ...user, role: 'doctor', doctorId: result.doctorId } };
};

export const getMe = async (userId: number): Promise<(PublicUser & { role: 'user' | 'doctor'; doctorId?: number }) | null> => {
  const user = await userRepository.findById(userId);
  if (!user) return null;

  const doctor = await userRepository.findDoctorByUserId(userId);
  return {
    ...user,
    role: doctor ? 'doctor' : 'user',
    doctorId: doctor?.id_doctor,
  };
};