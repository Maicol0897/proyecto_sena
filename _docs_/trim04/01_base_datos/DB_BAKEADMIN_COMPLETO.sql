DROP SCHEMA IF EXISTS `bakeadmin`;
-- BAKEADMIN v4 - Coffee Park (MySQL 8 / MariaDB 10.5+)
-- Modelo en 3FN. No se guardan datos derivados:
-- la sede de cada documento sale de usuarios.id_sede, el inventario se calcula
-- y el costo del insumo y la prefactura son vistas. Los estados son ENUM.
-- Las llaves foraneas se llaman igual que la llave primaria que referencian.
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `bakeadmin` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `bakeadmin`;

-- usuarios y seguridad
CREATE TABLE `roles` (
  `id_rol` INT NOT NULL AUTO_INCREMENT,
  `nombre_rol` VARCHAR(50) NOT NULL,
  `descripcion_rol` VARCHAR(150) NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE INDEX `uq_rol_nombre` (`nombre_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[01 Usuarios]';

CREATE TABLE `permisos` (
  `id_permiso` INT NOT NULL AUTO_INCREMENT,
  `codigo_permiso` VARCHAR(60) NOT NULL,
  `descripcion_permiso` VARCHAR(150) NULL,
  PRIMARY KEY (`id_permiso`),
  UNIQUE INDEX `uq_permiso_codigo` (`codigo_permiso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[01 Usuarios]';

CREATE TABLE `roles_permisos` (
  `id_rol` INT NOT NULL,
  `id_permiso` INT NOT NULL,
  PRIMARY KEY (`id_rol`, `id_permiso`),
  INDEX `idx_rp_permiso` (`id_permiso`),
  CONSTRAINT `fk_rp_roles` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_rp_permisos` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id_permiso`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[01 Usuarios]';

CREATE TABLE `informacion_complementaria` (
  `id_informacion` INT NOT NULL AUTO_INCREMENT,
  `nombres` VARCHAR(80) NOT NULL,
  `apellidos` VARCHAR(80) NOT NULL,
  `tipo_documento` VARCHAR(5) NOT NULL,
  `numero_documento` VARCHAR(20) NOT NULL,
  `numero_telefono` VARCHAR(20) NULL,
  `direccion` VARCHAR(150) NULL,
  PRIMARY KEY (`id_informacion`),
  UNIQUE INDEX `uq_informacion_documento` (`numero_documento`),
  CONSTRAINT `chk_informacion_tipo` CHECK (`tipo_documento` IN ('CC','CE','TI','PP','NIT'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[01 Usuarios]';

CREATE TABLE `sedes` (
  `id_sede` INT NOT NULL AUTO_INCREMENT,
  `nombre_sede` VARCHAR(80) NOT NULL,
  `direccion_sede` VARCHAR(150) NOT NULL,
  `telefono_sede` VARCHAR(20) NULL,
  `tipo_sede` ENUM('punto_venta','planta') NOT NULL,
  `estado_sede` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_sede`),
  UNIQUE INDEX `uq_sede_nombre` (`nombre_sede`),
  CONSTRAINT `chk_sede_estado` CHECK (`estado_sede` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[01 Usuarios]';

CREATE TABLE `usuarios` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `id_rol` INT NOT NULL,
  `id_informacion` INT NOT NULL,
  `id_sede` INT NULL,
  `correo_usuario` VARCHAR(120) NOT NULL,
  `contrasena_usuario` VARCHAR(255) NOT NULL,
  `correo_recuperacion_usuario` VARCHAR(120) NOT NULL,
  `estado_usuario` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `uq_usuario_correo` (`correo_usuario`),
  UNIQUE INDEX `uq_usuario_informacion` (`id_informacion`),
  INDEX `idx_usuario_rol` (`id_rol`),
  INDEX `idx_usuario_sede` (`id_sede`),
  CONSTRAINT `fk_usuarios_roles` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_usuarios_informacion` FOREIGN KEY (`id_informacion`) REFERENCES `informacion_complementaria` (`id_informacion`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_usuarios_sedes` FOREIGN KEY (`id_sede`) REFERENCES `sedes` (`id_sede`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_usuario_estado` CHECK (`estado_usuario` IN (0,1)),
  CONSTRAINT `chk_usuario_correos` CHECK (`correo_usuario` <> `correo_recuperacion_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[01 Usuarios]';

CREATE TABLE `clientes` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `id_informacion` INT NOT NULL,
  `fecha_registro_cliente` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado_cliente` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_cliente`),
  UNIQUE INDEX `uq_cliente_informacion` (`id_informacion`),
  CONSTRAINT `fk_clientes_informacion` FOREIGN KEY (`id_informacion`) REFERENCES `informacion_complementaria` (`id_informacion`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_cliente_estado` CHECK (`estado_cliente` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[01 Usuarios]';

-- compras
CREATE TABLE `proveedores` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `nit_proveedor` VARCHAR(20) NOT NULL,
  `nombre_proveedor` VARCHAR(120) NOT NULL,
  `correo_proveedor` VARCHAR(120) NULL,
  `telefono_proveedor` VARCHAR(20) NULL,
  `estado_proveedor` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_proveedor`),
  UNIQUE INDEX `uq_proveedor_nit` (`nit_proveedor`),
  CONSTRAINT `chk_proveedor_estado` CHECK (`estado_proveedor` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[02 Compras]';

CREATE TABLE `insumos` (
  `id_insumo` INT NOT NULL AUTO_INCREMENT,
  `nombre_insumo` VARCHAR(100) NOT NULL,
  `unidad_medida_insumo` ENUM('g','ml','und') NOT NULL,
  `stock_minimo_insumo` DECIMAL(12,3) NOT NULL DEFAULT 0,
  `stock_maximo_insumo` DECIMAL(12,3) NOT NULL DEFAULT 0,
  `estado_insumo` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_insumo`),
  UNIQUE INDEX `uq_insumo_nombre` (`nombre_insumo`),
  CONSTRAINT `chk_insumo_valores` CHECK (`stock_minimo_insumo` >= 0 AND `stock_maximo_insumo` >= `stock_minimo_insumo` AND `estado_insumo` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[02 Compras]';

CREATE TABLE `insumos_proveedores` (
  `id_insumo` INT NOT NULL,
  `id_proveedor` INT NOT NULL,
  `precio_actual` DECIMAL(12,4) NOT NULL DEFAULT 0,
  `estado_oferta` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_insumo`, `id_proveedor`),
  INDEX `idx_ip_proveedor` (`id_proveedor`),
  CONSTRAINT `fk_ip_insumos` FOREIGN KEY (`id_insumo`) REFERENCES `insumos` (`id_insumo`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ip_proveedores` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_ip_valores` CHECK (`precio_actual` >= 0 AND `estado_oferta` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[02 Compras]';

CREATE TABLE `ordenes_compra` (
  `id_orden_compra` INT NOT NULL AUTO_INCREMENT,
  `id_proveedor` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  `id_usuario_recepcion` INT NULL,
  `fecha_orden` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado_orden` ENUM('borrador','enviada','pendiente_factura','facturada','cancelada','rechazada') NOT NULL DEFAULT 'borrador',
  `metodo_envio` ENUM('correo_automatico','pdf_manual') NULL,
  `fecha_envio` DATETIME NULL,
  `fecha_recepcion` DATETIME NULL,
  PRIMARY KEY (`id_orden_compra`),
  INDEX `idx_oc_proveedor` (`id_proveedor`),
  INDEX `idx_oc_usuario` (`id_usuario`),
  INDEX `idx_oc_usuario_recepcion` (`id_usuario_recepcion`),
  CONSTRAINT `fk_oc_proveedores` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_oc_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_oc_usuario_recepcion` FOREIGN KEY (`id_usuario_recepcion`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[02 Compras]';

CREATE TABLE `detalle_orden_compra` (
  `id_detalle_orden_compra` INT NOT NULL AUTO_INCREMENT,
  `id_orden_compra` INT NOT NULL,
  `id_insumo` INT NOT NULL,
  `cantidad_pedida` DECIMAL(12,3) NOT NULL,
  `precio_pactado` DECIMAL(12,4) NOT NULL DEFAULT 0,
  `cantidad_recibida` DECIMAL(12,3) NULL,
  PRIMARY KEY (`id_detalle_orden_compra`),
  UNIQUE INDEX `uq_doc_orden_insumo` (`id_orden_compra`, `id_insumo`),
  INDEX `idx_doc_insumo` (`id_insumo`),
  CONSTRAINT `fk_doc_ordenes` FOREIGN KEY (`id_orden_compra`) REFERENCES `ordenes_compra` (`id_orden_compra`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_doc_insumos` FOREIGN KEY (`id_insumo`) REFERENCES `insumos` (`id_insumo`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_doc_valores` CHECK (`cantidad_pedida` > 0 AND `precio_pactado` >= 0 AND (`cantidad_recibida` IS NULL OR (`cantidad_recibida` >= 0 AND `cantidad_recibida` <= `cantidad_pedida`)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[02 Compras]';

-- produccion
CREATE TABLE `productos` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `nombre_producto` VARCHAR(100) NOT NULL,
  `precio_venta` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `porcentaje_iva` DECIMAL(5,2) NOT NULL DEFAULT 0,
  `estado_producto` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_producto`),
  UNIQUE INDEX `uq_producto_nombre` (`nombre_producto`),
  CONSTRAINT `chk_producto_valores` CHECK (`precio_venta` >= 0 AND `porcentaje_iva` BETWEEN 0 AND 100 AND `estado_producto` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[03 Produccion]';

CREATE TABLE `recetas` (
  `id_producto` INT NOT NULL,
  `id_insumo` INT NOT NULL,
  `cantidad_necesaria` DECIMAL(12,3) NOT NULL,
  PRIMARY KEY (`id_producto`, `id_insumo`),
  INDEX `idx_receta_insumo` (`id_insumo`),
  CONSTRAINT `fk_recetas_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_recetas_insumos` FOREIGN KEY (`id_insumo`) REFERENCES `insumos` (`id_insumo`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_receta_cantidad` CHECK (`cantidad_necesaria` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[03 Produccion]';

CREATE TABLE `producciones` (
  `id_produccion` INT NOT NULL AUTO_INCREMENT,
  `id_producto` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  `cantidad_producida` INT NOT NULL,
  `fecha_produccion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_produccion`),
  INDEX `idx_prod_producto` (`id_producto`),
  INDEX `idx_prod_usuario` (`id_usuario`),
  CONSTRAINT `fk_prod_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_prod_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_prod_cantidad` CHECK (`cantidad_producida` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[03 Produccion]';

CREATE TABLE `traslados` (
  `id_traslado` INT NOT NULL AUTO_INCREMENT,
  `id_sede_destino` INT NOT NULL,
  `id_usuario_envia` INT NOT NULL,
  `id_usuario_recibe` INT NULL,
  `estado_traslado` ENUM('pendiente','en_transito','recibido','cancelado') NOT NULL DEFAULT 'pendiente',
  `fecha_traslado` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_recepcion` DATETIME NULL,
  PRIMARY KEY (`id_traslado`),
  INDEX `idx_tr_destino` (`id_sede_destino`),
  INDEX `idx_tr_envia` (`id_usuario_envia`),
  INDEX `idx_tr_recibe` (`id_usuario_recibe`),
  CONSTRAINT `fk_tr_sede_destino` FOREIGN KEY (`id_sede_destino`) REFERENCES `sedes` (`id_sede`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_tr_usuario_envia` FOREIGN KEY (`id_usuario_envia`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_tr_usuario_recibe` FOREIGN KEY (`id_usuario_recibe`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[03 Produccion]';

CREATE TABLE `detalle_traslado` (
  `id_traslado` INT NOT NULL,
  `id_producto` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`id_traslado`, `id_producto`),
  INDEX `idx_dt_producto` (`id_producto`),
  CONSTRAINT `fk_dt_traslados` FOREIGN KEY (`id_traslado`) REFERENCES `traslados` (`id_traslado`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_dt_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_dt_cantidad` CHECK (`cantidad` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[03 Produccion]';

-- domicilios
CREATE TABLE `pedidos` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `id_usuario_acepta` INT NULL,
  `id_usuario_repartidor` INT NULL,
  `direccion_entrega` VARCHAR(150) NOT NULL DEFAULT '',
  `metodo_pago` ENUM('efectivo','tarjeta','nequi','transferencia') NOT NULL,
  `estado_pedido` ENUM('pendiente','aceptado','en_preparacion','despachado','entregado','cancelado') NOT NULL DEFAULT 'pendiente',
  `fecha_pedido` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_aceptacion` DATETIME NULL,
  `fecha_despacho` DATETIME NULL,
  `fecha_entrega` DATETIME NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `idx_ped_cliente` (`id_cliente`),
  INDEX `idx_ped_acepta` (`id_usuario_acepta`),
  INDEX `idx_ped_repartidor` (`id_usuario_repartidor`),
  CONSTRAINT `fk_ped_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ped_usuario_acepta` FOREIGN KEY (`id_usuario_acepta`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ped_usuario_repartidor` FOREIGN KEY (`id_usuario_repartidor`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[04 Domicilios]';

CREATE TABLE `detalle_pedido` (
  `id_detalle_pedido` INT NOT NULL AUTO_INCREMENT,
  `id_pedido` INT NOT NULL,
  `id_producto` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL DEFAULT 0,
  `porcentaje_iva` DECIMAL(5,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_detalle_pedido`),
  UNIQUE INDEX `uq_dp_pedido_producto` (`id_pedido`, `id_producto`),
  INDEX `idx_dp_producto` (`id_producto`),
  CONSTRAINT `fk_dp_pedidos` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_dp_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_dp_cantidad` CHECK (`cantidad` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='[04 Domicilios]';
-- funciones, procedimientos y triggers
-- antes de cada accion de personal la app ejecuta SET @app_usuario_id = <id del usuario>;
-- la sede sale de usuarios.id_sede y el stock se calcula con fn_stock_insumo / fn_stock_producto
USE `bakeadmin`;
DELIMITER $$

CREATE FUNCTION `fn_usuario_actual`() RETURNS INT
READS SQL DATA
BEGIN
  DECLARE v_id INT;
  IF @app_usuario_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Defina @app_usuario_id (usuario que realiza la operacion) antes de ejecutar esta accion';
  END IF;
  SELECT id_usuario INTO v_id FROM usuarios WHERE id_usuario = @app_usuario_id AND estado_usuario = 1;
  IF v_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '@app_usuario_id no corresponde a un usuario activo';
  END IF;
  RETURN v_id;
END$$

-- sede de un usuario activo, falla si esta inactivo o sin sede
CREATE FUNCTION `fn_sede_usuario`(p_usuario INT) RETURNS INT
READS SQL DATA
BEGIN
  DECLARE v_sede INT; DECLARE v_activo TINYINT;
  SELECT id_sede, estado_usuario INTO v_sede, v_activo FROM usuarios WHERE id_usuario = p_usuario;
  IF v_activo IS NULL OR v_activo <> 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe o esta inactivo';
  END IF;
  IF v_sede IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no tiene sede asignada (usuarios.id_sede)';
  END IF;
  RETURN v_sede;
END$$

-- stock de un insumo en una sede: lo recibido en compras menos lo que gastaron las producciones
CREATE FUNCTION `fn_stock_insumo`(p_insumo INT, p_sede INT) RETURNS DECIMAL(14,3)
READS SQL DATA
BEGIN
  DECLARE v_entra DECIMAL(14,3); DECLARE v_sale DECIMAL(14,3);
  SELECT COALESCE(SUM(d.cantidad_recibida), 0) INTO v_entra
    FROM detalle_orden_compra d
    JOIN ordenes_compra o ON o.id_orden_compra = d.id_orden_compra
    JOIN usuarios u ON u.id_usuario = o.id_usuario
   WHERE d.id_insumo = p_insumo AND u.id_sede = p_sede;
  SELECT COALESCE(SUM(p.cantidad_producida * r.cantidad_necesaria), 0) INTO v_sale
    FROM producciones p
    JOIN recetas r ON r.id_producto = p.id_producto
    JOIN usuarios u ON u.id_usuario = p.id_usuario
   WHERE r.id_insumo = p_insumo AND u.id_sede = p_sede;
  RETURN v_entra - v_sale;
END$$

-- cantidad de un insumo en ordenes enviadas que aun no se revisan (para respetar el maximo)
CREATE FUNCTION `fn_insumo_en_camino`(p_insumo INT, p_sede INT) RETURNS DECIMAL(14,3)
READS SQL DATA
BEGIN
  DECLARE v DECIMAL(14,3);
  SELECT COALESCE(SUM(d.cantidad_pedida), 0) INTO v
    FROM detalle_orden_compra d
    JOIN ordenes_compra o ON o.id_orden_compra = d.id_orden_compra
    JOIN usuarios u ON u.id_usuario = o.id_usuario
   WHERE d.id_insumo = p_insumo AND u.id_sede = p_sede AND o.estado_orden = 'enviada' AND d.cantidad_recibida IS NULL;
  RETURN v;
END$$

-- stock de producto terminado en una sede
-- suma lo producido y los traslados recibidos en la sede
-- resta los traslados que salen y los pedidos aceptados (no cancelados)
CREATE FUNCTION `fn_stock_producto`(p_producto INT, p_sede INT) RETURNS INT
READS SQL DATA
BEGIN
  DECLARE v_prod INT; DECLARE v_in INT; DECLARE v_out INT; DECLARE v_ped INT;
  SELECT COALESCE(SUM(p.cantidad_producida), 0) INTO v_prod
    FROM producciones p JOIN usuarios u ON u.id_usuario = p.id_usuario
   WHERE p.id_producto = p_producto AND u.id_sede = p_sede;
  SELECT COALESCE(SUM(dt.cantidad), 0) INTO v_in
    FROM detalle_traslado dt JOIN traslados t ON t.id_traslado = dt.id_traslado
   WHERE dt.id_producto = p_producto AND t.id_sede_destino = p_sede AND t.estado_traslado = 'recibido';
  SELECT COALESCE(SUM(dt.cantidad), 0) INTO v_out
    FROM detalle_traslado dt JOIN traslados t ON t.id_traslado = dt.id_traslado JOIN usuarios u ON u.id_usuario = t.id_usuario_envia
   WHERE dt.id_producto = p_producto AND u.id_sede = p_sede AND t.estado_traslado IN ('en_transito','recibido');
  SELECT COALESCE(SUM(dp.cantidad), 0) INTO v_ped
    FROM detalle_pedido dp JOIN pedidos pe ON pe.id_pedido = dp.id_pedido JOIN usuarios u ON u.id_usuario = pe.id_usuario_acepta
   WHERE dp.id_producto = p_producto AND u.id_sede = p_sede AND pe.estado_pedido IN ('aceptado','en_preparacion','despachado','entregado');
  RETURN v_prod + v_in - v_out - v_ped;
END$$

CREATE FUNCTION `fn_puede_entregar`(p_usuario INT) RETURNS TINYINT
READS SQL DATA
BEGIN
  RETURN EXISTS (SELECT 1 FROM usuarios u JOIN roles_permisos rp ON rp.id_rol = u.id_rol JOIN permisos p ON p.id_permiso = rp.id_permiso
                  WHERE u.id_usuario = p_usuario AND u.estado_usuario = 1 AND p.codigo_permiso = 'domicilios.entregar');
END$$

-- repartidor menos ocupado de la sede (menos pedidos despachados sin entregar)
CREATE FUNCTION `fn_repartidor_disponible`(p_sede INT) RETURNS INT
READS SQL DATA
BEGIN
  DECLARE v_id INT;
  SELECT u.id_usuario INTO v_id
    FROM usuarios u
    JOIN roles_permisos rp ON rp.id_rol = u.id_rol
    JOIN permisos p ON p.id_permiso = rp.id_permiso
   WHERE p.codigo_permiso = 'domicilios.entregar' AND u.estado_usuario = 1 AND u.id_sede = p_sede
   ORDER BY (SELECT COUNT(*) FROM pedidos x WHERE x.id_usuario_repartidor = u.id_usuario AND x.estado_pedido = 'despachado'), u.id_usuario
   LIMIT 1;
  RETURN v_id;
END$$

CREATE PROCEDURE `sp_crear_admin_inicial`(IN p_nombres VARCHAR(80), IN p_apellidos VARCHAR(80), IN p_tipo_doc VARCHAR(5), IN p_numero_doc VARCHAR(20),
                                          IN p_correo VARCHAR(120), IN p_correo_recuperacion VARCHAR(120), IN p_hash VARCHAR(255))
BEGIN
  DECLARE v_rol INT; DECLARE v_info INT;
  SELECT id_rol INTO v_rol FROM roles WHERE nombre_rol = 'administrador';
  IF EXISTS (SELECT 1 FROM usuarios WHERE id_rol = v_rol) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un administrador; este procedimiento solo sirve para el primero';
  END IF;
  IF CHAR_LENGTH(p_hash) < 50 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Envie el hash bcrypt de la contrasena, nunca la contrasena en texto plano';
  END IF;
  INSERT INTO informacion_complementaria (nombres, apellidos, tipo_documento, numero_documento) VALUES (p_nombres, p_apellidos, p_tipo_doc, p_numero_doc);
  SET v_info = LAST_INSERT_ID();
  INSERT INTO usuarios (id_rol, id_informacion, correo_usuario, contrasena_usuario, correo_recuperacion_usuario)
  VALUES (v_rol, v_info, p_correo, p_hash, p_correo_recuperacion);
  SELECT LAST_INSERT_ID() AS id_usuario_administrador;
END$$

-- minimos y maximos: stock + en camino + linea nueva no puede pasar el maximo
CREATE PROCEDURE `sp_validar_linea_compra`(IN p_orden INT, IN p_insumo INT, IN p_cantidad DECIMAL(12,3))
BEGIN
  DECLARE v_sede INT; DECLARE v_max DECIMAL(12,3);
  SELECT u.id_sede INTO v_sede FROM ordenes_compra o JOIN usuarios u ON u.id_usuario = o.id_usuario WHERE o.id_orden_compra = p_orden;
  SELECT stock_maximo_insumo INTO v_max FROM insumos WHERE id_insumo = p_insumo;
  IF v_max IS NULL OR v_max <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El insumo no tiene stock_maximo definido; las compras se rigen por minimos y maximos';
  END IF;
  IF fn_stock_insumo(p_insumo, v_sede) + fn_insumo_en_camino(p_insumo, v_sede) + p_cantidad > v_max THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La linea supera el stock maximo del insumo (stock + en camino + pedido)';
  END IF;
END$$

-- usuarios: quien ya registro documentos no cambia de sede
CREATE TRIGGER `trg_usuarios_bu` BEFORE UPDATE ON `usuarios` FOR EACH ROW
BEGIN
  IF NOT (NEW.id_sede <=> OLD.id_sede) AND OLD.id_sede IS NOT NULL THEN
    IF EXISTS (SELECT 1 FROM ordenes_compra WHERE id_usuario = OLD.id_usuario OR id_usuario_recepcion = OLD.id_usuario)
       OR EXISTS (SELECT 1 FROM producciones WHERE id_usuario = OLD.id_usuario)
       OR EXISTS (SELECT 1 FROM traslados WHERE id_usuario_envia = OLD.id_usuario OR id_usuario_recibe = OLD.id_usuario)
       OR EXISTS (SELECT 1 FROM pedidos WHERE id_usuario_acepta = OLD.id_usuario OR id_usuario_repartidor = OLD.id_usuario) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un usuario con documentos registrados no cambia de sede (cree otro usuario para la nueva sede)';
    END IF;
  END IF;
END$$

-- compras
CREATE TRIGGER `trg_oc_bi` BEFORE INSERT ON `ordenes_compra` FOR EACH ROW
BEGIN
  DECLARE v_sede INT;
  IF NEW.estado_orden <> 'borrador' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Toda orden nace en borrador'; END IF;
  IF NEW.id_usuario_recepcion IS NOT NULL OR NEW.fecha_envio IS NOT NULL OR NEW.fecha_recepcion IS NOT NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Envio y recepcion los registra el sistema';
  END IF;
  SET v_sede = fn_sede_usuario(NEW.id_usuario);
  IF (SELECT estado_sede FROM sedes WHERE id_sede = v_sede) <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sede del usuario esta inactiva'; END IF;
  IF (SELECT estado_proveedor FROM proveedores WHERE id_proveedor = NEW.id_proveedor) <> 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El proveedor esta inactivo';
  END IF;
END$$

CREATE TRIGGER `trg_oc_bu` BEFORE UPDATE ON `ordenes_compra` FOR EACH ROW
BEGIN
  IF NEW.id_proveedor <> OLD.id_proveedor OR NEW.id_usuario <> OLD.id_usuario THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Proveedor y usuario de la orden no cambian (cancele y cree otra)';
  END IF;
  SET NEW.fecha_envio = OLD.fecha_envio;
  IF COALESCE(@bk_oc, 0) <> 1 THEN
    SET NEW.id_usuario_recepcion = OLD.id_usuario_recepcion, NEW.fecha_recepcion = OLD.fecha_recepcion;
  END IF;
  IF NEW.estado_orden <> OLD.estado_orden THEN
    IF NEW.estado_orden IN ('pendiente_factura','rechazada') AND COALESCE(@bk_oc, 0) <> 1 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La recepcion cierra la orden automaticamente (pendiente_factura o rechazada)';
    END IF;
    IF NOT ((OLD.estado_orden = 'borrador' AND NEW.estado_orden IN ('enviada','cancelada'))
         OR (OLD.estado_orden = 'enviada' AND NEW.estado_orden IN ('cancelada','pendiente_factura','rechazada'))
         OR (OLD.estado_orden = 'pendiente_factura' AND NEW.estado_orden = 'facturada')) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cambio de estado de la orden no permitido';
    END IF;
    IF NEW.estado_orden = 'enviada' THEN
      IF NEW.metodo_envio IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Indique el metodo de envio (correo_automatico o pdf_manual)'; END IF;
      IF NOT EXISTS (SELECT 1 FROM detalle_orden_compra WHERE id_orden_compra = OLD.id_orden_compra) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se envia una orden sin lineas';
      END IF;
      IF NEW.metodo_envio = 'correo_automatico' AND (SELECT correo_proveedor FROM proveedores WHERE id_proveedor = OLD.id_proveedor) IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El proveedor no tiene correo: use pdf_manual';
      END IF;
      SET NEW.fecha_envio = NOW();
    ELSEIF NEW.estado_orden = 'cancelada' AND OLD.estado_orden = 'enviada' THEN
      IF EXISTS (SELECT 1 FROM detalle_orden_compra WHERE id_orden_compra = OLD.id_orden_compra AND cantidad_recibida IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se cancela una orden con lineas ya revisadas';
      END IF;
    END IF;
  ELSE
    IF NOT (NEW.metodo_envio <=> OLD.metodo_envio) AND OLD.estado_orden <> 'borrador' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El metodo de envio no cambia despues de enviar';
    END IF;
  END IF;
END$$

CREATE TRIGGER `trg_oc_bd` BEFORE DELETE ON `ordenes_compra` FOR EACH ROW
BEGIN
  IF OLD.estado_orden <> 'borrador' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se eliminan ordenes en borrador; las demas se cancelan'; END IF;
END$$

CREATE TRIGGER `trg_doc_bi` BEFORE INSERT ON `detalle_orden_compra` FOR EACH ROW
BEGIN
  DECLARE v_prov INT; DECLARE v_precio DECIMAL(12,4);
  IF (SELECT estado_orden FROM ordenes_compra WHERE id_orden_compra = NEW.id_orden_compra) <> 'borrador' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se agregan lineas a ordenes en borrador';
  END IF;
  IF NEW.cantidad_recibida IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cantidad recibida se registra al recibir el pedido'; END IF;
  IF (SELECT estado_insumo FROM insumos WHERE id_insumo = NEW.id_insumo) <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El insumo esta inactivo'; END IF;
  SELECT id_proveedor INTO v_prov FROM ordenes_compra WHERE id_orden_compra = NEW.id_orden_compra;
  SELECT precio_actual INTO v_precio FROM insumos_proveedores WHERE id_insumo = NEW.id_insumo AND id_proveedor = v_prov AND estado_oferta = 1;
  IF v_precio IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El proveedor de la orden no ofrece ese insumo (ver insumos_proveedores)'; END IF;
  IF NEW.precio_pactado = 0 THEN SET NEW.precio_pactado = v_precio; END IF;
  CALL sp_validar_linea_compra(NEW.id_orden_compra, NEW.id_insumo, NEW.cantidad_pedida);
END$$

CREATE TRIGGER `trg_doc_bu` BEFORE UPDATE ON `detalle_orden_compra` FOR EACH ROW
BEGIN
  DECLARE v_estado VARCHAR(20); DECLARE v_sede_orden INT;
  IF NEW.id_orden_compra <> OLD.id_orden_compra OR NEW.id_insumo <> OLD.id_insumo THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Orden e insumo de la linea no cambian (elimine la linea y cree otra)';
  END IF;
  SELECT estado_orden INTO v_estado FROM ordenes_compra WHERE id_orden_compra = OLD.id_orden_compra;
  IF v_estado = 'borrador' THEN
    IF NOT (NEW.cantidad_recibida <=> OLD.cantidad_recibida) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se recibe una orden enviada'; END IF;
    IF NEW.cantidad_pedida <> OLD.cantidad_pedida THEN
      CALL sp_validar_linea_compra(OLD.id_orden_compra, OLD.id_insumo, NEW.cantidad_pedida);
    END IF;
  ELSEIF v_estado = 'enviada' AND OLD.cantidad_recibida IS NULL AND NEW.cantidad_recibida IS NOT NULL
         AND NEW.cantidad_pedida = OLD.cantidad_pedida AND NEW.precio_pactado = OLD.precio_pactado THEN
    SELECT u.id_sede INTO v_sede_orden FROM ordenes_compra o JOIN usuarios u ON u.id_usuario = o.id_usuario WHERE o.id_orden_compra = OLD.id_orden_compra;
    IF fn_sede_usuario(fn_usuario_actual()) <> v_sede_orden THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido lo recibe un usuario de la sede de la orden';
    END IF;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Las lineas se editan en borrador; en una orden enviada solo se registra la cantidad recibida (una sola vez por linea)';
  END IF;
END$$

CREATE TRIGGER `trg_doc_bd` BEFORE DELETE ON `detalle_orden_compra` FOR EACH ROW
BEGIN
  IF (SELECT estado_orden FROM ordenes_compra WHERE id_orden_compra = OLD.id_orden_compra) <> 'borrador' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se eliminan lineas de ordenes en borrador';
  END IF;
END$$

-- al revisar la ultima linea la orden se cierra: pendiente_factura si algo llego o rechazada si nada llego
CREATE TRIGGER `trg_doc_au` AFTER UPDATE ON `detalle_orden_compra` FOR EACH ROW
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN SET @bk_oc = 0; RESIGNAL; END;
  IF OLD.cantidad_recibida IS NULL AND NEW.cantidad_recibida IS NOT NULL THEN
    IF NOT EXISTS (SELECT 1 FROM detalle_orden_compra WHERE id_orden_compra = NEW.id_orden_compra AND cantidad_recibida IS NULL) THEN
      SET @bk_oc = 1;
      UPDATE ordenes_compra
         SET estado_orden = IF(EXISTS (SELECT 1 FROM detalle_orden_compra WHERE id_orden_compra = NEW.id_orden_compra AND cantidad_recibida > 0), 'pendiente_factura', 'rechazada'),
             fecha_recepcion = NOW(),
             id_usuario_recepcion = fn_usuario_actual()
       WHERE id_orden_compra = NEW.id_orden_compra;
      SET @bk_oc = 0;
    END IF;
  END IF;
END$$

-- produccion
CREATE TRIGGER `trg_recetas_bi` BEFORE INSERT ON `recetas` FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM producciones WHERE id_producto = NEW.id_producto) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La receta ya se uso en producciones y no se modifica (el consumo historico dejaria de cuadrar)';
  END IF;
END$$
CREATE TRIGGER `trg_recetas_bu` BEFORE UPDATE ON `recetas` FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM producciones WHERE id_producto IN (OLD.id_producto, NEW.id_producto)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La receta ya se uso en producciones y no se modifica (el consumo historico dejaria de cuadrar)';
  END IF;
END$$
CREATE TRIGGER `trg_recetas_bd` BEFORE DELETE ON `recetas` FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM producciones WHERE id_producto = OLD.id_producto) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La receta ya se uso en producciones y no se modifica (el consumo historico dejaria de cuadrar)';
  END IF;
END$$

CREATE TRIGGER `trg_prod_bi` BEFORE INSERT ON `producciones` FOR EACH ROW
BEGIN
  DECLARE v_sede INT;
  SET v_sede = fn_sede_usuario(NEW.id_usuario);
  IF (SELECT estado_producto FROM productos WHERE id_producto = NEW.id_producto) <> 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto esta inactivo';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM recetas WHERE id_producto = NEW.id_producto) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto no tiene receta registrada';
  END IF;
  IF EXISTS (SELECT 1 FROM recetas r WHERE r.id_producto = NEW.id_producto
               AND fn_stock_insumo(r.id_insumo, v_sede) < r.cantidad_necesaria * NEW.cantidad_producida) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente de insumos en la sede para esta produccion';
  END IF;
END$$
CREATE TRIGGER `trg_prod_bu` BEFORE UPDATE ON `producciones` FOR EACH ROW
BEGIN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Una produccion registrada no se modifica; registre otra'; END$$
CREATE TRIGGER `trg_prod_bd` BEFORE DELETE ON `producciones` FOR EACH ROW
BEGIN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Una produccion registrada no se elimina'; END$$

CREATE TRIGGER `trg_tr_bi` BEFORE INSERT ON `traslados` FOR EACH ROW
BEGIN
  DECLARE v_origen INT;
  IF NEW.estado_traslado <> 'pendiente' OR NEW.id_usuario_recibe IS NOT NULL OR NEW.fecha_recepcion IS NOT NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Todo traslado nace pendiente y sin recepcion';
  END IF;
  SET v_origen = fn_sede_usuario(NEW.id_usuario_envia);
  IF v_origen = NEW.id_sede_destino THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El traslado debe ir a una sede distinta de la de origen'; END IF;
  IF (SELECT estado_sede FROM sedes WHERE id_sede = NEW.id_sede_destino) <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sede destino esta inactiva'; END IF;
END$$

CREATE TRIGGER `trg_tr_bu` BEFORE UPDATE ON `traslados` FOR EACH ROW
BEGIN
  DECLARE v_actor INT; DECLARE v_origen INT;
  IF NEW.id_sede_destino <> OLD.id_sede_destino OR NEW.id_usuario_envia <> OLD.id_usuario_envia THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Destino y usuario que envia no cambian (cancele y cree otro traslado)';
  END IF;
  SET NEW.id_usuario_recibe = OLD.id_usuario_recibe, NEW.fecha_recepcion = OLD.fecha_recepcion;
  IF NEW.estado_traslado <> OLD.estado_traslado THEN
    IF NOT ((OLD.estado_traslado = 'pendiente' AND NEW.estado_traslado IN ('en_transito','cancelado'))
         OR (OLD.estado_traslado = 'en_transito' AND NEW.estado_traslado IN ('recibido','cancelado'))) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cambio de estado de traslado no permitido';
    END IF;
    IF NEW.estado_traslado = 'en_transito' THEN
      IF NOT EXISTS (SELECT 1 FROM detalle_traslado WHERE id_traslado = OLD.id_traslado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se despacha un traslado sin lineas';
      END IF;
      SET v_origen = fn_sede_usuario(OLD.id_usuario_envia);
      IF EXISTS (SELECT 1 FROM detalle_traslado dt WHERE dt.id_traslado = OLD.id_traslado AND fn_stock_producto(dt.id_producto, v_origen) < dt.cantidad) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente de producto terminado en la sede de origen';
      END IF;
    ELSEIF NEW.estado_traslado = 'recibido' THEN
      SET v_actor = fn_usuario_actual();
      IF fn_sede_usuario(v_actor) <> OLD.id_sede_destino THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El traslado lo recibe un usuario de la sede destino';
      END IF;
      SET NEW.id_usuario_recibe = v_actor, NEW.fecha_recepcion = NOW();
    END IF;
  END IF;
END$$

CREATE TRIGGER `trg_tr_bd` BEFORE DELETE ON `traslados` FOR EACH ROW
BEGIN
  IF OLD.estado_traslado <> 'pendiente' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se eliminan traslados pendientes; los demas se cancelan'; END IF;
END$$

CREATE TRIGGER `trg_dt_bi` BEFORE INSERT ON `detalle_traslado` FOR EACH ROW
BEGIN
  IF (SELECT estado_traslado FROM traslados WHERE id_traslado = NEW.id_traslado) <> 'pendiente' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se editan las lineas de un traslado pendiente';
  END IF;
  IF (SELECT estado_producto FROM productos WHERE id_producto = NEW.id_producto) <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto esta inactivo'; END IF;
END$$
CREATE TRIGGER `trg_dt_bu` BEFORE UPDATE ON `detalle_traslado` FOR EACH ROW
BEGIN
  IF NEW.id_traslado <> OLD.id_traslado OR NEW.id_producto <> OLD.id_producto THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se cambia la cantidad de la linea'; END IF;
  IF (SELECT estado_traslado FROM traslados WHERE id_traslado = OLD.id_traslado) <> 'pendiente' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se editan las lineas de un traslado pendiente';
  END IF;
END$$
CREATE TRIGGER `trg_dt_bd` BEFORE DELETE ON `detalle_traslado` FOR EACH ROW
BEGIN
  IF (SELECT estado_traslado FROM traslados WHERE id_traslado = OLD.id_traslado) <> 'pendiente' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se editan las lineas de un traslado pendiente';
  END IF;
END$$

-- domicilios
CREATE TRIGGER `trg_ped_bi` BEFORE INSERT ON `pedidos` FOR EACH ROW
BEGIN
  IF NEW.estado_pedido <> 'pendiente' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Todo pedido nace pendiente'; END IF;
  IF NEW.id_usuario_acepta IS NOT NULL OR NEW.id_usuario_repartidor IS NOT NULL OR NEW.fecha_aceptacion IS NOT NULL
     OR NEW.fecha_despacho IS NOT NULL OR NEW.fecha_entrega IS NOT NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aceptacion, repartidor y fechas los registra el sistema';
  END IF;
  IF (SELECT estado_cliente FROM clientes WHERE id_cliente = NEW.id_cliente) <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente esta inactivo'; END IF;
  IF TRIM(NEW.direccion_entrega) = '' THEN
    SET NEW.direccion_entrega = (SELECT i.direccion FROM clientes c JOIN informacion_complementaria i ON i.id_informacion = c.id_informacion WHERE c.id_cliente = NEW.id_cliente);
  END IF;
  IF NEW.direccion_entrega IS NULL OR TRIM(NEW.direccion_entrega) = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido necesita direccion de entrega';
  END IF;
END$$

CREATE TRIGGER `trg_ped_bu` BEFORE UPDATE ON `pedidos` FOR EACH ROW
BEGIN
  DECLARE v_actor INT; DECLARE v_sede INT; DECLARE v_rep INT;
  IF NEW.id_cliente <> OLD.id_cliente THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente del pedido no cambia'; END IF;
  IF OLD.estado_pedido <> 'pendiente' AND (NEW.direccion_entrega <> OLD.direccion_entrega OR NEW.metodo_pago <> OLD.metodo_pago) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Direccion y metodo de pago no cambian despues de aceptar el pedido';
  END IF;
  SET NEW.id_usuario_acepta = OLD.id_usuario_acepta, NEW.fecha_aceptacion = OLD.fecha_aceptacion,
      NEW.fecha_despacho = OLD.fecha_despacho, NEW.fecha_entrega = OLD.fecha_entrega;
  IF NOT (NEW.id_usuario_repartidor <=> OLD.id_usuario_repartidor) AND NEW.id_usuario_repartidor IS NOT NULL THEN
    IF OLD.id_usuario_acepta IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Acepte el pedido antes de asignar repartidor'; END IF;
    IF fn_puede_entregar(NEW.id_usuario_repartidor) = 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario asignado no puede entregar domicilios (permiso domicilios.entregar)';
    END IF;
    IF NOT ((SELECT id_sede FROM usuarios WHERE id_usuario = NEW.id_usuario_repartidor) <=> (SELECT id_sede FROM usuarios WHERE id_usuario = OLD.id_usuario_acepta)) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El repartidor debe ser de la misma sede que atiende el pedido';
    END IF;
  END IF;
  IF NEW.estado_pedido <> OLD.estado_pedido THEN
    IF NOT ((OLD.estado_pedido = 'pendiente' AND NEW.estado_pedido IN ('aceptado','cancelado'))
         OR (OLD.estado_pedido = 'aceptado' AND NEW.estado_pedido IN ('en_preparacion','cancelado'))
         OR (OLD.estado_pedido = 'en_preparacion' AND NEW.estado_pedido IN ('despachado','cancelado'))
         OR (OLD.estado_pedido = 'despachado' AND NEW.estado_pedido IN ('entregado','cancelado'))) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cambio de estado de pedido no permitido';
    END IF;
    IF NEW.estado_pedido = 'aceptado' THEN
      IF NOT EXISTS (SELECT 1 FROM detalle_pedido WHERE id_pedido = OLD.id_pedido) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se acepta un pedido sin productos';
      END IF;
      SET v_actor = fn_usuario_actual();
      SET v_sede = fn_sede_usuario(v_actor);
      IF (SELECT tipo_sede FROM sedes WHERE id_sede = v_sede) <> 'punto_venta' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los pedidos los atiende un punto de venta (la planta no vende)';
      END IF;
      IF EXISTS (SELECT 1 FROM detalle_pedido d WHERE d.id_pedido = OLD.id_pedido AND fn_stock_producto(d.id_producto, v_sede) < d.cantidad) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente de producto terminado en la sede que acepta el pedido';
      END IF;
      SET NEW.id_usuario_acepta = v_actor, NEW.fecha_aceptacion = NOW();
    ELSEIF NEW.estado_pedido = 'despachado' THEN
      IF NEW.id_usuario_repartidor IS NULL THEN
        SET v_rep = fn_repartidor_disponible((SELECT id_sede FROM usuarios WHERE id_usuario = OLD.id_usuario_acepta));
        IF v_rep IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay un repartidor disponible en la sede'; END IF;
        SET NEW.id_usuario_repartidor = v_rep;
      END IF;
      SET NEW.fecha_despacho = NOW();
    ELSEIF NEW.estado_pedido = 'entregado' THEN
      SET NEW.fecha_entrega = NOW();
    END IF;
  END IF;
END$$

CREATE TRIGGER `trg_ped_bd` BEFORE DELETE ON `pedidos` FOR EACH ROW
BEGIN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los pedidos no se eliminan; se cancelan'; END$$

-- el precio y el IVA los pone el sistema desde el producto, la linea guarda el valor de ese momento
CREATE TRIGGER `trg_dp_bi` BEFORE INSERT ON `detalle_pedido` FOR EACH ROW
BEGIN
  DECLARE v_precio DECIMAL(10,2); DECLARE v_iva DECIMAL(5,2); DECLARE v_activo TINYINT;
  IF (SELECT estado_pedido FROM pedidos WHERE id_pedido = NEW.id_pedido) <> 'pendiente' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se agregan productos a un pedido pendiente';
  END IF;
  SELECT precio_venta, porcentaje_iva, estado_producto INTO v_precio, v_iva, v_activo FROM productos WHERE id_producto = NEW.id_producto;
  IF v_activo <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto esta inactivo'; END IF;
  SET NEW.precio_unitario = v_precio, NEW.porcentaje_iva = v_iva;
END$$

CREATE TRIGGER `trg_dp_bu` BEFORE UPDATE ON `detalle_pedido` FOR EACH ROW
BEGIN
  IF (SELECT estado_pedido FROM pedidos WHERE id_pedido = OLD.id_pedido) <> 'pendiente' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se modifican los productos de un pedido pendiente';
  END IF;
  IF NEW.id_producto <> OLD.id_producto OR NEW.id_pedido <> OLD.id_pedido OR NEW.precio_unitario <> OLD.precio_unitario OR NEW.porcentaje_iva <> OLD.porcentaje_iva THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se cambia la cantidad; para otro producto elimine la linea y cree otra';
  END IF;
END$$

CREATE TRIGGER `trg_dp_bd` BEFORE DELETE ON `detalle_pedido` FOR EACH ROW
BEGIN
  IF (SELECT estado_pedido FROM pedidos WHERE id_pedido = OLD.id_pedido) <> 'pendiente' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se modifican los productos de un pedido pendiente';
  END IF;
END$$

DELIMITER ;
-- vistas (lo calculado) y datos iniciales
USE `bakeadmin`;

CREATE VIEW `v_permisos_usuario` AS
SELECT u.id_usuario, u.correo_usuario, r.nombre_rol, p.codigo_permiso
  FROM usuarios u JOIN roles r ON r.id_rol = u.id_rol
  JOIN roles_permisos rp ON rp.id_rol = r.id_rol JOIN permisos p ON p.id_permiso = rp.id_permiso
 WHERE u.estado_usuario = 1;

-- inventario de insumos por sede con alertas de minimo y maximo
CREATE VIEW `v_stock_insumos` AS
SELECT t.*,
       CASE WHEN t.stock_actual <= 0 THEN 'SIN_STOCK'
            WHEN t.stock_actual < t.stock_minimo_insumo THEN 'BAJO_MINIMO'
            WHEN t.stock_maximo_insumo > 0 AND t.stock_actual > t.stock_maximo_insumo THEN 'SOBRE_MAXIMO'
            ELSE 'OK' END AS estado_stock
  FROM (SELECT s.id_sede, s.nombre_sede, i.id_insumo, i.nombre_insumo, i.unidad_medida_insumo,
               fn_stock_insumo(i.id_insumo, s.id_sede) AS stock_actual,
               fn_insumo_en_camino(i.id_insumo, s.id_sede) AS en_camino,
               i.stock_minimo_insumo, i.stock_maximo_insumo
          FROM sedes s CROSS JOIN insumos i WHERE s.estado_sede = 1 AND i.estado_insumo = 1) t;

CREATE VIEW `v_insumos_a_reponer` AS
SELECT id_sede, nombre_sede, id_insumo, nombre_insumo, unidad_medida_insumo, stock_actual, en_camino, estado_stock,
       stock_maximo_insumo - stock_actual - en_camino AS cantidad_sugerida_comprar
  FROM v_stock_insumos
 WHERE estado_stock IN ('SIN_STOCK','BAJO_MINIMO') AND stock_maximo_insumo > 0 AND stock_maximo_insumo - stock_actual - en_camino > 0;

CREATE VIEW `v_stock_productos` AS
SELECT s.id_sede, s.nombre_sede, p.id_producto, p.nombre_producto, fn_stock_producto(p.id_producto, s.id_sede) AS stock_actual
  FROM sedes s CROSS JOIN productos p WHERE s.estado_sede = 1 AND p.estado_producto = 1;

-- costo del insumo = precio pactado de la ultima compra recibida
CREATE VIEW `v_costo_insumo` AS
SELECT i.id_insumo, i.nombre_insumo, i.unidad_medida_insumo,
       COALESCE((SELECT d.precio_pactado FROM detalle_orden_compra d JOIN ordenes_compra o ON o.id_orden_compra = d.id_orden_compra
                  WHERE d.id_insumo = i.id_insumo AND d.cantidad_recibida > 0
                  ORDER BY COALESCE(o.fecha_recepcion, '9999-12-31') DESC, d.id_detalle_orden_compra DESC LIMIT 1), 0) AS costo_unitario
  FROM insumos i;

CREATE VIEW `v_costo_receta` AS
SELECT p.id_producto, p.nombre_producto, p.precio_venta, SUM(r.cantidad_necesaria * c.costo_unitario) AS costo_unitario_producto
  FROM productos p JOIN recetas r ON r.id_producto = p.id_producto JOIN v_costo_insumo c ON c.id_insumo = r.id_insumo
 GROUP BY p.id_producto, p.nombre_producto, p.precio_venta;

CREATE VIEW `v_ordenes_pendientes_factura` AS
SELECT o.id_orden_compra, pr.nombre_proveedor, pr.nit_proveedor, s.nombre_sede, o.fecha_recepcion,
       SUM(d.cantidad_recibida * d.precio_pactado) AS total_recibido
  FROM ordenes_compra o JOIN proveedores pr ON pr.id_proveedor = o.id_proveedor
  JOIN usuarios u ON u.id_usuario = o.id_usuario JOIN sedes s ON s.id_sede = u.id_sede
  JOIN detalle_orden_compra d ON d.id_orden_compra = o.id_orden_compra
 WHERE o.estado_orden = 'pendiente_factura'
 GROUP BY o.id_orden_compra, pr.nombre_proveedor, pr.nit_proveedor, s.nombre_sede, o.fecha_recepcion;

CREATE VIEW `v_pedidos_en_curso` AS
SELECT p.id_pedido, p.estado_pedido, CONCAT(i.nombres, ' ', i.apellidos) AS cliente, p.direccion_entrega, s.nombre_sede,
       CONCAT(ir.nombres, ' ', ir.apellidos) AS repartidor, p.fecha_pedido
  FROM pedidos p JOIN clientes c ON c.id_cliente = p.id_cliente JOIN informacion_complementaria i ON i.id_informacion = c.id_informacion
  LEFT JOIN usuarios ua ON ua.id_usuario = p.id_usuario_acepta LEFT JOIN sedes s ON s.id_sede = ua.id_sede
  LEFT JOIN usuarios ur ON ur.id_usuario = p.id_usuario_repartidor LEFT JOIN informacion_complementaria ir ON ir.id_informacion = ur.id_informacion
 WHERE p.estado_pedido IN ('pendiente','aceptado','en_preparacion','despachado');

CREATE VIEW `v_carga_repartidores` AS
SELECT u.id_usuario, CONCAT(i.nombres, ' ', i.apellidos) AS repartidor, u.id_sede,
       (SELECT COUNT(*) FROM pedidos x WHERE x.id_usuario_repartidor = u.id_usuario AND x.estado_pedido = 'despachado') AS pedidos_en_camino
  FROM usuarios u JOIN informacion_complementaria i ON i.id_informacion = u.id_informacion
 WHERE u.estado_usuario = 1 AND u.id_sede IS NOT NULL AND fn_puede_entregar(u.id_usuario) = 1;

-- prefactura para ICG, se calcula desde el pedido y no se guarda
CREATE VIEW `v_prefactura_detalle` AS
SELECT d.id_pedido, pr.id_producto, pr.nombre_producto, d.cantidad, d.precio_unitario, d.porcentaje_iva,
       ROUND(d.cantidad * d.precio_unitario, 2) AS subtotal_linea,
       ROUND(ROUND(d.cantidad * d.precio_unitario, 2) * d.porcentaje_iva / 100, 2) AS iva_linea,
       ROUND(d.cantidad * d.precio_unitario, 2) + ROUND(ROUND(d.cantidad * d.precio_unitario, 2) * d.porcentaje_iva / 100, 2) AS total_linea
  FROM detalle_pedido d JOIN productos pr ON pr.id_producto = d.id_producto
  JOIN pedidos p ON p.id_pedido = d.id_pedido
 WHERE p.estado_pedido NOT IN ('pendiente','cancelado');

CREATE VIEW `v_prefactura` AS
SELECT p.id_pedido AS numero_prefactura, p.fecha_aceptacion, p.estado_pedido, i.tipo_documento, i.numero_documento,
       CONCAT(i.nombres, ' ', i.apellidos) AS cliente, p.direccion_entrega, p.metodo_pago, s.nombre_sede,
       SUM(l.subtotal_linea) AS subtotal, SUM(l.iva_linea) AS total_iva, SUM(l.total_linea) AS total_prefactura
  FROM pedidos p JOIN v_prefactura_detalle l ON l.id_pedido = p.id_pedido
  JOIN clientes c ON c.id_cliente = p.id_cliente JOIN informacion_complementaria i ON i.id_informacion = c.id_informacion
  JOIN usuarios ua ON ua.id_usuario = p.id_usuario_acepta JOIN sedes s ON s.id_sede = ua.id_sede
 GROUP BY p.id_pedido, p.fecha_aceptacion, p.estado_pedido, i.tipo_documento, i.numero_documento, i.nombres, i.apellidos,
          p.direccion_entrega, p.metodo_pago, s.nombre_sede;

CREATE VIEW `v_ventas_por_dia` AS
SELECT DATE(fecha_aceptacion) AS dia, nombre_sede, COUNT(*) AS num_prefacturas,
       SUM(subtotal) AS subtotal, SUM(total_iva) AS total_iva, SUM(total_prefactura) AS total_vendido
  FROM v_prefactura GROUP BY DATE(fecha_aceptacion), nombre_sede;

-- datos iniciales
INSERT INTO roles (nombre_rol, descripcion_rol) VALUES
('administrador', 'Acceso total al sistema'),
('gerente_sede', 'Gestiona una sede'),
('cocinero', 'Producción y traslados desde la planta'),
('mesero', 'Atiende pedidos y entrega domicilios'),
('repartidor', 'Entrega domicilios'),
('cliente', 'Cliente de la aplicación');

INSERT INTO permisos (codigo_permiso, descripcion_permiso) VALUES
('usuarios.gestionar', 'Crear y administrar usuarios, roles y permisos'),
('catalogo.consultar', 'Ver productos y precios'),
('productos.gestionar', 'Crear y editar productos, insumos y recetas'),
('compras.gestionar', 'Crear y enviar órdenes de compra'),
('compras.recibir', 'Registrar la recepción de mercancía'),
('facturas.gestionar', 'Registrar y conciliar facturas de proveedor'),
('inventario.consultar', 'Consultar inventario y alertas'),
('produccion.registrar', 'Registrar producción'),
('traslados.gestionar', 'Crear, despachar y recibir traslados'),
('pedidos.crear', 'Crear pedidos desde la aplicación'),
('pedidos.gestionar', 'Aceptar, preparar y despachar pedidos'),
('domicilios.entregar', 'Entregar domicilios');

-- el administrador tiene todos los permisos
INSERT INTO roles_permisos (id_rol, id_permiso) SELECT r.id_rol, p.id_permiso FROM roles r CROSS JOIN permisos p WHERE r.nombre_rol = 'administrador';
INSERT INTO roles_permisos (id_rol, id_permiso) SELECT r.id_rol, p.id_permiso FROM roles r JOIN permisos p ON p.codigo_permiso IN ('catalogo.consultar','compras.recibir','inventario.consultar','traslados.gestionar','pedidos.gestionar') WHERE r.nombre_rol = 'gerente_sede';
INSERT INTO roles_permisos (id_rol, id_permiso) SELECT r.id_rol, p.id_permiso FROM roles r JOIN permisos p ON p.codigo_permiso IN ('catalogo.consultar','inventario.consultar','produccion.registrar','traslados.gestionar','compras.recibir') WHERE r.nombre_rol = 'cocinero';
INSERT INTO roles_permisos (id_rol, id_permiso) SELECT r.id_rol, p.id_permiso FROM roles r JOIN permisos p ON p.codigo_permiso IN ('catalogo.consultar','pedidos.gestionar','domicilios.entregar') WHERE r.nombre_rol = 'mesero';
INSERT INTO roles_permisos (id_rol, id_permiso) SELECT r.id_rol, p.id_permiso FROM roles r JOIN permisos p ON p.codigo_permiso IN ('catalogo.consultar','domicilios.entregar') WHERE r.nombre_rol = 'repartidor';
INSERT INTO roles_permisos (id_rol, id_permiso) SELECT r.id_rol, p.id_permiso FROM roles r JOIN permisos p ON p.codigo_permiso IN ('catalogo.consultar','pedidos.crear') WHERE r.nombre_rol = 'cliente';

INSERT INTO sedes (nombre_sede, direccion_sede, telefono_sede, tipo_sede) VALUES
('COFFEE PARK 140', 'Direccion 140', '3000000001', 'punto_venta'),
('COFFEE PARK 104', 'Direccion 104', '3000000002', 'punto_venta'),
('COFFEE PARK 63', 'Direccion 63', '3000000003', 'punto_venta'),
('COFFEE PARK RESTREPO', 'Direccion Restrepo', '3000000004', 'punto_venta'),
('COFFEE PARK PLANTA', 'Direccion Planta', '3000000005', 'planta');

SET SQL_MODE=@OLD_SQL_MODE;
