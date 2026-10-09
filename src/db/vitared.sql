CREATE DATABASE IF NOT EXISTS vitared;
USE vitared;

-- 1. Tabla de Ubicaciones (Departamentos y Municipios/Ciudades)
CREATE TABLE locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_location (city, department)
);

-- 2. Tabla Usuarios
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password TEXT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- 3. Tabla Especialidades
CREATE TABLE especialidad (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    especialidad VARCHAR(100) NOT NULL UNIQUE
);

-- 4. Tabla Clínica / Consultorio (Relacionada con Locations)
CREATE TABLE clinica (
    id_clinica INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    id_location INT NOT NULL,
    zona INT NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    whatsapp VARCHAR(20) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_location) REFERENCES locations(id) ON DELETE RESTRICT
);

-- 5. Tabla Doctores
CREATE TABLE doctor (
    id_doctor INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    id_clinica INT NOT NULL,
    id_especialidad INT NOT NULL,
    numero_colegiado VARCHAR(50),
    tarifa_consulta DECIMAL(10,2),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_clinica) REFERENCES clinica(id_clinica) ON DELETE CASCADE,
    FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad) ON DELETE CASCADE
);

-- 6. Horario de Atención del Doctor
CREATE TABLE horario_doctor (
    id_horario INT AUTO_INCREMENT PRIMARY KEY,
    id_doctor INT NOT NULL,
    dia ENUM('LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'DOMINGO') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    CHECK (
        MINUTE(hora_inicio) = 0 AND SECOND(hora_inicio) = 0
        AND MINUTE(hora_fin) = 0 AND SECOND(hora_fin) = 0
    ),
    FOREIGN KEY (id_doctor) REFERENCES doctor(id_doctor) ON DELETE CASCADE,
    UNIQUE (id_doctor, dia)
);

-- 7. Gestor de Citas
CREATE TABLE cita (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_doctor INT NOT NULL,
    id_paciente INT NOT NULL,
    fecha_hora_inicio DATETIME NOT NULL,
    motivo VARCHAR(255),
    estado ENUM('PROGRAMADA', 'CANCELADA', 'ATENDIDA') NOT NULL DEFAULT 'PROGRAMADA',
    FOREIGN KEY (id_doctor) REFERENCES doctor(id_doctor) ON DELETE CASCADE,
    FOREIGN KEY (id_paciente) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    UNIQUE (id_doctor, fecha_hora_inicio),
    CHECK (
        MINUTE(fecha_hora_inicio) = 0 AND SECOND(fecha_hora_inicio) = 0
    )
);

