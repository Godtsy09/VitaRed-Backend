import { z } from 'zod';

export const filterDoctorsSchema = z.object({
  locationId: z.coerce.number().int().positive().optional(),
  specialtyId: z.coerce.number().int().positive().optional(),
}).refine(
  (data) => !(data.locationId && data.specialtyId),
  {
    message: 'Solo se permite filtrar por ubicación O especialidad, no ambos',
    path: ['locationId'],
  }
);

export const updateDoctorSchema = z.object({
  id_especialidad: z.number().int().positive().optional(),
  numero_colegiado: z.string().max(50).optional().nullable(),
  tarifa_consulta: z.number().positive().optional().nullable(),
});

export const updateClinicSchema = z.object({
  clinicNombre: z.string().min(1).max(200).optional(),
  clinicLocationId: z.number().int().positive().optional(),
  clinicZona: z.number().int().positive().optional(),
  clinicDireccion: z.string().min(1).max(255).optional(),
  clinicTelefono: z.string().max(20).optional().nullable(),
  clinicWhatsapp: z.string().min(1).max(20).optional(),
});

export type FilterDoctorsInput = z.infer<typeof filterDoctorsSchema>;
export type UpdateDoctorInput = z.infer<typeof updateDoctorSchema>;
export type UpdateClinicInput = z.infer<typeof updateClinicSchema>;