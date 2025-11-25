import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import authRoutes from './routes/auth.js';

const app = express();
app.use(cors());
app.use(express.json());

// Conecte ao MongoDB
mongoose.connect('mongodb+srv://tecbala8_db_user:G9T5L7J1k4lQCLOt@cluster0.fs2ftam.mongodb.net/Tecbala')
  .then(() => console.log('✅ Conectado ao MongoDB'))
  .catch(err => console.error('Erro ao conectar ao MongoDB', err));

app.use('/auth', authRoutes);

app.listen(3000,'0.0.0.0', () => console.log('🚀 Servidor rodando na porta 3000'));
