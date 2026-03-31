-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 31-03-2026 a las 04:20:44
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `biblioteca`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_socio` (IN `id` INT, IN `nueva_direccion` VARCHAR(100), IN `nuevo_telefono` VARCHAR(10))   BEGIN

UPDATE socio
SET 
SOC_DIRECCION = nueva_direccion,
SOC_TELEFONO = nuevo_telefono
WHERE SOC_NUMERO = id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_libro` (IN `nombreLibro` VARCHAR(255))   BEGIN

SELECT *
FROM libro
WHERE LIB_TITULO LIKE CONCAT('%',nombreLibro,'%');

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_libro` (IN `idlibro` BIGINT)   BEGIN

IF NOT EXISTS (
SELECT *
FROM prestamo
WHERE COPIA_ISBN = idlibro
)
THEN
DELETE FROM libro
WHERE LIB_ISBN = idlibro;
ELSE
SELECT 'No se puede eliminar el libro porque tiene prestamos registrados' AS mensaje;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_socio` (IN `nombre` VARCHAR(45), IN `apellido` VARCHAR(45), IN `direccion` VARCHAR(100), IN `telefono` VARCHAR(10))   BEGIN

DECLARE nuevo_id INT;

SELECT MAX(SOC_NUMERO) + 1 INTO nuevo_id
FROM socio;

INSERT INTO socio
VALUES (nuevo_id, nombre, apellido, direccion, telefono);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `libros_prestados` ()   BEGIN

SELECT 
l.LIB_TITULO,
s.SOC_NOMBRE,
s.SOC_APELLIDO,
p.PRES_FPRESTAMO,
p.PRES_FDEVOLUCION

FROM prestamo p
INNER JOIN socio s
ON p.COPIA_NUMERO = s.SOC_NUMERO
INNER JOIN libro l
ON p.COPIA_ISBN = l.LIB_ISBN;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `socios_con_prestamos` ()   BEGIN

SELECT 
s.SOC_NUMERO,
s.SOC_NOMBRE,
s.SOC_APELLIDO,
p.PRES_ID,
p.PRES_FPRESTAMO,
p.PRES_FDEVOLUCION

FROM socio s
LEFT JOIN prestamo p
ON s.SOC_NUMERO = p.COPIA_NUMERO;

END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `dias_prestamo` (`idlibro` BIGINT) RETURNS INT(11) DETERMINISTIC BEGIN

DECLARE dias INT;

SELECT DATEDIFF(PRES_FDEVOLUCION, PRES_FPRESTAMO)
INTO dias
FROM prestamo
WHERE COPIA_ISBN = idlibro
LIMIT 1;

RETURN dias;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_socios` () RETURNS INT(11) DETERMINISTIC BEGIN

DECLARE total INT;
SELECT COUNT(*) INTO total
FROM socio;
RETURN total;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_autor`
--

