-- BAKEADMIN - sentencias DML (datos de prueba, consultas y operaciones)
-- Coffee Park - SENA ADSO ficha 3388489
--
-- Primero correr 01_base_datos/DB_BAKEADMIN_COMPLETO.sql (deja roles, permisos y las 5 sedes)
-- y despues este archivo completo. Los ids suponen una base recien creada.
-- Las contrasenas van con hash bcrypt, no en texto plano (mirar 04_seguridad_db).
-- @app_usuario_id es la variable que dice quien hizo cada operacion.

USE bakeadmin;

-- datos maestros
-- administrador inicial (el procedimiento exige el hash)
CALL sp_crear_admin_inicial('Duberney', 'Soto Vera', 'CC', '1000000001',
     'admin@coffeepark.com', 'duberney.recuperacion@gmail.com', '$2b$10$z9SpGEjjwP/QBhitXhF32.OrLyw1C4OUvICcbhDXCZ7MsLoMWwbTe');

-- personas: empleados y clientes
INSERT INTO informacion_complementaria (nombres, apellidos, tipo_documento, numero_documento, numero_telefono, direccion) VALUES
('Carlos Andres', 'Mejia Rojas',   'CC', '1000000002', '3101000002', 'Calle 10 # 5-20'),
('Laura Camila',  'Gomez Perez',   'CC', '1000000003', '3101000003', 'Carrera 15 # 100-30'),
('Santiago',      'Alfonso Romero','CC', '1000000004', '3101000004', 'Calle 140 # 11-45'),
('Maicol Esneider','Ortiz Lopez',  'CC', '1000000005', '3101000005', 'Carrera 7 # 63-10'),
('Juan Pablo',    'Rincon Diaz',   'CC', '1000000006', '3101000006', 'Calle 104 # 14-22'),
('Andrea',        'Velasquez Cruz','CC', '1000000007', '3101000007', 'Avenida 19 # 104-50'),
('Maria Fernanda','Lopez Torres',  'CC', '1000000008', '3201000008', 'Calle 134 # 19-12'),
('Carlos',        'Ruiz Herrera',  'CC', '1000000009', '3201000009', 'Carrera 11 # 140-18'),
('Valentina',     'Castro Mora',   'CC', '1000000010', '3201000010', 'Calle 63 # 24-40');

-- usuarios con rol y sede (sedes: 1=140, 2=104, 3=63, 4=Restrepo, 5=Planta)
INSERT INTO usuarios (id_rol, id_informacion, id_sede, correo_usuario, contrasena_usuario, correo_recuperacion_usuario) VALUES
((SELECT id_rol FROM roles WHERE nombre_rol='gerente_sede'), 2, 5, 'gerente.planta@coffeepark.com', '$2b$10$r7CbOFOwg01tdjpjZy61h.EfGWAuic9HSVayrVXPC9YddJZKbD7ga', 'carlos.mejia.rec@gmail.com'),
((SELECT id_rol FROM roles WHERE nombre_rol='cocinero'),     3, 5, 'cocina.planta@coffeepark.com',  '$2b$10$5M5ryEiuU5QmJVRYgU1KO.T56LKh2xR7mGRJxsZzXg29Kub8VCFlK', 'laura.gomez.rec@gmail.com'),
((SELECT id_rol FROM roles WHERE nombre_rol='gerente_sede'), 4, 1, 'gerente.140@coffeepark.com',    '$2b$10$yUN9kBvu1B8rc2WXvuYqJues5JdwvZICFnEY2jAwAfoWyjjanQe0a', 'santiago.rec@gmail.com'),
((SELECT id_rol FROM roles WHERE nombre_rol='mesero'),       5, 1, 'mesero.140@coffeepark.com',     '$2b$10$XDqHnEB0hgdbhzILxMUyVunBCEK5nz9.LfCJNWiYZf8edc1rxsQwy', 'maicol.rec@gmail.com'),
((SELECT id_rol FROM roles WHERE nombre_rol='repartidor'),   6, 1, 'repartidor.140@coffeepark.com', '$2b$10$Qp6/4r3s/E0xzGuTirUR.eJKR4Ko.vRsmnwqQf7ZdclLtYG47zYOS', 'juan.rincon.rec@gmail.com'),
((SELECT id_rol FROM roles WHERE nombre_rol='gerente_sede'), 7, 2, 'gerente.104@coffeepark.com',    '$2b$10$EilNG9CXb118c6ZXRvO/4.nIK01DxbbLJDM7WzMj5MtNvcidbZL/6', 'andrea.rec@gmail.com');
-- ids que quedan: 1 admin, 2 gerente planta, 3 cocinero planta, 4 gerente 140, 5 mesero 140, 6 repartidor 140, 7 gerente 104

