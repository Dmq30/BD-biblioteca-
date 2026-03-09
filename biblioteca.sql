-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-03-2026 a las 17:21:57
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_autor`
--

CREATE TABLE `audi_autor` (
  `id_audi_autor` int(11) NOT NULL,
  `audi_apellido_nuevo` varchar(55) NOT NULL,
  `audi_muerte_nuevo` datetime NOT NULL,
  `audi_nacimiento_nuevo` datetime NOT NULL,
  `audi_apellido_anterior` varchar(55) NOT NULL,
  `audi_muerte_anterior` datetime NOT NULL,
  `audi_nacimiento_anterior` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_libro`
--

CREATE TABLE `audi_libro` (
  `id_audi_libro` int(11) NOT NULL,
  `id_diaPrestamo_anterior` int(11) DEFAULT NULL,
  `audi_genero_anterior` varchar(20) DEFAULT NULL,
  `audi_isbn_anterior` bigint(20) DEFAULT NULL,
  `audi_numeroPaginas_anterior` int(11) DEFAULT NULL,
  `audi_titulo_anterior` varchar(255) DEFAULT NULL,
  `id_diaPrestamo_nuevo` int(11) DEFAULT NULL,
  `audi_genero_nuevo` varchar(20) DEFAULT NULL,
  `audi_isbn_nuevo` bigint(20) DEFAULT NULL,
  `audi_numeroPaginas_nuevo` int(11) DEFAULT NULL,
  `audi_titulo_nuevo` varchar(255) DEFAULT NULL,
  `audi_fecha_modificacion` datetime DEFAULT NULL,
  `audi_usuario` varchar(20) DEFAULT NULL,
  `audi_accion` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audi_libro`
--

INSERT INTO `audi_libro` (`id_audi_libro`, `id_diaPrestamo_anterior`, `audi_genero_anterior`, `audi_isbn_anterior`, `audi_numeroPaginas_anterior`, `audi_titulo_anterior`, `id_diaPrestamo_nuevo`, `audi_genero_nuevo`, `audi_isbn_nuevo`, `audi_numeroPaginas_nuevo`, `audi_titulo_nuevo`, `audi_fecha_modificacion`, `audi_usuario`, `audi_accion`) VALUES
(1231232313, 7, 'Novela', 1231232313, 350, 'Título ejemplo', NULL, NULL, NULL, NULL, NULL, '2026-03-05 10:19:33', 'root@localhost', 'registro eliminado'),
(2147483647, 2, 'novela', 2718281828, 387, 'El Bosque de los Suspiros', NULL, NULL, NULL, NULL, NULL, '2026-03-05 10:09:33', 'root@localhost', 'registro eliminado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_socio`
--

CREATE TABLE `audi_socio` (
  `id_audi` int(10) NOT NULL,
  `soc_numero_audi` int(11) DEFAULT NULL,
  `soc_nombre_anterior` varchar(45) DEFAULT NULL,
  `soc_apellido_anterior` varchar(45) DEFAULT NULL,
  `soc_direccion_anterior` varchar(255) DEFAULT NULL,
  `soc_telefono_anterior` varchar(10) DEFAULT NULL,
  `soc_nombre_nuevo` varchar(45) DEFAULT NULL,
  `soc_apellido_nuevo` varchar(45) DEFAULT NULL,
  `soc_direccion_nuevo` varchar(255) DEFAULT NULL,
  `soc_telefono_nuevo` varchar(10) DEFAULT NULL,
  `audi_fechaModificacion` datetime DEFAULT NULL,
  `audi_usuario` varchar(10) DEFAULT NULL,
  `audi_accion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autor`
--

CREATE TABLE `autor` (
  `aut_codigo` int(11) NOT NULL,
  `aut_apellido` varchar(45) NOT NULL,
  `aut_nacimiento` date NOT NULL,
  `aut_muerte` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `autor`
--

INSERT INTO `autor` (`aut_codigo`, `aut_apellido`, `aut_nacimiento`, `aut_muerte`) VALUES
(98, 'Smith', '1974-12-21', '2018-07-21'),
(123, 'Taylor', '1980-04-15', '0000-00-00'),
(234, 'Medina', '1977-06-21', '2005-09-12'),
(345, 'Wilson', '1975-08-29', '0000-00-00'),
(432, 'Miller', '1981-10-26', '0000-00-00'),
(456, 'Garcia', '1978-09-27', '2021-12-09'),
(567, 'Davis', '1983-03-04', '2010-03-28'),
(678, 'Silva', '1986-02-02', '0000-00-00'),
(765, 'López', '1976-07-08', '2020-07-15'),
(789, 'Rodriguez', '1985-12-10', '0000-00-00'),
(890, 'Brown', '1982-11-17', '0000-00-00'),
(901, 'Soto', '1979-05-13', '2015-11-05');

--
-- Disparadores `autor`
--
DELIMITER $$
CREATE TRIGGER `autor_delete` BEFORE DELETE ON `autor` FOR EACH ROW BEGIN

INSERT INTO audi_autor(
    id_audi_autor,
    audi_apellido_anterior,
    audi_muerte_anterior,
    audi_nacimiento_anterior,
    audi_apellido_nuevo,
    audi_muerte_nuevo,
    audi_nacimiento_nuevo,
    fecha_cambio,
    usuario,
    accion
)
VALUES (
    OLD.aut_apellido,
    OLD.aut_muerte,
    OLD.aut_nacimiento,
    NULL,
    NULL,
    NULL,
    NOW(),
    CURRENT_USER(),
    'Autor Eliminado'
);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `autor_update` BEFORE UPDATE ON `autor` FOR EACH ROW BEGIN

INSERT INTO audi_autor(
    id_audi_autor,
    audi_apellido_anterior,
    audi_muerte_anterior,
    audi_nacimiento_anterior,
    audi_apellido_nuevo,
    audi_muerte_nuevo,
    audi_nacimiento_nuevo,
    fecha_cambio,
    usuario,
    accion
)
VALUES (
    OLD.aut_apellido,
    OLD.aut_muerte,
    OLD.aut_nacimiento,
    NEW.aut_apellido,
    NEW.aut_muerte,
    NEW.aut_nacimiento,
    NOW(),
    CURRENT_USER(),
    'Autor Actualizado'
);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libro`
--

CREATE TABLE `libro` (
  `lib_isbn` bigint(20) NOT NULL,
  `lib_titulo` varchar(255) NOT NULL,
  `lib_genero` varchar(20) NOT NULL,
  `lib_numeroPaginas` int(11) NOT NULL,
  `lib_diaPrestamo` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libro`
--

INSERT INTO `libro` (`lib_isbn`, `lib_titulo`, `lib_genero`, `lib_numeroPaginas`, `lib_diaPrestamo`) VALUES
(1234567890, 'El Sueño de los Susurros', 'novela', 275, 7),
(1357924680, 'El Jardín de las Mariposas Perdidas', 'novela', 536, 7),
(2468135790, 'La Melodía de la Oscuridad', 'romance', 189, 7),
(2718281828, 'Título ejemplo', 'Novela', 350, 7),
(3141592653, 'El Secreto de las Estrellas Olvidadas', 'Misterio', 203, 7),
(5555555555, 'La Última Llave del Destino', 'cuento', 503, 7),
(7777777777, 'El Misterio de la Luna Plateada', 'Misterio', 422, 7),
(8642097531, 'El Reloj de Arena Infinito', 'novela', 321, 7),
(8888888888, 'La Ciudad de los Susurros', 'Misterio', 274, 1),
(9517530862, 'Las Crónicas del Eco Silencioso', 'fantasia', 448, 7),
(9876543210, 'El Laberinto de los Recuerdos', 'cuento', 412, 7),
(9999999999, 'El Enigma de los Espejos Rotos', 'romance', 156, 7);

--
-- Disparadores `libro`
--
DELIMITER $$
CREATE TRIGGER `libro_delete` AFTER DELETE ON `libro` FOR EACH ROW BEGIN

INSERT INTO audi_libro(
    id_audi_libro,
    id_diaPrestamo_anterior,
    audi_genero_anterior,
    audi_isbn_anterior,
    audi_numeroPaginas_anterior,
    audi_titulo_anterior,
    audi_fecha_modificacion,
    audi_usuario,
    audi_accion
)
VALUES(
    old.lib_isbn,
    old.lib_diaPrestamo,
    old.lib_genero,
    old.lib_isbn,
    old.lib_numeroPaginas,
    old.lib_titulo,
    NOW(),
    CURRENT_USER(),
    'registro eliminado'
);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `libro_update` BEFORE UPDATE ON `libro` FOR EACH ROW INSERT INTO audi_libro(
    id_audi_libro,
    id_diaPrestamo_anterior,
    audi_genero_anterior,
    audi_isbn_anterior,
    audi_numeroPaginas_anterior,
    audi_titulo_anterior,
    id_diaPrestamo_nuevo,
    audi_genero_nuevo,
    audi_isbn_nuevo,
    audi_numeroPaginas_nuevo,
    audi_titulo_nuevo,
    audi_fecha_modificacion,
    audi_usuario,
    audi_accion
)
VALUES(
    NEW.lib_isbn,
    OLD.lib_diaPrestamo,
    OLD.lib_genero,
    OLD.lib_numeroPaginas,
    OLD.lib_titulo,
    NEW.lib_diaPrestamo,
    NEW.lib_genero,
    NEW.lib_numeroPaginas,
    NEW.lib_titulo,
    NOW(),
    CURRENT_USER(),
    'Actualizacion'
)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamo`
--

CREATE TABLE `prestamo` (
  `pres_id` varchar(20) NOT NULL,
  `pres_fechaPrestamo` date NOT NULL,
  `pres_fechaDevolucion` date NOT NULL,
  `soc_copiaNumero` int(11) NOT NULL,
  `lib_copiaISBN` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamo`
--

INSERT INTO `prestamo` (`pres_id`, `pres_fechaPrestamo`, `pres_fechaDevolucion`, `soc_copiaNumero`, `lib_copiaISBN`) VALUES
('pres1', '2023-01-15', '2023-01-20', 1, 1234567890),
('pres2', '2023-02-03', '2023-02-04', 2, 9999999999),
('pres4', '2023-06-14', '2023-06-15', 9, 8888888888),
('pres5', '2023-07-02', '2023-07-09', 10, 5555555555),
('pres6', '2023-08-19', '2023-08-26', 12, 5555555555),
('pres7', '2023-10-24', '2023-10-27', 3, 1357924680),
('pres8', '2023-11-11', '2023-11-12', 4, 9999999999);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socio`
--

CREATE TABLE `socio` (
  `soc_numero` int(11) NOT NULL,
  `soc_nombre` varchar(45) NOT NULL,
  `soc_apellido` varchar(45) NOT NULL,
  `soc_direccion` varchar(255) NOT NULL,
  `soc_telefono` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `socio`
--

INSERT INTO `socio` (`soc_numero`, `soc_nombre`, `soc_apellido`, `soc_direccion`, `soc_telefono`) VALUES
(1, 'Ana', 'Ruiz', 'Calle Primavera 123, Ciudad Jardín, Barcelona', '9123456780'),
(2, 'Andrés Felipe', 'Galindo Luna', 'Avenida del Sol 456, Pueblo Nuevo, Madrid', '2123456789'),
(3, 'Juan ', 'González', 'Calle Principal 789, Villa Flores, Valencia', '2012345678'),
(4, 'Maria', 'Rodríguez', 'Carrera del Río 321, El Pueblo, Sevilla', '3012345678'),
(5, 'Pedro ', 'Martínez', 'Calle del Bosque 654, Los Pinos, Málaga', '1234567812'),
(6, 'Ana ', 'López', 'Avenida Central 987, Villa Hermosa, Bilbao', '6123456781'),
(7, 'Carlos', 'Sánchez', 'Calle de la Luna 234, El Prado, Alicante', '1123456781'),
(8, 'Laura', 'Ramírez', 'Carrera del Mar 567, Playa Azul, Palma de Mallorca', '1312345678'),
(9, 'Luis', 'Hernández', 'Avenida de la Montaña 890, Monte Verde, Granada', '6101234567'),
(10, 'Andrea', 'García', 'Calle del Sol 432, La Colina, Zaragoza', '1112345678'),
(11, 'Alejandro', 'Torres', 'Carrera del Oeste 765, Ciudad Nueva, Murcia', '4951234567'),
(12, 'Sofia', 'Morales', 'Avenida del Mar 098, Costa Brava, Gijón', '5512345678');

--
-- Disparadores `socio`
--
DELIMITER $$
CREATE TRIGGER `socio_after_delete` AFTER DELETE ON `socio` FOR EACH ROW INSERT INTO audi_socio(
    soc_numero_audi,
    soc_nombre_anterior,
    soc_apellido_anterior,
    soc_direccion_anterior,
    soc_telefono_anterior,
    audi_fecha_modificacion,
    audi_usuario,
    audi_accion)
VALUES (
    old.soc_numero,
    old.soc_nombre,
    old.soc_apellido,
    old.soc_direccion,
    old.soc_telefono,
    NOW(),
    CURRENT_USER(),
    'registro eliminado')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `socios_before_update` BEFORE UPDATE ON `socio` FOR EACH ROW INSERT INTO audi_socio(
    socNumero_audi,
    socNombre_anterior,
    socApellido_anterior,
    socDireccion_anterior,
    socTelefono_anterior,
    socNombre_nuevo,
    socApellido_nuevo,
    socDireccion_nuevo,
    socTelefono_nuevo,
    audi_fechaModificacion,
    audi_usuario,
    audi_accion)
VALUES(
    new.soc_numero,
    old.soc_nombre,
    old.soc_apellido,
    old.soc_direccion,
    old.soc_telefono,
    new.soc_nombre,
    new.soc_apellido,
    new.soc_direccion,
    new.soc_telefono,
    NOW(),
    CURRENT_USER(),
    'Actualización')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoautores`
--

CREATE TABLE `tipoautores` (
  `copia_ISBN` bigint(20) NOT NULL,
  `copia_autor` int(11) NOT NULL,
  `tipoAutor` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipoautores`
--

INSERT INTO `tipoautores` (`copia_ISBN`, `copia_autor`, `tipoAutor`) VALUES
(1357924680, 123, 'Traductor'),
(1234567890, 123, 'Autor'),
(1234567890, 456, 'Coautor'),
(8888888888, 234, 'Autor'),
(2468135790, 234, 'Autor'),
(9876543210, 567, 'Autor'),
(1234567890, 890, 'Autor'),
(8642097531, 345, 'Autor'),
(8888888888, 345, 'Coautor'),
(5555555555, 678, 'Autor'),
(3141592653, 901, 'Autor'),
(9517530862, 432, 'Autor'),
(7777777777, 765, 'Autor'),
(9999999999, 98, 'Autor');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_libros_autores`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_libros_autores` (
`lib_isbn` bigint(20)
,`lib_titulo` varchar(255)
,`lib_genero` varchar(20)
,`lib_numeroPaginas` int(11)
,`aut_apellido` varchar(45)
,`aut_nacimiento` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_prestamos_libros`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_prestamos_libros` (
`pres_id` varchar(20)
,`lib_isbn` bigint(20)
,`lib_titulo` varchar(255)
,`soc_numero` int(11)
,`soc_nombre` varchar(45)
,`soc_apellido` varchar(45)
,`pres_fechaPrestamo` date
,`pres_fechaDevolucion` date
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_libros_autores`
--
DROP TABLE IF EXISTS `vista_libros_autores`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_libros_autores`  AS SELECT `l`.`lib_isbn` AS `lib_isbn`, `l`.`lib_titulo` AS `lib_titulo`, `l`.`lib_genero` AS `lib_genero`, `l`.`lib_numeroPaginas` AS `lib_numeroPaginas`, `a`.`aut_apellido` AS `aut_apellido`, `a`.`aut_nacimiento` AS `aut_nacimiento` FROM ((`autor` `a` join `tipoautores` `t` on(`t`.`copia_autor` = `a`.`aut_codigo`)) join `libro` `l` on(`l`.`lib_isbn` = `t`.`copia_ISBN`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_prestamos_libros`
--
DROP TABLE IF EXISTS `vista_prestamos_libros`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_prestamos_libros`  AS SELECT `p`.`pres_id` AS `pres_id`, `l`.`lib_isbn` AS `lib_isbn`, `l`.`lib_titulo` AS `lib_titulo`, `s`.`soc_numero` AS `soc_numero`, `s`.`soc_nombre` AS `soc_nombre`, `s`.`soc_apellido` AS `soc_apellido`, `p`.`pres_fechaPrestamo` AS `pres_fechaPrestamo`, `p`.`pres_fechaDevolucion` AS `pres_fechaDevolucion` FROM ((`prestamo` `p` join `libro` `l` on(`p`.`lib_copiaISBN` = `l`.`lib_isbn`)) join `socio` `s` on(`p`.`soc_copiaNumero` = `s`.`soc_numero`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `audi_autor`
--
ALTER TABLE `audi_autor`
  ADD PRIMARY KEY (`id_audi_autor`);

--
-- Indices de la tabla `audi_libro`
--
ALTER TABLE `audi_libro`
  ADD PRIMARY KEY (`id_audi_libro`);

--
-- Indices de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  ADD PRIMARY KEY (`id_audi`) USING BTREE;

--
-- Indices de la tabla `autor`
--
ALTER TABLE `autor`
  ADD PRIMARY KEY (`aut_codigo`);

--
-- Indices de la tabla `libro`
--
ALTER TABLE `libro`
  ADD PRIMARY KEY (`lib_isbn`),
  ADD KEY `idx_titulo` (`lib_titulo`);

--
-- Indices de la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD PRIMARY KEY (`pres_id`),
  ADD KEY `soc_copiaNumero` (`soc_copiaNumero`),
  ADD KEY `lib_copiaISBN` (`lib_copiaISBN`);

--
-- Indices de la tabla `socio`
--
ALTER TABLE `socio`
  ADD PRIMARY KEY (`soc_numero`);

--
-- Indices de la tabla `tipoautores`
--
ALTER TABLE `tipoautores`
  ADD KEY `copia_ISBN` (`copia_ISBN`),
  ADD KEY `copia_autor` (`copia_autor`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  MODIFY `id_audi` int(10) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD CONSTRAINT `prestamo_ibfk_1` FOREIGN KEY (`soc_copiaNumero`) REFERENCES `socio` (`soc_numero`),
  ADD CONSTRAINT `prestamo_ibfk_2` FOREIGN KEY (`lib_copiaISBN`) REFERENCES `libro` (`lib_isbn`);

--
-- Filtros para la tabla `tipoautores`
--
ALTER TABLE `tipoautores`
  ADD CONSTRAINT `tipoautores_ibfk_1` FOREIGN KEY (`copia_ISBN`) REFERENCES `libro` (`lib_isbn`),
  ADD CONSTRAINT `tipoautores_ibfk_2` FOREIGN KEY (`copia_autor`) REFERENCES `autor` (`aut_codigo`);

DELIMITER $$
--
-- Eventos
--
CREATE DEFINER=`root`@`localhost` EVENT `anual_eliminar_prestamos` ON SCHEDULE EVERY 1 YEAR STARTS '2026-03-09 06:42:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    DELETE FROM prestamo
    WHERE pres_fechaDevolucion <= NOW() - INTERVAL 1 YEAR;
    #datos menores a la fecha actual - 1 año
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
