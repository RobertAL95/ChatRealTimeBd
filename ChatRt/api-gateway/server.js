require('dotenv').config();
const express = require('express');
const cors = require('cors');
const routes = require('./routes');

const app = express();
app.use(cors());
app.use(express.json());

// Usar rutas definidas en routes.js
app.use('/', routes);

// Puerto desde variables de entorno
const PORT = process.env.PORT || 3000;

// Levantar servidor
app.listen(PORT, () => {
  console.log(`API Gateway corriendo en puerto ${PORT}`);
});
