-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema bakeadmin
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `bakeadmin` ;

-- -----------------------------------------------------
-- Schema bakeadmin
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bakeadmin` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `bakeadmin` ;

-- -----------------------------------------------------
-- Table `bakeadmin`.`sedes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`sedes` (
  `id_sede` INT NOT NULL AUTO_INCREMENT,
  `nombre_sede` VARCHAR(60) NOT NULL,
  `direccion` VARCHAR(120) NULL DEFAULT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id_sede`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`almacenes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`almacenes` (
  `id_almacen` INT NOT NULL AUTO_INCREMENT,
  `nombre_almacen` VARCHAR(60) NOT NULL,
  `ubicacion` VARCHAR(100) NULL DEFAULT NULL,
  `id_sede` INT NOT NULL,
  PRIMARY KEY (`id_almacen`),
  INDEX `fk_almacenes_sede` (`id_sede` ASC) VISIBLE,
  CONSTRAINT `fk_almacenes_sede`
    FOREIGN KEY (`id_sede`)
    REFERENCES `bakeadmin`.`sedes` (`id_sede`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`categorias_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`categorias_producto` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `nombre_categoria` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE INDEX `nombre_categoria` (`nombre_categoria` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`clientes` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `correo` VARCHAR(100) NULL DEFAULT NULL,
  `direccion` VARCHAR(150) NULL DEFAULT NULL,
  PRIMARY KEY (`id_cliente`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`roles` (
  `id_rol` INT NOT NULL AUTO_INCREMENT,
  `nombre_rol` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE INDEX `nombre_rol` (`nombre_rol` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`usuarios` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `correo` VARCHAR(100) NOT NULL,
  `contrasena_hash` VARCHAR(255) NOT NULL,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Activo',
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_rol` INT NOT NULL,
  `id_sede` INT NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `correo` (`correo` ASC) VISIBLE,
  INDEX `fk_usuarios_rol` (`id_rol` ASC) VISIBLE,
  INDEX `fk_usuarios_sede` (`id_sede` ASC) VISIBLE,
  CONSTRAINT `fk_usuarios_rol`
    FOREIGN KEY (`id_rol`)
    REFERENCES `bakeadmin`.`roles` (`id_rol`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_usuarios_sede`
    FOREIGN KEY (`id_sede`)
    REFERENCES `bakeadmin`.`sedes` (`id_sede`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`pedidos` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `fecha_pedido` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `metodo_pago` VARCHAR(30) NOT NULL,
  `estado` VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
  `direccion_entrega` VARCHAR(150) NULL DEFAULT NULL,
  `id_cliente` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  `id_sede` INT NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_pedidos_cliente` (`id_cliente` ASC) VISIBLE,
  INDEX `fk_pedidos_usuario` (`id_usuario` ASC) VISIBLE,
  INDEX `fk_pedidos_sede` (`id_sede` ASC) VISIBLE,
  CONSTRAINT `fk_pedidos_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `bakeadmin`.`clientes` (`id_cliente`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedidos_sede`
    FOREIGN KEY (`id_sede`)
    REFERENCES `bakeadmin`.`sedes` (`id_sede`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedidos_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `bakeadmin`.`usuarios` (`id_usuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`comandas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`comandas` (
  `id_comanda` INT NOT NULL AUTO_INCREMENT,
  `estacion` VARCHAR(30) NOT NULL,
  `prioridad` INT NULL DEFAULT '0',
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
  `id_pedido` INT NOT NULL,
  PRIMARY KEY (`id_comanda`),
  INDEX `fk_comandas_pedido` (`id_pedido` ASC) VISIBLE,
  CONSTRAINT `fk_comandas_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `bakeadmin`.`pedidos` (`id_pedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`productos` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(255) NULL DEFAULT NULL,
  `precio` DECIMAL(10,2) NOT NULL,
  `id_categoria` INT NOT NULL,
  PRIMARY KEY (`id_producto`),
  INDEX `fk_productos_categoria` (`id_categoria` ASC) VISIBLE,
  CONSTRAINT `fk_productos_categoria`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `bakeadmin`.`categorias_producto` (`id_categoria`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`detalle_pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`detalle_pedido` (
  `id_detalle_pedido` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL,
  `id_pedido` INT NOT NULL,
  `id_producto` INT NOT NULL,
  PRIMARY KEY (`id_detalle_pedido`),
  INDEX `fk_detped_pedido` (`id_pedido` ASC) VISIBLE,
  INDEX `fk_detped_producto` (`id_producto` ASC) VISIBLE,
  CONSTRAINT `fk_detped_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `bakeadmin`.`pedidos` (`id_pedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_detped_producto`
    FOREIGN KEY (`id_producto`)
    REFERENCES `bakeadmin`.`productos` (`id_producto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`insumos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`insumos` (
  `id_insumo` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `unidad_medida` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_insumo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`necesidades_insumos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`necesidades_insumos` (
  `id_necesidad` INT NOT NULL AUTO_INCREMENT,
  `cantidad_requerida` DECIMAL(10,2) NOT NULL,
  `fecha_solicitud` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
  `id_insumo` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_necesidad`),
  INDEX `fk_necesidades_insumo` (`id_insumo` ASC) VISIBLE,
  INDEX `fk_necesidades_usuario` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_necesidades_insumo`
    FOREIGN KEY (`id_insumo`)
    REFERENCES `bakeadmin`.`insumos` (`id_insumo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_necesidades_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `bakeadmin`.`usuarios` (`id_usuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`pedidos_compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`pedidos_compra` (
  `id_pedido_compra` INT NOT NULL AUTO_INCREMENT,
  `fecha_pedido` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` VARCHAR(30) NOT NULL DEFAULT 'Registrado',
  `id_necesidad` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_pedido_compra`),
  INDEX `fk_pedcompra_necesidad` (`id_necesidad` ASC) VISIBLE,
  INDEX `fk_pedcompra_usuario` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_pedcompra_necesidad`
    FOREIGN KEY (`id_necesidad`)
    REFERENCES `bakeadmin`.`necesidades_insumos` (`id_necesidad`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedcompra_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `bakeadmin`.`usuarios` (`id_usuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`detalle_pedido_compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`detalle_pedido_compra` (
  `id_detalle_pc` INT NOT NULL AUTO_INCREMENT,
  `cantidad` DECIMAL(10,2) NOT NULL,
  `observaciones` VARCHAR(150) NULL DEFAULT NULL,
  `id_pedido_compra` INT NOT NULL,
  `id_insumo` INT NOT NULL,
  PRIMARY KEY (`id_detalle_pc`),
  INDEX `fk_detpc_pedidocompra` (`id_pedido_compra` ASC) VISIBLE,
  INDEX `fk_detpc_insumo` (`id_insumo` ASC) VISIBLE,
  CONSTRAINT `fk_detpc_insumo`
    FOREIGN KEY (`id_insumo`)
    REFERENCES `bakeadmin`.`insumos` (`id_insumo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_detpc_pedidocompra`
    FOREIGN KEY (`id_pedido_compra`)
    REFERENCES `bakeadmin`.`pedidos_compra` (`id_pedido_compra`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`domicilios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`domicilios` (
  `id_domicilio` INT NOT NULL AUTO_INCREMENT,
  `fecha_asignacion` DATETIME NULL DEFAULT NULL,
  `fecha_entrega` DATETIME NULL DEFAULT NULL,
  `estado_entrega` VARCHAR(30) NOT NULL DEFAULT 'Asignado',
  `id_pedido` INT NOT NULL,
  `id_domiciliario` INT NOT NULL,
  PRIMARY KEY (`id_domicilio`),
  INDEX `fk_domicilios_pedido` (`id_pedido` ASC) VISIBLE,
  INDEX `fk_domicilios_domiciliario` (`id_domiciliario` ASC) VISIBLE,
  CONSTRAINT `fk_domicilios_domiciliario`
    FOREIGN KEY (`id_domiciliario`)
    REFERENCES `bakeadmin`.`usuarios` (`id_usuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_domicilios_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `bakeadmin`.`pedidos` (`id_pedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`lotes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`lotes` (
  `id_lote` INT NOT NULL AUTO_INCREMENT,
  `numero_lote` VARCHAR(30) NOT NULL,
  `fecha_vencimiento` DATE NULL DEFAULT NULL,
  `cantidad` DECIMAL(10,2) NOT NULL,
  `id_producto` INT NOT NULL,
  `id_almacen` INT NOT NULL,
  PRIMARY KEY (`id_lote`),
  INDEX `fk_lotes_producto` (`id_producto` ASC) VISIBLE,
  INDEX `fk_lotes_almacen` (`id_almacen` ASC) VISIBLE,
  CONSTRAINT `fk_lotes_almacen`
    FOREIGN KEY (`id_almacen`)
    REFERENCES `bakeadmin`.`almacenes` (`id_almacen`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_lotes_producto`
    FOREIGN KEY (`id_producto`)
    REFERENCES `bakeadmin`.`productos` (`id_producto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`movimientos_inventario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`movimientos_inventario` (
  `id_movimiento` INT NOT NULL AUTO_INCREMENT,
  `tipo_movimiento` VARCHAR(20) NOT NULL,
  `cantidad` DECIMAL(10,2) NOT NULL,
  `fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_producto` INT NOT NULL,
  `id_almacen` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_movimiento`),
  INDEX `fk_mov_producto` (`id_producto` ASC) VISIBLE,
  INDEX `fk_mov_almacen` (`id_almacen` ASC) VISIBLE,
  INDEX `fk_mov_usuario` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_mov_almacen`
    FOREIGN KEY (`id_almacen`)
    REFERENCES `bakeadmin`.`almacenes` (`id_almacen`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_mov_producto`
    FOREIGN KEY (`id_producto`)
    REFERENCES `bakeadmin`.`productos` (`id_producto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_mov_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `bakeadmin`.`usuarios` (`id_usuario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`proveedores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`proveedores` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `nit` VARCHAR(20) NOT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `correo` VARCHAR(100) NULL DEFAULT NULL,
  `direccion` VARCHAR(150) NULL DEFAULT NULL,
  PRIMARY KEY (`id_proveedor`),
  UNIQUE INDEX `nit` (`nit` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`ordenes_compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`ordenes_compra` (
  `id_orden` INT NOT NULL AUTO_INCREMENT,
  `fecha_envio` DATETIME NULL DEFAULT NULL,
  `estado` VARCHAR(30) NOT NULL DEFAULT 'Enviada',
  `id_pedido_compra` INT NOT NULL,
  `id_proveedor` INT NOT NULL,
  PRIMARY KEY (`id_orden`),
  INDEX `fk_ordencompra_pedido` (`id_pedido_compra` ASC) VISIBLE,
  INDEX `fk_ordencompra_proveedor` (`id_proveedor` ASC) VISIBLE,
  CONSTRAINT `fk_ordencompra_pedido`
    FOREIGN KEY (`id_pedido_compra`)
    REFERENCES `bakeadmin`.`pedidos_compra` (`id_pedido_compra`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ordencompra_proveedor`
    FOREIGN KEY (`id_proveedor`)
    REFERENCES `bakeadmin`.`proveedores` (`id_proveedor`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`permisos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`permisos` (
  `id_permiso` INT NOT NULL AUTO_INCREMENT,
  `nombre_permiso` VARCHAR(60) NOT NULL,
  `descripcion` VARCHAR(150) NULL DEFAULT NULL,
  PRIMARY KEY (`id_permiso`),
  UNIQUE INDEX `nombre_permiso` (`nombre_permiso` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `bakeadmin`.`roles_permisos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`roles_permisos` (
  `id_rol` INT NOT NULL,
  `id_permiso` INT NOT NULL,
  PRIMARY KEY (`id_rol`, `id_permiso`),
  INDEX `fk_rp_permiso` (`id_permiso` ASC) VISIBLE,
  CONSTRAINT `fk_rp_permiso`
    FOREIGN KEY (`id_permiso`)
    REFERENCES `bakeadmin`.`permisos` (`id_permiso`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rp_rol`
    FOREIGN KEY (`id_rol`)
    REFERENCES `bakeadmin`.`roles` (`id_rol`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
