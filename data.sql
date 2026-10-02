BEGIN;

INSERT INTO specialty (name) VALUES
    ('Терапия'),
    ('Кардиология'),
    ('Неврология');

INSERT INTO patient (medical_record_number, full_name, birth_date, phone) VALUES
    ('MR-0001', 'Анна Смирнова', DATE '1988-04-12', '+7-900-000-00-01'),
    ('MR-0002', 'Андрей Денисов', DATE '1975-11-03', '+7-900-000-00-02'),
    ('MR-0003', 'Иван Смартов', DATE '1994-07-21', NULL),
    ('MR-0004', 'Богдан Романов', DATE '2001-02-15', '+7-900-000-00-04'),
    ('MR-0005', 'Андрей Беляк', DATE '1982-09-09', '+7-900-000-00-05'),
    ('MR-0006', 'Саша Белый', DATE '1990-06-18', '+7-900-000-00-06'),
    ('MR-0007', 'Жанна Фёдорова', DATE '1985-12-02', '+7-900-000-00-07'),
    ('MR-0008', 'Артема Пятнинская', DATE '1979-03-26', NULL),
    ('MR-0009', 'Илья Романов', DATE '1998-08-14', '+7-900-000-00-09'),
    ('MR-0010', 'Александр Подгурский', DATE '2000-01-30', '+7-900-000-00-10'),
    ('MR-0011', 'Лев Лещенко', DATE '1968-10-05', '+7-900-000-00-11'),
    ('MR-0012', 'Марина Егорова', DATE '1992-05-23', '+7-900-000-00-12');

INSERT INTO doctor (specialty_id, license_number, full_name) VALUES
    ((SELECT specialty_id FROM specialty WHERE name = 'Терапия'),
     'LIC-1001', 'Григорий Хаус'),
    ((SELECT specialty_id FROM specialty WHERE name = 'Терапия'),
     'LIC-1002', 'Игорь Никитин'),
    ((SELECT specialty_id FROM specialty WHERE name = 'Кардиология'),
     'LIC-1003', 'Мария Белова'),
    ((SELECT specialty_id FROM specialty WHERE name = 'Неврология'),
     'LIC-1004', 'Павел Кузнецов'),
    ((SELECT specialty_id FROM specialty WHERE name = 'Терапия'),
     'LIC-1005', 'Ольга Сергеева'),
    ((SELECT specialty_id FROM specialty WHERE name = 'Кардиология'),
     'LIC-1006', 'Роман Виноградов'),
    ((SELECT specialty_id FROM specialty WHERE name = 'Неврология'),
     'LIC-1007', 'Светлана Лебедева'),
    ((SELECT specialty_id FROM specialty WHERE name = 'Терапия'),
     'LIC-1008', 'Алексей Попов');

INSERT INTO diagnosis (code, name) VALUES
    ('Z00.0', 'Недостаток сна'),
    ('I10', 'Эксестенциальный кризис'),
    ('G43.9', 'Мигрень неуточнённая'),
    ('J06.9', 'Острая кофейная недостаточность'),
    ('E11.9', 'Сахарный диабет 2 типа без осложнений');

INSERT INTO appointment
    (patient_id, doctor_id, scheduled_at, duration_minutes, status, complaint)
