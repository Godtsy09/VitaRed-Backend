import { z } from 'zod';

const isOnTheHour = (value: string): boolean => {
  const match = value.match(/T(\d{2}):(\d{2})(?::(\d{2}))?/);
  if (!match) return false;
  return match[2] === '00' && (match[3] ?? '00') === '00';
};

export const createAppointmentSchema = z.object({
  id_doctor: z
    .number({ required_error: 'El médico es obligatorio', invalid_type_error: 'Selecciona un médico válido' })
    .int('El ID del médico debe ser un número entero')
    .positive('Selecciona un médico válido'),
  fecha_hora_inicio: z
    .string({ required_error: 'La fecha y hora de la cita son obligatorias', invalid_type_error: 'Formato de fecha/hora inválido (YYYY-MM-DDTHH:MM:SS)' })
    .datetime({ local: true, message: 'Formato de fecha/hora inválido (YYYY-MM-DDTHH:MM:SS)' })
    .refine(isOnTheHour, 'La cita debe iniciar en una hora en punto (minutos y segundos en 00)'),
  motivo: z
    .string({ required_error: 'El motivo de la consulta es obligatorio', invalid_type_error: 'El motivo de la consulta es obligatorio' })
    .trim()
    .min(1, 'El motivo de la consulta es obligatorio')
    .max(255, 'El motivo no puede superar los 255 caracteres'),
});

export const updateStatusSchema = z.object({
  estado: z.enum(['CANCELADA', 'ATENDIDA'], {
    errorMap: () => ({ message: 'El estado debe ser CANCELADA o ATENDIDA' }),
  }),
});

export type CreateAppointmentInput = z.infer<typeof createAppointmentSchema>;
export type UpdateStatusInput = z.infer<typeof updateStatusSchema>;