CREATE TABLE `auditoria_autor` (
  `id` int(11) NOT NULL,
  `accion` varchar(20) DEFAULT NULL,
  `id_autor` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `auditoria_autor`
--

INSERT INTO `auditoria_autor` (`id`, `accion`, `id_autor`, `nombre`, `fecha`) VALUES
(1, 'DELETE', 123, 'Taylor', '2026-03-30 20:53:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_libro`
--

CREATE TABLE `auditoria_libro` (
  `id` int(11) NOT NULL,
  `accion` varchar(20) DEFAULT NULL,
  `isbn` bigint(20) DEFAULT NULL,
  `titulo` varchar(200) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `auditoria_libro`
--

INSERT INTO `auditoria_libro` (`id`, `accion`, `isbn`, `titulo`, `fecha`) VALUES
(1, 'INSERT', 1234567821, 'El principito', '2026-03-30 20:45:31'),
(2, 'DELETE', 1357924680, 'El Jardín de las Mariposas Perdidas', '2026-03-30 20:50:23');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_socio`
--

CREATE TABLE `auditoria_socio` (
  `id` int(11) NOT NULL,
  `accion` varchar(20) DEFAULT NULL,
  `id_socio` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `auditoria_socio`
--

INSERT INTO `auditoria_socio` (`id`, `accion`, `id_socio`, `nombre`, `fecha`) VALUES
(1, 'UPDATE', 1, 'Ana', '2026-03-30 20:33:00'),
(3, 'DELETE', 1, 'Carlos Perez', '2026-03-30 20:41:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autor`
--

CREATE TABLE `autor` (
  `AUT_COD` int(11) NOT NULL,
  `AUT_APELLIDO` varchar(45) DEFAULT NULL,
  `AUT_NACIMIENTO` date DEFAULT NULL,
  `AUT_FALLECIMIENTO` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `autor`
--

INSERT INTO `autor` (`AUT_COD`, `AUT_APELLIDO`, `AUT_NACIMIENTO`, `AUT_FALLECIMIENTO`) VALUES
(98, 'Smith', '1974-12-21', '2018-07-21'),
(234, 'Medina', '1977-06-21', '2005-09-12'),
(345, 'Wilson', '1975-08-29', '0000-00-00'),
(432, 'Miller', '1981-10-26', '0000-00-00'),
(456, 'Garcia', '1978-09-27', '2021-12-09'),
(567, 'Davis', '1983-03-04', '2010-03-28'),
(678, 'Silva', '1986-02-02', '0000-00-00'),
(765, 'López', '1976-07-08', '2024-07-08'),
(789, 'Rodriguez', '1985-12-10', '0000-00-00'),
(890, 'Brown', '1982-11-17', '0000-00-00'),
(901, 'Soto', '1979-05-13', '2015-11-05');

--
-- Disparadores `autor`
--
DELIMITER $$
CREATE TRIGGER `autor_delete_auditoria` BEFORE DELETE ON `autor` FOR EACH ROW BEGIN

INSERT INTO auditoria_autor
(accion,id_autor,nombre,fecha)

VALUES
('DELETE', OLD.AUT_COD, OLD.AUT_APELLIDO, NOW());

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `autor_update_auditoria` AFTER UPDATE ON `autor` FOR EACH ROW BEGIN

INSERT INTO auditoria_autor
(accion,id_autor,nombre,fecha)

VALUES
('UPDATE', OLD.AUT_COD, OLD.AUT_APELLIDO, NOW());

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libro`
--

CREATE TABLE `libro` (
  `LIB_ISBN` bigint(20) NOT NULL,
  `LIB_TITULO` varchar(255) DEFAULT NULL,
  `LIB_GENERO` varchar(20) DEFAULT NULL,
  `NUM_PAGINAS` int(11) DEFAULT NULL,
  `DIAS_PRESTAMO` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libro`
--

INSERT INTO `libro` (`LIB_ISBN`, `LIB_TITULO`, `LIB_GENERO`, `NUM_PAGINAS`, `DIAS_PRESTAMO`) VALUES
(1234567821, 'El principito', 'Novela', 96, 7),
(1234567890, 'El Sueño de los Susurros', 'novela', 275, 7),
(2468135790, 'La Melodía de la Oscuridad', 'romance', 189, 7),
(2718281828, 'El Bosque de los Suspiros', 'novela', 387, 2),
(3141592653, 'El Secreto de las Estrellas Olvidadas', 'Misterio', 203, 7),
(5555555555, 'La Última Llave del Destino', 'cuento', 503, 7),
(7777777777, 'El Misterio de la Luna Plateada', 'Misterio', 422, 7),
(8642097531, 'El Reloj de Arena Infinito', 'novela', 321, 7),
(8888888888, 'La Ciudad de los Susurros', 'Misterio', 274, 1),
(9517530862, 'Las Crónicas del Eco Silencioso', 'fantasía', 448, 7),
(9788426706, 'sql', 'ingenieria', 384, 15),
(9876543210, 'El Laberinto de los Recuerdos', 'cuento', 412, 7),
(9999999999, 'La Última Llave del Destino', 'romance', 156, 7),
(9788426721006, 'sql', 'ingenieria', 384, 15);

--
-- Disparadores `libro`
--
DELIMITER $$
CREATE TRIGGER `libro_delete_auditoria` BEFORE DELETE ON `libro` FOR EACH ROW BEGIN

INSERT INTO auditoria_libro
(accion,isbn,titulo,fecha)

VALUES
('DELETE', OLD.LIB_ISBN, OLD.LIB_TITULO, NOW());

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `libro_insert_auditoria` AFTER INSERT ON `libro` FOR EACH ROW BEGIN

INSERT INTO auditoria_libro
(accion,isbn,titulo,fecha)

VALUES
('INSERT', NEW.LIB_ISBN, NEW.LIB_TITULO, NOW());

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `libro_update_auditoria` AFTER UPDATE ON `libro` FOR EACH ROW BEGIN

INSERT INTO auditoria_libro
(accion,isbn,titulo,fecha)

VALUES
('UPDATE', NEW.LIB_ISBN, NEW.LIB_TITULO, NOW());

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamo`
--

CREATE TABLE `prestamo` (
  `PRES_ID` varchar(20) NOT NULL,
  `PRES_FPRESTAMO` date DEFAULT NULL,
  `PRES_FDEVOLUCION` date DEFAULT NULL,
  `COPIA_NUMERO` int(11) DEFAULT NULL,
  `COPIA_ISBN` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamo`
--

INSERT INTO `prestamo` (`PRES_ID`, `PRES_FPRESTAMO`, `PRES_FDEVOLUCION`, `COPIA_NUMERO`, `COPIA_ISBN`) VALUES
('pres2', '2023-02-03', '2023-02-04', 2, 9999999999),
('pres3', '2023-04-09', '2023-04-11', 6, 2718281828),
('pres4', '2023-06-14', '2023-06-15', 9, 8888888888),
('pres5', '2023-07-02', '2023-07-09', 10, 5555555555),
('pres6', '2023-08-19', '2023-08-26', 12, 5555555555);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socio`
--

CREATE TABLE `socio` (
  `SOC_NUMERO` int(11) NOT NULL,
  `SOC_NOMBRE` varchar(45) DEFAULT NULL,
  `SOC_APELLIDO` varchar(45) DEFAULT NULL,
  `SOC_DIRECCION` varchar(100) DEFAULT NULL,
  `SOC_TELEFONO` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `socio`
--

INSERT INTO `socio` (`SOC_NUMERO`, `SOC_NOMBRE`, `SOC_APELLIDO`, `SOC_DIRECCION`, `SOC_TELEFONO`) VALUES
(2, 'Andrés Felipe', 'Galindo Luna', 'Avenida del Sol 456, Madrid', '2123456789'),
(3, 'Juan', 'González', 'Calle Principal 789, Valencia', '2012345678'),
(4, 'María', 'Rodríguez', 'Carrera del Río 321, Sevilla', '3012345678'),
(5, 'Pedro', 'Martínez', 'Calle del Bosque 654, Málaga', '1234567812'),
(6, 'Ana', 'López', 'Avenida Central 987, Bilbao', '6123456781'),
(7, 'Carlos', 'Sánchez', 'Calle de la Luna 234, Alicante', '1123456781'),
(8, 'Laura', 'Ramírez', 'Carrera del Mar 567, Palma', '1312345678'),
(9, 'Luis', 'Hernández', 'Avenida de la Montaña 890, Granada', '6101234567'),
(10, 'Andrea', 'García', 'Calle del Sol 432, Zaragoza', '1112345678'),
(11, 'Alejandro', 'Torres', 'Carrera del Oeste 765, Murcia', '4951234567'),
(12, 'Sofia', 'Morales', 'Avenida del Mar 098, Gijón', '5512345678'),
(13, 'Daniel', 'Medina', 'Calle 45', '3001234567');

--
-- Disparadores `socio`
--
DELIMITER $$
CREATE TRIGGER `socio_delete_auditoria` BEFORE DELETE ON `socio` FOR EACH ROW BEGIN

INSERT INTO auditoria_socio
(accion,id_socio,nombre,fecha)

VALUES
('DELETE', OLD.SOC_NUMERO, OLD.SOC_NOMBRE, NOW());

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `socio_update_auditoria` AFTER UPDATE ON `socio` FOR EACH ROW BEGIN

INSERT INTO auditoria_socio
(accion,id_socio,nombre,fecha)

VALUES
('UPDATE', OLD.SOC_NUMERO, OLD.SOC_NOMBRE, NOW());

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoautores`
--

CREATE TABLE `tipoautores` (
  `COPIA_ISBNN` bigint(20) NOT NULL,
  `COPIA_AUTOR` int(11) NOT NULL,
  `TIP_AUTOR` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipoautores`
--

INSERT INTO `tipoautores` (`COPIA_ISBNN`, `COPIA_AUTOR`, `TIP_AUTOR`) VALUES
(1234567890, 456, 'Coautor'),
(1234567890, 890, 'Autor'),
(2468135790, 234, 'Autor'),
(2718281828, 789, 'Traductor'),
(3141592653, 901, 'Autor'),
(5555555555, 678, 'Autor'),
(7777777777, 765, 'Autor'),
(8642097531, 345, 'Autor'),
(8888888888, 234, 'Autor'),
(8888888888, 345, 'Coautor'),
(9517530862, 432, 'Autor'),
(9876543210, 567, 'Autor'),
(9999999999, 98, 'Autor');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_libros`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_libros` (
`LIB_ISBN` bigint(20)
,`LIB_TITULO` varchar(255)
,`LIB_GENERO` varchar(20)
,`NUM_PAGINAS` int(11)
,`DIAS_PRESTAMO` tinyint(4)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_prestamos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_prestamos` (
`SOC_NOMBRE` varchar(45)
,`LIB_TITULO` varchar(255)
,`PRES_FPRESTAMO` date
,`PRES_FDEVOLUCION` date
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_libros`
--
DROP TABLE IF EXISTS `vista_libros`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_libros`  AS SELECT `libro`.`LIB_ISBN` AS `LIB_ISBN`, `libro`.`LIB_TITULO` AS `LIB_TITULO`, `libro`.`LIB_GENERO` AS `LIB_GENERO`, `libro`.`NUM_PAGINAS` AS `NUM_PAGINAS`, `libro`.`DIAS_PRESTAMO` AS `DIAS_PRESTAMO` FROM `libro` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_prestamos`
--
DROP TABLE IF EXISTS `vista_prestamos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_prestamos`  AS SELECT `s`.`SOC_NOMBRE` AS `SOC_NOMBRE`, `l`.`LIB_TITULO` AS `LIB_TITULO`, `p`.`PRES_FPRESTAMO` AS `PRES_FPRESTAMO`, `p`.`PRES_FDEVOLUCION` AS `PRES_FDEVOLUCION` FROM ((`prestamo` `p` join `socio` `s` on(`p`.`COPIA_NUMERO` = `s`.`SOC_NUMERO`)) join `libro` `l` on(`p`.`COPIA_ISBN` = `l`.`LIB_ISBN`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria_autor`
--
ALTER TABLE `auditoria_autor`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `auditoria_libro`
--
ALTER TABLE `auditoria_libro`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `auditoria_socio`
--
ALTER TABLE `auditoria_socio`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `autor`
--
ALTER TABLE `autor`
  ADD PRIMARY KEY (`AUT_COD`);

--
-- Indices de la tabla `libro`
--
ALTER TABLE `libro`
  ADD PRIMARY KEY (`LIB_ISBN`),
  ADD KEY `idx_lib_titulo` (`LIB_TITULO`);

--
-- Indices de la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD PRIMARY KEY (`PRES_ID`),
  ADD KEY `COPIA_NUMERO` (`COPIA_NUMERO`),
  ADD KEY `COPIA_ISBN` (`COPIA_ISBN`);

--
-- Indices de la tabla `socio`
--
ALTER TABLE `socio`
  ADD PRIMARY KEY (`SOC_NUMERO`);

--
-- Indices de la tabla `tipoautores`
--
ALTER TABLE `tipoautores`
  ADD PRIMARY KEY (`COPIA_ISBNN`,`COPIA_AUTOR`),
  ADD KEY `COPIA_AUTOR` (`COPIA_AUTOR`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auditoria_autor`
--
ALTER TABLE `auditoria_autor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `auditoria_libro`
--
ALTER TABLE `auditoria_libro`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `auditoria_socio`
--
ALTER TABLE `auditoria_socio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD CONSTRAINT `prestamo_ibfk_1` FOREIGN KEY (`COPIA_NUMERO`) REFERENCES `socio` (`SOC_NUMERO`),
  ADD CONSTRAINT `prestamo_ibfk_2` FOREIGN KEY (`COPIA_ISBN`) REFERENCES `libro` (`LIB_ISBN`);

--
-- Filtros para la tabla `tipoautores`
--
ALTER TABLE `tipoautores`
  ADD CONSTRAINT `tipoautores_ibfk_1` FOREIGN KEY (`COPIA_ISBNN`) REFERENCES `libro` (`LIB_ISBN`),
  ADD CONSTRAINT `tipoautores_ibfk_2` FOREIGN KEY (`COPIA_AUTOR`) REFERENCES `autor` (`AUT_COD`);

DELIMITER $$
--
-- Eventos
--
CREATE DEFINER=`root`@`localhost` EVENT `eliminar_prestamos` ON SCHEDULE EVERY 1 DAY STARTS '2026-05-01 00:00:00' ENDS '2026-12-31 23:59:59' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM prestamo
WHERE PRES_FDEVOLUCION < CURDATE()$$

CREATE DEFINER=`root`@`localhost` EVENT `prueba_prestamos` ON SCHEDULE AT '2026-03-30 20:58:58' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM prestamo
WHERE PRES_FDEVOLUCION < CURDATE()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
