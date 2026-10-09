import { z } from 'zod';

export const loginSchema = z.object({
  email: z.string().email('El email no es válido'),
  password: z.string().min(1, 'La contraseña es obligatoria'),
});

export const registerUserSchema = z.object({
  nombre: z.string().min(1, 'El nombre es obligatorio').max(100),
  apellido: z.string().min(1, 'El apellido es obligatorio').max(100),
  fecha_nacimiento: z.string().date('Fecha de nacimiento inválida (YYYY-MM-DD)'),
  email: z.string().email('El email no es válido'),
  password: z.string().min(8, 'La contraseña debe tener al menos 8 caracteres'),
});

export const registerDoctorSchema = registerUserSchema.extend({
  clinicNombre: z.string().min(1, 'El nombre de la clínica es obligatorio').max(200),
  clinicLocationId: z.number().int().positive('ID de ubicación inválido'),
  clinicZona: z.number().int().positive('La zona es obligatoria'),
  clinicDireccion: z.string().min(1, 'La dirección es obligatoria').max(255),
  clinicTelefono: z.string().max(20).optional(),
  clinicWhatsapp: z.string().min(1, 'El WhatsApp es obligatorio').max(20),
  id_especialidad: z.number().int().positive('La especialidad es obligatoria'),
  numero_colegiado: z.string().max(50).optional(),
  tarifa_consulta: z.number().positive().optional(),
});

export type LoginInput = z.infer<typeof loginSchema>;
export type RegisterUserInput = z.infer<typeof registerUserSchema>;
export type RegisterDoctorInput = z.infer<typeof registerDoctorSchema>;