-- =====================================================================
-- DATOS: ubicaciones y especialidades (se insertan UNA sola vez)
-- =====================================================================
INSERT INTO locations (id, city, department) VALUES
(1, 'Cobán', 'Alta Verapaz'),
(2, 'Santa Cruz Verapaz', 'Alta Verapaz'),
(3, 'San Cristóbal Verapaz', 'Alta Verapaz'),
(4, 'Tactic', 'Alta Verapaz'),
(5, 'Tamahú', 'Alta Verapaz'),
(6, 'Tucurú', 'Alta Verapaz'),
(7, 'Panzós', 'Alta Verapaz'),
(8, 'Senahú', 'Alta Verapaz'),
(9, 'San Pedro Carchá', 'Alta Verapaz'),
(10, 'San Juan Chamelco', 'Alta Verapaz'),
(11, 'Lanquín', 'Alta Verapaz'),
(12, 'Cahabón', 'Alta Verapaz'),
(13, 'Chisec', 'Alta Verapaz'),
(14, 'Chahal', 'Alta Verapaz'),
(15, 'Fray Bartolomé de las Casas', 'Alta Verapaz'),
(16, 'Santa Catalina la Tinta', 'Alta Verapaz'),
(17, 'Raxruhá', 'Alta Verapaz'),
(18, 'Salamá', 'Baja Verapaz'),
(19, 'San Miguel Chicaj', 'Baja Verapaz'),
(20, 'Rabinal', 'Baja Verapaz'),
(21, 'Cubulco', 'Baja Verapaz'),
(22, 'Granados', 'Baja Verapaz'),
(23, 'Santa Cruz el Chol', 'Baja Verapaz'),
(24, 'San Jerónimo', 'Baja Verapaz'),
(25, 'Purulhá', 'Baja Verapaz'),
(26, 'Chimaltenango', 'Chimaltenango'),
(27, 'San José Poaquíl', 'Chimaltenango'),
(28, 'San Martín Jilotepeque', 'Chimaltenango'),
(29, 'San Juan Comalapa', 'Chimaltenango'),
(30, 'Santa Apolonia', 'Chimaltenango'),
(31, 'Tecpán Guatemala', 'Chimaltenango'),
(32, 'Patzún', 'Chimaltenango'),
(33, 'Pochuta', 'Chimaltenango'),
(34, 'Patzicía', 'Chimaltenango'),
(35, 'Santa Cruz Balanyá', 'Chimaltenango'),
(36, 'Acatenango', 'Chimaltenango'),
(37, 'San Pedro Yepocapa', 'Chimaltenango'),
(38, 'San Andrés Itzapa', 'Chimaltenango'),
(39, 'Parramos', 'Chimaltenango'),
(40, 'Zaragoza', 'Chimaltenango'),
(41, 'El Tejar', 'Chimaltenango'),
(42, 'Chiquimula', 'Chiquimula'),
(43, 'San José la Arada', 'Chiquimula'),
(44, 'San Juan Ermita', 'Chiquimula'),
(45, 'Jocotán', 'Chiquimula'),
(46, 'Camotán', 'Chiquimula'),
(47, 'Olopa', 'Chiquimula'),
(48, 'Esquipulas', 'Chiquimula'),
(49, 'Concepción Las Minas', 'Chiquimula'),
(50, 'Quetzaltepeque', 'Chiquimula'),
(51, 'San Jacinto', 'Chiquimula'),
(52, 'Ipala', 'Chiquimula'),
(53, 'Guastatoya', 'El Progreso'),
(54, 'Morazán', 'El Progreso'),
(55, 'San Agustín Acasaguastlán', 'El Progreso'),
(56, 'San Cristóbal Acasaguastlán', 'El Progreso'),
(57, 'El Jícaro', 'El Progreso'),
(58, 'Sansare', 'El Progreso'),
(59, 'Sanarate', 'El Progreso'),
(60, 'San Antonio La Paz', 'El Progreso'),
(61, 'Escuintla', 'Escuintla'),
(62, 'Santa Lucía Cotzumalguapa', 'Escuintla'),
(63, 'La Democracia', 'Escuintla'),
(64, 'Siquinalá', 'Escuintla'),
(65, 'Masagua', 'Escuintla'),
(66, 'Tiquisate', 'Escuintla'),
(67, 'La Gomera', 'Escuintla'),
(68, 'Guanagazapa', 'Escuintla'),
(69, 'San José', 'Escuintla'),
(70, 'Iztapa', 'Escuintla'),
(71, 'Palín', 'Escuintla'),
(72, 'San Vicente Pacaya', 'Escuintla'),
(73, 'Nueva Concepción', 'Escuintla'),
(74, 'Sipacate', 'Escuintla'),
(75, 'Ciudad de Guatemala', 'Guatemala'),
(76, 'Santa Catarina Pinula', 'Guatemala'),
(77, 'San José Pinula', 'Guatemala'),
(78, 'San José del Golfo', 'Guatemala'),
(79, 'Palencia', 'Guatemala'),
(80, 'Chinautla', 'Guatemala'),
(81, 'San Pedro Ayampuc', 'Guatemala'),
(82, 'Mixco', 'Guatemala'),
(83, 'San Pedro Sacatepéquez', 'Guatemala'),
(84, 'San Juan Sacatepéquez', 'Guatemala'),
(85, 'San Raymundo', 'Guatemala'),
(86, 'Chuarrancho', 'Guatemala'),
(87, 'Fraijanes', 'Guatemala'),
(88, 'Amatitlán', 'Guatemala'),
(89, 'Villa Nueva', 'Guatemala'),
(90, 'Villa Canales', 'Guatemala'),
(91, 'San Miguel Petapa', 'Guatemala'),
(92, 'Huehuetenango', 'Huehuetenango'),
(93, 'Chiantla', 'Huehuetenango'),
(94, 'Malacatancito', 'Huehuetenango'),
(95, 'Cuilco', 'Huehuetenango'),
(96, 'Nentón', 'Huehuetenango'),
(97, 'San Pedro Necta', 'Huehuetenango'),
(98, 'Jacaltenango', 'Huehuetenango'),
(99, 'San Pedro Soloma', 'Huehuetenango'),
(100, 'San Ildefonso Ixtahuacán', 'Huehuetenango'),
(101, 'Santa Bárbara', 'Huehuetenango'),
(102, 'La Libertad', 'Huehuetenango'),
(103, 'La Democracia', 'Huehuetenango'),
(104, 'San Miguel Acatán', 'Huehuetenango'),
(105, 'San Rafael La Independencia', 'Huehuetenango'),
(106, 'Todos Santos Cuchumatán', 'Huehuetenango'),
(107, 'San Juan Atitán', 'Huehuetenango'),
(108, 'Santa Eulalia', 'Huehuetenango'),
(109, 'San Mateo Ixtatán', 'Huehuetenango'),
(110, 'Colotenango', 'Huehuetenango'),
(111, 'San Sebastián Huehuetenango', 'Huehuetenango'),
(112, 'Tectitán', 'Huehuetenango'),
(113, 'Concepción Huista', 'Huehuetenango'),
(114, 'San Juan Ixcoy', 'Huehuetenango'),
(115, 'San Antonio Huista', 'Huehuetenango'),
(116, 'San Sebastián Coatán', 'Huehuetenango'),
(117, 'Barillas', 'Huehuetenango'),
(118, 'Aguacatán', 'Huehuetenango'),
(119, 'San Rafael Petzal', 'Huehuetenango'),
(120, 'San Gaspar Ixchil', 'Huehuetenango'),
(121, 'Santiago Chimaltenango', 'Huehuetenango'),
(122, 'Santa Ana Huista', 'Huehuetenango'),
(123, 'Unión Cantinil', 'Huehuetenango'),
(124, 'Petatán', 'Huehuetenango'),
(125, 'Puerto Barrios', 'Izabal'),
(126, 'Livingston', 'Izabal'),
(127, 'El Estor', 'Izabal'),
(128, 'Morales', 'Izabal'),
(129, 'Los Amates', 'Izabal'),
(130, 'Jalapa', 'Jalapa'),
(131, 'San Pedro Pinula', 'Jalapa'),
(132, 'San Luis Jilotepeque', 'Jalapa'),
(133, 'San Manuel Chaparrón', 'Jalapa'),
(134, 'San Carlos Alzatate', 'Jalapa'),
(135, 'Monjas', 'Jalapa'),
(136, 'Mataquescuintla', 'Jalapa'),
(137, 'Jutiapa', 'Jutiapa'),
(138, 'El Progreso', 'Jutiapa'),
(139, 'Santa Catarina Mita', 'Jutiapa'),
(140, 'Agua Blanca', 'Jutiapa'),
(141, 'Asunción Mita', 'Jutiapa'),
(142, 'Yupiltepeque', 'Jutiapa'),
(143, 'Atescatempa', 'Jutiapa'),
(144, 'Jerez', 'Jutiapa'),
(145, 'El Adelanto', 'Jutiapa'),
(146, 'Zapotitlán', 'Jutiapa'),
(147, 'Comapa', 'Jutiapa'),
(148, 'Jalpatagua', 'Jutiapa'),
(149, 'Conguaco', 'Jutiapa'),
(150, 'Moyuta', 'Jutiapa'),
(151, 'Pasaco', 'Jutiapa'),
(152, 'San José Acatempa', 'Jutiapa'),
(153, 'Quesada', 'Jutiapa'),
(154, 'Flores', 'Petén'),
(155, 'San José', 'Petén'),
(156, 'San Benito', 'Petén'),
(157, 'San Andrés', 'Petén'),
(158, 'La Libertad', 'Petén'),
(159, 'San Francisco', 'Petén'),
(160, 'Santa Ana', 'Petén'),
(161, 'Dolores', 'Petén'),
(162, 'San Luis', 'Petén'),
(163, 'Sayaxché', 'Petén'),
(164, 'Melchor de Mencos', 'Petén'),
(165, 'Poptún', 'Petén'),
(166, 'Las Cruces', 'Petén'),
(167, 'El Chal', 'Petén'),
(168, 'Quetzaltenango', 'Quetzaltenango'),
(169, 'Salcajá', 'Quetzaltenango'),
(170, 'Olintepeque', 'Quetzaltenango'),
(171, 'San Carlos Sija', 'Quetzaltenango'),
(172, 'Sibilia', 'Quetzaltenango'),
(173, 'Cabricán', 'Quetzaltenango'),
(174, 'Cajolá', 'Quetzaltenango'),
(175, 'San Miguel Sigüilá', 'Quetzaltenango'),
(176, 'San Juan Ostuncalco', 'Quetzaltenango'),
(177, 'San Mateo', 'Quetzaltenango'),
(178, 'Concepción Chiquirichapa', 'Quetzaltenango'),
(179, 'San Martín Sacatepéquez', 'Quetzaltenango'),
(180, 'Almolonga', 'Quetzaltenango'),
(181, 'Cantel', 'Quetzaltenango'),
(182, 'Huitán', 'Quetzaltenango'),
(183, 'Zunil', 'Quetzaltenango'),
(184, 'Colomba', 'Quetzaltenango'),
(185, 'San Francisco La Unión', 'Quetzaltenango'),
(186, 'El Palmar', 'Quetzaltenango'),
(187, 'Coatepeque', 'Quetzaltenango'),
(188, 'Génova', 'Quetzaltenango'),
(189, 'Flores Costa Cuca', 'Quetzaltenango'),
(190, 'La Esperanza', 'Quetzaltenango'),
(191, 'Palestina de Los Altos', 'Quetzaltenango'),
(192, 'Santa Cruz del Quiché', 'Quiché'),
(193, 'Chiché', 'Quiché'),
(194, 'Chinique', 'Quiché'),
(195, 'Zacualpa', 'Quiché'),
(196, 'Chajul', 'Quiché'),
(197, 'Chichicastenango', 'Quiché'),
(198, 'Patzité', 'Quiché'),
(199, 'San Antonio Ilotenango', 'Quiché'),
(200, 'San Pedro Jocopilas', 'Quiché'),
(201, 'Cunén', 'Quiché'),
(202, 'San Juan Cotzal', 'Quiché'),
(203, 'Joyabaj', 'Quiché'),
(204, 'Nebaj', 'Quiché'),
(205, 'San Andrés Sajcabajá', 'Quiché'),
(206, 'Uspantán', 'Quiché'),
(207, 'Sacapulas', 'Quiché'),
(208, 'San Bartolomé Jocotenango', 'Quiché'),
(209, 'Canillá', 'Quiché'),
(210, 'Chicamán', 'Quiché'),
(211, 'Ixcán', 'Quiché'),
(212, 'Pachalum', 'Quiché'),
(213, 'Retalhuleu', 'Retalhuleu'),
(214, 'San Sebastián', 'Retalhuleu'),
(215, 'Santa Cruz Muluá', 'Retalhuleu'),
(216, 'San Martín Zapotitlán', 'Retalhuleu'),
(217, 'San Felipe', 'Retalhuleu'),
(218, 'San Andrés Villa Seca', 'Retalhuleu'),
(219, 'Champerico', 'Retalhuleu'),
(220, 'Nuevo San Carlos', 'Retalhuleu'),
(221, 'El Asintal', 'Retalhuleu'),
(222, 'Antigua Guatemala', 'Sacatepéquez'),
(223, 'Jocotenango', 'Sacatepéquez'),
(224, 'Pastores', 'Sacatepéquez'),
(225, 'Sumpango', 'Sacatepéquez'),
(226, 'Santo Domingo Xenacoj', 'Sacatepéquez'),
(227, 'Santiago Sacatepéquez', 'Sacatepéquez'),
(228, 'San Bartolomé Milpas Altas', 'Sacatepéquez'),
(229, 'San Lucas Sacatepéquez', 'Sacatepéquez'),
(230, 'Santa Lucía Milpas Altas', 'Sacatepéquez'),
(231, 'Magdalena Milpas Altas', 'Sacatepéquez'),
(232, 'Santa María de Jesús', 'Sacatepéquez'),
(233, 'Ciudad Vieja', 'Sacatepéquez'),
(234, 'San Miguel Dueñas', 'Sacatepéquez'),
(235, 'Alotenango', 'Sacatepéquez'),
(236, 'San Antonio Aguas Calientes', 'Sacatepéquez'),
(237, 'Santa Catarina Barahona', 'Sacatepéquez'),
(238, 'San Marcos', 'San Marcos'),
(239, 'San Pedro Sacatepéquez', 'San Marcos'),
(240, 'San Antonio Sacatepéquez', 'San Marcos'),
(241, 'Comitancillo', 'San Marcos'),
(242, 'San Miguel Ixtahuacán', 'San Marcos'),
(243, 'Concepción Tutuapa', 'San Marcos'),
(244, 'Tacaná', 'San Marcos'),
(245, 'Sibinal', 'San Marcos'),
(246, 'Tajumulco', 'San Marcos'),
(247, 'Tejutla', 'San Marcos'),
(248, 'San Rafael Pie de la Cuesta', 'San Marcos'),
(249, 'Nuevo Progreso', 'San Marcos'),
(250, 'El Tumbador', 'San Marcos'),
(251, 'El Rodeo', 'San Marcos'),
(252, 'Malacatán', 'San Marcos'),
(253, 'Catarina', 'San Marcos'),
(254, 'Ayutla', 'San Marcos'),
(255, 'Ocós', 'San Marcos'),
(256, 'San Pablo', 'San Marcos'),
(257, 'El Quetzal', 'San Marcos'),
(258, 'La Reforma', 'San Marcos'),
(259, 'Pajapita', 'San Marcos'),
(260, 'Ixchiguán', 'San Marcos'),
(261, 'San José Ojetenam', 'San Marcos'),
(262, 'San Cristóbal Cucho', 'San Marcos'),
(263, 'Sipacapa', 'San Marcos'),
(264, 'Esquipulas Palo Gordo', 'San Marcos'),
(265, 'Río Blanco', 'San Marcos'),
(266, 'San Lorenzo', 'San Marcos'),
(267, 'La Blanca', 'San Marcos'),
(268, 'Cuilapa', 'Santa Rosa'),
(269, 'Barberena', 'Santa Rosa'),
(270, 'Santa Rosa de Lima', 'Santa Rosa'),
(271, 'Casillas', 'Santa Rosa'),
(272, 'San Rafael las Flores', 'Santa Rosa'),
(273, 'Oratorio', 'Santa Rosa'),
(274, 'San Juan Tecuaco', 'Santa Rosa'),
(275, 'Chiquimulilla', 'Santa Rosa'),
(276, 'Taxisco', 'Santa Rosa'),
(277, 'Santa María Ixhuatán', 'Santa Rosa'),
(278, 'Guazacapán', 'Santa Rosa'),
(279, 'Santa Cruz Naranjo', 'Santa Rosa'),
(280, 'Pueblo Nuevo Viñas', 'Santa Rosa'),
(281, 'Nueva Santa Rosa', 'Santa Rosa'),
(282, 'Sololá', 'Sololá'),
(283, 'San José Chacayá', 'Sololá'),
(284, 'Santa María Visitación', 'Sololá'),
(285, 'Santa Lucía Utatlán', 'Sololá'),
(286, 'Nahualá', 'Sololá'),
(287, 'Santa Catarina Ixtahuacán', 'Sololá'),
(288, 'Santa Clara La Laguna', 'Sololá'),
(289, 'Concepción', 'Sololá'),
(290, 'San Andrés Semetabaj', 'Sololá'),
(291, 'Panajachel', 'Sololá'),
(292, 'Santa Catarina Palopó', 'Sololá'),
(293, 'San Antonio Palopó', 'Sololá'),
(294, 'San Lucas Tolimán', 'Sololá'),
(295, 'Santa Cruz La Laguna', 'Sololá'),
(296, 'San Pablo La Laguna', 'Sololá'),
(297, 'San Marcos La Laguna', 'Sololá'),
(298, 'San Juan La Laguna', 'Sololá'),
(299, 'San Pedro La Laguna', 'Sololá'),
(300, 'Santiago Atitlán', 'Sololá'),
(301, 'Mazatenango', 'Suchitepéquez'),
(302, 'Cuyotenango', 'Suchitepéquez'),
(303, 'San Francisco Zapotitlán', 'Suchitepéquez'),
(304, 'San Bernardino', 'Suchitepéquez'),
(305, 'San José El Ídolo', 'Suchitepéquez'),
(306, 'San Lorenzo', 'Suchitepéquez'),
(307, 'Samayac', 'Suchitepéquez'),
(308, 'San Pablo Jocopilas', 'Suchitepéquez'),
(309, 'San Antonio Suchitepéquez', 'Suchitepéquez'),
(310, 'San Miguel Panán', 'Suchitepéquez'),
(311, 'San Gabriel', 'Suchitepéquez'),
(312, 'Chicacao', 'Suchitepéquez'),
(313, 'Patulul', 'Suchitepéquez'),
(314, 'Santa Bárbara', 'Suchitepéquez'),
(315, 'San Juan Bautista', 'Suchitepéquez'),
(316, 'Santo Domingo Suchitepéquez', 'Suchitepéquez'),
(317, 'Zunilito', 'Suchitepéquez'),
(318, 'Pueblo Nuevo', 'Suchitepéquez'),
(319, 'Río Bravo', 'Suchitepéquez'),
(320, 'Santo Tomás La Unión', 'Suchitepéquez'),
(321, 'San José La Máquina', 'Suchitepéquez'),
(322, 'Totonicapán', 'Totonicapán'),
(323, 'San Cristóbal Totonicapán', 'Totonicapán'),
(324, 'San Francisco El Alto', 'Totonicapán'),
(325, 'San Andrés Xecul', 'Totonicapán'),
(326, 'Momostenango', 'Totonicapán'),
(327, 'Santa María Chiquimula', 'Totonicapán'),
(328, 'Santa Lucía La Reforma', 'Totonicapán'),
(329, 'San Bartolo', 'Totonicapán'),
(330, 'Zacapa', 'Zacapa'),
(331, 'Estanzuela', 'Zacapa'),
(332, 'Río Hondo', 'Zacapa'),
(333, 'Gualán', 'Zacapa'),
(334, 'Teculután', 'Zacapa'),
(335, 'Usumatlán', 'Zacapa'),
(336, 'Cabañas', 'Zacapa'),
(337, 'San Diego', 'Zacapa'),
(338, 'La Unión', 'Zacapa'),
(339, 'Huité', 'Zacapa'),
(340, 'San Jorge', 'Zacapa');

