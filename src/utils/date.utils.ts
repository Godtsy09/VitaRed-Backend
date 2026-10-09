import { DoctorSchedule } from '../types';

const DAY_NAMES: Record<number, DoctorSchedule['dia']> = {
  0: 'DOMINGO',
  1: 'LUNES',
  2: 'MARTES',
  3: 'MIERCOLES',
  4: 'JUEVES',
  5: 'VIERNES',
  6: 'SABADO',
};

export const getDayName = (date: Date | string): DoctorSchedule['dia'] => {
  const d = typeof date === 'string' ? new Date(date) : date;
  return DAY_NAMES[d.getDay()];
};

export const isWithinSchedule = (
  schedules: DoctorSchedule[],
  dateTime: Date | string
): boolean => {
  const date = typeof dateTime === 'string' ? new Date(dateTime) : dateTime;
  const dayName = getDayName(date);
  const time = date.toTimeString().slice(0, 5);

  const daySchedule = schedules.find((s) => s.dia === dayName);
  if (!daySchedule) return false;

  return time >= daySchedule.hora_inicio.slice(0, 5) && time < daySchedule.hora_fin.slice(0, 5);
};

export const formatDateTimeForMySQL = (date: Date): string => {
  return date.toISOString().slice(0, 19).replace('T', ' ');
};

export const parseMySQLDateTime = (dateTime: string): Date => {
  return new Date(dateTime.replace(' ', 'T'));
};