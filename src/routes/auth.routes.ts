import { Router } from 'express';
import { login, registerUser, registerDoctor, me } from '../controllers/auth.controller';
import { authenticate } from '../middleware/auth.middleware';
import { validate } from '../middleware/validate.middleware';
import { loginSchema, registerUserSchema, registerDoctorSchema } from '../schemas/auth.schema';

const router = Router();

router.post('/auth/login', validate(loginSchema), login);
router.post('/auth/register/user', validate(registerUserSchema), registerUser);
router.post('/auth/register/doctor', validate(registerDoctorSchema), registerDoctor);
router.get('/auth/me', authenticate, me);

export default router;