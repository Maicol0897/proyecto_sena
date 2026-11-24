// genera el hash bcrypt de una contrasena para guardarlo en usuarios.contrasena_usuario
// uso: npm install bcryptjs y luego node GENERAR_HASH_BCRYPT.js "MiContrasenaSegura123*"
// imprime el hash (60 caracteres, empieza por $2a$ o $2b$), ese es el valor que va en la base
const bcrypt = require('bcryptjs');

const contrasena = process.argv[2];
if (!contrasena) {
  console.error('Uso: node GENERAR_HASH_BCRYPT.js "contrasena"');
  process.exit(1);
}

const rondas = 10; // costo del algoritmo (2^10 iteraciones)
const hash = bcrypt.hashSync(contrasena, rondas);
console.log(hash);
