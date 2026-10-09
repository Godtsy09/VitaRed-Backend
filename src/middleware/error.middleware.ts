import type { Request, Response, NextFunction } from 'express';
import { HttpError } from '../utils/HttpError';

export const notFoundHandler = (req: Request, res: Response) => {
  res.status(404).json({ error: `Ruta no encontrada: ${req.method} ${req.originalUrl}` });
};

export const errorHandler = (err: Error, req: Request, res: Response, _next: NextFunction) => {
  if (err instanceof HttpError) {
    return res.status(err.status).json({ error: err.message });
  }

  console.error('Error no manejado:', err);
  return res.status(500).json({ error: 'Error interno del servidor' });
};