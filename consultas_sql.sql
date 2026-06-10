-- =================================================================
-- Franklin David Barahona López
-- PRÁCTICA: Base de Datos de Alojamientos Turísticos
-- =================================================================

-- =================================================================
-- 01. INSERT - Insertar un nuevo propietario
-- =================================================================
-- Descripción: Agregar un nuevo propietario a la tabla owners
-- Nota: El owner_id es autoincremental, no es necesario especificarlo

INSERT INTO owners (
    first_name, 
    last_name, 
    company_name, 
    email, 
    phone, 
    tax_id, 
    address_line1, 
    address_line2, 
    city, 
    state, 
    country, 
    postal_code
) VALUES (
    'Zoila Quijada',
    'Alegre',
    'Quijada Propiedades de R.L.',
    'zoila.quijada@gmail.com',
    '+503 1234 5678',
    'ES-12345678',
    'Calle La Amargura',
    'Sexta Avenida Norte, Casa 33',
    'San Salador Este',
    'San Martín',
    'El Salador',
    '2026'
);


-- Interpretación semántica
-- Seleccionar todos los campos de la tabla "owners". El nuevo registro 
-- está al final, en mi caso a la altura del índice 23.
SELECT * FROM owners;


-- =================================================================
-- 02. INSERT - Crear un alojamiento vinculado a un propietario
-- =================================================================
-- Descripción: Insertar un nuevo alojamiento asociado al propietario creado
-- Nota: Primero obtener el owner_id del propietario insertado (23)
-- SELECT * FROM owners;

INSERT INTO accommodations (
    owner_id,
    accommodation_type_id,
    location_id,
    name,
    description,
    max_guests,
    bedroom_count,
    bathroom_count,
    base_price_per_night,
    currency_code,
    check_in_time,
    check_out_time,
    is_active
) VALUES (
    23,  -- es (23)
    3,   -- Apartment (verificado con: SELECT * FROM accommodation_types)
    1,   -- location_id existente
    'Apartamento Premium Centro',
    'Lujoso apartamento en el centro de San Salador',
    6,
    3,
    2,
    250.00,
    'USD',
    '15:00:00',
    '11:00:00',
    TRUE
);

-- Interpretación semántica: Selecciona todas las columnas 
-- de la tabla accommodations, ordena los resultados por 
-- accommodation_id de mayor a menor, y devuelve solo el 
-- primero de esa lista

SELECT * FROM accommodations ORDER BY accommodation_id DESC LIMIT 1;


-- =================================================================
-- 03. INSERT - Registrar un nuevo huésped y una reserva
-- =================================================================
-- Descripción: Insertar un huésped y luego una reserva asociada

-- Paso 1: Insertar nuevo huésped
INSERT INTO guests (
    first_name,
    last_name,
    email,
    phone,
    date_of_birth,
    nationality,
    passport_number,
    emergency_contact_name,
    emergency_contact_phone
) VALUES (
    'Armando',
    'Casas',
    'armando.casas@gmail.com',
    '+503 2222 3333',
    '15-08-1985',
    'Salvadoreño',
    'p123456',
    'Aitor Tilla',
    '+503 7111 2222'
);

-- Paso 2: Insertar nueva reserva (guest_id = 101, accommodation_id = 21)
-- en mi prueba.
INSERT INTO bookings (
    guest_id,
    accommodation_id,
    room_id,
    booking_status_id,
    check_in_date,
    check_out_date,
    adult_count,
    child_count,
    subtotal_amount,
    tax_amount,
    discount_amount,
    total_amount,
    special_requests,
    booking_reference
) VALUES (
    101,  -- guest_id del nuevo huésped
    21,   -- accommodation_id del nuevo alojamiento
    NULL, -- sin habitación específica
    1,    -- Pending
    '15-07-2026',
    '22-07-2026',
    2,
    0,
    1750.00,  -- 7 noches * 250
    210.00,   -- 12% impuesto
    0.00,
    1960.00,
    'Me gustaría una habitación con vistas',
    'A-Primer_cliente'
);

-- Interpretación semántica: Seleccionar todos los campos de la tabla "guest"
-- y ordenar los datos encontrados según el índice "guest_id" de mayor a menor
-- mostrando un solo resultado (el mayor o más reciente). 
SELECT * FROM guests ORDER BY guest_id DESC LIMIT 1;