-- clientes (usan la misma tabla de datos personales)
INSERT INTO clientes (id_informacion) VALUES (8), (9), (10);

-- insumos (el stock actual no se guarda, se calcula)
INSERT INTO insumos (nombre_insumo, unidad_medida_insumo, stock_minimo_insumo, stock_maximo_insumo) VALUES
('Harina de trigo',   'g',   20000, 200000),
('Azucar',            'g',   10000, 100000),
('Mantequilla',       'g',    5000,  60000),
('Huevos',            'und',    60,    600),
('Leche entera',      'ml',  10000, 120000),
('Chocolate semiamargo','g',  3000,  40000),
('Levadura',          'g',    1000,  10000),
('Cafe en grano',     'g',    5000,  50000);

-- proveedores
INSERT INTO proveedores (nit_proveedor, nombre_proveedor, correo_proveedor, telefono_proveedor) VALUES
('900111222-1', 'Molinos del Tolima SAS',     'ventas@molinostolima.com', '6015550101'),
('900333444-5', 'Lacteos La Sabana SAS',      'pedidos@lacteossabana.com','6015550102'),
('900555666-9', 'Distribuidora El Cacao Ltda', NULL,                      '6015550103');

-- que insumos vende cada proveedor y a que precio
INSERT INTO insumos_proveedores (id_insumo, id_proveedor, precio_actual) VALUES
(1, 1, 3.2000), (2, 1, 3.8000), (7, 1, 28.0000),
(3, 2, 32.0000), (5, 2, 4.1000), (4, 2, 650.0000),
(6, 3, 45.0000), (8, 3, 52.0000), (2, 3, 4.0000);

-- productos
INSERT INTO productos (nombre_producto, precio_venta, porcentaje_iva) VALUES
('Croissant de mantequilla', 6500.00, 0.00),
('Pan artesanal',            8000.00, 0.00),
('Brownie de chocolate',     7500.00, 19.00),
('Torta de chocolate',      68000.00, 19.00),
('Galleta de mantequilla',   3500.00, 19.00),
('Cafe molido 250 g',       24000.00, 19.00);

-- recetas: cantidad de insumo por una unidad de producto
INSERT INTO recetas (id_producto, id_insumo, cantidad_necesaria) VALUES
(1, 1, 60), (1, 3, 35), (1, 2, 5),  (1, 7, 2), (1, 4, 0.5),
(2, 1, 250),(2, 7, 5),
(3, 6, 45), (3, 3, 30), (3, 2, 40), (3, 4, 1), (3, 1, 20),
(4, 1, 300),(4, 6, 200),(4, 2, 250),(4, 3, 150),(4, 4, 6), (4, 5, 150),
(5, 1, 25), (5, 3, 15), (5, 2, 12),
(6, 8, 250);

-- compras
-- el flujo es borrador, enviada, pendiente_factura y facturada

-- orden 1: la crea el gerente de planta (usuario 2) a Molinos del Tolima
INSERT INTO ordenes_compra (id_proveedor, id_usuario) VALUES (1, 2);
INSERT INTO detalle_orden_compra (id_orden_compra, id_insumo, cantidad_pedida) VALUES
(1, 1, 150000), (1, 2, 60000), (1, 7, 5000);   -- precio pactado = precio vigente del proveedor
UPDATE ordenes_compra SET estado_orden = 'enviada', metodo_envio = 'correo_automatico' WHERE id_orden_compra = 1;

