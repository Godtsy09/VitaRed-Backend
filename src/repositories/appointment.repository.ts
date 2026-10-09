import type { RowDataPacket, ResultSetHeader, Connection } from 'mysql2/promise';
import { pool } from '../config/database';
import { Appointment, DoctorSchedule } from '../types';
import { isWithinSchedule } from '../utils/date.utils';

interface AppointmentRow extends RowDataPacket {
  id_cita: number;
  id_doctor: number;
  id_paciente: number;
  fecha_hora_inicio: string;
  motivo: string | null;
  estado: 'PROGRAMADA' | 'CANCELADA' | 'ATENDIDA';
}

interface AppointmentDetailRow extends RowDataPacket {
  id_cita: number;
  id_doctor: number;
  id_paciente: number;
  fecha_hora_inicio: string;
  motivo: string | null;
  estado: 'PROGRAMADA' | 'CANCELADA' | 'ATENDIDA';
  doctor_nombre: string;
  doctor_apellido: string;
  doctor_especialidad: string;
  doctor_clinic_name: string;
  doctor_clinic_city: string;
  doctor_clinic_department: string;
  paciente_nombre: string;
  paciente_apellido: string;
  paciente_email: string;
}

export const create = async (
  conn: Connection,
  data: { id_doctor: number; id_paciente: number; fecha_hora_inicio: string; motivo: string | null }
): Promise<number> => {
  const [result] = await conn.execute<ResultSetHeader>(
    `INSERT INTO cita (id_doctor, id_paciente, fecha_hora_inicio, motivo, estado)
     VALUES (?, ?, ?, ?, 'PROGRAMADA')`,
    [data.id_doctor, data.id_paciente, data.fecha_hora_inicio, data.motivo]
  );
  return result.insertId;
};

export const findById = async (id: number): Promise<Appointment | null> => {
  const [rows] = await pool.query<AppointmentDetailRow[]>(
    `SELECT c.id_cita, c.id_doctor, c.id_paciente, c.fecha_hora_inicio, c.motivo, c.estado,
            d.id_doctor, u.nombre AS doctor_nombre, u.apellido AS doctor_apellido,
            e.especialidad AS doctor_especialidad,
            cl.nombre AS doctor_clinic_name, l.city AS doctor_clinic_city, l.department AS doctor_clinic_department,
            p.nombre AS paciente_nombre, p.apellido AS paciente_apellido, p.email AS paciente_email
     FROM cita c
     JOIN doctor d ON d.id_doctor = c.id_doctor
     JOIN usuario u ON u.id_usuario = d.id_usuario
     JOIN especialidad e ON e.id_especialidad = d.id_especialidad
     JOIN clinica cl ON cl.id_clinica = d.id_clinica
     JOIN locations l ON l.id = cl.id_location
     JOIN usuario p ON p.id_usuario = c.id_paciente
     WHERE c.id_cita = ?`,
    [id]
  );

  if (rows.length === 0) return null;

  const row = rows[0];
  return {
    id_cita: row.id_cita,
    id_doctor: row.id_doctor,
    id_paciente: row.id_paciente,
    fecha_hora_inicio: row.fecha_hora_inicio,
    motivo: row.motivo,
    estado: row.estado,
    doctor: {
      id_doctor: row.id_doctor,
      id_usuario: 0,
      id_clinica: 0,
      id_especialidad: 0,
      numero_colegiado: null,
      tarifa_consulta: null,
      activo: true,
      especialidad: { id_especialidad: 0, especialidad: row.doctor_especialidad },
      clinica: { id_clinica: 0, nombre: row.doctor_clinic_name, id_location: 0, zona: 0, direccion: '', telefono: null, whatsapp: '', activo: true, city: row.doctor_clinic_city, department: row.doctor_clinic_department },
      usuario: { id_usuario: 0, nombre: row.doctor_nombre, apellido: row.doctor_apellido, fecha_nacimiento: '', email: '', activo: true },
    },
    paciente: {
      id_usuario: row.id_paciente,
      nombre: row.paciente_nombre,
      apellido: row.paciente_apellido,
      fecha_nacimiento: '',
      email: row.paciente_email,
      activo: true,
    },
  };
};

