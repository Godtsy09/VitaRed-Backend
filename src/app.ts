import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import authRoutes from './routes/auth.routes';
import doctorRoutes from './routes/doctor.routes';
import appointmentRoutes from './routes/appointment.routes';
import { errorHandler, notFoundHandler } from './middleware/error.middleware';

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());

app.use('/api', authRoutes);
app.use('/api', doctorRoutes);
app.use('/api', appointmentRoutes);

app.use(notFoundHandler);
app.use(errorHandler);

export default app;