import type { Request, Response } from 'express';
import * as appointmentService from '../services/appointment.service';
import { HttpError } from '../utils/HttpError';
import { parseId } from '../utils/parseId';

export const create = async (req: Request, res: Response) => {
  try {
    const appointmentId = await appointmentService.createAppointment(req.user!.id, req.body);
    return res.status(201).json({ id_cita: appointmentId, message: 'Cita creada exitosamente' });
  } catch (error) {
    if (error instanceof HttpError) {
      return res.status(error.status).json({ error: error.message });
    }
    console.error('Error al crear cita:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
};

export const getMyAppointments = async (req: Request, res: Response) => {
  try {
    const appointments = await appointmentService.getMyAppointments(req.user!.id);
    return res.status(200).json(appointments);
  } catch (error) {
    console.error('Error al obtener citas:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
};

export const getDoctorAppointments = async (req: Request, res: Response) => {
  try {
    const appointments = await appointmentService.getAppointmentsForDoctorUser(req.user!.id);
    return res.status(200).json(appointments);
  } catch (error) {
    if (error instanceof HttpError) {
      return res.status(error.status).json({ error: error.message });
    }
    console.error('Error al obtener citas del doctor:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
};

export const updateStatus = async (req: Request, res: Response) => {
  try {
    const id = parseId(req, res);
    if (id === null) return;
    await appointmentService.updateStatus(req.user!.id, id, req.body.estado);
    return res.status(200).json({ message: 'Estado de cita actualizado' });
  } catch (error) {
    if (error instanceof HttpError) {
      return res.status(error.status).json({ error: error.message });
    }
    console.error('Error al actualizar estado:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
};