INSERT INTO especialidad (especialidad) VALUES
('Medicina Interna'),('Pediatría'),('Ginecología y Obstetricia'),('Cardiología'),('Dermatología'),
('Neurología'),('Oftalmología'),('Otorrinolaringología'),('Traumatología y Ortopedia'),('Psiquiatría'),
('Gastroenterología'),('Endocrinología'),('Urología'),('Neumología'),('Radiología');


-- =====================================================================
-- DATOS DE PRUEBA VITARED
-- Ejecutar DESPUÉS de crear las tablas e insertar locations/especialidad.
-- Contraseña de TODOS los usuarios de prueba: 1234 (guardada como hash bcrypt, cost 10)
-- Fecha de referencia del dataset: 08/10/2026
-- =====================================================================

SET @pwd = '$2a$10$YFOYlKoF24.AVmYquXJWXeBFiCahrSW28e/kdgXuXBZkQFSLmM9rC';

-- ---------------------------------------------------------------------
-- 2. USUARIOS
--    1-70  : pacientes (1-55 con citas, 56-70 SIN citas)
--            6-10 y 26-30 son menores de edad (pacientes de pediatría)
--    71-90 : usuarios con rol doctor
-- ---------------------------------------------------------------------
INSERT INTO usuario (id_usuario, nombre, apellido, fecha_nacimiento, email, password, activo) VALUES
(1,  'Carlos',              'Méndez Ruano',         '1985-03-14', 'carlos.mendez@example.com',        @pwd, TRUE),
(2,  'María Fernanda',      'López Girón',          '1990-07-22', 'maria.lopez@example.com',          @pwd, TRUE),
(3,  'José Luis',           'García Toledo',        '1978-11-05', 'jose.garcia@example.com',          @pwd, TRUE),
(4,  'Ana Lucía',           'Pérez Marroquín',      '1995-02-18', 'ana.perez@example.com',            @pwd, TRUE),
(5,  'Luis Alberto',        'Morales Cifuentes',    '1982-09-30', 'luis.morales@example.com',         @pwd, TRUE),
(6,  'Sofía Alejandra',     'Ramírez Díaz',         '2016-05-12', 'sofia.ramirez@example.com',        @pwd, TRUE),
(7,  'Diego Andrés',        'Castillo Barrera',     '2018-08-03', 'diego.castillo@example.com',       @pwd, TRUE),
(8,  'Valeria Estefanía',   'Cruz Monzón',          '2014-01-27', 'valeria.cruz@example.com',         @pwd, TRUE),
(9,  'Mateo Sebastián',     'Ortiz Pinto',          '2019-10-15', 'mateo.ortiz@example.com',          @pwd, TRUE),
(10, 'Camila Daniela',      'Reyes Arévalo',        '2017-04-09', 'camila.reyes@example.com',         @pwd, TRUE),
(11, 'Gabriela Alejandra',  'Hernández Soto',       '1992-06-21', 'gabriela.hernandez@example.com',   @pwd, TRUE),
(12, 'Andrea Michelle',     'Solís Barrios',        '1988-12-02', 'andrea.solis@example.com',         @pwd, TRUE),
(13, 'Paola Beatriz',       'Sandoval Cano',        '1996-03-29', 'paola.sandoval@example.com',       @pwd, TRUE),
(14, 'Karla Patricia',      'Mejía Orozco',         '1984-08-17', 'karla.mejia@example.com',          @pwd, TRUE),
(15, 'Lucía Fernanda',      'Aguilar Rosales',      '1999-11-23', 'lucia.aguilar@example.com',        @pwd, TRUE),
(16, 'Roberto Carlos',      'Estrada Funes',        '1975-04-11', 'roberto.estrada@example.com',      @pwd, TRUE),
(17, 'Miguel Ángel',        'Barrios Leiva',        '1969-01-19', 'miguel.barrios@example.com',       @pwd, TRUE),
(18, 'Julio César',         'Vásquez Peralta',      '1980-07-07', 'julio.vasquez@example.com',        @pwd, TRUE),
(19, 'Elena Marisol',       'Figueroa Lara',        '1972-05-30', 'elena.figueroa@example.com',       @pwd, TRUE),
(20, 'Héctor Manuel',       'Rojas Ixcot',          '1966-09-14', 'hector.rojas@example.com',         @pwd, TRUE),
(21, 'Patricia Eugenia',    'Cifuentes Mazariegos', '1987-02-25', 'patricia.cifuentes@example.com',   @pwd, TRUE),
(22, 'Fernando José',       'Monzón Escobar',       '1991-10-08', 'fernando.monzon@example.com',      @pwd, TRUE),
(23, 'Silvia Noemí',        'Girón Valdez',         '1979-12-19', 'silvia.giron@example.com',         @pwd, TRUE),
(24, 'Óscar Rolando',       'Palencia Juárez',      '1983-06-04', 'oscar.palencia@example.com',       @pwd, TRUE),
(25, 'Marta Elizabeth',     'Chávez Ramos',         '1993-01-13', 'marta.chavez@example.com',         @pwd, TRUE),
(26, 'Emma Victoria',       'Salazar Quiej',        '2015-03-08', 'emma.salazar@example.com',         @pwd, TRUE),
(27, 'Santiago Rafael',     'Aguirre Méndez',       '2020-07-21', 'santiago.aguirre@example.com',     @pwd, TRUE),
(28, 'Isabella Nicole',     'Paz Contreras',        '2013-09-02', 'isabella.paz@example.com',         @pwd, TRUE),
(29, 'Joaquín Emilio',      'Lemus Argueta',        '2017-12-16', 'joaquin.lemus@example.com',        @pwd, TRUE),
(30, 'Renata Lucía',        'Barillas Pineda',      '2021-02-05', 'renata.barillas@example.com',      @pwd, TRUE),
(31, 'Claudia Verónica',    'Orellana Gómez',       '1989-08-26', 'claudia.orellana@example.com',     @pwd, TRUE),
(32, 'Lorena Beatriz',      'Archila Montúfar',     '1994-04-14', 'lorena.archila@example.com',       @pwd, TRUE),
(33, 'Wendy Johana',        'Pineda Lima',          '1990-10-31', 'wendy.pineda@example.com',         @pwd, TRUE),
(34, 'Rosa Elvira',         'Velásquez Tun',        '1977-01-09', 'rosa.velasquez@example.com',       @pwd, TRUE),
(35, 'Daniela Alejandra',   'Monroy Fuentes',       '2001-05-18', 'daniela.monroy@example.com',       @pwd, TRUE),
(36, 'Pedro Pablo',         'Cabrera Sosa',         '1971-03-22', 'pedro.cabrera@example.com',        @pwd, TRUE),
(37, 'Jorge Mario',         'Taracena Gálvez',      '1986-11-11', 'jorge.taracena@example.com',       @pwd, TRUE),
(38, 'Alejandro Josué',     'Mazariegos Ponce',     '1998-06-27', 'alejandro.mazariegos@example.com', @pwd, TRUE),
(39, 'Byron Estuardo',      'Colindres Ávila',      '1974-02-03', 'byron.colindres@example.com',      @pwd, TRUE),
(40, 'Edgar Leonel',        'Santizo Herrera',      '1963-08-15', 'edgar.santizo@example.com',        @pwd, TRUE),
(41, 'Ricardo Antonio',     'Samayoa Díaz',         '1981-12-28', 'ricardo.samayoa@example.com',      @pwd, TRUE),
(42, 'Manuel de Jesús',     'Tzoc Batz',            '1976-07-16', 'manuel.tzoc@example.com',          @pwd, TRUE),
(43, 'Ingrid Johanna',      'Ixcoy Tzunún',         '1992-09-09', 'ingrid.ixcoy@example.com',         @pwd, TRUE),
(44, 'Brenda Karina',       'Alvarado Mora',        '1985-04-02', 'brenda.alvarado@example.com',      @pwd, TRUE),
(45, 'Cristian Ernesto',    'Maldonado Reyna',      '2000-01-30', 'cristian.maldonado@example.com',   @pwd, TRUE),
(46, 'Mynor Rolando',       'Castañeda Veliz',      '1970-10-20', 'mynor.castaneda@example.com',      @pwd, TRUE),
(47, 'Stephanie Michelle',  'Duarte Illescas',      '1997-07-01', 'stephanie.duarte@example.com',     @pwd, TRUE),
(48, 'Rodrigo Alfonso',     'Villatoro Mena',       '1989-03-06', 'rodrigo.villatoro@example.com',    @pwd, TRUE),
(49, 'Evelyn Roxana',       'Quiñónez Paredes',     '1982-11-14', 'evelyn.quinonez@example.com',      @pwd, TRUE),
(50, 'Gerson Adolfo',       'Cano Medrano',         '1995-05-25', 'gerson.cano@example.com',          @pwd, TRUE),
(51, 'Débora Raquel',       'Folgar Salguero',      '1978-06-12', 'debora.folgar@example.com',        @pwd, TRUE),
(52, 'Kevin Alexander',     'Luna Ordóñez',         '2002-09-18', 'kevin.luna@example.com',           @pwd, TRUE),
(53, 'Johana Maribel',      'Ajanel Sicán',         '1993-12-07', 'johana.ajanel@example.com',        @pwd, TRUE),
(54, 'Walter Rolando',      'Donis Ayala',          '1968-02-28', 'walter.donis@example.com',         @pwd, TRUE),
(55, 'Alma Delia',          'Coc Choc',             '1987-10-03', 'alma.coc@example.com',             @pwd, TRUE),
-- Pacientes sin citas (56-70)
(56, 'Samuel David',        'Echeverría Paiz',      '1999-04-19', 'samuel.echeverria@example.com',    @pwd, TRUE),
(57, 'Nancy Yolanda',       'Ac Pop',               '1980-08-08', 'nancy.ac@example.com',             @pwd, TRUE),
(58, 'Erick Josué',         'Pop Xol',              '2003-01-12', 'erick.pop@example.com',            @pwd, TRUE),
(59, 'Sandra Liliana',      'Tiul Caal',            '1974-05-05', 'sandra.tiul@example.com',          @pwd, TRUE),
(60, 'Henry Estuardo',      'Caal Maquín',          '1991-11-30', 'henry.caal@example.com',           @pwd, TRUE),
(61, 'Mirna Leticia',       'Xol Cucul',            '1986-03-17', 'mirna.xol@example.com',            @pwd, TRUE),
(62, 'Allan Gabriel',       'Choc Rax',             '1996-07-24', 'allan.choc@example.com',           @pwd, TRUE),
(63, 'Beatriz Eugenia',     'Maas Cú',              '1967-09-21', 'beatriz.maas@example.com',         @pwd, TRUE),
(64, 'Josué Daniel',        'Cú Tux',               '2004-06-06', 'josue.cu@example.com',             @pwd, TRUE),
(65, 'Tania Lissette',      'Box Ical',             '1984-12-13', 'tania.box@example.com',            @pwd, TRUE),
(66, 'Víctor Hugo',         'Say Coy',              '1973-10-10', 'victor.say@example.com',           @pwd, TRUE),
(67, 'Karen Julissa',       'Batz Ixchop',          '1998-02-11', 'karen.batz@example.com',           @pwd, TRUE),
(68, 'Douglas Fernando',    'Coy Racancoj',         '1990-01-01', 'douglas.coy@example.com',          @pwd, TRUE),
(69, 'Mónica Andrea',       'Rodas Campos',         '1988-05-29', 'monica.rodas@example.com',         @pwd, FALSE),  -- usuario inactivo (para pruebas)
(70, 'Luis Fernando',       'Gómez Arriola',        '1993-08-22', 'luis.gomez@example.com',           @pwd, TRUE),
-- Usuarios con rol doctor (71-90)
(71, 'Ricardo',             'Arriaza Mendoza',      '1974-02-10', 'ricardo.arriaza@vitared.gt',       @pwd, TRUE),
(72, 'Silvia',              'Ordóñez Paiz',         '1979-06-18', 'silvia.ordonez@vitared.gt',        @pwd, TRUE),
(73, 'Mariana',             'Castellanos Roca',     '1981-09-03', 'mariana.castellanos@vitared.gt',   @pwd, TRUE),
(74, 'Eduardo',             'Villagrán Soto',       '1972-12-27', 'eduardo.villagran@vitared.gt',     @pwd, TRUE),
(75, 'Carolina',            'Lemus Barrios',        '1985-04-15', 'carolina.lemus@vitared.gt',        @pwd, TRUE),
(76, 'Francisco',           'Sagastume Peña',       '1970-08-09', 'francisco.sagastume@vitared.gt',   @pwd, TRUE),
(77, 'Gloria',              'Menéndez Cordón',      '1977-11-21', 'gloria.menendez@vitared.gt',       @pwd, TRUE),
(78, 'Alfredo',             'Quezada Lorenzana',    '1975-03-30', 'alfredo.quezada@vitared.gt',       @pwd, TRUE),
(79, 'Julio',               'Recinos Alonzo',       '1968-07-14', 'julio.recinos@vitared.gt',         @pwd, TRUE),
(80, 'Ana Cristina',        'Paiz Valenzuela',      '1983-01-26', 'anacristina.paiz@vitared.gt',      @pwd, TRUE),
(81, 'Marco Antonio',       'Herrera Quiroa',       '1971-10-05', 'marco.herrera@vitared.gt',         @pwd, TRUE),
(82, 'Lucrecia',            'Fuentes Madrid',       '1980-05-19', 'lucrecia.fuentes@vitared.gt',      @pwd, TRUE),
(83, 'Rolando',             'Chinchilla Mérida',    '1969-12-02', 'rolando.chinchilla@vitared.gt',    @pwd, TRUE),
(84, 'Estuardo',            'Cordón Gudiel',        '1978-09-23', 'estuardo.cordon@vitared.gt',       @pwd, TRUE),
(85, 'Yesenia',             'Barrera Cabrera',      '1986-02-08', 'yesenia.barrera@vitared.gt',       @pwd, TRUE),
(86, 'Hugo Leonel',         'Maldonado Arana',      '1973-06-11', 'hugo.maldonado@vitared.gt',        @pwd, TRUE),
(87, 'Rebeca',              'Solares Estrada',      '1984-10-29', 'rebeca.solares@vitared.gt',        @pwd, TRUE),
(88, 'Ingrid',              'Samayoa Pellecer',     '1982-03-07', 'ingrid.samayoa@vitared.gt',        @pwd, TRUE),
(89, 'Mauricio',            'Escobar Ruiz',         '1976-01-16', 'mauricio.escobar@vitared.gt',      @pwd, TRUE),
(90, 'Flor de María',       'Tobar Najarro',        '1987-08-24', 'flor.tobar@vitared.gt',            @pwd, TRUE);