export const findByPatientId = async (patientId: number): Promise<Appointment[]> => {
  const [rows] = await pool.query<AppointmentDetailRow[]>(
    `SELECT c.id_cita, c.id_doctor, c.id_paciente, c.fecha_hora_inicio, c.motivo, c.estado,
            d.id_doctor, u.nombre AS doctor_nombre, u.apellido AS doctor_apellido,
            e.especialidad AS doctor_especialidad,
            cl.nombre AS doctor_clinic_name, l.city AS doctor_clinic_city, l.department AS doctor_clinic_department,
            p.nombre AS paciente_nombre, p.apellido AS paciente_apellido, p.email AS paciente_email
     FROM cita c
     JOIN doctor d ON d.id_doctor = c.id_doctor
     JOIN usuario u ON u.id_usuario = d.id_usuario
     JOIN especialidad e ON e.id_especialidad = d.id_especialidad
     JOIN clinica cl ON cl.id_clinica = d.id_clinica
     JOIN locations l ON l.id = cl.id_location
     JOIN usuario p ON p.id_usuario = c.id_paciente
     WHERE c.id_paciente = ?
     ORDER BY c.fecha_hora_inicio DESC`,
    [patientId]
  );

  return rows.map((row) => ({
    id_cita: row.id_cita,
    id_doctor: row.id_doctor,
    id_paciente: row.id_paciente,
    fecha_hora_inicio: row.fecha_hora_inicio,
    motivo: row.motivo,
    estado: row.estado,
    doctor: {
      id_doctor: row.id_doctor,
      id_usuario: 0,
      id_clinica: 0,
      id_especialidad: 0,
      numero_colegiado: null,
      tarifa_consulta: null,
      activo: true,
      especialidad: { id_especialidad: 0, especialidad: row.doctor_especialidad },
      clinica: { id_clinica: 0, nombre: row.doctor_clinic_name, id_location: 0, zona: 0, direccion: '', telefono: null, whatsapp: '', activo: true, city: row.doctor_clinic_city, department: row.doctor_clinic_department },
      usuario: { id_usuario: 0, nombre: row.doctor_nombre, apellido: row.doctor_apellido, fecha_nacimiento: '', email: '', activo: true },
    },
    paciente: {
      id_usuario: row.id_paciente,
      nombre: row.paciente_nombre,
      apellido: row.paciente_apellido,
      fecha_nacimiento: '',
      email: row.paciente_email,
      activo: true,
    },
  }));
};

export const findByDoctorId = async (doctorId: number): Promise<Appointment[]> => {
  const [rows] = await pool.query<AppointmentDetailRow[]>(
    `SELECT c.id_cita, c.id_doctor, c.id_paciente, c.fecha_hora_inicio, c.motivo, c.estado,
            d.id_doctor, u.nombre AS doctor_nombre, u.apellido AS doctor_apellido,
            e.especialidad AS doctor_especialidad,
            cl.nombre AS doctor_clinic_name, l.city AS doctor_clinic_city, l.department AS doctor_clinic_department,
            p.nombre AS paciente_nombre, p.apellido AS paciente_apellido, p.email AS paciente_email
     FROM cita c
     JOIN doctor d ON d.id_doctor = c.id_doctor
     JOIN usuario u ON u.id_usuario = d.id_usuario
     JOIN especialidad e ON e.id_especialidad = d.id_especialidad
     JOIN clinica cl ON cl.id_clinica = d.id_clinica
     JOIN locations l ON l.id = cl.id_location
     JOIN usuario p ON p.id_usuario = c.id_paciente
     WHERE c.id_doctor = ?
     ORDER BY c.fecha_hora_inicio DESC`,
    [doctorId]
  );

  return rows.map((row) => ({
    id_cita: row.id_cita,
    id_doctor: row.id_doctor,
    id_paciente: row.id_paciente,
    fecha_hora_inicio: row.fecha_hora_inicio,
    motivo: row.motivo,
    estado: row.estado,
    doctor: {
      id_doctor: row.id_doctor,
      id_usuario: 0,
      id_clinica: 0,
      id_especialidad: 0,
      numero_colegiado: null,
      tarifa_consulta: null,
      activo: true,
      especialidad: { id_especialidad: 0, especialidad: row.doctor_especialidad },
      clinica: { id_clinica: 0, nombre: row.doctor_clinic_name, id_location: 0, zona: 0, direccion: '', telefono: null, whatsapp: '', activo: true, city: row.doctor_clinic_city, department: row.doctor_clinic_department },
      usuario: { id_usuario: 0, nombre: row.doctor_nombre, apellido: row.doctor_apellido, fecha_nacimiento: '', email: '', activo: true },
    },
    paciente: {
      id_usuario: row.id_paciente,
      nombre: row.paciente_nombre,
      apellido: row.paciente_apellido,
      fecha_nacimiento: '',
      email: row.paciente_email,
      activo: true,
    },
  }));
};

export const updateStatus = async (id: number, estado: 'CANCELADA' | 'ATENDIDA'): Promise<boolean> => {
  const [result] = await pool.execute<ResultSetHeader>(
    `UPDATE cita SET estado = ? WHERE id_cita = ?`,
    [estado, id]
  );
  return result.affectedRows > 0;
};

export const checkAvailability = async (
  doctorId: number,
  fechaHoraInicio: string,
  schedules: DoctorSchedule[]
): Promise<boolean> => {
  const dateTime = new Date(fechaHoraInicio);

  if (!isWithinSchedule(schedules, dateTime)) {
    return false;
  }

  const [rows] = await pool.query<RowDataPacket[]>(
    `SELECT 1 FROM cita WHERE id_doctor = ? AND fecha_hora_inicio = ? AND estado = 'PROGRAMADA'`,
    [doctorId, fechaHoraInicio]
  );

  return rows.length === 0;
};

export const findDoctorSchedules = async (doctorId: number): Promise<DoctorSchedule[]> => {
  const [rows] = await pool.query<RowDataPacket[]>(
    `SELECT id_horario, id_doctor, dia, hora_inicio, hora_fin FROM horario_doctor WHERE id_doctor = ?`,
    [doctorId]
  );
  return rows as DoctorSchedule[];
};