# 🏨 SQL Exercises: Accommodations Tourism Database

Este repositorio contiene 20 ejercicios SQL guiados + consultas adicionales, diseñados para practicar desde `INSERT` básico hasta subconsultas y funciones de agregación (`AGG`).  
Todos los ejercicios están adaptados a **San Salvador, El Salvador**, con **nombres curiosos**, **direcciones reales** y **precios en USD**.

La base de datos original es `accommodations_tourism` (PostgreSQL 14+).

---

## 📚 Tabla de Contenidos

1. [Requisitos previos](#requisitos-previos)
2. [Estructura de la base de datos](#estructura-de-la-base-de-datos)
3. [Ejercicios](#ejercicios)
   - [01. INSERT - Propietario](#01-insert---propietario)
   - [02. INSERT - Alojamiento](#02-insert---alojamiento)
   - [03. INSERT - Huésped + Reserva](#03-insert---huésped--reserva)
   - [04. INSERT - Pago](#04-insert---pago)
   - [05. SELECT - Alojamientos activos](#05-select---alojamientos-activos)
   - [06. SELECT - Huéspedes por nacionalidad](#06-select---huéspedes-por-nacionalidad)
   - [07. SELECT - Reservas en rango de fechas](#07-select---reservas-en-rango-de-fechas)
   - [08. UPDATE - Aumentar precio de alojamiento](#08-update---aumentar-precio-de-alojamiento)
   - [09. UPDATE - Cambiar estado de reserva](#09-update---cambiar-estado-de-reserva)
   - [10. DELETE - Eliminar reseña](#10-delete---eliminar-reseña)
   - [11. JOIN - Reservas + Huésped](#11-join---reservas--huésped)
   - [12. JOIN - Alojamiento completo (tipo, ubicación, dueño)](#12-join---alojamiento-completo)
   - [13. JOIN - Pagos + Reservas + Huésped + Alojamiento](#13-join---pagos--reservas--huésped--alojamiento)
   - [14. LEFT JOIN - Alojamientos sin reseñas](#14-left-join---alojamientos-sin-reseñas)
   - [15. LEFT JOIN - Alojamientos sin reservas](#15-left-join---alojamientos-sin-reservas)
   - [16. AGG - Totales de pagos completados](#16-agg---totales-de-pagos-completados)
   - [17. AGG - Rating promedio por alojamiento](#17-agg---rating-promedio-por-alojamiento)
   - [18. AGG - Top 5 alojamientos con más reservas](#18-agg---top-5-alojamientos-con-más-reservas)
   - [19. HAVING - Huéspedes con más de 3 reservas](#19-having---huéspedes-con-más-de-3-reservas)
   - [20. Subconsulta - Alojamiento más caro](#20-subconsulta---alojamiento-más-caro)
4. [Verificación de datos insertados](#verificación-de-datos-insertados)
5. [Ejecución del script](#ejecución-del-script)

---

## Requisitos previos

- **PostgreSQL** 14 o superior.
- Base de datos `accommodations_tourism` creada y restaurada (incluye tablas: `owners`, `accommodations`, `guests`, `bookings`, `payments`, `reviews`, `locations`, `accommodation_types`, `booking_statuses`, etc.).
- Conexión configurada (usuario, contraseña, puerto).

> **Nota:** Todos los ejercicios están escritos **sin alias** (usando el nombre completo de las tablas) para mayor claridad didáctica.

---

## Estructura de la base de datos

Las tablas principales que utilizarás son:

| Tabla | Descripción |
|-------|-------------|
| `owners` | Propietarios de los alojamientos |
| `accommodations` | Alojamientos (apartamentos, hoteles, etc.) |
| `accommodation_types` | Tipos: Hotel, Apartment, Villa, etc. |
| `locations` | Direcciones reales (San Salvador, Escalón, etc.) |
| `guests` | Huéspedes |
| `bookings` | Reservas |
| `booking_statuses` | Estados: Pending, Confirmed, Cancelled, etc. |
| `payments` | Pagos asociados a reservas |
| `reviews` | Reseñas y calificaciones |

---

## Ejercicios

### 01. INSERT - Propietario

```sql
INSERT INTO owners (first_name, last_name, company_name, email, phone, tax_id, address_line1, address_line2, city, state, country, postal_code) 
VALUES ('Cipriano', 'Chupacables', 'Chupacables Propiedades S.A. de C.V.', 'cipriano.chupacables@hotmail.com', '+503 7012 3456', '0614-210598-101-1', 'Paseo General Escalón', 'Edificio La Rotonda, Local 2B', 'San Salvador', 'San Salvador', 'El Salvador', '1101');
```


### 02. INSERT - Alojamiento
```
INSERT INTO accommodations (owner_id, accommodation_type_id, location_id, name, description, max_guests, bedroom_count, bathroom_count, base_price_per_night, currency_code, check_in_time, check_out_time, is_active) 
VALUES (23, 3, 1, 'El Chilito en la Mitad del Mundo', 'Apartamento bien chivo en pleno Paseo General Escalón. Piscina, parqueo y vigilancia 24/7. Cerca de La Pampa y el Multiplaza.', 6, 3, 2, 95.00, 'USD', '14:00:00', '12:00:00', TRUE);
```

### 03. INSERT - Huésped + Reserva
```
INSERT INTO guests (first_name, last_name, email, phone, date_of_birth, nationality, passport_number, emergency_contact_name, emergency_contact_phone) 
VALUES ('María', 'De los Tacos', 'maria.delostacos@gmail.com', '+503 7654 3210', '1988-03-25', 'Salvadoreña', 'P123456', 'Pancracio De los Tacos', '+503 7111 2222');

INSERT INTO bookings (guest_id, accommodation_id, booking_status_id, check_in_date, check_out_date, adult_count, child_count, subtotal_amount, tax_amount, total_amount, booking_reference, booked_at) 
VALUES (101, 21, 1, '2026-07-15', '2026-07-22', 4, 2, 665.00, 79.80, 744.80, 'BK-PUPUSA2026', CURRENT_TIMESTAMP);
```

### 04. INSERT - Pago
```
INSERT INTO payments (booking_id, payment_date, amount, payment_method, payment_status, transaction_reference, notes) 
VALUES (101, CURRENT_TIMESTAMP, 744.80, 'Efectivo', 'Completed', 'PAGO-' || MD5(RANDOM()::TEXT), 'Pago en efectivo, billetes bien sudados.');
```

### 05. SELECT - Alojamientos activos
```
SELECT accommodation_id, name, base_price_per_night, currency_code, max_guests, bedroom_count, bathroom_count, is_active
FROM accommodations
WHERE is_active = TRUE
ORDER BY name;
```

### 06. SELECT - Huéspedes por nacionalidad
```
SELECT guest_id, first_name, last_name, email, phone, nationality, date_of_birth
FROM guests
WHERE nationality = 'Salvadoreña'
ORDER BY last_name, first_name;
```

### 07. SELECT - Reservas en rango de fechas (2027)
```
SELECT booking_id, booking_reference, guest_id, check_in_date, check_out_date, total_amount, booking_status_id
FROM bookings
WHERE booked_at >= '2027-01-01' AND booked_at < '2028-01-01'
ORDER BY booked_at DESC;
```

### 08. UPDATE - Aumentar precio de alojamiento (20%)
```
UPDATE accommodations
SET base_price_per_night = base_price_per_night * 1.20, updated_at = CURRENT_TIMESTAMP
WHERE name = 'El Chilito en la Mitad del Mundo' AND is_active = TRUE;
```


### 09. UPDATE - Cambiar estado de reserva a "Confirmed"
```
UPDATE bookings
SET booking_status_id = 2, updated_at = CURRENT_TIMESTAMP
WHERE booking_reference = 'BK-NVQHW06X';
```

### 10. DELETE - Eliminar reseña (ejemplo con review_id = 60)
```
DELETE FROM reviews
WHERE review_id = 60;
```

### 11. JOIN - Reservas + Huésped
```
SELECT bookings.booking_id, bookings.booking_reference, guests.first_name || ' ' || guests.last_name AS guest_name, guests.email, bookings.check_in_date, bookings.check_out_date, bookings.total_nights, bookings.total_amount, booking_statuses.status_name
FROM bookings
INNER JOIN guests ON bookings.guest_id = guests.guest_id
INNER JOIN booking_statuses ON bookings.booking_status_id = booking_statuses.booking_status_id
ORDER BY bookings.check_in_date DESC
LIMIT 20;
```

### 12. JOIN - Alojamiento completo (tipo, ubicación, dueño)
```
SELECT accommodations.accommodation_id, accommodations.name AS accommodation_name, accommodation_types.type_name AS accommodation_type, locations.city, locations.country, locations.address_line1, owners.first_name || ' ' || owners.last_name AS owner_name, owners.email AS owner_email, accommodations.base_price_per_night, accommodations.currency_code, accommodations.max_guests, accommodations.is_active
FROM accommodations
INNER JOIN accommodation_types ON accommodations.accommodation_type_id = accommodation_types.accommodation_type_id
INNER JOIN locations ON accommodations.location_id = locations.location_id
INNER JOIN owners ON accommodations.owner_id = owners.owner_id
ORDER BY accommodations.base_price_per_night DESC
LIMIT 20;
```


### 13. JOIN - Pagos + Reservas + Huésped + Alojamiento
```
SELECT payments.payment_id, payments.amount, payments.payment_method, payments.payment_status, payments.payment_date, bookings.booking_reference, guests.first_name || ' ' || guests.last_name AS guest_name, bookings.total_amount AS booking_total, accommodations.name AS accommodation_name
FROM payments
INNER JOIN bookings ON payments.booking_id = bookings.booking_id
INNER JOIN guests ON bookings.guest_id = guests.guest_id
INNER JOIN accommodations ON bookings.accommodation_id = accommodations.accommodation_id
WHERE payments.payment_status = 'Completed'
ORDER BY payments.payment_date DESC
LIMIT 20;
```


### 14. LEFT JOIN - Alojamientos sin reseñas
```
SELECT accommodations.accommodation_id, accommodations.name AS accommodation_name, accommodations.base_price_per_night, COUNT(reviews.review_id) AS review_count
FROM accommodations
LEFT JOIN reviews ON accommodations.accommodation_id = reviews.accommodation_id
GROUP BY accommodations.accommodation_id, accommodations.name, accommodations.base_price_per_night
HAVING COUNT(reviews.review_id) = 0
ORDER BY accommodations.name;
```


### 15. LEFT JOIN - Alojamientos sin reservas
```
SELECT accommodations.accommodation_id, accommodations.name AS accommodation_name, accommodations.base_price_per_night, accommodations.is_active, COUNT(bookings.booking_id) AS total_bookings
FROM accommodations
LEFT JOIN bookings ON accommodations.accommodation_id = bookings.accommodation_id
GROUP BY accommodations.accommodation_id, accommodations.name, accommodations.base_price_per_night, accommodations.is_active
HAVING COUNT(bookings.booking_id) = 0
ORDER BY accommodations.name;
```


### 16. AGG - Totales de pagos completados
```
SELECT SUM(amount) AS total_income, COUNT(*) AS total_payments, ROUND(AVG(amount), 2) AS average_payment, MIN(amount) AS min_payment, MAX(amount) AS max_payment
FROM payments
WHERE payment_status = 'Completed';
```


### 17. AGG - Rating promedio por alojamiento
```
SELECT accommodations.accommodation_id, accommodations.name AS accommodation_name, COUNT(reviews.review_id) AS total_reviews, ROUND(AVG(reviews.rating), 2) AS average_rating, MIN(reviews.rating) AS min_rating, MAX(reviews.rating) AS max_rating
FROM accommodations
INNER JOIN reviews ON accommodations.accommodation_id = reviews.accommodation_id
GROUP BY accommodations.accommodation_id, accommodations.name
ORDER BY average_rating DESC;
```


### 18. AGG - Top 5 alojamientos con más reservas
```
SELECT accommodations.accommodation_id, accommodations.name AS accommodation_name, COUNT(bookings.booking_id) AS total_bookings, SUM(bookings.total_amount) AS total_revenue, ROUND(AVG(bookings.total_amount), 2) AS avg_booking_value
FROM accommodations
INNER JOIN bookings ON accommodations.accommodation_id = bookings.accommodation_id
GROUP BY accommodations.accommodation_id, accommodations.name
ORDER BY total_bookings DESC
LIMIT 5;
```


### 19. HAVING - Huéspedes con más de 3 reservas
```
SELECT guests.guest_id, guests.first_name || ' ' || guests.last_name AS guest_name, guests.email, guests.nationality, COUNT(bookings.booking_id) AS total_bookings, SUM(bookings.total_amount) AS total_spent, ROUND(AVG(bookings.total_amount), 2) AS avg_booking
FROM guests
INNER JOIN bookings ON guests.guest_id = bookings.guest_id
GROUP BY guests.guest_id, guests.first_name, guests.last_name, guests.email, guests.nationality
HAVING COUNT(bookings.booking_id) > 3
ORDER BY total_bookings DESC;
```


### 20. Subconsulta - Alojamiento más caro
```
SELECT accommodations.accommodation_id, accommodations.name, accommodations.base_price_per_night, accommodations.currency_code, accommodation_types.type_name, accommodations.max_guests
FROM accommodations
JOIN accommodation_types ON accommodations.accommodation_type_id = accommodation_types.accommodation_type_id
WHERE accommodations.base_price_per_night = (SELECT MAX(base_price_per_night) FROM accommodations WHERE is_active = TRUE);
```


## ¡Feliz SQL! 🇸🇻🐘