-- ---------------------------------------------------------------------
-- 4. CLÍNICAS (una por doctor, id_clinica = id_doctor)
--    Algunas con telefono NULL para probar campos opcionales
-- ---------------------------------------------------------------------
INSERT INTO clinica (id_clinica, nombre, id_location, zona, direccion, telefono, whatsapp, activo) VALUES
(1,  'Centro Médico Arriaza',               75,  10, '6a Avenida 8-24, Zona 10, Ciudad de Guatemala',            '+502 2331 4501', '+502 5512 3401', TRUE),
(2,  'Clínica Pediátrica Ordóñez',          82,  4,  'Calzada Roosevelt 3-45, Zona 4, Mixco',                    '+502 2432 7702', '+502 5512 3402', TRUE),
(3,  'Centro de la Mujer Castellanos',      89,  1,  '3a Calle 5-18, Zona 1, Villa Nueva',                       '+502 6634 8803', '+502 5512 3403', TRUE),
(4,  'Cardio Altos Quetzaltenango',         168, 3,  '12 Avenida 7-31, Zona 3, Quetzaltenango',                  '+502 7761 2204', '+502 5512 3404', TRUE),
(5,  'DermaCare Cobán',                     1,   2,  '1a Calle 4-10, Zona 2, Cobán',                             '+502 7951 3305', '+502 5512 3405', TRUE),
(6,  'Neurología Antigua',                  222, 1,  '4a Calle Oriente 12, Antigua Guatemala',                   NULL,             '+502 5512 3406', TRUE),
(7,  'Visión Clara Escuintla',              61,  1,  '5a Avenida 6-22, Zona 1, Escuintla',                       '+502 7888 4407', '+502 5512 3407', TRUE),
(8,  'Otorrino Cuchumatanes',               92,  1,  '4a Avenida 3-15, Zona 1, Huehuetenango',                   '+502 7764 5508', '+502 5512 3408', TRUE),
(9,  'Ortopedia del Oriente',               42,  1,  '7a Avenida 2-40, Zona 1, Chiquimula',                      '+502 7942 6609', '+502 5512 3409', TRUE),
(10, 'Clínica Mente Sana Zacapa',           330, 1,  '9a Calle 5-12, Zona 1, Zacapa',                            NULL,             '+502 5512 3410', TRUE),
(11, 'Gastro Caribe',                       125, 1,  '8a Calle 6-30, Zona 1, Puerto Barrios',                    '+502 7948 7711', '+502 5512 3411', TRUE),
(12, 'Endocrino Petén',                     154, 1,  'Calle Central 1-05, Zona 1, Flores',                       '+502 7926 8812', '+502 5512 3412', TRUE),
(13, 'Urología Jalapa',                     130, 1,  '2a Avenida 4-18, Zona 1, Jalapa',                          '+502 7922 9913', '+502 5512 3413', TRUE),
(14, 'Neumología Atitlán',                  282, 2,  '5a Calle 3-25, Zona 2, Sololá',                            '+502 7762 1014', '+502 5512 3414', TRUE),
(15, 'Imagen Diagnóstica Mazatenango',      301, 1,  '6a Avenida 4-50, Zona 1, Mazatenango',                     '+502 7872 1115', '+502 5512 3415', TRUE),
(16, 'Clínica Integral Retalhuleu',         213, 1,  '5a Calle 5-16, Zona 1, Retalhuleu',                        '+502 7771 1216', '+502 5512 3416', TRUE),
(17, 'Pediatría Baja Verapaz',              18,  1,  '3a Avenida 6-08, Zona 1, Salamá',                          NULL,             '+502 5512 3417', TRUE),
(18, 'Salud de la Mujer Chimaltenango',     26,  2,  'Calzada Tecún Umán 2-45, Zona 2, Chimaltenango',           '+502 7839 1318', '+502 5512 3418', TRUE),
(19, 'Cardio San Marcos',                   238, 2,  '6a Avenida 7-12, Zona 2, San Marcos',                      '+502 7760 1419', '+502 5512 3419', TRUE),
(20, 'Dermatología Quiché',                 192, 1,  '4a Calle 3-33, Zona 1, Santa Cruz del Quiché',             '+502 7755 1520', '+502 5512 3420', TRUE);

