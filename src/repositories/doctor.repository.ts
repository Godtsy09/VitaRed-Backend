import type { RowDataPacket, ResultSetHeader } from 'mysql2/promise';
import { pool } from '../config/database';
import { Doctor, Clinic, Specialty, DoctorSchedule, Location } from '../types';

interface DoctorRow extends RowDataPacket {
  id_doctor: number;
  id_usuario: number;
  id_clinica: number;
  id_especialidad: number;
  numero_colegiado: string | null;
  tarifa_consulta: number | null;
  activo: boolean;
  nombre: string;
  apellido: string;
  email: string;
  fecha_nacimiento: string;
  clinic_nombre: string;
  clinic_id_location: number;
  clinic_zona: number;
  clinic_direccion: string;
  clinic_telefono: string | null;
  clinic_whatsapp: string;
  clinic_activo: boolean;
  city: string;
  department: string;
  especialidad: string;
}

interface ScheduleRow extends RowDataPacket {
  id_horario: number;
  id_doctor: number;
  dia: 'LUNES' | 'MARTES' | 'MIERCOLES' | 'JUEVES' | 'VIERNES' | 'SABADO' | 'DOMINGO';
  hora_inicio: string;
  hora_fin: string;
}

export const findAll = async (filters?: { locationId?: number; specialtyId?: number }): Promise<Doctor[]> => {
  let query = `
    SELECT d.id_doctor, d.id_usuario, d.id_clinica, d.id_especialidad, d.numero_colegiado, d.tarifa_consulta, d.activo,
           u.nombre, u.apellido, u.email, u.fecha_nacimiento,
           c.nombre AS clinic_nombre, c.id_location AS clinic_id_location, c.zona AS clinic_zona, c.direccion AS clinic_direccion, c.telefono AS clinic_telefono, c.whatsapp AS clinic_whatsapp, c.activo AS clinic_activo,
           l.city, l.department,
           e.especialidad
    FROM doctor d
    JOIN usuario u ON u.id_usuario = d.id_usuario
    JOIN clinica c ON c.id_clinica = d.id_clinica
    JOIN locations l ON l.id = c.id_location
    JOIN especialidad e ON e.id_especialidad = d.id_especialidad
    WHERE d.activo = TRUE AND u.activo = TRUE AND c.activo = TRUE
  `;
  const params: unknown[] = [];

  if (filters?.locationId) {
    query += ' AND l.id = ?';
    params.push(filters.locationId);
  }
  if (filters?.specialtyId) {
    query += ' AND e.id_especialidad = ?';
    params.push(filters.specialtyId);
  }

  query += ' ORDER BY u.nombre, u.apellido';

  const [rows] = await pool.query<DoctorRow[]>(query, params);

  const doctorsMap = new Map<number, Doctor>();

  for (const row of rows) {
    if (!doctorsMap.has(row.id_doctor)) {
      doctorsMap.set(row.id_doctor, {
        id_doctor: row.id_doctor,
        id_usuario: row.id_usuario,
        id_clinica: row.id_clinica,
        id_especialidad: row.id_especialidad,
        numero_colegiado: row.numero_colegiado,
        tarifa_consulta: row.tarifa_consulta,
        activo: row.activo,
        usuario: {
          id_usuario: row.id_usuario,
          nombre: row.nombre,
          apellido: row.apellido,
          fecha_nacimiento: row.fecha_nacimiento,
          email: row.email,
          activo: true,
        },
        clinica: {
          id_clinica: row.id_clinica,
          nombre: row.clinic_nombre,
          id_location: row.clinic_id_location,
          zona: row.clinic_zona,
          direccion: row.clinic_direccion,
          telefono: row.clinic_telefono,
          whatsapp: row.clinic_whatsapp,
          activo: row.clinic_activo,
          city: row.city,
          department: row.department,
        },
        especialidad: {
          id_especialidad: row.id_especialidad,
          especialidad: row.especialidad,
        },
        horarios: [],
      });
    }
  }

  if (doctorsMap.size > 0) {
    const doctorIds = Array.from(doctorsMap.keys());
    const placeholders = doctorIds.map(() => '?').join(',');
    const [scheduleRows] = await pool.query<ScheduleRow[]>(
      `SELECT id_horario, id_doctor, dia, hora_inicio, hora_fin FROM horario_doctor WHERE id_doctor IN (${placeholders})`,
      doctorIds
    );

    for (const schedule of scheduleRows) {
      const doctor = doctorsMap.get(schedule.id_doctor);
      if (doctor) {
        doctor.horarios!.push({
          id_horario: schedule.id_horario,
          id_doctor: schedule.id_doctor,
          dia: schedule.dia,
          hora_inicio: schedule.hora_inicio,
          hora_fin: schedule.hora_fin,
        });
      }
    }
  }

  return Array.from(doctorsMap.values());
};

