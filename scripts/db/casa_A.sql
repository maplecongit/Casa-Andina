-- =====================================================
-- CREACIÓN DE BASE DE DATOS
-- =====================================================
DROP DATABASE IF EXISTS bd_andina2;
CREATE DATABASE bd_andina2;
USE bd_andina2;

-- =====================================================
-- TABLA PRINCIPAL DEL HOTEL
-- =====================================================
CREATE TABLE Casa_Andina (
    id_hotel INT AUTO_INCREMENT PRIMARY KEY,
    sede VARCHAR(100),
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    horario VARCHAR(100)
);

-- =====================================================
-- SERVICIOS DEL HOTEL
-- =====================================================
CREATE TABLE Servicio_Hotel (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    id_hotel INT,
    FOREIGN KEY (id_hotel) REFERENCES Casa_Andina(id_hotel)
);

-- =====================================================
-- HABITACIONES
-- =====================================================
CREATE TABLE Habitacion (
    id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
    numero INT,
    piso INT,
    estado VARCHAR(50),
    nombre_tipo VARCHAR(100),
    precio DECIMAL(10,2),
    num_adultos INT,
    num_niños INT,
    id_hotel INT,
    FOREIGN KEY (id_hotel) REFERENCES Casa_Andina(id_hotel)
);

-- =====================================================
-- SERVICIOS DE HABITACION
-- =====================================================
CREATE TABLE Servicio_Habitacion (
    id_serv_hab INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Relación HABITACION - SERVICIO_HABITACION
CREATE TABLE Habitacion_Servicio (
    id_habitacion INT,
    id_serv_hab INT,
    PRIMARY KEY (id_habitacion, id_serv_hab),
    FOREIGN KEY (id_habitacion) REFERENCES Habitacion(id_habitacion),
    FOREIGN KEY (id_serv_hab) REFERENCES Servicio_Habitacion(id_serv_hab)
);

-- =====================================================
-- CLIENTES
-- =====================================================
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    apellidos VARCHAR(100),
    email VARCHAR(100),
    telefono VARCHAR(20),
    nro_documento VARCHAR(50),
    tipo_documento VARCHAR(50),
    pais VARCHAR(50)
);

-- =====================================================
-- RESERVAS
-- =====================================================
CREATE TABLE Reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_habitacion INT,
    fecha_reserva DATE,
    fecha_entrada DATE,
    fecha_salida DATE,
    num_adultos INT,
    num_niños INT,
    num_noches INT,
    estado VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_habitacion) REFERENCES Habitacion(id_habitacion)
);

-- =====================================================
-- PAGOS DEL HOTEL
-- =====================================================
CREATE TABLE Pago_Hotel (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT,
    fecha_pago DATE,
    monto_total DECIMAL(10,2),
    estado_pago VARCHAR(50),
    metodo_pago VARCHAR(50),
    igv DECIMAL(5,2),
    titular_tarjeta VARCHAR(50),
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva)
);

-- =====================================================
-- RESTAURANTE
-- =====================================================
CREATE TABLE Restaurante (
    id_restaurante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    horario_aper VARCHAR(100),
    horario_cierre VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100),
    id_hotel INT,
    FOREIGN KEY (id_hotel) REFERENCES Casa_Andina(id_hotel)
);

-- =====================================================
-- EMPLEADOS
-- =====================================================
CREATE TABLE Empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    id_hotel INT,
    id_restaurante INT,
    nombre VARCHAR(100),
    apellidos VARCHAR(100),
    email VARCHAR(100),
    telefono VARCHAR(20),
    cargo VARCHAR(50),
    FOREIGN KEY (id_hotel) REFERENCES Casa_Andina(id_hotel),
    FOREIGN KEY (id_restaurante) REFERENCES Restaurante(id_restaurante)
);

-- =====================================================
-- PRODUCTOS DEL RESTAURANTE
-- =====================================================
CREATE TABLE Producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    tipo_producto VARCHAR(50),
    precio DECIMAL(10,2),
    stock INT,
    id_restaurante INT,
    FOREIGN KEY (id_restaurante) REFERENCES Restaurante(id_restaurante)
);

-- =====================================================
-- PEDIDOS DEL RESTAURANTE
-- =====================================================
CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_empleado INT,
    fecha DATE,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