-- ---------------------------------------------------------------------
-- 5. DOCTORES (usuarios 71-90)
--    Especialidades: 1 Med. Interna, 2 Pediatría, 3 Gineco, 4 Cardio, 5 Derma,
--    6 Neuro, 7 Oftalmo, 8 ORL, 9 Trauma, 10 Psiquiatría, 11 Gastro,
--    12 Endocrino, 13 Urología, 14 Neumología, 15 Radiología
-- ---------------------------------------------------------------------
INSERT INTO doctor (id_doctor, id_usuario, id_clinica, id_especialidad, numero_colegiado, tarifa_consulta, activo) VALUES
(1,  71, 1,  1,  'COL-10234', 350.00, TRUE),
(2,  72, 2,  2,  'COL-11876', 250.00, TRUE),
(3,  73, 3,  3,  'COL-12459', 300.00, TRUE),
(4,  74, 4,  4,  'COL-09871', 450.00, TRUE),
(5,  75, 5,  5,  'COL-13302', 300.00, TRUE),
(6,  76, 6,  6,  'COL-08745', 500.00, TRUE),
(7,  77, 7,  7,  'COL-11023', 280.00, TRUE),
(8,  78, 8,  8,  'COL-10598', 260.00, TRUE),
(9,  79, 9,  9,  'COL-07912', 400.00, TRUE),
(10, 80, 10, 10, 'COL-13877', 400.00, TRUE),
(11, 81, 11, 11, 'COL-09340', 380.00, TRUE),
(12, 82, 12, 12, 'COL-12066', 350.00, TRUE),
(13, 83, 13, 13, 'COL-08213', 420.00, TRUE),
(14, 84, 14, 14, 'COL-10991', 330.00, TRUE),
(15, 85, 15, 15, 'COL-14125', 450.00, TRUE),
(16, 86, 16, 1,  'COL-09654', 300.00, TRUE),
(17, 87, 17, 2,  'COL-13540', 220.00, TRUE),
(18, 88, 18, 3,  'COL-12788', 280.00, TRUE),
(19, 89, 19, 4,  'COL-10407', 430.00, TRUE),   -- sin citas
(20, 90, 20, 5,  'COL-14390', 290.00, TRUE);   -- sin citas

