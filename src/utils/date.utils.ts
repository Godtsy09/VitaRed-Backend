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

interface DateTimeParts {
  year: number;
  month: number;
  day: number;
  hours: number;
  minutes: number;
  seconds: number;
}

const pad = (n: number): string => String(n).padStart(2, '0');

/**
 * Extrae los componentes de fecha/hora "de pared" (wall clock) sin aplicar
 * conversiones de zona horaria. Si recibe un string ISO ("2026-10-13T08:00:00Z")
 * toma los dígitos tal cual, de modo que la hora indicada sea la misma que se
 * guarda en la columna DATETIME y contra la que se comparan los horarios.
 */
const getDateTimeParts = (dateTime: Date | string): DateTimeParts => {
  if (typeof dateTime === 'string') {
    const match = dateTime.match(/^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})(?::(\d{2}))?/);
    if (match) {
      return {
        year: Number(match[1]),
        month: Number(match[2]),
        day: Number(match[3]),
        hours: Number(match[4]),
        minutes: Number(match[5]),
        seconds: Number(match[6] ?? 0),
      };
    }

    const parsed = new Date(dateTime);
    return {
      year: parsed.getFullYear(),
      month: parsed.getMonth() + 1,
      day: parsed.getDate(),
      hours: parsed.getHours(),
      minutes: parsed.getMinutes(),
      seconds: parsed.getSeconds(),
    };
  }

  return {
    year: dateTime.getFullYear(),
    month: dateTime.getMonth() + 1,
    day: dateTime.getDate(),
    hours: dateTime.getHours(),
    minutes: dateTime.getMinutes(),
    seconds: dateTime.getSeconds(),
  };
};

export const getDayName = (dateTime: Date | string): DoctorSchedule['dia'] => {
  const { year, month, day } = getDateTimeParts(dateTime);
  return DAY_NAMES[new Date(year, month - 1, day).getDay()];
};

export const isWithinSchedule = (
  schedules: DoctorSchedule[],
  dateTime: Date | string
): boolean => {
  const { hours, minutes } = getDateTimeParts(dateTime);
  const dayName = getDayName(dateTime);
  const time = `${pad(hours)}:${pad(minutes)}`;

  const daySchedule = schedules.find((s) => s.dia === dayName);
  if (!daySchedule) return false;

  return time >= daySchedule.hora_inicio.slice(0, 5) && time < daySchedule.hora_fin.slice(0, 5);
};

/** Normaliza una fecha/hora al formato DATETIME de MySQL ('YYYY-MM-DD HH:MM:SS'). */
export const formatDateTimeForMySQL = (dateTime: Date | string): string => {
  const { year, month, day, hours, minutes, seconds } = getDateTimeParts(dateTime);
  return `${year}-${pad(month)}-${pad(day)} ${pad(hours)}:${pad(minutes)}:${pad(seconds)}`;
};

export const parseMySQLDateTime = (dateTime: string): Date => {
  const { year, month, day, hours, minutes, seconds } = getDateTimeParts(dateTime);
  return new Date(year, month - 1, day, hours, minutes, seconds);
};