-- recepcion: la hace el cocinero de planta (usuario 3)
SET @app_usuario_id = 3;
UPDATE detalle_orden_compra SET cantidad_recibida = 150000 WHERE id_orden_compra = 1 AND id_insumo = 1;
UPDATE detalle_orden_compra SET cantidad_recibida = 58000  WHERE id_orden_compra = 1 AND id_insumo = 2;   -- llego menos
UPDATE detalle_orden_compra SET cantidad_recibida = 5000   WHERE id_orden_compra = 1 AND id_insumo = 7;   -- ultima linea, la orden se cierra sola
-- la orden queda en pendiente_factura, ahora se factura
UPDATE ordenes_compra SET estado_orden = 'facturada' WHERE id_orden_compra = 1;

-- orden 2: lacteos
INSERT INTO ordenes_compra (id_proveedor, id_usuario) VALUES (2, 2);
INSERT INTO detalle_orden_compra (id_orden_compra, id_insumo, cantidad_pedida) VALUES
(2, 3, 40000), (2, 5, 60000), (2, 4, 400);
UPDATE ordenes_compra SET estado_orden = 'enviada', metodo_envio = 'correo_automatico' WHERE id_orden_compra = 2;
UPDATE detalle_orden_compra SET cantidad_recibida = 40000 WHERE id_orden_compra = 2 AND id_insumo = 3;
UPDATE detalle_orden_compra SET cantidad_recibida = 60000 WHERE id_orden_compra = 2 AND id_insumo = 5;
UPDATE detalle_orden_compra SET cantidad_recibida = 400   WHERE id_orden_compra = 2 AND id_insumo = 4;   -- queda pendiente_factura

-- orden 3: chocolate y cafe (el proveedor no tiene correo, se envia en PDF)
INSERT INTO ordenes_compra (id_proveedor, id_usuario) VALUES (3, 2);
INSERT INTO detalle_orden_compra (id_orden_compra, id_insumo, cantidad_pedida) VALUES
(3, 6, 30000), (3, 8, 20000);
UPDATE ordenes_compra SET estado_orden = 'enviada', metodo_envio = 'pdf_manual' WHERE id_orden_compra = 3;
UPDATE detalle_orden_compra SET cantidad_recibida = 30000 WHERE id_orden_compra = 3 AND id_insumo = 6;
UPDATE detalle_orden_compra SET cantidad_recibida = 20000 WHERE id_orden_compra = 3 AND id_insumo = 8;

-- orden 4: se deja en borrador
INSERT INTO ordenes_compra (id_proveedor, id_usuario) VALUES (1, 2);
INSERT INTO detalle_orden_compra (id_orden_compra, id_insumo, cantidad_pedida) VALUES (4, 1, 20000);

-- orden 5: enviada y sin recibir
INSERT INTO ordenes_compra (id_proveedor, id_usuario) VALUES (2, 2);
INSERT INTO detalle_orden_compra (id_orden_compra, id_insumo, cantidad_pedida) VALUES (5, 4, 100);
UPDATE ordenes_compra SET estado_orden = 'enviada', metodo_envio = 'correo_automatico' WHERE id_orden_compra = 5;

-- orden 6: cancelada antes de enviarla
INSERT INTO ordenes_compra (id_proveedor, id_usuario) VALUES (3, 2);
INSERT INTO detalle_orden_compra (id_orden_compra, id_insumo, cantidad_pedida) VALUES (6, 2, 10000);
UPDATE ordenes_compra SET estado_orden = 'cancelada' WHERE id_orden_compra = 6;

-- produccion (la hace el cocinero de planta y descuenta insumos segun la receta)
INSERT INTO producciones (id_producto, id_usuario, cantidad_producida) VALUES
(1, 3, 300),   -- croissants
(2, 3, 100),   -- pan artesanal
(3, 3, 150),   -- brownies
(4, 3, 10),   -- tortas
(5, 3, 300),   -- galletas
(6, 3, 60);   -- cafe molido

-- traslados de la planta a los puntos de venta
-- pendiente, en_transito, recibido

