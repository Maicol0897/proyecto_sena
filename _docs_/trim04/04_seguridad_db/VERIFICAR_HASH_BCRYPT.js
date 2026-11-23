// revisa si una contrasena corresponde a un hash guardado en la base (lo mismo que hace el backend en el login)
// uso: npm install bcryptjs y luego node VERIFICAR_HASH_BCRYPT.js "Coffee2026*" "$2b$10$...hash de usuarios.contrasena_usuario..."
// imprime COINCIDE o NO COINCIDE
const bcrypt = require('bcryptjs');

const [contrasena, hash] = process.argv.slice(2);
if (!contrasena || !hash) {
  console.error('Uso: node VERIFICAR_HASH_BCRYPT.js "contrasena" "hash"');
  process.exit(1);
}

console.log(bcrypt.compareSync(contrasena, hash) ? 'COINCIDE' : 'NO COINCIDE');