-- DETALLE DEL PEDIDO
CREATE TABLE Detalle_Pedido (
    id_pedido INT,
    id_producto INT,
    sub_total DECIMAL(10,2),
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- PAGOS DEL RESTAURANTE
CREATE TABLE Pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    fecha_pago DATE,
    monto DECIMAL(10,2),
    metodo_pago VARCHAR(50),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

-- =====================================================
-- FUNCIONES
-- =====================================================

-- Calcular IGV de un monto (18%)
DELIMITER //
CREATE FUNCTION fn_calcular_igv(monto DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN monto * 0.18;
END;
//
DELIMITER ;

-- Calcular total noches de una reserva
DELIMITER //
CREATE FUNCTION fn_total_noches(fecha_ini DATE, fecha_fin DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(fecha_fin, fecha_ini);
END;
//
DELIMITER ;

-- Calcular total de un pedido (sumando sus productos)
DELIMITER //
CREATE FUNCTION fn_total_pedido(pid INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(sub_total) INTO total
    FROM Detalle_Pedido
    WHERE id_pedido = pid;
    RETURN IFNULL(total,0);
END;
//
DELIMITER ;
-- Calcular precio total por estadía (precio × noches)
DELIMITER //
CREATE FUNCTION fn_precio_estadia(pid_habitacion INT, fecha_ini DATE, fecha_fin DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE precio DECIMAL(10,2);
    DECLARE noches INT;

    SELECT h.precio INTO precio
    FROM Habitacion h
    WHERE h.id_habitacion = pid_habitacion;

    SET noches = DATEDIFF(fecha_fin, fecha_ini);

    RETURN precio * noches;
END;
//
DELIMITER ;

-- Verificar disponibilidad de una habitación entre fechas dadas
DELIMITER //
CREATE FUNCTION fn_habitacion_disponible(pid_habitacion INT, fecha_ini DATE, fecha_fin DATE)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE ocupada INT;
    SELECT COUNT(*) INTO ocupada
    FROM Reserva r
    WHERE r.id_habitacion = pid_habitacion
      AND r.estado IN ('Pendiente','Confirmada')
      AND (
            (fecha_ini BETWEEN r.fecha_entrada AND r.fecha_salida)
         OR (fecha_fin BETWEEN r.fecha_entrada AND r.fecha_salida)
         OR (r.fecha_entrada BETWEEN fecha_ini AND fecha_fin)
         OR (r.fecha_salida BETWEEN fecha_ini AND fecha_fin)
      );
    RETURN (ocupada = 0); 
END;
//
DELIMITER ;

-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS
-- =====================================================

-- Insertar nuevo cliente
DELIMITER //
CREATE PROCEDURE sp_insertar_cliente(
    IN p_nombre VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_nro_documento VARCHAR(50),
    IN p_tipo_documento VARCHAR(50),
    IN p_pais VARCHAR(50)
)
BEGIN
    INSERT INTO Cliente(nombre, apellidos, email, telefono, nro_documento, tipo_documento, pais)
    VALUES(p_nombre, p_apellidos, p_email, p_telefono, p_nro_documento, p_tipo_documento, p_pais);
END;
//
DELIMITER ;
-- Insertar nueva reserva
DELIMITER //
CREATE PROCEDURE sp_insertar_reserva(
    IN p_id_cliente INT,
    IN p_id_habitacion INT,
    IN p_fecha_reserva DATE,
    IN p_fecha_entrada DATE,
    IN p_fecha_salida DATE,
    IN p_num_adultos INT,
    IN p_num_niños INT
)
BEGIN
    DECLARE noches INT;
    SET noches = fn_total_noches(p_fecha_entrada, p_fecha_salida);

    INSERT INTO Reserva(id_cliente, id_habitacion, fecha_reserva, fecha_entrada, fecha_salida,
                        num_adultos, num_niños, num_noches, estado)
    VALUES(p_id_cliente, p_id_habitacion, p_fecha_reserva, p_fecha_entrada, p_fecha_salida,
           p_num_adultos, p_num_niños, noches, 'Pendiente');
END;
//
DELIMITER ;

-- Insertar pedido restaurante
DELIMITER //
CREATE PROCEDURE sp_insertar_pedido(
    IN p_id_cliente INT,
    IN p_id_empleado INT,
    IN p_fecha DATE
)
BEGIN
    INSERT INTO Pedido(id_cliente, id_empleado, fecha)
    VALUES(p_id_cliente, p_id_empleado, p_fecha);
END;
//
DELIMITER;
-- Insertar detalle de pedido de restaurante
DELIMITER //
CREATE PROCEDURE sp_insertar_detalle_pedido(
    IN p_id_pedido INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_subtotal DECIMAL(10,2);

    -- Verificar si el producto existe
    SELECT precio INTO v_precio
    FROM Producto
    WHERE id_producto = p_id_producto;

    IF v_precio IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Producto no encontrado';
    END IF;

    SET v_subtotal = v_precio * p_cantidad;
    
    -- Si ya existe el producto en el pedido, solo actualizar
    IF EXISTS (SELECT 1 FROM Detalle_Pedido WHERE id_pedido = p_id_pedido AND id_producto = p_id_producto) THEN
        UPDATE Detalle_Pedido
        SET cantidad = cantidad + p_cantidad,
            sub_total = sub_total + v_subtotal
        WHERE id_pedido = p_id_pedido AND id_producto = p_id_producto;
    ELSE
        INSERT INTO Detalle_Pedido(id_pedido, id_producto, cantidad, sub_total, precio_unitario)
        VALUES (p_id_pedido, p_id_producto, p_cantidad, v_subtotal, v_precio);
    END IF;
END //
DELIMITER ;


-- Insertar pago hotel
DELIMITER //
CREATE PROCEDURE sp_insertar_pago_hotel(
    IN p_id_reserva INT,
    IN p_monto DECIMAL(10,2),
    IN p_metodo VARCHAR(50),
    IN p_titular VARCHAR(50)
)
BEGIN
    INSERT INTO Pago_Hotel(id_reserva, fecha_pago, monto_total, estado_pago, metodo_pago, igv, titular_tarjeta)
    VALUES(p_id_reserva, CURDATE(), p_monto, 'Pagado', p_metodo, fn_calcular_igv(p_monto), p_titular);
END;
//
DELIMITER ;

-- Insertar pago restaurante
DELIMITER //
CREATE PROCEDURE sp_insertar_pago_restaurante(
    IN p_id_pedido INT,
    IN p_metodo VARCHAR(50)
)
BEGIN
    DECLARE total DECIMAL(10,2);
    SET total = fn_total_pedido(p_id_pedido);

    INSERT INTO Pago(id_pedido, fecha_pago, monto, metodo_pago)
    VALUES(p_id_pedido, CURDATE(), total, p_metodo);
END;
//
DELIMITER ;
-- =====================================================
-- PROCEDIMIENTOS PARA HABITACIONES
-- =====================================================
-- Insertar nueva habitación
DELIMITER //
CREATE PROCEDURE sp_insertar_habitacion(
    IN p_numero INT,
    IN p_piso INT,
    IN p_estado VARCHAR(50),
    IN p_nombre_tipo VARCHAR(100),
    IN p_precio DECIMAL(10,2),
    IN p_num_adultos INT,
    IN p_num_niños INT,
    IN p_id_hotel INT
)
BEGIN
    INSERT INTO Habitacion(numero, piso, estado, nombre_tipo, precio, num_adultos, num_niños, id_hotel)
    VALUES(p_numero, p_piso, p_estado, p_nombre_tipo, p_precio, p_num_adultos, p_num_niños, p_id_hotel);
END;
//
DELIMITER ;

-- Actualizar datos de una habitación
DELIMITER //
CREATE PROCEDURE sp_actualizar_habitacion(
    IN p_id_habitacion INT,
    IN p_numero INT,
    IN p_piso INT,
    IN p_estado VARCHAR(50),
    IN p_nombre_tipo VARCHAR(100),
    IN p_precio DECIMAL(10,2),
    IN p_num_adultos INT,
    IN p_num_niños INT
)
BEGIN
    UPDATE Habitacion
    SET numero = p_numero,
        piso = p_piso,
        estado = p_estado,
        nombre_tipo = p_nombre_tipo,
        precio = p_precio,
        num_adultos = p_num_adultos,
        num_niños = p_num_niños
    WHERE id_habitacion = p_id_habitacion;
END;
//
DELIMITER ;

-- Eliminar una habitación
DELIMITER //
CREATE PROCEDURE sp_eliminar_habitacion(
    IN p_id_habitacion INT
)
BEGIN
    DELETE FROM Habitacion WHERE id_habitacion = p_id_habitacion;
END;
//
DELIMITER ;

-- Cambiar estado de una habitación 
DELIMITER //
CREATE PROCEDURE sp_cambiar_estado_habitacion(
    IN p_id_habitacion INT,
    IN p_estado VARCHAR(50)
)
BEGIN
    UPDATE Habitacion
    SET estado = p_estado
    WHERE id_habitacion = p_id_habitacion;
END;
//
DELIMITER ;
-- =====================================================
-- TRIGGER: Verificar número de habitación duplicado
-- =====================================================
DELIMITER //
CREATE TRIGGER verificar_numero_habitacion	
BEFORE INSERT ON Habitacion
FOR EACH ROW
BEGIN
    DECLARE existe INT;
    
    SELECT COUNT(*) INTO existe
    FROM Habitacion
    WHERE numero = NEW.numero AND id_hotel = NEW.id_hotel;
    
    IF existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe una habitación con ese número en este hotel.';
    END IF;
END;
//
DELIMITER ;
-- =====================================================
-- TRIGGER: Actualizar estado de habitación al crear reserva
-- =====================================================
DELIMITER //
CREATE TRIGGER trg_ocupar_habitacion_reserva
AFTER INSERT ON Reserva
FOR EACH ROW
BEGIN
    UPDATE Habitacion
    SET estado = 'Ocupada'
    WHERE id_habitacion = NEW.id_habitacion;
END;
//
DELIMITER ;

-- Verificar si ya existe un cliente con el mismo número de documento
DELIMITER //
CREATE TRIGGER trg_verificar_cliente_existente
BEFORE INSERT ON Cliente
FOR EACH ROW
BEGIN
    DECLARE existe INT;
    SELECT COUNT(*) INTO existe
    FROM Cliente
    WHERE nro_documento = NEW.nro_documento;

    -- Si existe, lanzar un error y cancelar la inserción
    IF existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un cliente con ese número de documento (DNI).';
    END IF;
END //
DELIMITER ;

