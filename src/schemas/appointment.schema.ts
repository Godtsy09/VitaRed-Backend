import { z } from 'zod';

export const createAppointmentSchema = z.object({
  id_doctor: z.number().int().positive('El ID del doctor es obligatorio'),
  fecha_hora_inicio: z.string().datetime('Formato de fecha/hora inválido (ISO 8601)'),
  motivo: z.string().max(255).optional(),
});

export const updateStatusSchema = z.object({
  estado: z.enum(['CANCELADA', 'ATENDIDA'], {
    errorMap: () => ({ message: 'El estado debe ser CANCELADA o ATENDIDA' }),
  }),
});

export type CreateAppointmentInput = z.infer<typeof createAppointmentSchema>;
export type UpdateStatusInput = z.infer<typeof updateStatusSchema>;