VALUES
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0001'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1001'),
     TIMESTAMPTZ '2026-09-10 09:00:00+03', 30, 'completed', 'Плановый осмотр'),
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0002'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1001'),
     TIMESTAMPTZ '2026-09-10 10:00:00+03', 30, 'completed', 'Повышенное давление'),
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0003'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1002'),
     TIMESTAMPTZ '2026-09-11 11:00:00+03', 30, 'completed', 'Повышенная температура'),
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0001'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1003'),
     TIMESTAMPTZ '2026-09-12 12:00:00+03', 45, 'completed', 'Контроль давления'),
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0004'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1001'),
     TIMESTAMPTZ '2026-10-06 09:00:00+03', 30, 'scheduled', 'Первичный приём'),
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0005'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1001'),
     TIMESTAMPTZ '2026-10-06 10:00:00+03', 30, 'scheduled', 'Консультация'),
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0002'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1004'),
     TIMESTAMPTZ '2026-10-07 14:00:00+03', 30, 'cancelled', 'Головная боль'),
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0003'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1002'),
     TIMESTAMPTZ '2026-10-08 15:00:00+03', 30, 'scheduled', 'Повторный приём'),
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0006'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1004'),
     TIMESTAMPTZ '2026-09-15 14:00:00+03', 30, 'completed', 'Головная боль'),
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0007'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1005'),
     TIMESTAMPTZ '2026-09-16 09:30:00+03', 30, 'completed', 'Кашель'),
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0008'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1006'),
     TIMESTAMPTZ '2026-10-09 11:00:00+03', 30, 'scheduled', 'Сердцебиение'),
    ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0009'),
     (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1008'),
     TIMESTAMPTZ '2026-10-10 13:30:00+03', 30, 'scheduled', 'Консультация');

-- Один приём может иметь несколько диагнозов, один диагноз встречается на разных приёмах
INSERT INTO appointment_diagnosis (appointment_id, diagnosis_id, is_primary, notes) VALUES
    ((SELECT appointment_id FROM appointment WHERE scheduled_at = TIMESTAMPTZ '2026-09-10 09:00:00+03'),
     (SELECT diagnosis_id FROM diagnosis WHERE code = 'Z00.0'), true, 'Плановый осмотр'),
    ((SELECT appointment_id FROM appointment WHERE scheduled_at = TIMESTAMPTZ '2026-09-10 10:00:00+03'),
     (SELECT diagnosis_id FROM diagnosis WHERE code = 'I10'), true, NULL),
    ((SELECT appointment_id FROM appointment WHERE scheduled_at = TIMESTAMPTZ '2026-09-11 11:00:00+03'),
     (SELECT diagnosis_id FROM diagnosis WHERE code = 'J06.9'), true, NULL),
    ((SELECT appointment_id FROM appointment WHERE scheduled_at = TIMESTAMPTZ '2026-09-12 12:00:00+03'),
     (SELECT diagnosis_id FROM diagnosis WHERE code = 'I10'), true, 'Контроль показателей'),
    ((SELECT appointment_id FROM appointment WHERE scheduled_at = TIMESTAMPTZ '2026-09-12 12:00:00+03'),
     (SELECT diagnosis_id FROM diagnosis WHERE code = 'Z00.0'), false, 'Сопутствующий осмотр'),
    ((SELECT appointment_id FROM appointment WHERE scheduled_at = TIMESTAMPTZ '2026-09-15 14:00:00+03'),
     (SELECT diagnosis_id FROM diagnosis WHERE code = 'G43.9'), true, NULL),
    ((SELECT appointment_id FROM appointment WHERE scheduled_at = TIMESTAMPTZ '2026-09-16 09:30:00+03'),
     (SELECT diagnosis_id FROM diagnosis WHERE code = 'J06.9'), true, NULL);

INSERT INTO prescription
    (appointment_id, medication_name, single_dose, dose_unit,
     times_per_day, duration_days, instructions)
VALUES
    ((SELECT appointment_id FROM appointment WHERE scheduled_at = TIMESTAMPTZ '2026-09-10 10:00:00+03'),
     'Учебный препарат А', 1.00, 'таблетка', 1, 30, 'Учебная запись'),
    ((SELECT appointment_id FROM appointment WHERE scheduled_at = TIMESTAMPTZ '2026-09-11 11:00:00+03'),
     'Учебный препарат Б', 5.00, 'мл', 2, 5, 'Учебная запись'),
    ((SELECT appointment_id FROM appointment WHERE scheduled_at = TIMESTAMPTZ '2026-09-12 12:00:00+03'),
     'Учебный препарат В', 1.00, 'таблетка', 2, 14, 'Учебная запись'),
    ((SELECT appointment_id FROM appointment WHERE scheduled_at = TIMESTAMPTZ '2026-09-15 14:00:00+03'),
     'Учебный препарат Г', 1.00, 'таблетка', 1, 7, 'Учебная запись');