-- Interpretación semántica
-- Seleccionar todos los campos de la tabla "booking" y los registros encontrados
-- ordenarlos según el índice "booking_id" de mayor a menor. Mostrar solo el último
-- resultado (El más reciente).
SELECT * FROM bookings ORDER BY booking_id DESC LIMIT 1;


-- =================================================================
-- 04. INSERT - Registrar un pago para una reserva
-- =================================================================
-- Descripción: Insertar un pago asociado a la reserva creada

INSERT INTO payments (
    booking_id,
    payment_date,
    amount,
    payment_method,
    payment_status,
    transaction_reference,
    notes
) VALUES (
    101,  -- booking_id de la nueva reserva
    CURRENT_TIMESTAMP,
    1960.00,
    'Efectivo',
    'Completed',
    'PAGO-' || MD5(RANDOM()::TEXT), -- Aquí me ayudé con IA.
    'Pago en efectivo, billetes bien sudados.'
);

-- Interpretación semántica
-- Seleccionar todos los campos de la tabla "payments" y ordenar los
-- registros encontrados de mayor a menor. Mostrar el último resultado.
SELECT * FROM payments ORDER BY payment_id DESC LIMIT 1;


-- =================================================================
-- 05. SELECT - Alojamientos activos
-- =================================================================
-- Descripción: Listar todos los alojamientos que están activos

SELECT 
    accommodation_id,
    name,
    base_price_per_night,
    currency_code,
    max_guests,
    bedroom_count,
    bathroom_count,
    is_active
FROM accommodations
WHERE is_active = TRUE
ORDER BY name;


-- =================================================================
-- 06. SELECT - Huéspedes filtrados por nacionalidad
-- =================================================================
-- Descripción: Listar huéspedes de una nacionalidad específica

SELECT 
    guest_id,
    first_name,
    last_name,
    email,
    phone,
    nationality,
    date_of_birth
FROM guests
WHERE nationality = 'Salvadoreño'
ORDER BY last_name, first_name;

-- Solo debe aparecer un Salvadoreño.

-- =================================================================
-- 07. SELECT - Reservas dentro de un rango de fechas (BETWEEN)
-- =================================================================
-- Descripción: Reservas que se realizaron entre dos fechas

SELECT 
    booking_id,
    booking_reference,
    guest_id,
    check_in_date,
    check_out_date,
    total_amount,
    booking_status_id
FROM bookings
WHERE booked_at >= '2027-01-01' AND booked_at < '2028-01-01'
ORDER BY booked_at DESC;

-- booked_at es TIMESTAMP, esto significa que no guarda solo la 
-- fecha, sino la fecha + hora exacta en que se hizo la reserva.
-- De esta manera el rango es: desde el primer instante del 1 
-- de enero hasta justo antes del 1 de enero del año siguiente.

-- En este caso no nos muestra reservas para el año 2027.


-- =================================================================
-- 08. UPDATE - Actualizar precio base de un alojamiento
-- =================================================================
-- Descripción: Aumentar el precio de un alojamiento específico

-- Verificamos el precio del apartamento antes de actualizar ($250)
SELECT name, base_price_per_night, updated_at 
FROM accommodations 
WHERE name = 'Apartamento Premium Centro';

-- Actualizamos al 20%, es decir, multiplicamos por 1.2 el precio original.
UPDATE accommodations
SET base_price_per_night = base_price_per_night * 1.20,  -- Aumento del 20%
    updated_at = CURRENT_TIMESTAMP
WHERE name = 'Apartamento Premium Centro'
  AND is_active = TRUE;

-- Verificar actualización. El nuevo precio es $300
SELECT name, base_price_per_night, updated_at 
FROM accommodations 
WHERE name = 'Apartamento Premium Centro';


-- =================================================================
-- 09. UPDATE - Actualizar estado de una reserva (SIN alias)
-- =================================================================

-- PASO 1: Ver estado actual
SELECT 
    bookings.booking_id,
    bookings.booking_reference,
    booking_statuses.status_name AS estado_actual,
    bookings.booking_status_id
FROM bookings
JOIN booking_statuses ON bookings.booking_status_id = booking_statuses.booking_status_id
WHERE bookings.booking_reference = 'BK-NVQHW06X';

-- PASO 2: Actualizar el estado a "Confirmed"
UPDATE bookings
SET booking_status_id = 2,
    updated_at = CURRENT_TIMESTAMP
WHERE booking_reference = 'BK-NVQHW06X';

-- PASO 3: Verificar la actualización
SELECT 
    bookings.booking_reference,
    booking_statuses.status_name AS estado_nuevo,
    bookings.updated_at