export const findById = async (id: number): Promise<Doctor | null> => {
  const [rows] = await pool.query<DoctorRow[]>(
    `SELECT d.id_doctor, d.id_usuario, d.id_clinica, d.id_especialidad, d.numero_colegiado, d.tarifa_consulta, d.activo,
            u.nombre, u.apellido, u.email, u.fecha_nacimiento,
            c.nombre AS clinic_nombre, c.id_location AS clinic_id_location, c.zona AS clinic_zona, c.direccion AS clinic_direccion, c.telefono AS clinic_telefono, c.whatsapp AS clinic_whatsapp, c.activo AS clinic_activo,
            l.city, l.department,
            e.especialidad
     FROM doctor d
     JOIN usuario u ON u.id_usuario = d.id_usuario
     JOIN clinica c ON c.id_clinica = d.id_clinica
     JOIN locations l ON l.id = c.id_location
     JOIN especialidad e ON e.id_especialidad = d.id_especialidad
     WHERE d.id_doctor = ? AND d.activo = TRUE AND u.activo = TRUE AND c.activo = TRUE`,
    [id]
  );

  if (rows.length === 0) return null;

  const row = rows[0];
  const [scheduleRows] = await pool.query<ScheduleRow[]>(
    `SELECT id_horario, id_doctor, dia, hora_inicio, hora_fin FROM horario_doctor WHERE id_doctor = ?`,
    [id]
  );

  return {
    id_doctor: row.id_doctor,
    id_usuario: row.id_usuario,
    id_clinica: row.id_clinica,
    id_especialidad: row.id_especialidad,
    numero_colegiado: row.numero_colegiado,
    tarifa_consulta: row.tarifa_consulta,
    activo: row.activo,
    usuario: {
      id_usuario: row.id_usuario,
      nombre: row.nombre,
      apellido: row.apellido,
      fecha_nacimiento: row.fecha_nacimiento,
      email: row.email,
      activo: true,
    },
    clinica: {
      id_clinica: row.id_clinica,
      nombre: row.clinic_nombre,
      id_location: row.clinic_id_location,
      zona: row.clinic_zona,
      direccion: row.clinic_direccion,
      telefono: row.clinic_telefono,
      whatsapp: row.clinic_whatsapp,
      activo: row.clinic_activo,
      city: row.city,
      department: row.department,
    },
    especialidad: {
      id_especialidad: row.id_especialidad,
      especialidad: row.especialidad,
    },
    horarios: scheduleRows.map((s) => ({
      id_horario: s.id_horario,
      id_doctor: s.id_doctor,
      dia: s.dia,
      hora_inicio: s.hora_inicio,
      hora_fin: s.hora_fin,
    })),
  };
};

export const findByUserId = async (userId: number): Promise<Doctor | null> => {
  const [rows] = await pool.query<DoctorRow[]>(
    `SELECT d.id_doctor, d.id_usuario, d.id_clinica, d.id_especialidad, d.numero_colegiado, d.tarifa_consulta, d.activo,
            u.nombre, u.apellido, u.email, u.fecha_nacimiento,
            c.nombre AS clinic_nombre, c.id_location AS clinic_id_location, c.zona AS clinic_zona, c.direccion AS clinic_direccion, c.telefono AS clinic_telefono, c.whatsapp AS clinic_whatsapp, c.activo AS clinic_activo,
            l.city, l.department,
            e.especialidad
     FROM doctor d
     JOIN usuario u ON u.id_usuario = d.id_usuario
     JOIN clinica c ON c.id_clinica = d.id_clinica
     JOIN locations l ON l.id = c.id_location
     JOIN especialidad e ON e.id_especialidad = d.id_especialidad
     WHERE d.id_usuario = ? AND d.activo = TRUE AND u.activo = TRUE AND c.activo = TRUE`,
    [userId]
  );

  if (rows.length === 0) return null;

  const row = rows[0];
  const [scheduleRows] = await pool.query<ScheduleRow[]>(
    `SELECT id_horario, id_doctor, dia, hora_inicio, hora_fin FROM horario_doctor WHERE id_doctor = ?`,
    [row.id_doctor]
  );

  return {
    id_doctor: row.id_doctor,
    id_usuario: row.id_usuario,
    id_clinica: row.id_clinica,
    id_especialidad: row.id_especialidad,
    numero_colegiado: row.numero_colegiado,
    tarifa_consulta: row.tarifa_consulta,
    activo: row.activo,
    usuario: {
      id_usuario: row.id_usuario,
      nombre: row.nombre,
      apellido: row.apellido,
      fecha_nacimiento: row.fecha_nacimiento,
      email: row.email,
      activo: true,
    },
    clinica: {
      id_clinica: row.id_clinica,
      nombre: row.clinic_nombre,
      id_location: row.clinic_id_location,
      zona: row.clinic_zona,
      direccion: row.clinic_direccion,
      telefono: row.clinic_telefono,
      whatsapp: row.clinic_whatsapp,
      activo: row.clinic_activo,
      city: row.city,
      department: row.department,
    },
    especialidad: {
      id_especialidad: row.id_especialidad,
      especialidad: row.especialidad,
    },
    horarios: scheduleRows.map((s) => ({
      id_horario: s.id_horario,
      id_doctor: s.id_doctor,
      dia: s.dia,
      hora_inicio: s.hora_inicio,
      hora_fin: s.hora_fin,
    })),
  };
};