COMMIT;

-- -- Контроль наполнения: 3 специальности, 12 пациентов, 8 врачей,
-- -- 5 диагнозов, 12 приёмов, 7 связей приём-диагноз, 4 назначения.
-- SELECT 'specialty' AS table_name, count(*) AS row_count FROM specialty
-- UNION ALL SELECT 'patient', count(*) FROM patient
-- UNION ALL SELECT 'doctor', count(*) FROM doctor
-- UNION ALL SELECT 'diagnosis', count(*) FROM diagnosis
-- UNION ALL SELECT 'appointment', count(*) FROM appointment
-- UNION ALL SELECT 'appointment_diagnosis', count(*) FROM appointment_diagnosis
-- UNION ALL SELECT 'prescription', count(*) FROM prescription;

-- -- Просмотр связанных данных: приём, пациент, врач, специальность и диагноз.
-- SELECT a.appointment_id, a.scheduled_at, p.full_name AS patient,
--        d.full_name AS doctor, s.name AS specialty,
--        a.status, dg.code AS diagnosis_code, dg.name AS diagnosis
-- FROM appointment AS a
-- JOIN patient AS p ON p.patient_id = a.patient_id
-- JOIN doctor AS d ON d.doctor_id = a.doctor_id
-- JOIN specialty AS s ON s.specialty_id = d.specialty_id
-- LEFT JOIN appointment_diagnosis AS ad ON ad.appointment_id = a.appointment_id
-- LEFT JOIN diagnosis AS dg ON dg.diagnosis_id = ad.diagnosis_id
-- ORDER BY a.scheduled_at, dg.code;

-- Девять некорректных операций INSERT/UPDATE. Каждая должна быть отклонена.
-- Проверки ограничений: выполняются после загрузки данных в этом же файле.
-- Вспомогательная функция перехватывает ожидаемую ошибку и выдаёт NOTICE PASS.
-- Если команда неожиданно выполнится или возникнет другая ошибка, тест остановится.
CREATE OR REPLACE FUNCTION pg_temp.expect_constraint_error(
    test_name text,
    command_sql text,
    expected_sqlstate text,
    expected_constraint text
) RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
    actual_sqlstate text;
    actual_constraint text;
BEGIN
    BEGIN
        EXECUTE command_sql;
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS
            actual_sqlstate = RETURNED_SQLSTATE,
            actual_constraint = CONSTRAINT_NAME;
        IF actual_sqlstate <> expected_sqlstate
           OR (expected_constraint IS NOT NULL
               AND actual_constraint IS DISTINCT FROM expected_constraint) THEN
            RAISE EXCEPTION 'FAIL %: получено SQLSTATE %, ограничение %; ожидалось %, %',
                test_name, actual_sqlstate, actual_constraint,
                expected_sqlstate, expected_constraint;
        END IF;
        RAISE NOTICE 'PASS %: SQLSTATE %, ограничение %',
            test_name, actual_sqlstate, actual_constraint;
        RETURN;
    END;
    RAISE EXCEPTION 'FAIL %: ошибочная операция неожиданно выполнилась', test_name;
END;
$function$;

-- 1. UNIQUE: номер карты пациента уже занят.
SELECT pg_temp.expect_constraint_error(
    'повтор номера карты',
    $sql$INSERT INTO patient (medical_record_number, full_name, birth_date)
         VALUES ('MR-0001', 'Тестовый пациент', DATE '1990-01-01')$sql$,
    '23505', 'patient_record_number_uk'
);

-- 2. NOT NULL: ФИО пациента обязательно.
SELECT pg_temp.expect_constraint_error(
    'отсутствует ФИО пациента',
    $sql$INSERT INTO patient (medical_record_number, full_name, birth_date)
         VALUES ('MR-9999', NULL, DATE '1990-01-01')$sql$,
    '23502', NULL
);