FROM bookings
JOIN booking_statuses ON bookings.booking_status_id = booking_statuses.booking_status_id
WHERE bookings.booking_reference = 'BK-NVQHW06X';


-- =================================================================
-- 10. DELETE - Eliminar una reseña específica
-- =================================================================
-- Descripción: Eliminar una reseña por su ID (con precaución)

-- Primero verificar qué reseña existe en mi reserva recién creada.
SELECT review_text AS reseña_completa
FROM reviews 
WHERE booking_id = (SELECT booking_id FROM bookings WHERE booking_reference = 'BK-NVQHW06X');
-- Veo que mi reserva recien hecha tiene reseña "Mano también trata mucho".

-- Eliminar una reseña específica
DELETE FROM reviews 
WHERE booking_id = (SELECT booking_id FROM bookings WHERE booking_reference = 'BK-NVQHW06X');

-- Verificar eliminación. En review_text nada aparece ya.
SELECT * FROM reviews 
WHERE booking_id = (SELECT booking_id FROM bookings WHERE booking_reference = 'BK-NVQHW06X');



-- =================================================================
-- 11. JOIN - Reservas con información del huésped (INNER JOIN)
-- =================================================================
-- Descripción: Mostrar reservas junto con los datos del huésped

SELECT 
    bookings.booking_id,
    bookings.booking_reference,
    guests.first_name || ' ' || guests.last_name AS guest_name,
    guests.email,
    bookings.check_in_date,
    bookings.check_out_date,
    bookings.total_nights,
    bookings.total_amount,
    booking_statuses.status_name
FROM bookings
INNER JOIN guests ON bookings.guest_id = guests.guest_id
INNER JOIN booking_statuses ON bookings.booking_status_id = booking_statuses.booking_status_id
ORDER BY bookings.check_in_date DESC
LIMIT 20;


-- =================================================================
-- 12. JOIN - Información completa del alojamiento (JOIN múltiple)
-- =================================================================
-- Descripción: Mostrar alojamiento con tipo, ubicación y propietario

SELECT 
    accommodations.accommodation_id,
    accommodations.name AS accommodation_name,
    accommodation_types.type_name AS accommodation_type,
    locations.city,
    locations.country,
    locations.address_line1,
    owners.first_name || ' ' || owners.last_name AS owner_name,
    owners.email AS owner_email,
    accommodations.base_price_per_night,
    accommodations.currency_code,
    accommodations.max_guests,
    accommodations.is_active
FROM accommodations
INNER JOIN accommodation_types ON accommodations.accommodation_type_id = accommodation_types.accommodation_type_id
INNER JOIN locations ON accommodations.location_id = locations.location_id
INNER JOIN owners ON accommodations.owner_id = owners.owner_id
ORDER BY accommodations.base_price_per_night DESC
LIMIT 20;


-- =================================================================
-- 13. JOIN - Pagos con información de reservas (JOIN combinado)
-- =================================================================
-- Descripción: Mostrar pagos junto con datos de la reserva y huésped

SELECT 
    payments.payment_id,
    payments.amount,
    payments.payment_method,
    payments.payment_status,
    payments.payment_date,
    bookings.booking_reference,
    guests.first_name || ' ' || guests.last_name AS guest_name,
    bookings.total_amount AS booking_total,
    accommodations.name AS accommodation_name
FROM payments
INNER JOIN bookings ON payments.booking_id = bookings.booking_id
INNER JOIN guests ON bookings.guest_id = guests.guest_id
INNER JOIN accommodations ON bookings.accommodation_id = accommodations.accommodation_id
WHERE payments.payment_status = 'Completed'
ORDER BY payments.payment_date DESC
LIMIT 20;


-- =================================================================
-- 14. LEFT JOIN - Alojamientos sin reseñas (incluye nulls)
-- =================================================================
-- Descripción: Listar alojamientos que no tienen reseñas

SELECT 
    accommodations.accommodation_id,
    accommodations.name AS accommodation_name,
    accommodations.base_price_per_night,
    COUNT(reviews.review_id) AS review_count
FROM accommodations
LEFT JOIN reviews ON accommodations.accommodation_id = reviews.accommodation_id
GROUP BY accommodations.accommodation_id, accommodations.name, accommodations.base_price_per_night
HAVING COUNT(reviews.review_id) = 0
ORDER BY accommodations.name;


-- =================================================================
-- 15. LEFT JOIN - Alojamientos sin reservas (filtrar null)
-- =================================================================
-- Descripción: Listar alojamientos que nunca han tenido reservas

