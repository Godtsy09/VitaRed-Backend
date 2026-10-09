import type { RowDataPacket, ResultSetHeader, Connection } from 'mysql2/promise';
import { pool } from '../config/database';
import { User, PublicUser, RegisterDoctorData } from '../types';

interface UserRow extends RowDataPacket {
  id_usuario: number;
  nombre: string;
  apellido: string;
  fecha_nacimiento: string;
  email: string;
  password: string;
  activo: boolean;
}

interface DoctorRow extends RowDataPacket {
  id_doctor: number;
  id_usuario: number;
  id_clinica: number;
  id_especialidad: number;
  numero_colegiado: string | null;
  tarifa_consulta: number | null;
  activo: boolean;
}

export const findByEmail = async (email: string): Promise<User | null> => {
  const [rows] = await pool.query<UserRow[]>(
    `SELECT id_usuario, nombre, apellido, fecha_nacimiento, email, password, activo
     FROM usuario WHERE email = ? AND activo = TRUE`,
    [email]
  );
  return rows[0] ?? null;
};

export const findById = async (id: number): Promise<PublicUser | null> => {
  const [rows] = await pool.query<UserRow[]>(
    `SELECT id_usuario, nombre, apellido, fecha_nacimiento, email, activo
     FROM usuario WHERE id_usuario = ? AND activo = TRUE`,
    [id]
  );
  return rows[0] ?? null;
};

export const findDoctorByUserId = async (userId: number): Promise<DoctorRow | null> => {
  const [rows] = await pool.query<DoctorRow[]>(
    `SELECT id_doctor, id_usuario, id_clinica, id_especialidad, numero_colegiado, tarifa_consulta, activo
     FROM doctor WHERE id_usuario = ? AND activo = TRUE`,
    [userId]
  );
  return rows[0] ?? null;
};

export const createUser = async (
  conn: Connection,
  data: Omit<User, 'id_usuario' | 'activo'>
): Promise<number> => {
  const [result] = await conn.execute<ResultSetHeader>(
    `INSERT INTO usuario (nombre, apellido, fecha_nacimiento, email, password, activo)
     VALUES (?, ?, ?, ?, ?, TRUE)`,
    [data.nombre, data.apellido, data.fecha_nacimiento, data.email, data.password]
  );
  return result.insertId;
};

export const createUserOnly = async (data: Omit<User, 'id_usuario' | 'activo'>): Promise<number> => {
  const [result] = await pool.execute<ResultSetHeader>(
    `INSERT INTO usuario (nombre, apellido, fecha_nacimiento, email, password, activo)
     VALUES (?, ?, ?, ?, ?, TRUE)`,
    [data.nombre, data.apellido, data.fecha_nacimiento, data.email, data.password]
  );
  return result.insertId;
};

interface ClinicCreateData {
  nombre: string;
  id_location: number;
  zona: number;
  direccion: string;
  telefono: string | null;
  whatsapp: string;
}

export const createClinic = async (
  conn: Connection,
  data: ClinicCreateData
): Promise<number> => {
  const [result] = await conn.execute<ResultSetHeader>(
    `INSERT INTO clinica (nombre, id_location, zona, direccion, telefono, whatsapp, activo)
     VALUES (?, ?, ?, ?, ?, ?, TRUE)`,
    [data.nombre, data.id_location, data.zona, data.direccion, data.telefono, data.whatsapp]
  );
  return result.insertId;
};

export const createDoctor = async (
  conn: Connection,
  data: { id_usuario: number; id_clinica: number; id_especialidad: number; numero_colegiado: string | null; tarifa_consulta: number | null }
): Promise<number> => {
  const [result] = await conn.execute<ResultSetHeader>(
    `INSERT INTO doctor (id_usuario, id_clinica, id_especialidad, numero_colegiado, tarifa_consulta, activo)
     VALUES (?, ?, ?, ?, ?, TRUE)`,
    [data.id_usuario, data.id_clinica, data.id_especialidad, data.numero_colegiado, data.tarifa_consulta]
  );
  return result.insertId;
};

export const createDoctorWithClinic = async (data: RegisterDoctorData): Promise<{ userId: number; doctorId: number; clinicId: number }> => {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const userId = await createUser(conn, {
      nombre: data.nombre,
      apellido: data.apellido,
      fecha_nacimiento: data.fecha_nacimiento,
      email: data.email,
      password: data.password,
    });

    const clinicId = await createClinic(conn, {
      nombre: data.clinicNombre,
      id_location: data.clinicLocationId,
      zona: data.clinicZona,
      direccion: data.clinicDireccion,
      telefono: data.clinicTelefono ?? null,
      whatsapp: data.clinicWhatsapp,
    });

    const doctorId = await createDoctor(conn, {
      id_usuario: userId,
      id_clinica: clinicId,
      id_especialidad: data.id_especialidad,
      numero_colegiado: data.numero_colegiado ?? null,
      tarifa_consulta: data.tarifa_consulta ?? null,
    });

    await conn.commit();
    return { userId, doctorId, clinicId };
  } catch (error) {
    await conn.rollback();
    throw error;
  } finally {
    conn.release();
  }
};

