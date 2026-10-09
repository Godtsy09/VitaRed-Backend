import { Router } from 'express';
import { create, getMyAppointments, getDoctorAppointments, updateStatus } from '../controllers/appointment.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';
import { validate } from '../middleware/validate.middleware';
import { createAppointmentSchema, updateStatusSchema } from '../schemas/appointment.schema';

const router = Router();

router.post('/appointments', authenticate, authorize('user'), validate(createAppointmentSchema), create);
router.get('/appointments/my', authenticate, authorize('user'), getMyAppointments);
router.get('/appointments/doctor', authenticate, authorize('doctor'), getDoctorAppointments);
router.patch('/appointments/:id/status', authenticate, authorize('doctor'), validate(updateStatusSchema), updateStatus);

export default router;