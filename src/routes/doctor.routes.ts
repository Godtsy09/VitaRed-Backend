import { Router } from 'express';
import { getDoctors, getDoctorById, getMyProfile, updateMyProfile, updateMyClinic, getSpecialties, getLocations } from '../controllers/doctor.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';
import { validate } from '../middleware/validate.middleware';
import { filterDoctorsSchema, updateDoctorSchema, updateClinicSchema } from '../schemas/doctor.schema';

const router = Router();

router.get('/doctors', validate(filterDoctorsSchema), getDoctors);
router.get('/doctors/:id', getDoctorById);
router.get('/doctors/specialties', getSpecialties);
router.get('/doctors/locations', getLocations);

router.get('/doctors/me', authenticate, authorize('doctor'), getMyProfile);
router.put('/doctors/me', authenticate, authorize('doctor'), validate(updateDoctorSchema), updateMyProfile);
router.put('/doctors/me/clinic', authenticate, authorize('doctor'), validate(updateClinicSchema), updateMyClinic);

export default router;