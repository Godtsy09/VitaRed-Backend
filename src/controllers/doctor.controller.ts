import type { Request, Response } from 'express';
import * as doctorService from '../services/doctor.service';
import { HttpError } from '../utils/HttpError';

export const getDoctors = async (req: Request, res: Response) => {
  try {
    const filters = {
      locationId: req.query.locationId ? Number(req.query.locationId) : undefined,
      specialtyId: req.query.specialtyId ? Number(req.query.specialtyId) : undefined,
    };
    const doctors = await doctorService.getDoctors(filters);
    return res.status(200).json(doctors);
  } catch (error) {
    if (error instanceof HttpError) {
      return res.status(error.status).json({ error: error.message });
    }
    console.error('Error al obtener doctores:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
};

export const getDoctorById = async (req: Request, res: Response) => {
  try {
    const id = Number(req.params.id);
    if (isNaN(id)) {
      return res.status(400).json({ error: 'ID inválido' });
    }
    const doctor = await doctorService.getDoctorById(id);
    if (!doctor) {
      return res.status(404).json({ error: 'Doctor no encontrado' });
    }
    return res.status(200).json(doctor);
  } catch (error) {
    console.error('Error al obtener doctor:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
};

export const getMyProfile = async (req: Request, res: Response) => {
  try {
    const doctor = await doctorService.getMyProfile(req.user!.id);
    if (!doctor) {
      return res.status(404).json({ error: 'Perfil de doctor no encontrado' });
    }
    return res.status(200).json(doctor);
  } catch (error) {
    if (error instanceof HttpError) {
      return res.status(error.status).json({ error: error.message });
    }
    console.error('Error al obtener perfil:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
};

export const updateMyProfile = async (req: Request, res: Response) => {
  try {
    const doctor = await doctorService.updateMyProfile(req.user!.id, req.body);
    return res.status(200).json(doctor);
  } catch (error) {
    if (error instanceof HttpError) {
      return res.status(error.status).json({ error: error.message });
    }
    console.error('Error al actualizar perfil:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
};

export const updateMyClinic = async (req: Request, res: Response) => {
  try {
    const doctor = await doctorService.updateMyClinic(req.user!.id, req.body);
    return res.status(200).json(doctor);
  } catch (error) {
    if (error instanceof HttpError) {
      return res.status(error.status).json({ error: error.message });
    }
    console.error('Error al actualizar clínica:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
};

export const getSpecialties = async (_req: Request, res: Response) => {
  try {
    const specialties = await doctorService.getSpecialties();
    return res.status(200).json(specialties);
  } catch (error) {
    console.error('Error al obtener especialidades:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
};

export const getLocations = async (_req: Request, res: Response) => {
  try {
    const locations = await doctorService.getLocations();
    return res.status(200).json(locations);
  } catch (error) {
    console.error('Error al obtener ubicaciones:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
};