-- 3. FK: врача с doctor_id = -1 не существует.
SELECT pg_temp.expect_constraint_error(
    'ссылка на отсутствующего врача',
    $sql$INSERT INTO appointment
             (patient_id, doctor_id, scheduled_at, duration_minutes, status)
         VALUES ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0005'),
                 -1, TIMESTAMPTZ '2026-10-09 16:00:00+03', 30, 'scheduled')$sql$,
    '23503', 'appointment_doctor_fk'
);

-- 4. CHECK: длительность не может быть нулевой.
SELECT pg_temp.expect_constraint_error(
    'недопустимая длительность',
    $sql$INSERT INTO appointment
             (patient_id, doctor_id, scheduled_at, duration_minutes, status)
         VALUES ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0005'),
                 (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1004'),
                 TIMESTAMPTZ '2026-10-09 16:00:00+03', 0, 'scheduled')$sql$,
    '23514', 'appointment_duration_ck'
);

-- 5. CHECK: статус принимает только три перечисленных значения.
SELECT pg_temp.expect_constraint_error(
    'недопустимый статус',
    $sql$UPDATE appointment SET status = 'unknown'
         WHERE scheduled_at = TIMESTAMPTZ '2026-10-06 09:00:00+03'$sql$,
    '23514', 'appointment_status_ck'
);

-- 6. CHECK: доза должна быть положительной.
SELECT pg_temp.expect_constraint_error(
    'отрицательная доза',
    $sql$INSERT INTO prescription
             (appointment_id, medication_name, single_dose, dose_unit,
              times_per_day, duration_days)
         VALUES ((SELECT appointment_id FROM appointment
                  WHERE scheduled_at = TIMESTAMPTZ '2026-09-10 10:00:00+03'),
                 'Учебный препарат Г', -1.00, 'мл', 1, 5)$sql$,
    '23514', 'prescription_dose_positive_ck'
);

-- 7. Составной UNIQUE: у врача уже есть приём в это время.
SELECT pg_temp.expect_constraint_error(
    'двойная запись к врачу',
    $sql$INSERT INTO appointment
             (patient_id, doctor_id, scheduled_at, duration_minutes, status)
         VALUES ((SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0003'),
                 (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1001'),
                 TIMESTAMPTZ '2026-09-10 09:00:00+03', 30, 'scheduled')$sql$,
    '23505', 'appointment_doctor_time_uk'
);

-- 8. Составной PK: та же пара «приём — диагноз» уже существует.
SELECT pg_temp.expect_constraint_error(
    'повтор диагноза на приёме',
    $sql$INSERT INTO appointment_diagnosis
             (appointment_id, diagnosis_id, is_primary)
         VALUES ((SELECT appointment_id FROM appointment
                  WHERE scheduled_at = TIMESTAMPTZ '2026-09-10 09:00:00+03'),
                 (SELECT diagnosis_id FROM diagnosis WHERE code = 'Z00.0'),
                 false)$sql$,
    '23505', 'appointment_diagnosis_pk'
);

-- 9. Дополнительное правило: на одном приёме один основной диагноз.
SELECT pg_temp.expect_constraint_error(
    'второй основной диагноз',
    $sql$INSERT INTO appointment_diagnosis
             (appointment_id, diagnosis_id, is_primary)
         VALUES ((SELECT appointment_id FROM appointment
                  WHERE scheduled_at = TIMESTAMPTZ '2026-09-10 09:00:00+03'),
                 (SELECT diagnosis_id FROM diagnosis WHERE code = 'I10'),
                 true)$sql$,
    '23505', 'appointment_one_primary_diagnosis_uk'
);

-- После тестов число строк должно остаться прежним.
SELECT 'patient' AS table_name, count(*) AS row_count FROM patient
UNION ALL SELECT 'appointment', count(*) FROM appointment
UNION ALL SELECT 'appointment_diagnosis', count(*) FROM appointment_diagnosis
UNION ALL SELECT 'prescription', count(*) FROM prescription;
