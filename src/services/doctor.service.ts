import * as doctorRepository from '../repositories/doctor.repository';
import { HttpError } from '../utils/HttpError';
import { Doctor, FilterDoctorsInput } from '../types';

export const getDoctors = async (filters?: FilterDoctorsInput): Promise<Doctor[]> => {
  if (filters?.locationId && filters?.specialtyId) {
    throw new HttpError(400, 'Solo se permite filtrar por ubicación O especialidad, no ambos');
  }
  return doctorRepository.findAll(filters);
};

export const getDoctorById = async (id: number): Promise<Doctor | null> => {
  return doctorRepository.findById(id);
};

export const getMyProfile = async (userId: number): Promise<Doctor | null> => {
  return doctorRepository.findByUserId(userId);
};

export const updateMyProfile = async (userId: number, data: { id_especialidad?: number; numero_colegiado?: string | null; tarifa_consulta?: number | null }): Promise<Doctor | null> => {
  const doctor = await doctorRepository.findByUserId(userId);
  if (!doctor) {
    throw new HttpError(404, 'Perfil de doctor no encontrado');
  }

  const updated = await doctorRepository.updateDoctor(doctor.id_doctor, data);
  if (!updated) {
    throw new HttpError(400, 'No se proporcionaron datos para actualizar');
  }

  return doctorRepository.findByUserId(userId);
};

export const updateMyClinic = async (userId: number, data: { clinicNombre?: string; clinicLocationId?: number; clinicZona?: number; clinicDireccion?: string; clinicTelefono?: string | null; clinicWhatsapp?: string }): Promise<Doctor | null> => {
  const doctor = await doctorRepository.findByUserId(userId);
  if (!doctor) {
    throw new HttpError(404, 'Perfil de doctor no encontrado');
  }

  const clinicData = {
    nombre: data.clinicNombre,
    id_location: data.clinicLocationId,
    zona: data.clinicZona,
    direccion: data.clinicDireccion,
    telefono: data.clinicTelefono,
    whatsapp: data.clinicWhatsapp,
  };

  const updated = await doctorRepository.updateClinic(doctor.id_clinica, clinicData);
  if (!updated) {
    throw new HttpError(400, 'No se proporcionaron datos para actualizar');
  }

  return doctorRepository.findByUserId(userId);
};

export const getSpecialties = async () => doctorRepository.getSpecialties();
export const getLocations = async () => doctorRepository.getLocations();