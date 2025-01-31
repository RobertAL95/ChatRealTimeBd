require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');

const app = express();
app.use(express.json());

// Conexión a la base de datos
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('Conectado a MongoDB en Auth Service'))
.catch(err => console.error('Error de conexión Mongo:', err));

// Cargar rutas desde /src/network
const router = require('./src/network');
app.use('/', router);

// Iniciar servidor
const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`Auth Service corriendo en puerto ${PORT}`);
});
