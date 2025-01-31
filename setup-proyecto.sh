#!/usr/bin/env bash

#########################
# CONFIGURACIÓN GENERAL #
#########################

# Nombre base del directorio (puedes cambiarlo si quieres)
PROJECT_DIR="ChatRt"

# Crea la carpeta principal
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit

#################################
# ARCHIVO GITIGNORE EN LA RAÍZ  #
#################################
cat <<EOF > .gitignore
# Node
node_modules/
npm-debug.log
yarn-error.log

# Logs
*.log

# Env files
.env

# Mac / Windows
.DS_Store
Thumbs.db

# Docker
docker-compose.override.yml
EOF

#################################
# ARCHIVO README EN LA RAÍZ     #
#################################
cat <<EOF > README.md
# Proyecto Microservicios (Día 1)

Estructura base para el proyecto con:

- API Gateway (Express, configuración de rutas)
- Servicios: Auth y Chat (cada uno con su propio server.js, modelos, controladores, etc.)
- Configurado para usar Docker y contenedores más adelante.

## Estructura de carpetas

- \`api-gateway/\`
- \`services/\`
  - \`auth-service/\`
  - \`chat-service/\`

## Pasos iniciales

1. Instalar dependencias en cada servicio (\`auth-service\`, \`chat-service\`) y en el \`api-gateway\`.
2. Definir variables de entorno en cada \`.env\`.
3. Más adelante, se agregará Docker, NGINX, RabbitMQ, etc.

EOF

#################################
# PACKAGE.JSON EN LA RAÍZ (OPC) #
#################################
# Este package.json es opcional; muchos proyectos de microservicios no lo usan en la raíz.
# Lo dejamos mínimo, por si luego quieres añadir scripts globales.
cat <<EOF > package.json
{
  "name": "microservices-root",
  "version": "1.0.0",
  "description": "Root package.json for microservices project",
  "scripts": {
    "start": "echo 'Use the individual service start commands instead.'"
  },
  "author": "",
  "license": "ISC"
}
EOF

#################################
# CREACIÓN DE CARPETAS          #
#################################

# Crea carpeta para el API Gateway
mkdir -p api-gateway

# Crea carpeta para los servicios
mkdir -p services/auth-service
mkdir -p services/chat-service

#################################
# ARCHIVOS API GATEWAY          #
#################################

cd api-gateway || exit

# package.json para el API Gateway
cat <<EOF > package.json
{
  "name": "api-gateway",
  "version": "1.0.0",
  "description": "API Gateway for microservices project",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5"
  }
}
EOF

# Archivo .env (vacío por ahora, se puede configurar luego)
cat <<EOF > .env
# Puerto donde correrá el API Gateway
PORT=3000

# Clave JWT de ejemplo (cambia para producción)
JWT_SECRET=super-secret-key
EOF

# server.js (API Gateway principal)
cat <<EOF > server.js
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
  console.log(\`API Gateway corriendo en puerto \${PORT}\`);
});
EOF

# routes.js (lógica de enrutamiento hacia microservicios)
cat <<EOF > routes.js
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
EOF

cd ..

#################################
# ARCHIVOS AUTH SERVICE         #
#################################

cd services/auth-service || exit

# package.json para Auth Service
cat <<EOF > package.json
{
  "name": "auth-service",
  "version": "1.0.0",
  "description": "Authentication microservice",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.0.3",
    "mongoose": "^6.8.0",
    "bcrypt": "^5.1.0",
    "jsonwebtoken": "^8.5.1"
  }
}
EOF

# .env para Auth Service
cat <<EOF > .env
# Puerto del Auth Service
PORT=4000

# URI de MongoDB (ejemplo local, cambiar según tu entorno)
MONGO_URI=mongodb://localhost:27017/authdb

# Clave JWT (debe coincidir con la del gateway o manejarse según tu estrategia)
JWT_SECRET=super-secret-key
EOF

# server.js
cat <<EOF > server.js
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
  console.log(\`Auth Service corriendo en puerto \${PORT}\`);
});
EOF

# Creación de carpetas internas (MVC)
mkdir -p src/models
mkdir -p src/controllers
mkdir -p src/network

# Ejemplo de model User (vacío o minimal)
cat <<EOF > src/models/User.js
const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
}, {
  timestamps: true
});

module.exports = mongoose.model('User', UserSchema);
EOF

# Ejemplo de controller (vacío por ahora)
cat <<EOF > src/controllers/authController.js
// Aquí iría la lógica de registro, login, etc.

module.exports = {
  signup: async (req, res) => {
    // TODO: implementar registro
    return res.send('signup en construcción');
  },
  login: async (req, res) => {
    // TODO: implementar login
    return res.send('login en construcción');
  }
};
EOF

# Ejemplo de network (rutas)
cat <<EOF > src/network/index.js
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// Rutas para autenticación
router.post('/signup', authController.signup);
router.post('/login', authController.login);

module.exports = router;
EOF

cd ..

#################################
# ARCHIVOS CHAT SERVICE         #
#################################

cd ../chat-service || exit

# package.json para Chat Service
cat <<EOF > package.json
{
  "name": "chat-service",
  "version": "1.0.0",
  "description": "Chat microservice",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.0.3",
    "mongoose": "^6.8.0",
    "socket.io": "^4.6.1"
  }
}
EOF

# .env para Chat Service
cat <<EOF > .env
# Puerto del Chat Service
PORT=5000

# URI de MongoDB (ejemplo local)
MONGO_URI=mongodb://localhost:27017/chatdb
EOF

# server.js
cat <<EOF > server.js
require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const http = require('http');
const { Server } = require('socket.io');
const router = require('./src/network');

const app = express();
app.use(express.json());

// Conexión a la base de datos
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('Conectado a MongoDB en Chat Service'))
.catch(err => console.error('Error de conexión Mongo:', err));

// Rutas HTTP
app.use('/', router);

// Servidor HTTP para integrar Socket.io
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
  },
});

// Evento de conexión Socket.io
io.on('connection', (socket) => {
  console.log('Nuevo cliente conectado al chat');
  
  // Ejemplo de evento 'message'
  socket.on('message', (data) => {
    console.log('Mensaje recibido:', data);
    // Emitir a todos los conectados
    io.emit('message', data);
  });

  socket.on('disconnect', () => {
    console.log('Cliente desconectado del chat');
  });
});

// Iniciar servidor
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(\`Chat Service corriendo en puerto \${PORT}\`);
});
EOF

# Creación de carpetas internas
mkdir -p src/models
mkdir -p src/controllers
mkdir -p src/network

# Ejemplo de model Message
cat <<EOF > src/models/Message.js
const mongoose = require('mongoose');

const MessageSchema = new mongoose.Schema({
  user: { type: String, required: true },
  content: { type: String, required: true },
}, {
  timestamps: true
});

module.exports = mongoose.model('Message', MessageSchema);
EOF

# Ejemplo de controller (lógica de chat)
cat <<EOF > src/controllers/chatController.js
// Aquí iría la lógica de guardado, obtención de mensajes, etc.

module.exports = {
  getMessages: async (req, res) => {
    return res.send('getMessages en construcción');
  },
  postMessage: async (req, res) => {
    return res.send('postMessage en construcción');
  }
};
EOF

# Ejemplo de network (rutas)
cat <<EOF > src/network/index.js
const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');

// Rutas para el chat
router.get('/messages', chatController.getMessages);
router.post('/messages', chatController.postMessage);

module.exports = router;
EOF

cd ../../..

echo "Estructura base creada en la carpeta '$PROJECT_DIR'."
echo "Listo para instalar dependencias y comenzar con el proyecto."
