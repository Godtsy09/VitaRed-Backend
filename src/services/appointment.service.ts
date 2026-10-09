import { pool } from '../config/database';
import * as appointmentRepository from '../repositories/appointment.repository';
import * as doctorRepository from '../repositories/doctor.repository';
import { HttpError } from '../utils/HttpError';
import { formatDateTimeForMySQL } from '../utils/date.utils';

const isDuplicateEntry = (error: unknown): boolean =>
  typeof error === 'object' &&
  error !== null &&
  (error as { code?: string }).code === 'ER_DUP_ENTRY';

export const createAppointment = async (patientId: number, data: { id_doctor: number; fecha_hora_inicio: string; motivo?: string | null }): Promise<number> => {
  const doctor = await doctorRepository.findById(data.id_doctor);
  if (!doctor) {
    throw new HttpError(404, 'Doctor no encontrado');
  }
  if (!doctor.activo || !doctor.usuario?.activo || !doctor.clinica?.activo) {
    throw new HttpError(400, 'El doctor no está disponible');
  }

  const schedules = await appointmentRepository.findDoctorSchedules(data.id_doctor);
  if (schedules.length === 0) {
    throw new HttpError(400, 'El doctor no tiene horarios configurados');
  }

  const fechaHoraInicio = formatDateTimeForMySQL(data.fecha_hora_inicio);

  if (new Date(fechaHoraInicio).getTime() <= Date.now()) {
    throw new HttpError(400, 'La fecha y hora de la cita deben ser posteriores a ahora');
  }

  const isAvailable = await appointmentRepository.checkAvailability(data.id_doctor, fechaHoraInicio, schedules);
  if (!isAvailable) {
    throw new HttpError(409, 'El horario no está disponible');
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    const appointmentId = await appointmentRepository.create(conn, {
      id_doctor: data.id_doctor,
      id_paciente: patientId,
      fecha_hora_inicio: fechaHoraInicio,
      motivo: data.motivo ?? null,
    });
    await conn.commit();
    return appointmentId;
  } catch (error) {
    await conn.rollback();
    if (isDuplicateEntry(error)) {
      throw new HttpError(409, 'El horario no está disponible');
    }
    throw error;
  } finally {
    conn.release();
  }
};

export const getMyAppointments = async (patientId: number) => {
  return appointmentRepository.findByPatientId(patientId);
};

export const getAppointmentsForDoctorUser = async (doctorUserId: number) => {
  const doctor = await doctorRepository.findByUserId(doctorUserId);
  if (!doctor) {
    throw new HttpError(404, 'Perfil de doctor no encontrado');
  }
  return appointmentRepository.findByDoctorId(doctor.id_doctor);
};

export const updateStatus = async (doctorUserId: number, appointmentId: number, estado: 'CANCELADA' | 'ATENDIDA'): Promise<boolean> => {
  const appointment = await appointmentRepository.findById(appointmentId);
  if (!appointment) {
    throw new HttpError(404, 'Cita no encontrada');
  }

  const doctor = await doctorRepository.findByUserId(doctorUserId);
  if (!doctor) {
    throw new HttpError(404, 'Perfil de doctor no encontrado');
  }

  if (appointment.id_doctor !== doctor.id_doctor) {
    throw new HttpError(403, 'No tienes permisos para modificar esta cita');
  }

  if (appointment.estado !== 'PROGRAMADA') {
    throw new HttpError(400, 'Solo se pueden modificar citas en estado PROGRAMADA');
  }

  return appointmentRepository.updateStatus(appointmentId, estado);
};