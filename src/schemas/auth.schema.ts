import { z } from 'zod';

export const loginSchema = z.object({
  email: z.string().email('El email no es válido'),
  password: z.string().min(1, 'La contraseña es obligatoria'),
});

const namePattern = /^[\p{L}' .-]+$/u;

export const registerUserSchema = z.object({
  nombre: z
    .string({ required_error: 'El nombre es obligatorio' })
    .trim()
    .min(1, 'El nombre es obligatorio')
    .min(2, 'El nombre debe tener al menos 2 caracteres')
    .max(100, 'El nombre no puede superar los 100 caracteres')
    .regex(namePattern, 'El nombre solo puede contener letras'),
  apellido: z
    .string({ required_error: 'El apellido es obligatorio' })
    .trim()
    .min(1, 'El apellido es obligatorio')
    .min(2, 'El apellido debe tener al menos 2 caracteres')
    .max(100, 'El apellido no puede superar los 100 caracteres')
    .regex(namePattern, 'El apellido solo puede contener letras'),
  fecha_nacimiento: z
    .string({ required_error: 'La fecha de nacimiento es obligatoria' })
    .date('La fecha de nacimiento no es válida (YYYY-MM-DD)')
    .refine((value) => {
      const dob = new Date(`${value}T00:00:00Z`);
      return !Number.isNaN(dob.getTime()) && dob.getTime() < Date.now();
    }, 'La fecha de nacimiento no puede ser futura'),
  email: z
    .string({ required_error: 'El correo electrónico es obligatorio' })
    .trim()
    .email('El correo electrónico no es válido')
    .max(150, 'El correo electrónico no puede superar los 150 caracteres'),
  password: z
    .string({ required_error: 'La contraseña es obligatoria' })
    .min(8, 'La contraseña debe tener al menos 8 caracteres')
    .max(128, 'La contraseña no puede superar los 128 caracteres'),
});

export const registerDoctorSchema = registerUserSchema.extend({
  clinicNombre: z
    .string({ required_error: 'El nombre de la clínica es obligatorio' })
    .trim()
    .min(1, 'El nombre de la clínica es obligatorio')
    .max(200, 'El nombre de la clínica no puede superar los 200 caracteres'),
  clinicLocationId: z
    .number({ required_error: 'La ubicación es obligatoria', invalid_type_error: 'La ubicación es obligatoria' })
    .int('La ubicación no es válida')
    .positive('La ubicación es obligatoria'),
  clinicZona: z
    .number({ required_error: 'La zona es obligatoria', invalid_type_error: 'La zona es obligatoria' })
    .int('La zona no es válida')
    .positive('La zona es obligatoria')
    .max(99, 'La zona no puede ser mayor a 99'),
  clinicDireccion: z
    .string({ required_error: 'La dirección es obligatoria' })
    .trim()
    .min(1, 'La dirección es obligatoria')
    .max(255, 'La dirección no puede superar los 255 caracteres'),
  clinicTelefono: z
    .string({ required_error: 'El teléfono es obligatorio' })
    .trim()
    .min(1, 'El teléfono es obligatorio')
    .max(20, 'El teléfono no puede superar los 20 caracteres')
    .regex(/^[0-9]{8,}$/, 'El teléfono debe contener al menos 8 dígitos'),
  clinicWhatsapp: z
    .string({ required_error: 'El WhatsApp es obligatorio' })
    .trim()
    .min(1, 'El WhatsApp es obligatorio')
    .max(20, 'El WhatsApp no puede superar los 20 caracteres')
    .regex(/^[0-9]{8,}$/, 'El WhatsApp debe contener al menos 8 dígitos'),
  id_especialidad: z
    .number({ required_error: 'La especialidad es obligatoria', invalid_type_error: 'La especialidad es obligatoria' })
    .int('La especialidad no es válida')
    .positive('La especialidad es obligatoria'),
  numero_colegiado: z
    .string({ required_error: 'El número de colegiado es obligatorio' })
    .trim()
    .min(1, 'El número de colegiado es obligatorio')
    .max(50, 'El número de colegiado no puede superar los 50 caracteres'),
  tarifa_consulta: z
    .number({ required_error: 'La tarifa por consulta es obligatoria', invalid_type_error: 'La tarifa por consulta es obligatoria' })
    .positive('La tarifa por consulta debe ser mayor a 0')
    .max(9999.99, 'La tarifa por consulta no puede superar los 9999.99'),
});

export type LoginInput = z.infer<typeof loginSchema>;
export type RegisterUserInput = z.infer<typeof registerUserSchema>;
export type RegisterDoctorInput = z.infer<typeof registerDoctorSchema>;