-- traslado 1: planta a sede 140
INSERT INTO traslados (id_sede_destino, id_usuario_envia) VALUES (1, 2);
INSERT INTO detalle_traslado (id_traslado, id_producto, cantidad) VALUES
(1, 1, 120), (1, 2, 40), (1, 3, 60), (1, 4, 4), (1, 5, 120), (1, 6, 20);
UPDATE traslados SET estado_traslado = 'en_transito' WHERE id_traslado = 1;
SET @app_usuario_id = 4;
UPDATE traslados SET estado_traslado = 'recibido' WHERE id_traslado = 1;

-- traslado 2: planta a sede 104
INSERT INTO traslados (id_sede_destino, id_usuario_envia) VALUES (2, 2);
INSERT INTO detalle_traslado (id_traslado, id_producto, cantidad) VALUES (2, 1, 100), (2, 3, 50), (2, 5, 80);
UPDATE traslados SET estado_traslado = 'en_transito' WHERE id_traslado = 2;
SET @app_usuario_id = 7;
UPDATE traslados SET estado_traslado = 'recibido' WHERE id_traslado = 2;

-- traslado 3: en transito
INSERT INTO traslados (id_sede_destino, id_usuario_envia) VALUES (1, 2);
INSERT INTO detalle_traslado (id_traslado, id_producto, cantidad) VALUES (3, 1, 30);
UPDATE traslados SET estado_traslado = 'en_transito' WHERE id_traslado = 3;

-- traslado 4: pendiente, todavia se puede editar
INSERT INTO traslados (id_sede_destino, id_usuario_envia) VALUES (2, 2);
INSERT INTO detalle_traslado (id_traslado, id_producto, cantidad) VALUES (4, 2, 20);

-- pedidos a domicilio de la sede 140
-- pendiente, aceptado, en_preparacion, despachado, entregado o cancelado
-- el precio y el IVA de cada linea salen del producto

-- pedido 1: entregado
INSERT INTO pedidos (id_cliente, direccion_entrega, metodo_pago) VALUES (1, 'Calle 134 # 19-12 Apto 301', 'nequi');
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad) VALUES (1, 1, 4), (1, 3, 2), (1, 6, 1);
SET @app_usuario_id = 5;
UPDATE pedidos SET estado_pedido = 'aceptado'       WHERE id_pedido = 1;
UPDATE pedidos SET estado_pedido = 'en_preparacion' WHERE id_pedido = 1;
UPDATE pedidos SET id_usuario_repartidor = 6, estado_pedido = 'despachado' WHERE id_pedido = 1;   -- repartidor asignado a mano (usuario 6)
UPDATE pedidos SET estado_pedido = 'entregado'      WHERE id_pedido = 1;

-- pedido 2: despachado
INSERT INTO pedidos (id_cliente, direccion_entrega, metodo_pago) VALUES (2, '', 'efectivo');   -- direccion vacia, usa la del cliente
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad) VALUES (2, 2, 3), (2, 5, 12);
UPDATE pedidos SET estado_pedido = 'aceptado'       WHERE id_pedido = 2;
UPDATE pedidos SET estado_pedido = 'en_preparacion' WHERE id_pedido = 2;
UPDATE pedidos SET estado_pedido = 'despachado'     WHERE id_pedido = 2;   -- sin repartidor, el sistema asigna el de menor carga

-- pedido 3: en preparacion
INSERT INTO pedidos (id_cliente, direccion_entrega, metodo_pago) VALUES (3, 'Calle 63 # 24-40', 'tarjeta');
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad) VALUES (3, 4, 2), (3, 1, 6);
UPDATE pedidos SET estado_pedido = 'aceptado'       WHERE id_pedido = 3;
UPDATE pedidos SET estado_pedido = 'en_preparacion' WHERE id_pedido = 3;

-- pedido 4: aceptado
INSERT INTO pedidos (id_cliente, direccion_entrega, metodo_pago) VALUES (1, 'Calle 134 # 19-12 Apto 301', 'transferencia');
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad) VALUES (4, 3, 5);
UPDATE pedidos SET estado_pedido = 'aceptado' WHERE id_pedido = 4;