-- ---------------------------------------------------------------------
-- 6. HORARIOS (un registro por doctor y día; horas en punto)
-- ---------------------------------------------------------------------
INSERT INTO horario_doctor (id_doctor, dia, hora_inicio, hora_fin) VALUES
-- Dr. 1: Lun-Vie 08-16
(1,'LUNES','08:00:00','16:00:00'),(1,'MARTES','08:00:00','16:00:00'),(1,'MIERCOLES','08:00:00','16:00:00'),
(1,'JUEVES','08:00:00','16:00:00'),(1,'VIERNES','08:00:00','16:00:00'),
-- Dr. 2: Lun, Mié, Vie 09-17 y Sáb 08-12
(2,'LUNES','09:00:00','17:00:00'),(2,'MIERCOLES','09:00:00','17:00:00'),(2,'VIERNES','09:00:00','17:00:00'),(2,'SABADO','08:00:00','12:00:00'),
-- Dr. 3: Mar, Jue 10-18 y Sáb 09-13
(3,'MARTES','10:00:00','18:00:00'),(3,'JUEVES','10:00:00','18:00:00'),(3,'SABADO','09:00:00','13:00:00'),
-- Dr. 4: Lun-Jue 07-15
(4,'LUNES','07:00:00','15:00:00'),(4,'MARTES','07:00:00','15:00:00'),(4,'MIERCOLES','07:00:00','15:00:00'),(4,'JUEVES','07:00:00','15:00:00'),
-- Dr. 5: Lun-Vie 14-19 (tardes)
(5,'LUNES','14:00:00','19:00:00'),(5,'MARTES','14:00:00','19:00:00'),(5,'MIERCOLES','14:00:00','19:00:00'),
(5,'JUEVES','14:00:00','19:00:00'),(5,'VIERNES','14:00:00','19:00:00'),
-- Dr. 6: Mar-Jue 08-14 y Vie 08-12
(6,'MARTES','08:00:00','14:00:00'),(6,'MIERCOLES','08:00:00','14:00:00'),(6,'JUEVES','08:00:00','14:00:00'),(6,'VIERNES','08:00:00','12:00:00'),
-- Dr. 7: Lun, Mar, Jue, Vie 09-16 (descansa miércoles)
(7,'LUNES','09:00:00','16:00:00'),(7,'MARTES','09:00:00','16:00:00'),(7,'JUEVES','09:00:00','16:00:00'),(7,'VIERNES','09:00:00','16:00:00'),
-- Dr. 8: Lun-Vie 08-13 (solo mañanas)
(8,'LUNES','08:00:00','13:00:00'),(8,'MARTES','08:00:00','13:00:00'),(8,'MIERCOLES','08:00:00','13:00:00'),
(8,'JUEVES','08:00:00','13:00:00'),(8,'VIERNES','08:00:00','13:00:00'),
-- Dr. 9: Mié-Vie 10-18 y Sáb 08-14
(9,'MIERCOLES','10:00:00','18:00:00'),(9,'JUEVES','10:00:00','18:00:00'),(9,'VIERNES','10:00:00','18:00:00'),(9,'SABADO','08:00:00','14:00:00'),
-- Dr. 10: Lun, Mié, Vie 15-20
(10,'LUNES','15:00:00','20:00:00'),(10,'MIERCOLES','15:00:00','20:00:00'),(10,'VIERNES','15:00:00','20:00:00'),
-- Dr. 11: Mar-Sáb 08-14
(11,'MARTES','08:00:00','14:00:00'),(11,'MIERCOLES','08:00:00','14:00:00'),(11,'JUEVES','08:00:00','14:00:00'),
(11,'VIERNES','08:00:00','14:00:00'),(11,'SABADO','08:00:00','14:00:00'),
-- Dr. 12: Lun-Mié 09-17 y Sáb 09-13
(12,'LUNES','09:00:00','17:00:00'),(12,'MARTES','09:00:00','17:00:00'),(12,'MIERCOLES','09:00:00','17:00:00'),(12,'SABADO','09:00:00','13:00:00'),
-- Dr. 13: Mar, Jue 08-16
(13,'MARTES','08:00:00','16:00:00'),(13,'JUEVES','08:00:00','16:00:00'),
-- Dr. 14: Lun-Vie 10-17
(14,'LUNES','10:00:00','17:00:00'),(14,'MARTES','10:00:00','17:00:00'),(14,'MIERCOLES','10:00:00','17:00:00'),
(14,'JUEVES','10:00:00','17:00:00'),(14,'VIERNES','10:00:00','17:00:00'),
-- Dr. 15: Lun-Vie 07-15 y Sáb 07-11
(15,'LUNES','07:00:00','15:00:00'),(15,'MARTES','07:00:00','15:00:00'),(15,'MIERCOLES','07:00:00','15:00:00'),
(15,'JUEVES','07:00:00','15:00:00'),(15,'VIERNES','07:00:00','15:00:00'),(15,'SABADO','07:00:00','11:00:00'),
-- Dr. 16: Lun, Mar, Jue 13-19 y Sáb 08-12
(16,'LUNES','13:00:00','19:00:00'),(16,'MARTES','13:00:00','19:00:00'),(16,'JUEVES','13:00:00','19:00:00'),(16,'SABADO','08:00:00','12:00:00'),
-- Dr. 17: Lun, Mar, Jue, Vie 08-16 (descansa miércoles)
(17,'LUNES','08:00:00','16:00:00'),(17,'MARTES','08:00:00','16:00:00'),(17,'JUEVES','08:00:00','16:00:00'),(17,'VIERNES','08:00:00','16:00:00'),
-- Dr. 18: Lun-Vie 11-19
(18,'LUNES','11:00:00','19:00:00'),(18,'MARTES','11:00:00','19:00:00'),(18,'MIERCOLES','11:00:00','19:00:00'),
(18,'JUEVES','11:00:00','19:00:00'),(18,'VIERNES','11:00:00','19:00:00'),
-- Dr. 19: Lun-Jue 09-17
(19,'LUNES','09:00:00','17:00:00'),(19,'MARTES','09:00:00','17:00:00'),(19,'MIERCOLES','09:00:00','17:00:00'),(19,'JUEVES','09:00:00','17:00:00'),
-- Dr. 20: Mié-Sáb 08-15
(20,'MIERCOLES','08:00:00','15:00:00'),(20,'JUEVES','08:00:00','15:00:00'),(20,'VIERNES','08:00:00','15:00:00'),(20,'SABADO','08:00:00','15:00:00');