SELECT 
    accommodations.accommodation_id,
    accommodations.name AS accommodation_name,
    accommodations.base_price_per_night,
    accommodations.is_active,
    COUNT(bookings.booking_id) AS total_bookings
FROM accommodations
LEFT JOIN bookings ON accommodations.accommodation_id = bookings.accommodation_id
GROUP BY accommodations.accommodation_id, accommodations.name, accommodations.base_price_per_night, accommodations.is_active
HAVING COUNT(bookings.booking_id) = 0
ORDER BY accommodations.name;


-- =================================================================
-- 16. AGG - Total de ingresos por pagos completados
-- =================================================================
-- Descripción: Calcular el total de ingresos de pagos completados

SELECT 
    SUM(amount) AS total_income,
    COUNT(*) AS total_payments,
    ROUND(AVG(amount), 2) AS average_payment,
    MIN(amount) AS min_payment,
    MAX(amount) AS max_payment
FROM payments
WHERE payment_status = 'Completed';

-- AGG es un grupo de "funciones" que realizan cálculos matemáticos
-- sobre un conjunto de filas y devuelven una cantidad única.
-- En este caso se trata de la función "SUM()"


-- =================================================================
-- 17. AGG - Promedio de rating por alojamiento
-- =================================================================
-- Descripción: Calcular el rating promedio de cada alojamiento

SELECT 
    accommodations.accommodation_id,
    accommodations.name AS accommodation_name,
    COUNT(reviews.review_id) AS total_reviews,
    -- -----------------------------------------------------------------
    ROUND(AVG(reviews.rating), 2) AS average_rating,-- <-- Aquí el promedio
    -- -----------------------------------------------------------------
    MIN(reviews.rating) AS min_rating,
    MAX(reviews.rating) AS max_rating
FROM accommodations
INNER JOIN reviews ON accommodations.accommodation_id = reviews.accommodation_id
GROUP BY accommodations.accommodation_id, accommodations.name
ORDER BY average_rating DESC;

-- ¿Qué debemos entender de "Promedio de rating"?
-- Es el promedio de la calificación que los huéspedes han dado a cada uno 
-- de los alojamientos. Se suman el total de calificaciones y se divide entre
-- el total de alojamientos calificados.


-- =================================================================
-- 18. AGG - Top alojamientos con más reservas (COUNT + LIMIT)
-- =================================================================
-- Descripción: Listar los 5 alojamientos con mayor número de reservas

SELECT 
    accommodations.accommodation_id,
    accommodations.name AS accommodation_name,
    COUNT(bookings.booking_id) AS total_bookings,
    SUM(bookings.total_amount) AS total_revenue,
    ROUND(AVG(bookings.total_amount), 2) AS avg_booking_value
FROM accommodations
INNER JOIN bookings ON accommodations.accommodation_id = bookings.accommodation_id
GROUP BY accommodations.accommodation_id, accommodations.name
ORDER BY total_bookings DESC
LIMIT 5;


-- =================================================================
-- 19. HAVING - Huéspedes con más de 3 reservas (GROUP BY + HAVING)
-- =================================================================
-- Descripción: Mostrar huéspedes que han realizado más de 3 reservas

SELECT 
    guests.guest_id,
    guests.first_name || ' ' || guests.last_name AS guest_name,
    guests.email,
    guests.nationality,
    COUNT(bookings.booking_id) AS total_bookings,
    SUM(bookings.total_amount) AS total_spent,
    ROUND(AVG(bookings.total_amount), 2) AS avg_booking
FROM guests
INNER JOIN bookings ON guests.guest_id = bookings.guest_id
GROUP BY guests.guest_id, guests.first_name, guests.last_name, guests.email, guests.nationality
HAVING COUNT(bookings.booking_id) > 3
ORDER BY total_bookings DESC;


-- =================================================================
-- 20. Subconsulta - Alojamiento más caro (Subquery)
-- =================================================================
-- Descripción: Encontrar el alojamiento con el precio más alto

SELECT 
    accommodations.accommodation_id,
    accommodations.name,
    accommodations.base_price_per_night,
    accommodations.currency_code,
    accommodation_types.type_name,
    accommodations.max_guests
FROM accommodations
JOIN accommodation_types ON accommodations.accommodation_type_id = accommodation_types.accommodation_type_id
WHERE accommodations.base_price_per_night = (
    SELECT MAX(base_price_per_night)
    FROM accommodations
    WHERE is_active = TRUE
);