-- pedido 5: pendiente
INSERT INTO pedidos (id_cliente, direccion_entrega, metodo_pago) VALUES (2, 'Carrera 11 # 140-18', 'efectivo');
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad) VALUES (5, 1, 2), (5, 5, 6);

-- pedido 6: cancelado
INSERT INTO pedidos (id_cliente, direccion_entrega, metodo_pago) VALUES (3, 'Calle 63 # 24-40', 'nequi');
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad) VALUES (6, 2, 1);
UPDATE pedidos SET estado_pedido = 'cancelado' WHERE id_pedido = 6;

-- consultas

-- usuarios con su rol, sede y datos personales (INNER JOIN)
SELECT u.id_usuario, CONCAT(i.nombres,' ',i.apellidos) AS empleado, u.correo_usuario, r.nombre_rol, s.nombre_sede
  FROM usuarios u
  JOIN informacion_complementaria i ON i.id_informacion = u.id_informacion
  JOIN roles r ON r.id_rol = u.id_rol
  LEFT JOIN sedes s ON s.id_sede = u.id_sede
 ORDER BY u.id_usuario;

-- permisos de cada rol (4 tablas)
SELECT r.nombre_rol, p.codigo_permiso, p.descripcion_permiso
  FROM roles r
  JOIN roles_permisos rp ON rp.id_rol = r.id_rol
  JOIN permisos p ON p.id_permiso = rp.id_permiso
 ORDER BY r.nombre_rol, p.codigo_permiso;

-- roles sin usuarios (LEFT JOIN)
SELECT r.nombre_rol, COUNT(u.id_usuario) AS usuarios
  FROM roles r LEFT JOIN usuarios u ON u.id_rol = r.id_rol
 GROUP BY r.id_rol, r.nombre_rol
HAVING COUNT(u.id_usuario) = 0;

-- proveedores y sus insumos (muchos a muchos)
SELECT pr.nombre_proveedor, ins.nombre_insumo, ins.unidad_medida_insumo, ip.precio_actual
  FROM insumos_proveedores ip
  JOIN proveedores pr ON pr.id_proveedor = ip.id_proveedor
  JOIN insumos ins ON ins.id_insumo = ip.id_insumo
 WHERE ip.estado_oferta = 1
 ORDER BY ins.nombre_insumo, ip.precio_actual;

-- proveedor mas barato de cada insumo (subconsulta)
SELECT ins.nombre_insumo, pr.nombre_proveedor, ip.precio_actual
  FROM insumos_proveedores ip
  JOIN insumos ins ON ins.id_insumo = ip.id_insumo
  JOIN proveedores pr ON pr.id_proveedor = ip.id_proveedor
 WHERE ip.precio_actual = (SELECT MIN(x.precio_actual) FROM insumos_proveedores x WHERE x.id_insumo = ip.id_insumo)
 ORDER BY ins.nombre_insumo;

-- receta de cada producto con el costo de sus insumos
SELECT p.nombre_producto, ins.nombre_insumo, r.cantidad_necesaria, ins.unidad_medida_insumo,
       ROUND(r.cantidad_necesaria * (SELECT MIN(ip.precio_actual) FROM insumos_proveedores ip WHERE ip.id_insumo = ins.id_insumo), 2) AS costo_linea
  FROM recetas r
  JOIN productos p ON p.id_producto = r.id_producto
  JOIN insumos ins ON ins.id_insumo = r.id_insumo
 ORDER BY p.nombre_producto, ins.nombre_insumo;

-- ordenes de compra con proveedor, creador, sede y total
SELECT o.id_orden_compra, pr.nombre_proveedor, s.nombre_sede, o.estado_orden, o.metodo_envio,
       SUM(d.cantidad_pedida * d.precio_pactado) AS total_pedido
  FROM ordenes_compra o
  JOIN proveedores pr ON pr.id_proveedor = o.id_proveedor
  JOIN usuarios u ON u.id_usuario = o.id_usuario
  JOIN sedes s ON s.id_sede = u.id_sede
  JOIN detalle_orden_compra d ON d.id_orden_compra = o.id_orden_compra
 GROUP BY o.id_orden_compra, pr.nombre_proveedor, s.nombre_sede, o.estado_orden, o.metodo_envio
 ORDER BY o.id_orden_compra;

