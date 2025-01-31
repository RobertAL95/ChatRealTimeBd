const express = require('express');
const router = express.Router();

// EJEMPLO de enrutamiento hacia auth-service y chat-service
// En una etapa posterior, implementaremos la lógica para consumir
// la dirección/host de los microservicios (por Docker o config).

// Rutas para el auth-service
// Podrías reencaminar así:
// router.use('/auth', (req, res) => {
//   // Lógica para redirigir la solicitud al microservicio de autenticación
// });

// Rutas para el chat-service
// router.use('/chat', (req, res) => {
//   // Lógica para redirigir la solicitud al microservicio de chat
// });

router.get('/', (req, res) => {
  res.send('Bienvenido al API Gateway');
});

module.exports = router;
