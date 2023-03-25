-- MySQL Workbench Forward Engineering
SET FOREIGN_KEY_CHECKS=0;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Model_Bicing
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Model_Bicing` ;

-- -----------------------------------------------------
-- Schema Model_Bicing
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Model_Bicing` DEFAULT CHARACTER SET utf8 ;
USE `Model_Bicing` ;

-- -----------------------------------------------------
-- Table `Model_Bicing`.`CUENTA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`CUENTA` (
  `Id_cuenta` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(16) NOT NULL,
  `email` VARCHAR(255) NULL,
  `password` VARCHAR(255) NOT NULL,
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id_cuenta`));


-- -----------------------------------------------------
-- Table `Model_Bicing`.`USUARIO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`USUARIO` (
  `DNI` CHAR(9) NOT NULL,
  `Nombre` VARCHAR(255) NOT NULL,
  `Direccion` VARCHAR(255) NOT NULL,
  `Telefono` INT NOT NULL,
  `Fecha_nacimiento` DATE NOT NULL,
  `Cuenta_Id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`DNI`),
  CONSTRAINT `fk_USUARIO_CUENTA1`
    FOREIGN KEY (`Cuenta_Id`)
    REFERENCES `Model_Bicing`.`CUENTA` (`Id_cuenta`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Model_Bicing`.`REPOSICION_bicis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`REPOSICION_bicis` (
  `placa_camion` CHAR(7) NOT NULL,
  `capacidad` INT NOT NULL,
  `zona_actividad` VARCHAR(255) NOT NULL,
  `dni_conductor` CHAR(9) NOT NULL,
  PRIMARY KEY (`placa_camion`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Model_Bicing`.`ESTACION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`ESTACION` (
  `ID_Estacion` INT NOT NULL AUTO_INCREMENT,
  `Localizacion` VARCHAR(255) NOT NULL,
  `Coordenadas` VARCHAR(255) NOT NULL,
  `Capacidad` INT NOT NULL,
  `Espacios_vacios` INT NOT NULL,
  `Disponibles` INT NOT NULL,
  `Reposicion` CHAR(7) NOT NULL,
  PRIMARY KEY (`ID_Estacion`),
  CONSTRAINT `fk_ESTACION_Reposicion_bicis1`
    FOREIGN KEY (`Reposicion`)
    REFERENCES `Model_Bicing`.`REPOSICION_bicis` (`placa_camion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Model_Bicing`.`BICICLETA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`BICICLETA` (
  `ID_Bici` INT NOT NULL AUTO_INCREMENT,
  `Tipo` TINYINT NOT NULL,
  `Estado` TINYINT NOT NULL DEFAULT 0,
  `ESTACION_ID_Estacion` INT NOT NULL,
  PRIMARY KEY (`ID_Bici`),
  CONSTRAINT `fk_BICICLETA_ESTACION1`
    FOREIGN KEY (`ESTACION_ID_Estacion`)
    REFERENCES `Model_Bicing`.`ESTACION` (`ID_Estacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Model_Bicing`.`FACTURACION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`FACTURACION` (
  `idFACTURACION` INT NOT NULL AUTO_INCREMENT,
  `Fecha` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `Total` DOUBLE NOT NULL,
  PRIMARY KEY (`idFACTURACION`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Model_Bicing`.`TARIFAS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`TARIFAS` (
  `ID_Tarifa` INT NOT NULL,
  `Nombre` VARCHAR(45) NOT NULL,
  `Precio` DOUBLE NOT NULL,
  PRIMARY KEY (`ID_Tarifa`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Model_Bicing`.`TARJETAS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`TARJETAS` (
  `ID_Tarjeta` INT NOT NULL AUTO_INCREMENT,
  `Fecha_alta` DATE NOT NULL,
  `Alta_tarifa` DATE NULL,
  `Expiracion_tarifa` DATE NULL,
  `USUARIO_DNI` CHAR(9) NOT NULL,
  `TARIFAS_ID_Tarifa` INT NULL,
  PRIMARY KEY (`ID_Tarjeta`),
  CONSTRAINT `fk_TARJETAS_USUARIO1`
    FOREIGN KEY (`USUARIO_DNI`)
    REFERENCES `Model_Bicing`.`USUARIO` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TARJETAS_TARIFAS1`
    FOREIGN KEY (`TARIFAS_ID_Tarifa`)
    REFERENCES `Model_Bicing`.`TARIFAS` (`ID_Tarifa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Model_Bicing`.`MANTENIMIENTO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`MANTENIMIENTO` (
  `idMANTENIMIENTO` INT NOT NULL AUTO_INCREMENT,
  `Defecto` VARCHAR(555) NULL,
  `Fecha_baja` DATE NULL,
  `Fecha_alta` DATE NULL,
  `BICICLETA_ID_Bici` INT NOT NULL,
  PRIMARY KEY (`idMANTENIMIENTO`),
  CONSTRAINT `fk_MANTENIMIENTO_BICICLETA1`
    FOREIGN KEY (`BICICLETA_ID_Bici`)
    REFERENCES `Model_Bicing`.`BICICLETA` (`ID_Bici`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Model_Bicing`.`PLUS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`PLUS` (
  `min30` DOUBLE NOT NULL,
  `min30_2h` DOUBLE NOT NULL,
  `mas_de_2h` DOUBLE NOT NULL,
  `tipo_bici` TINYINT NOT NULL,
  `TARIFAS_ID_Tarifa` INT NOT NULL,
  CONSTRAINT `fk_PLUS_TARIFAS1`
    FOREIGN KEY (`TARIFAS_ID_Tarifa`)
    REFERENCES `Model_Bicing`.`TARIFAS` (`ID_Tarifa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Model_Bicing`.`ALQUILER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`ALQUILER` (
  `ID_alquiler` INT NOT NULL AUTO_INCREMENT,
  `USUARIO_DNI` CHAR(9) NOT NULL,
  `BICICLETA_ID_Bici` INT NOT NULL,
  `Fecha_recogida` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_devolucion` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Total_viaje` TIME NULL,
  `FACTURACION_idFACTURACION` INT NOT NULL,
  PRIMARY KEY (`ID_alquiler`),
  CONSTRAINT `fk_USUARIO_has_BICICLETA_USUARIO1`
    FOREIGN KEY (`USUARIO_DNI`)
    REFERENCES `Model_Bicing`.`USUARIO` (`DNI`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_USUARIO_has_BICICLETA_BICICLETA1`
    FOREIGN KEY (`BICICLETA_ID_Bici`)
    REFERENCES `Model_Bicing`.`BICICLETA` (`ID_Bici`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ALQUILER_FACTURACION1`
    FOREIGN KEY (`FACTURACION_idFACTURACION`)
    REFERENCES `Model_Bicing`.`FACTURACION` (`idFACTURACION`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Model_Bicing`.`AUTORIZACIONES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Model_Bicing`.`AUTORIZACIONES` (
  `N_AUTORIZACION` INT NOT NULL AUTO_INCREMENT,
  `nombre_tutor` VARCHAR(255) NULL,
  `dni_tutor` CHAR(9) NOT NULL,
  `fecha_autorizacion` DATE NULL,
  `USUARIO_DNI` CHAR(9) NOT NULL,
  PRIMARY KEY (`N_AUTORIZACION`),
  CONSTRAINT `fk_AUTORIZACIONES_USUARIO1`
    FOREIGN KEY (`USUARIO_DNI`)
    REFERENCES `Model_Bicing`.`USUARIO` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- ----------------------------------------------------

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