-- lineas donde llego menos de lo pedido
SELECT d.id_orden_compra, ins.nombre_insumo, d.cantidad_pedida, d.cantidad_recibida,
       d.cantidad_pedida - d.cantidad_recibida AS faltante
  FROM detalle_orden_compra d JOIN insumos ins ON ins.id_insumo = d.id_insumo
 WHERE d.cantidad_recibida IS NOT NULL AND d.cantidad_recibida < d.cantidad_pedida;

-- productos que ya se vendieron (subconsulta con IN)
SELECT nombre_producto FROM productos
 WHERE id_producto IN (SELECT dp.id_producto FROM detalle_pedido dp JOIN pedidos pe ON pe.id_pedido = dp.id_pedido WHERE pe.estado_pedido <> 'cancelado');

-- productos que nunca se han pedido (NOT EXISTS)
SELECT p.nombre_producto FROM productos p
 WHERE NOT EXISTS (SELECT 1 FROM detalle_pedido dp WHERE dp.id_producto = p.id_producto);

-- produccion por producto
SELECT p.nombre_producto, COUNT(*) AS lotes, SUM(pr.cantidad_producida) AS unidades
  FROM producciones pr JOIN productos p ON p.id_producto = pr.id_producto
 GROUP BY p.id_producto, p.nombre_producto ORDER BY unidades DESC;

-- traslados con origen, destino y unidades
SELECT t.id_traslado, so.nombre_sede AS origen, sd.nombre_sede AS destino, t.estado_traslado,
       SUM(dt.cantidad) AS unidades
  FROM traslados t
  JOIN usuarios ue ON ue.id_usuario = t.id_usuario_envia
  JOIN sedes so ON so.id_sede = ue.id_sede
  JOIN sedes sd ON sd.id_sede = t.id_sede_destino
  JOIN detalle_traslado dt ON dt.id_traslado = t.id_traslado
 GROUP BY t.id_traslado, so.nombre_sede, sd.nombre_sede, t.estado_traslado
 ORDER BY t.id_traslado;

-- pedidos con cliente, quien acepto, repartidor y total
SELECT pe.id_pedido, CONCAT(ci.nombres,' ',ci.apellidos) AS cliente, pe.estado_pedido, pe.metodo_pago,
       CONCAT(ia.nombres,' ',ia.apellidos) AS acepto, CONCAT(ir.nombres,' ',ir.apellidos) AS repartidor,
       SUM(dp.cantidad * dp.precio_unitario) AS subtotal
  FROM pedidos pe
  JOIN clientes c ON c.id_cliente = pe.id_cliente
  JOIN informacion_complementaria ci ON ci.id_informacion = c.id_informacion
  LEFT JOIN usuarios ua ON ua.id_usuario = pe.id_usuario_acepta
  LEFT JOIN informacion_complementaria ia ON ia.id_informacion = ua.id_informacion
  LEFT JOIN usuarios ur ON ur.id_usuario = pe.id_usuario_repartidor
  LEFT JOIN informacion_complementaria ir ON ir.id_informacion = ur.id_informacion
  JOIN detalle_pedido dp ON dp.id_pedido = pe.id_pedido
 GROUP BY pe.id_pedido, cliente, pe.estado_pedido, pe.metodo_pago, acepto, repartidor
 ORDER BY pe.id_pedido;

-- clientes que mas compran (subconsulta en FROM)
SELECT t.cliente, t.pedidos, t.total_comprado
  FROM (SELECT CONCAT(i.nombres,' ',i.apellidos) AS cliente, COUNT(DISTINCT pe.id_pedido) AS pedidos,
               SUM(dp.cantidad * dp.precio_unitario) AS total_comprado
          FROM pedidos pe
          JOIN clientes c ON c.id_cliente = pe.id_cliente
          JOIN informacion_complementaria i ON i.id_informacion = c.id_informacion
          JOIN detalle_pedido dp ON dp.id_pedido = pe.id_pedido
         WHERE pe.estado_pedido <> 'cancelado'
         GROUP BY c.id_cliente, cliente) t
 ORDER BY t.total_comprado DESC;