-- ---------------------------------------------------------------------
-- 7. CITAS
--    - Doctores 1-18 con 5 o más citas; doctores 19 y 20 SIN citas
--    - Pacientes 1-55 con citas; pacientes 56-70 SIN citas
--    - Todas caen en un día y hora dentro del horario del doctor
--    - Pasadas (antes del 08/10/2026): ATENDIDA o CANCELADA
--    - Futuras: PROGRAMADA (y alguna CANCELADA)
-- ---------------------------------------------------------------------
INSERT INTO cita (id_doctor, id_paciente, fecha_hora_inicio, motivo, estado) VALUES
-- Dr. 1 Medicina Interna
(1, 1,  '2026-09-14 09:00:00', 'Control de presión arterial',   'ATENDIDA'),
(1, 2,  '2026-09-22 10:00:00', 'Dolor abdominal recurrente',    'ATENDIDA'),
(1, 3,  '2026-10-02 14:00:00', 'Chequeo general',               'CANCELADA'),
(1, 4,  '2026-10-13 08:00:00', 'Seguimiento de diabetes',       'PROGRAMADA'),
(1, 5,  '2026-10-20 11:00:00', 'Resultados de laboratorio',     'PROGRAMADA'),
(1, 38, '2026-10-15 15:00:00', 'Fatiga persistente',            'PROGRAMADA'),
-- Dra. 2 Pediatría (pacientes menores)
(2, 6,  '2026-09-09 09:00:00', 'Control de niño sano',          'ATENDIDA'),
(2, 7,  '2026-09-19 08:00:00', 'Fiebre y tos',                  'ATENDIDA'),
(2, 8,  '2026-09-28 15:00:00', 'Vacunación',                    'CANCELADA'),
(2, 9,  '2026-10-12 10:00:00', 'Control de crecimiento',        'PROGRAMADA'),
(2, 10, '2026-10-17 09:00:00', 'Infección respiratoria',        'PROGRAMADA'),
-- Dra. 3 Ginecología y Obstetricia
(3, 11, '2026-09-10 10:00:00', 'Control prenatal',              'ATENDIDA'),
(3, 12, '2026-09-22 16:00:00', 'Papanicolaou',                  'ATENDIDA'),
(3, 13, '2026-10-01 11:00:00', 'Planificación familiar',        'ATENDIDA'),
(3, 14, '2026-10-13 12:00:00', 'Control prenatal',              'PROGRAMADA'),
(3, 15, '2026-10-24 09:00:00', 'Ultrasonido de control',        'PROGRAMADA'),
-- Dr. 4 Cardiología
(4, 16, '2026-09-07 08:00:00', 'Palpitaciones',                 'ATENDIDA'),
(4, 17, '2026-09-16 09:00:00', 'Electrocardiograma de control', 'ATENDIDA'),
(4, 18, '2026-09-29 07:00:00', 'Hipertensión arterial',         'CANCELADA'),
(4, 19, '2026-10-14 10:00:00', 'Evaluación cardiovascular',     'PROGRAMADA'),
(4, 20, '2026-10-22 13:00:00', 'Dolor torácico',                'PROGRAMADA'),
-- Dra. 5 Dermatología
(5, 21, '2026-09-08 14:00:00', 'Acné',                          'ATENDIDA'),
(5, 22, '2026-09-18 15:00:00', 'Dermatitis',                    'ATENDIDA'),
(5, 23, '2026-10-05 16:00:00', 'Revisión de lunares',           'CANCELADA'),
(5, 24, '2026-10-14 17:00:00', 'Alergia en la piel',            'PROGRAMADA'),
(5, 25, '2026-10-23 18:00:00', 'Control de psoriasis',          'PROGRAMADA'),
-- Dr. 6 Neurología
(6, 36, '2026-09-15 08:00:00', 'Migraña frecuente',             'ATENDIDA'),
(6, 37, '2026-09-24 10:00:00', 'Mareos',                        'ATENDIDA'),
(6, 38, '2026-10-07 09:00:00', 'Hormigueo en extremidades',     'ATENDIDA'),
(6, 39, '2026-10-16 11:00:00', 'Seguimiento de cefalea',        'PROGRAMADA'),
(6, 40, '2026-10-21 12:00:00', 'Evaluación neurológica',        'PROGRAMADA'),
-- Dra. 7 Oftalmología
(7, 43, '2026-09-11 09:00:00', 'Examen de la vista',            'ATENDIDA'),
(7, 44, '2026-09-21 10:00:00', 'Ojo seco',                      'ATENDIDA'),
(7, 47, '2026-10-01 15:00:00', 'Control de glaucoma',           'CANCELADA'),
(7, 49, '2026-10-15 11:00:00', 'Cambio de graduación',          'PROGRAMADA'),
(7, 51, '2026-10-27 14:00:00', 'Irritación ocular',             'PROGRAMADA'),
-- Dr. 8 Otorrinolaringología
(8, 53, '2026-09-14 08:00:00', 'Dolor de oído',                 'ATENDIDA'),
(8, 55, '2026-09-23 09:00:00', 'Sinusitis',                     'ATENDIDA'),
(8, 19, '2026-10-02 10:00:00', 'Amigdalitis',                   'ATENDIDA'),
(8, 21, '2026-10-13 11:00:00', 'Zumbido en el oído',            'PROGRAMADA'),
(8, 23, '2026-10-19 12:00:00', 'Rinitis alérgica',              'CANCELADA'),
-- Dr. 9 Traumatología y Ortopedia
(9, 50, '2026-09-12 08:00:00', 'Dolor de rodilla',              'ATENDIDA'),
(9, 52, '2026-09-23 10:00:00', 'Esguince de tobillo',           'ATENDIDA'),
(9, 54, '2026-10-02 16:00:00', 'Dolor lumbar',                  'ATENDIDA'),
(9, 22, '2026-10-14 14:00:00', 'Control post fractura',         'PROGRAMADA'),
(9, 24, '2026-10-24 10:00:00', 'Dolor de hombro',               'PROGRAMADA'),
-- Dra. 10 Psiquiatría
(10, 4,  '2026-09-09 15:00:00', 'Ansiedad',                     'ATENDIDA'),
(10, 14, '2026-09-18 17:00:00', 'Trastorno del sueño',          'ATENDIDA'),
(10, 34, '2026-09-28 16:00:00', 'Control de depresión',         'CANCELADA'),
(10, 44, '2026-10-14 18:00:00', 'Terapia de seguimiento',       'PROGRAMADA'),
(10, 55, '2026-10-23 19:00:00', 'Manejo del estrés',            'PROGRAMADA'),
-- Dr. 11 Gastroenterología
(11, 5,  '2026-09-08 08:00:00', 'Gastritis',                    'ATENDIDA'),
(11, 15, '2026-09-17 09:00:00', 'Reflujo gastroesofágico',      'ATENDIDA'),
(11, 25, '2026-09-26 10:00:00', 'Colon irritable',              'ATENDIDA'),
(11, 35, '2026-10-06 12:00:00', 'Dolor abdominal',              'CANCELADA'),
(11, 45, '2026-10-16 09:00:00', 'Endoscopía de control',        'PROGRAMADA'),
-- Dra. 12 Endocrinología
(12, 3,  '2026-09-16 09:00:00', 'Control de tiroides',          'ATENDIDA'),
(12, 13, '2026-09-29 11:00:00', 'Control de glucosa',           'ATENDIDA'),
(12, 23, '2026-10-05 10:00:00', 'Obesidad y metabolismo',       'ATENDIDA'),
(12, 33, '2026-10-19 14:00:00', 'Ajuste de tratamiento',        'PROGRAMADA'),
(12, 43, '2026-10-24 10:00:00', 'Hipotiroidismo',               'PROGRAMADA'),
-- Dr. 13 Urología (pacientes masculinos adultos)
(13, 41, '2026-09-15 08:00:00', 'Infección urinaria',           'ATENDIDA'),
(13, 42, '2026-09-24 09:00:00', 'Control de próstata',          'ATENDIDA'),
(13, 45, '2026-10-06 10:00:00', 'Cálculos renales',             'CANCELADA'),
(13, 46, '2026-10-15 13:00:00', 'Chequeo urológico',            'PROGRAMADA'),
(13, 48, '2026-10-27 15:00:00', 'Molestias al orinar',          'PROGRAMADA'),
-- Dr. 14 Neumología
(14, 17, '2026-09-14 10:00:00', 'Tos crónica',                  'ATENDIDA'),
(14, 38, '2026-09-25 11:00:00', 'Asma',                         'ATENDIDA'),
(14, 40, '2026-10-07 14:00:00', 'Dificultad para respirar',     'ATENDIDA'),
(14, 49, '2026-10-14 15:00:00', 'Espirometría',                 'PROGRAMADA'),
(14, 51, '2026-10-26 10:00:00', 'Control de EPOC',              'PROGRAMADA'),
-- Dra. 15 Radiología
(15, 2,  '2026-09-10 07:00:00', 'Radiografía de tórax',         'ATENDIDA'),
(15, 19, '2026-09-19 08:00:00', 'Ultrasonido abdominal',        'ATENDIDA'),
(15, 20, '2026-10-01 09:00:00', 'Resonancia de rodilla',        'ATENDIDA'),
(15, 41, '2026-10-13 10:00:00', 'Radiografía de columna',       'PROGRAMADA'),
(15, 52, '2026-10-20 13:00:00', 'Tomografía de abdomen',        'CANCELADA'),
-- Dr. 16 Medicina Interna
(16, 21, '2026-09-15 14:00:00', 'Hipertensión',                 'ATENDIDA'),
(16, 22, '2026-09-26 08:00:00', 'Chequeo anual',                'ATENDIDA'),
(16, 24, '2026-10-01 16:00:00', 'Control de colesterol',        'ATENDIDA'),
(16, 32, '2026-10-12 15:00:00', 'Anemia',                       'PROGRAMADA'),
(16, 39, '2026-10-22 17:00:00', 'Seguimiento de gastritis',     'PROGRAMADA'),
-- Dra. 17 Pediatría (pacientes menores)
(17, 26, '2026-09-17 08:00:00', 'Control de niño sano',         'ATENDIDA'),
(17, 27, '2026-09-25 09:00:00', 'Esquema de vacunación',        'ATENDIDA'),
(17, 28, '2026-10-05 10:00:00', 'Dolor de garganta',            'CANCELADA'),
(17, 29, '2026-10-15 14:00:00', 'Control de crecimiento',       'PROGRAMADA'),
(17, 30, '2026-10-23 11:00:00', 'Diarrea y deshidratación',     'PROGRAMADA'),
-- Dra. 18 Ginecología y Obstetricia
(18, 31, '2026-09-10 11:00:00', 'Control ginecológico',         'ATENDIDA'),
(18, 32, '2026-09-21 15:00:00', 'Dolor pélvico',                'ATENDIDA'),
(18, 33, '2026-10-02 12:00:00', 'Control prenatal',             'ATENDIDA'),
(18, 34, '2026-10-13 16:00:00', 'Papanicolaou',                 'PROGRAMADA'),
(18, 35, '2026-10-21 18:00:00', 'Control de ciclos menstruales','PROGRAMADA');
-- Doctores 19 y 20: sin citas.  Pacientes 56-70: sin citas.

-- ---------------------------------------------------------------------
-- CONSULTAS DE VERIFICACIÓN (opcionales)
-- ---------------------------------------------------------------------
-- SELECT COUNT(*) FROM usuario;                                                    -- 90
-- SELECT COUNT(*) FROM doctor;                                                     -- 20
-- SELECT d.id_doctor, COUNT(c.id_cita) FROM doctor d
--   LEFT JOIN cita c ON c.id_doctor = d.id_doctor GROUP BY d.id_doctor;            -- 19 y 20 = 0
-- SELECT u.id_usuario FROM usuario u
--   LEFT JOIN cita c ON c.id_paciente = u.id_usuario
--   WHERE u.id_usuario <= 70 AND c.id_cita IS NULL;                                -- 56 a 70
-- Citas fuera de horario (debe devolver 0 filas):
-- SELECT c.* FROM cita c
--   LEFT JOIN horario_doctor h ON h.id_doctor = c.id_doctor
--     AND h.dia = ELT(WEEKDAY(c.fecha_hora_inicio)+1,'LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO','DOMINGO')
--     AND TIME(c.fecha_hora_inicio) >= h.hora_inicio AND TIME(c.fecha_hora_inicio) < h.hora_fin
--   WHERE h.id_horario IS NULL;