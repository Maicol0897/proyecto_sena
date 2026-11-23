-- BAKEADMIN v4 - pruebas de reglas de negocio
-- Cada bloque intenta algo invalido y la base de datos lo tiene que rechazar.
-- Correr despues de BD_DML_BAKEADMIN.sql. Todo va en una transaccion con ROLLBACK, no cambia datos.
-- Ejecutar cada bloque por separado (o con 'continuar en caso de error').
-- Abajo de cada prueba esta el error que debe mostrar.

USE bakeadmin;

-- un segundo administrador inicial no se permite
-- da ERROR 1644: Ya existe un administrador; este procedimiento solo sirve para el primero
START TRANSACTION;
CALL sp_crear_admin_inicial('Otro','Admin','CC','1999999999','otro@coffeepark.com','otro.rec@gmail.com','x');
ROLLBACK;

-- correo de usuario repetido (UNIQUE)
-- da ERROR 1062: Duplicate entry 'admin@coffeepark.com' for key 'uq_usuario_correo'
START TRANSACTION;
INSERT INTO usuarios (id_rol,id_informacion,id_sede,correo_usuario,contrasena_usuario,correo_recuperacion_usuario) VALUES (2,2,1,'admin@coffeepark.com','hash','otro@gmail.com');
ROLLBACK;

-- numero de documento repetido (UNIQUE)
-- da ERROR 1062: Duplicate entry '1000000002' for key 'uq_informacion_documento'
START TRANSACTION;
INSERT INTO informacion_complementaria (nombres,apellidos,tipo_documento,numero_documento) VALUES ('Repetido','Prueba','CC','1000000002');
ROLLBACK;

-- tipo de documento fuera de la lista (CHECK)
-- da ERROR 4025: CONSTRAINT `chk_informacion_tipo` failed for `bakeadmin`.`informacion_complementaria`
START TRANSACTION;
INSERT INTO informacion_complementaria (nombres,apellidos,tipo_documento,numero_documento) VALUES ('Prueba','Check','XX','1888888888');
ROLLBACK;

-- usuario con rol inexistente (llave foranea)
-- da ERROR 1452: Cannot add or update a child row: a foreign key constraint fails
START TRANSACTION;
INSERT INTO usuarios (id_rol,id_informacion,id_sede,correo_usuario,contrasena_usuario,correo_recuperacion_usuario) VALUES (99,9,1,'fk@coffeepark.com','hash','fk2@gmail.com');
ROLLBACK;

-- no se borra una sede con usuarios (ON DELETE RESTRICT)
-- da ERROR 1451: Cannot delete or update a parent row: a foreign key constraint fails
START TRANSACTION;
DELETE FROM sedes WHERE id_sede = 1;
ROLLBACK;

-- no se borra un producto ya vendido (ON DELETE RESTRICT)
-- da ERROR 1451: Cannot delete or update a parent row: a foreign key constraint fails
START TRANSACTION;
DELETE FROM productos WHERE id_producto = 1;
ROLLBACK;

-- un pedido solo puede nacer pendiente
-- da ERROR 1644: Todo pedido nace pendiente
START TRANSACTION;
INSERT INTO pedidos (id_cliente,direccion_entrega,metodo_pago,estado_pedido) VALUES (1,'Calle 1','efectivo','entregado');
ROLLBACK;

-- un pedido pendiente no salta directo a entregado
-- da ERROR 1644: Cambio de estado de pedido no permitido
START TRANSACTION;
UPDATE pedidos SET estado_pedido='entregado' WHERE id_pedido=5;
ROLLBACK;

-- los pedidos no se eliminan, se cancelan
-- da ERROR 1644: Los pedidos no se eliminan; se cancelan
START TRANSACTION;
DELETE FROM pedidos WHERE id_pedido=6;
ROLLBACK;

-- un pedido ya aceptado no cambia sus productos
-- da ERROR 1644: Solo se modifican los productos de un pedido pendiente
START TRANSACTION;
UPDATE detalle_pedido SET cantidad=50 WHERE id_pedido=4;
ROLLBACK;