-- productos mas vendidos
SELECT p.nombre_producto, SUM(dp.cantidad) AS unidades_vendidas
  FROM detalle_pedido dp
  JOIN pedidos pe ON pe.id_pedido = dp.id_pedido AND pe.estado_pedido = 'entregado'
  JOIN productos p ON p.id_producto = dp.id_producto
 GROUP BY p.id_producto, p.nombre_producto
 ORDER BY unidades_vendidas DESC;

-- pedidos por estado
SELECT estado_pedido, COUNT(*) AS cantidad FROM pedidos GROUP BY estado_pedido ORDER BY cantidad DESC;

-- vistas del sistema
SELECT * FROM v_stock_insumos ORDER BY nombre_sede, nombre_insumo;
SELECT * FROM v_stock_productos ORDER BY nombre_sede, nombre_producto;
SELECT * FROM v_insumos_a_reponer;
SELECT * FROM v_costo_insumo;
SELECT * FROM v_costo_receta;
SELECT * FROM v_prefactura ORDER BY numero_prefactura;
SELECT * FROM v_prefactura_detalle WHERE id_pedido = 1;
SELECT * FROM v_ventas_por_dia;
SELECT * FROM v_ordenes_pendientes_factura;
SELECT * FROM v_pedidos_en_curso;
SELECT * FROM v_carga_repartidores;
SELECT * FROM v_permisos_usuario WHERE correo_usuario = 'mesero.140@coffeepark.com';

-- funciones de stock de un producto y de un insumo en una sede
SELECT fn_stock_producto(1, 1) AS croissants_en_sede_140, fn_stock_insumo(1, 5) AS harina_en_planta;

-- margen por producto (precio de venta menos costo de receta)
SELECT nombre_producto, precio_venta, ROUND(costo_unitario_producto, 2) AS costo,
       ROUND(precio_venta - costo_unitario_producto, 2) AS margen
  FROM v_costo_receta ORDER BY margen DESC;

-- update y delete
-- los historicos no se pueden borrar, eso se prueba en BD_PRUEBAS_REGLAS_BAKEADMIN.sql

-- subir el stock maximo de un insumo
UPDATE insumos SET stock_maximo_insumo = 250000 WHERE nombre_insumo = 'Harina de trigo';

-- cambiar precio de venta (los pedidos viejos conservan el suyo)
UPDATE productos SET precio_venta = 6800.00 WHERE nombre_producto = 'Croissant de mantequilla';

-- el proveedor sube un precio (las ordenes viejas no cambian)
UPDATE insumos_proveedores SET precio_actual = 3.4000 WHERE id_insumo = 1 AND id_proveedor = 1;

-- desactivar un producto en vez de borrarlo
UPDATE productos SET estado_producto = 0 WHERE nombre_producto = 'Galleta de mantequilla';

-- cambiar el telefono de un cliente
UPDATE informacion_complementaria SET numero_telefono = '3209998877' WHERE numero_documento = '1000000009';

-- borrar una linea de una orden en borrador
DELETE FROM detalle_orden_compra WHERE id_orden_compra = 4 AND id_insumo = 1;

-- borrar una orden en borrador (solo se pueden las de borrador)
DELETE FROM ordenes_compra WHERE id_orden_compra = 4;

-- borrar un traslado pendiente, sus lineas se van con CASCADE
DELETE FROM traslados WHERE id_traslado = 4;

-- quitar un producto de un pedido pendiente
DELETE FROM detalle_pedido WHERE id_pedido = 5 AND id_producto = 5;

-- conteo final
SELECT 'usuarios' AS tabla, COUNT(*) AS filas FROM usuarios UNION ALL
SELECT 'clientes', COUNT(*) FROM clientes UNION ALL
SELECT 'insumos', COUNT(*) FROM insumos UNION ALL
SELECT 'productos', COUNT(*) FROM productos UNION ALL
SELECT 'ordenes_compra', COUNT(*) FROM ordenes_compra UNION ALL
SELECT 'producciones', COUNT(*) FROM producciones UNION ALL
SELECT 'traslados', COUNT(*) FROM traslados UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos;
