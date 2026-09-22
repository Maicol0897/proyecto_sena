-- MySQL Workbench Forward Engineering
 
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
 
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
-- Table `bakeadmin`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`roles` (
  `id_rol` INT NOT NULL AUTO_INCREMENT,
  `nombre_rol` VARCHAR(50) NOT NULL,
  `descripcion_rol` VARCHAR(150) NULL,
  `estado_rol` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_rol`),
  UNIQUE INDEX `nombres_UNIQUE` (`nombre_rol` ASC) )
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`USUARIOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`USUARIOS` (
  `id_usuario` INT NOT NULL,
  `nombre_usuario` VARCHAR(100) NOT NULL,
  `correo_usuario` VARCHAR(100) NOT NULL,
  `contraseña_hash` VARCHAR(255) NOT NULL,
  `telefono_usuario` VARCHAR(20) NULL,
  `estado_usuario` TINYINT NOT NULL DEFAULT 1,
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE INDEX `correo_usuario_UNIQUE` (`correo_usuario` ASC) ,
  PRIMARY KEY (`id_usuario`))
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`clientes` (
  `id_cliente` INT NOT NULL,
  `direccion_cliente` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id_cliente`))
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`tipos_permiso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`tipos_permiso` (
  `id_tipo_permiso` INT NOT NULL,
  `nombre_permiso` VARCHAR(50) NOT NULL,
  `descripcion_permiso` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id_tipo_permiso`))
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`PERMISOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`PERMISOS` (
  `id_permiso` INT NOT NULL AUTO_INCREMENT,
  `estado` TINYINT NOT NULL DEFAULT 1,
  `USUARIOS_id_usuario` INT NOT NULL,
  `clientes_id_cliente` INT NULL,
  `roles_id_rol` INT NOT NULL,
  `tipos_permiso_id` INT NOT NULL,
  PRIMARY KEY (`id_permiso`),
  UNIQUE INDEX `id_permiso_UNIQUE` (`id_permiso` ASC) ,
  INDEX `fk_PERMISOS_USUARIOS1_idx` (`USUARIOS_id_usuario` ASC) ,
  INDEX `fk_PERMISOS_clientes1_idx` (`clientes_id_cliente` ASC) ,
  INDEX `fk_PERMISOS_roles_idx` (`roles_id_rol` ASC) ,
  INDEX `fk_PERMISOS_tipos_permiso_idx` (`tipos_permiso_id` ASC) ,
  CONSTRAINT `fk_PERMISOS_roles`
    FOREIGN KEY (`roles_id_rol`)
    REFERENCES `bakeadmin`.`roles` (`id_rol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PERMISOS_USUARIOS1`
    FOREIGN KEY (`USUARIOS_id_usuario`)
    REFERENCES `bakeadmin`.`USUARIOS` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PERMISOS_clientes1`
    FOREIGN KEY (`clientes_id_cliente`)
    REFERENCES `bakeadmin`.`clientes` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PERMISOS_tipos_permiso`
    FOREIGN KEY (`tipos_permiso_id`)
    REFERENCES `bakeadmin`.`tipos_permiso` (`id_tipo_permiso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`DOMICILIOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`DOMICILIOS` (
  `id_domiclios` INT NOT NULL AUTO_INCREMENT,
  `direccion_destino` VARCHAR(150) NOT NULL,
  `estado_domicilios` VARCHAR(30) NOT NULL,
  `fecha_entrega` DATETIME NULL,
  PRIMARY KEY (`id_domiclios`))
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`SEDES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`SEDES` (
  `id_sede` INT NULL AUTO_INCREMENT,
  `nombre_sede` VARCHAR(100) NOT NULL,
  `direccion_sede` VARCHAR(150) NOT NULL,
  `telefono_sede` VARCHAR(20) NOT NULL,
  `ciudad_sede` VARCHAR(80) NOT NULL,
  `estado_sede` TINYINT NOT NULL,
  PRIMARY KEY (`id_sede`))
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`PEDIDOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`PEDIDOS` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `fecha_pedido` DATETIME NOT NULL DEFAULT current_timestamp,
  `estado_pedido` VARCHAR(30) NOT NULL DEFAULT 'pendiente',
  `metodo_pago` VARCHAR(30) NOT NULL,
  `direccion_entrega` VARCHAR(150) NULL,
  `clientes_id_cliente` INT NOT NULL,
  `DOMICILIOS_id_domiclios` INT NOT NULL,
  `SEDES_id_sede1` INT NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_PEDIDOS_clientes1_idx` (`clientes_id_cliente` ASC) ,
  INDEX `fk_PEDIDOS_DOMICILIOS1_idx` (`DOMICILIOS_id_domiclios` ASC) ,
  INDEX `fk_PEDIDOS_SEDES1_idx` (`SEDES_id_sede1` ASC) ,
  CONSTRAINT `fk_PEDIDOS_clientes1`
    FOREIGN KEY (`clientes_id_cliente`)
    REFERENCES `bakeadmin`.`clientes` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PEDIDOS_DOMICILIOS1`
    FOREIGN KEY (`DOMICILIOS_id_domiclios`)
    REFERENCES `bakeadmin`.`DOMICILIOS` (`id_domiclios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PEDIDOS_SEDES1`
    FOREIGN KEY (`SEDES_id_sede1`)
    REFERENCES `bakeadmin`.`SEDES` (`id_sede`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`PRODUCTOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`PRODUCTOS` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `nombre_producto` VARCHAR(100) NOT NULL,
  `descripcion_producto` VARCHAR(255) NULL,
  `precio_venta` DECIMAL(10,2) NOT NULL,
  `estado_producto` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_producto`))
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`LISTA_PRODUCTO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`LISTA_PRODUCTO` (
  `id_lista_producto` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL,
  `PEDIDOS_id_pedido` INT NOT NULL,
  `PRODUCTOS_id_producto` INT NOT NULL,
  PRIMARY KEY (`id_lista_producto`),
  INDEX `fk_LISTA_PRODUCTO_PEDIDOS1_idx` (`PEDIDOS_id_pedido` ASC) ,
  INDEX `fk_LISTA_PRODUCTO_PRODUCTOS1_idx` (`PRODUCTOS_id_producto` ASC) ,
  CONSTRAINT `fk_LISTA_PRODUCTO_PEDIDOS1`
    FOREIGN KEY (`PEDIDOS_id_pedido`)
    REFERENCES `bakeadmin`.`PEDIDOS` (`id_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LISTA_PRODUCTO_PRODUCTOS1`
    FOREIGN KEY (`PRODUCTOS_id_producto`)
    REFERENCES `bakeadmin`.`PRODUCTOS` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`PRODUCCION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`PRODUCCION` (
  `id_produccion` INT NOT NULL AUTO_INCREMENT,
  `fecha_produccion` DATETIME NOT NULL,
  `cantidad_producida` INT NOT NULL,
  `estado_produccion` VARCHAR(30) NOT NULL,
  `SEDES_id_sede` INT NOT NULL,
  `PRODUCTOS_id_producto` INT NOT NULL,
  PRIMARY KEY (`id_produccion`),
  INDEX `fk_PRODUCCION_SEDES1_idx` (`SEDES_id_sede` ASC) ,
  INDEX `fk_PRODUCCION_PRODUCTOS1_idx` (`PRODUCTOS_id_producto` ASC) ,
  CONSTRAINT `fk_PRODUCCION_SEDES1`
    FOREIGN KEY (`SEDES_id_sede`)
    REFERENCES `bakeadmin`.`SEDES` (`id_sede`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PRODUCCION_PRODUCTOS1`
    FOREIGN KEY (`PRODUCTOS_id_producto`)
    REFERENCES `bakeadmin`.`PRODUCTOS` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`INSUMOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`INSUMOS` (
  `id_insumo` INT NOT NULL AUTO_INCREMENT,
  `nombre_insumo` VARCHAR(100) NOT NULL,
  `unidad_medida` VARCHAR(20) NOT NULL,
  `stock` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_insumo`))
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`PROVEEDORES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`PROVEEDORES` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `nombre_proveedor` VARCHAR(100) NOT NULL,
  `telefono_proveedor` VARCHAR(20) NULL,
  `correo_proveedor` VARCHAR(100) NULL,
  PRIMARY KEY (`id_proveedor`))
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`LISTADO_INSUMOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`LISTADO_INSUMOS` (
  `id_listado_insumos` INT NOT NULL AUTO_INCREMENT,
  `cantidad_utilizada` DECIMAL(10,2) NOT NULL,
  `INSUMOS_id_insumo` INT NOT NULL,
  `PROVEEDORES_id_proveedor` INT NOT NULL,
  PRIMARY KEY (`id_listado_insumos`),
  INDEX `fk_LISTADO_INSUMOS_INSUMOS1_idx` (`INSUMOS_id_insumo` ASC) ,
  INDEX `fk_LISTADO_INSUMOS_PROVEEDORES1_idx` (`PROVEEDORES_id_proveedor` ASC) ,
  CONSTRAINT `fk_LISTADO_INSUMOS_INSUMOS1`
    FOREIGN KEY (`INSUMOS_id_insumo`)
    REFERENCES `bakeadmin`.`INSUMOS` (`id_insumo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LISTADO_INSUMOS_PROVEEDORES1`
    FOREIGN KEY (`PROVEEDORES_id_proveedor`)
    REFERENCES `bakeadmin`.`PROVEEDORES` (`id_proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
 
 
-- -----------------------------------------------------
-- Table `bakeadmin`.`PRODUCCION_INSUMOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bakeadmin`.`PRODUCCION_INSUMOS` (
  `id_produccion_insumo` INT NOT NULL AUTO_INCREMENT,
  `cantidad_usada` DECIMAL(10,2) NOT NULL,
  `PRODUCCION_id_produccion` INT NOT NULL,
  `INSUMOS_id_insumo` INT NOT NULL,
  PRIMARY KEY (`id_produccion_insumo`),
  INDEX `fk_PRODUCCION_INSUMOS_PRODUCCION_idx` (`PRODUCCION_id_produccion` ASC) ,
  INDEX `fk_PRODUCCION_INSUMOS_INSUMOS_idx` (`INSUMOS_id_insumo` ASC) ,
  CONSTRAINT `fk_PRODUCCION_INSUMOS_PRODUCCION`
    FOREIGN KEY (`PRODUCCION_id_produccion`)
    REFERENCES `bakeadmin`.`PRODUCCION` (`id_produccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PRODUCCION_INSUMOS_INSUMOS`
    FOREIGN KEY (`INSUMOS_id_insumo`)
    REFERENCES `bakeadmin`.`INSUMOS` (`id_insumo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
 
 
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;