-- no se acepta un pedido sin saber quien lo hace (@app_usuario_id)
-- da ERROR 1644: Defina @app_usuario_id (usuario que realiza la operacion) antes de ejecutar esta accion
START TRANSACTION;
SET @app_usuario_id = NULL;
UPDATE pedidos SET estado_pedido='aceptado' WHERE id_pedido=5;
ROLLBACK;

-- la planta no vende: no puede aceptar pedidos
-- da ERROR 1644: Los pedidos los atiende un punto de venta (la planta no vende)
START TRANSACTION;
SET @app_usuario_id = 3;
UPDATE pedidos SET estado_pedido='aceptado' WHERE id_pedido=5;
ROLLBACK;

-- no se acepta un pedido si no hay producto terminado en la sede
-- da ERROR 1644: Stock insuficiente de producto terminado en la sede que acepta el pedido
START TRANSACTION;
SET @app_usuario_id = 5;
INSERT INTO pedidos (id_cliente,direccion_entrega,metodo_pago) VALUES (1,'Calle 1','efectivo');
SET @p = LAST_INSERT_ID();
INSERT INTO detalle_pedido (id_pedido,id_producto,cantidad) VALUES (@p,4,999);
UPDATE pedidos SET estado_pedido='aceptado' WHERE id_pedido=@p;
ROLLBACK;

-- no se envia una orden de compra sin lineas
-- da ERROR 1644: No se envia una orden sin lineas
START TRANSACTION;
INSERT INTO ordenes_compra (id_proveedor,id_usuario) VALUES (1,2);
UPDATE ordenes_compra SET estado_orden='enviada', metodo_envio='correo_automatico' WHERE id_orden_compra=LAST_INSERT_ID();
ROLLBACK;

-- el proveedor debe ofrecer el insumo que se le pide
-- da ERROR 1644: El proveedor de la orden no ofrece ese insumo (ver insumos_proveedores)
START TRANSACTION;
INSERT INTO ordenes_compra (id_proveedor,id_usuario) VALUES (1,2);
INSERT INTO detalle_orden_compra (id_orden_compra,id_insumo,cantidad_pedida) VALUES (LAST_INSERT_ID(),8,1000);
ROLLBACK;

-- una compra no puede superar el stock maximo del insumo
-- da ERROR 1644: La linea supera el stock maximo del insumo (stock + en camino + pedido)
START TRANSACTION;
INSERT INTO ordenes_compra (id_proveedor,id_usuario) VALUES (1,2);
INSERT INTO detalle_orden_compra (id_orden_compra,id_insumo,cantidad_pedida) VALUES (LAST_INSERT_ID(),1,900000);
ROLLBACK;

-- no se produce sin insumos suficientes en la sede
-- da ERROR 1644: Stock insuficiente de insumos en la sede para esta produccion
START TRANSACTION;
INSERT INTO producciones (id_producto,id_usuario,cantidad_producida) VALUES (1,3,100000);
ROLLBACK;

-- una produccion registrada no se modifica
-- da ERROR 1644: Una produccion registrada no se modifica; registre otra
START TRANSACTION;
UPDATE producciones SET cantidad_producida=1 WHERE id_produccion=1;
ROLLBACK;

-- una receta ya usada en produccion no se modifica
-- da ERROR 1644: La receta ya se uso en producciones y no se modifica (el consumo historico dejaria de cuadrar)
START TRANSACTION;
UPDATE recetas SET cantidad_necesaria=999 WHERE id_producto=1 AND id_insumo=1;
ROLLBACK;

-- un traslado debe ir a una sede distinta del origen
-- da ERROR 1644: El traslado debe ir a una sede distinta de la de origen
START TRANSACTION;
INSERT INTO traslados (id_sede_destino,id_usuario_envia) VALUES (5,2);
ROLLBACK;

-- quien ya registro documentos no cambia de sede
-- da ERROR 1644: Un usuario con documentos registrados no cambia de sede (cree otro usuario para la nueva sede)
START TRANSACTION;
UPDATE usuarios SET id_sede=2 WHERE id_usuario=5;
ROLLBACK;

-- el traslado lo recibe un usuario de la sede destino
-- da ERROR 1644: El traslado lo recibe un usuario de la sede destino
START TRANSACTION;
SET @app_usuario_id = 7;
UPDATE traslados SET estado_traslado='recibido' WHERE id_traslado=3;
ROLLBACK;
