-- BAKEADMIN v4 - seguridad de la base de datos
-- Coffee Park - SENA ADSO ficha 3388489
-- Correr despues de BD_DML_BAKEADMIN.sql (necesita usuarios cargados).
-- Tiene: hash bcrypt, roles y permisos, cuentas del motor con privilegios minimos y otras practicas del esquema.

USE bakeadmin;

-- contrasenas con hash bcrypt
-- la columna usuarios.contrasena_usuario no guarda la contrasena sino su hash bcrypt
-- el hash empieza por $2a$ o $2b$, mide 60 caracteres y lleva una sal aleatoria,
-- por eso dos usuarios con la misma contrasena tienen hashes distintos

-- algoritmo, costo y longitud del hash de cada usuario (sin mostrar el hash completo)
SELECT id_usuario, correo_usuario,
       LEFT(contrasena_usuario, 4)               AS algoritmo,        -- $2b$  = bcrypt
       SUBSTRING(contrasena_usuario, 5, 3)       AS costo,            -- 10$   = 2^10 rondas
       CHAR_LENGTH(contrasena_usuario)           AS longitud,         -- 60
       CONCAT(LEFT(contrasena_usuario, 12), '...') AS vista_parcial
  FROM usuarios
 ORDER BY id_usuario;

-- usuarios sin formato bcrypt (deben ser 0 filas)
SELECT id_usuario, correo_usuario
  FROM usuarios
 WHERE contrasena_usuario NOT REGEXP '^\\$2[aby]\\$[0-9]{2}\\$.{53}$';

-- los hashes son distintos aunque la contrasena sea la misma
-- (los 6 empleados de prueba usan la misma contrasena y tienen 6 hashes)
SELECT COUNT(*) AS usuarios, COUNT(DISTINCT contrasena_usuario) AS hashes_distintos FROM usuarios;

-- el procedimiento del administrador rechaza una contrasena en texto plano
-- (pide un hash de minimo 50 caracteres). Para probarlo en una base nueva:
-- CALL sp_crear_admin_inicial('Prueba','Texto','CC','1777777777','a@b.com','c@d.com','MiClave123');
-- da ERROR 1644: Envie el hash bcrypt de la contrasena, nunca la contrasena en texto plano

-- el hash se genera y verifica fuera de la base, en el backend
-- (GENERAR_HASH_BCRYPT.js y VERIFICAR_HASH_BCRYPT.js en esta carpeta).
-- en el login el backend lee el hash del usuario por correo
-- y compara con bcrypt.compare(contrasena, hash), la base nunca ve la contrasena

-- roles y permisos de la aplicacion
-- cada usuario tiene un rol y cada rol sus permisos (tabla roles_permisos)

-- permisos de cada rol
SELECT r.nombre_rol, COUNT(rp.id_permiso) AS permisos, GROUP_CONCAT(p.codigo_permiso ORDER BY p.codigo_permiso SEPARATOR ', ') AS lista
  FROM roles r
  LEFT JOIN roles_permisos rp ON rp.id_rol = r.id_rol
  LEFT JOIN permisos p ON p.id_permiso = rp.id_permiso
 GROUP BY r.id_rol, r.nombre_rol
 ORDER BY permisos DESC;

-- permisos de un usuario (vista)
SELECT * FROM v_permisos_usuario WHERE correo_usuario = 'repartidor.140@coffeepark.com';

-- permiso puntual con funcion: el repartidor puede entregar y el cocinero no
SELECT fn_puede_entregar(6) AS repartidor_puede_entregar, fn_puede_entregar(3) AS cocinero_puede_entregar;

-- un usuario inactivo pierde el acceso (se desactiva, no se borra)
-- UPDATE usuarios SET estado_usuario = 0 WHERE correo_usuario = 'mesero.140@coffeepark.com';
-- con estado 0 el sistema rechaza sus operaciones ("@app_usuario_id no corresponde a un usuario activo")

-- cuentas del motor con privilegios minimos
-- la app no se conecta como root, se crean cuentas con lo necesario
-- cambiar las claves de ejemplo antes de usar en un entorno real

-- cuenta del backend: lee, escribe y ejecuta rutinas pero no cambia la estructura
CREATE USER IF NOT EXISTS 'bakeadmin_app'@'localhost' IDENTIFIED BY 'Cambiar_App_2026#';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON bakeadmin.* TO 'bakeadmin_app'@'localhost';

-- cuenta de reportes: solo lee las vistas (no ve las tablas ni los hashes)
CREATE USER IF NOT EXISTS 'bakeadmin_reportes'@'localhost' IDENTIFIED BY 'Cambiar_Rep_2026#';
GRANT SELECT ON bakeadmin.v_stock_insumos               TO 'bakeadmin_reportes'@'localhost';
GRANT SELECT ON bakeadmin.v_stock_productos             TO 'bakeadmin_reportes'@'localhost';
GRANT SELECT ON bakeadmin.v_insumos_a_reponer           TO 'bakeadmin_reportes'@'localhost';
GRANT SELECT ON bakeadmin.v_costo_insumo                TO 'bakeadmin_reportes'@'localhost';
GRANT SELECT ON bakeadmin.v_costo_receta                TO 'bakeadmin_reportes'@'localhost';
GRANT SELECT ON bakeadmin.v_prefactura                  TO 'bakeadmin_reportes'@'localhost';
GRANT SELECT ON bakeadmin.v_prefactura_detalle          TO 'bakeadmin_reportes'@'localhost';
GRANT SELECT ON bakeadmin.v_ventas_por_dia              TO 'bakeadmin_reportes'@'localhost';
GRANT SELECT ON bakeadmin.v_ordenes_pendientes_factura  TO 'bakeadmin_reportes'@'localhost';
GRANT SELECT ON bakeadmin.v_pedidos_en_curso            TO 'bakeadmin_reportes'@'localhost';
GRANT SELECT ON bakeadmin.v_carga_repartidores          TO 'bakeadmin_reportes'@'localhost';

FLUSH PRIVILEGES;

-- privilegios concedidos
SHOW GRANTS FOR 'bakeadmin_app'@'localhost';
SHOW GRANTS FOR 'bakeadmin_reportes'@'localhost';

-- para quitar las cuentas:
-- DROP USER 'bakeadmin_app'@'localhost';
-- DROP USER 'bakeadmin_reportes'@'localhost';

-- otras practicas de seguridad del esquema
-- llaves foraneas: 27, y 24 con ON DELETE RESTRICT (no se borran datos con historial)
-- CHECK: estados 0/1, cantidades > 0, precios >= 0, tipos de documento validos, correos distintos
-- UNIQUE: correo de usuario, documento de persona, NIT de proveedor, nombres de producto, insumo y sede
-- triggers: pedidos, producciones y precios historicos no se borran ni se alteran
-- trazabilidad: cada operacion pide @app_usuario_id (usuario activo)
-- estados controlados: solo transiciones validas en pedido, orden de compra y traslado
-- precio e IVA de cada venta quedan fijos en la linea
-- los usuarios se desactivan (estado_usuario = 0), no se eliminan
-- el correo de recuperacion es distinto del de acceso (CHECK)
-- las pruebas de estas reglas estan en BD_PRUEBAS_REGLAS_BAKEADMIN.sql (carpeta 03_sentencias_dml)