export const findSchedulesByDoctorId = async (doctorId: number): Promise<DoctorSchedule[]> => {
  const [rows] = await pool.query<ScheduleRow[]>(
    `SELECT id_horario, id_doctor, dia, hora_inicio, hora_fin FROM horario_doctor WHERE id_doctor = ?`,
    [doctorId]
  );
  return rows.map((r) => ({
    id_horario: r.id_horario,
    id_doctor: r.id_doctor,
    dia: r.dia,
    hora_inicio: r.hora_inicio,
    hora_fin: r.hora_fin,
  }));
};

export const updateDoctor = async (doctorId: number, data: { id_especialidad?: number; numero_colegiado?: string | null; tarifa_consulta?: number | null }): Promise<boolean> => {
  const fields: string[] = [];
  const values: unknown[] = [];

  if (data.id_especialidad !== undefined) {
    fields.push('id_especialidad = ?');
    values.push(data.id_especialidad);
  }
  if (data.numero_colegiado !== undefined) {
    fields.push('numero_colegiado = ?');
    values.push(data.numero_colegiado);
  }
  if (data.tarifa_consulta !== undefined) {
    fields.push('tarifa_consulta = ?');
    values.push(data.tarifa_consulta);
  }

  if (fields.length === 0) return false;

  values.push(doctorId);
  const [result] = await pool.execute<ResultSetHeader>(
    `UPDATE doctor SET ${fields.join(', ')} WHERE id_doctor = ?`,
    values as any[]
  );
  return result.affectedRows > 0;
};

export const updateClinic = async (clinicId: number, data: { nombre?: string; id_location?: number; zona?: number; direccion?: string; telefono?: string | null; whatsapp?: string }): Promise<boolean> => {
  const fields: string[] = [];
  const values: unknown[] = [];

  if (data.nombre !== undefined) {
    fields.push('nombre = ?');
    values.push(data.nombre);
  }
  if (data.id_location !== undefined) {
    fields.push('id_location = ?');
    values.push(data.id_location);
  }
  if (data.zona !== undefined) {
    fields.push('zona = ?');
    values.push(data.zona);
  }
  if (data.direccion !== undefined) {
    fields.push('direccion = ?');
    values.push(data.direccion);
  }
  if (data.telefono !== undefined) {
    fields.push('telefono = ?');
    values.push(data.telefono);
  }
  if (data.whatsapp !== undefined) {
    fields.push('whatsapp = ?');
    values.push(data.whatsapp);
  }

  if (fields.length === 0) return false;

  values.push(clinicId);
  const [result] = await pool.execute<ResultSetHeader>(
    `UPDATE clinica SET ${fields.join(', ')} WHERE id_clinica = ?`,
    values as any[]
  );
  return result.affectedRows > 0;
};

export const getSpecialties = async (): Promise<Specialty[]> => {
  const [rows] = await pool.query<RowDataPacket[]>(
    `SELECT id_especialidad, especialidad FROM especialidad ORDER BY especialidad`
  );
  return rows as Specialty[];
};

export const getLocations = async (): Promise<Location[]> => {
  const [rows] = await pool.query<RowDataPacket[]>(
    `SELECT id, city, department FROM locations ORDER BY department, city`
  );
  return rows as Location[];
};