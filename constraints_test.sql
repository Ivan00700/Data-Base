
-- Повтор номера карты — UNIQUE
INSERT INTO patient (medical_record_number, full_name, birth_date)
VALUES ('MR-0001', 'Тестовый пациент', DATE '1990-01-01');

-- Отсутствует обязательное ФИО — NOT NULL
INSERT INTO patient (medical_record_number, full_name, birth_date)
VALUES ('MR-9999', NULL, DATE '1990-01-01');

-- Несуществующий врач — FOREIGN KEY
INSERT INTO appointment
    (patient_id, doctor_id, scheduled_at, duration_minutes, status)
VALUES (
    (SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0005'),
    -1,
    TIMESTAMPTZ '2026-10-09 16:00:00+03',
    30,
    'scheduled'
);

-- Нулевая длительность приёма — CHECK
INSERT INTO appointment
    (patient_id, doctor_id, scheduled_at, duration_minutes, status)
VALUES (
    (SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0005'),
    (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1004'),
    TIMESTAMPTZ '2026-10-09 16:00:00+03',
    0,
    'scheduled'
);

-- Недопустимый статус — CHECK
UPDATE appointment
SET status = 'unknown'
WHERE scheduled_at = TIMESTAMPTZ '2026-10-06 09:00:00+03';

-- Отрицательная доза — CHECK
INSERT INTO prescription
    (appointment_id, medication_name, single_dose, dose_unit,
     times_per_day, duration_days)
VALUES (
    (SELECT appointment_id FROM appointment
     WHERE scheduled_at = TIMESTAMPTZ '2026-09-10 10:00:00+03'),
    'Тестовый препарат',
    -1.00,
    'мл',
    1,
    5
);

-- Два приёма у одного врача в одно время — составной UNIQUE
INSERT INTO appointment
    (patient_id, doctor_id, scheduled_at, duration_minutes, status)
VALUES (
    (SELECT patient_id FROM patient WHERE medical_record_number = 'MR-0003'),
    (SELECT doctor_id FROM doctor WHERE license_number = 'LIC-1001'),
    TIMESTAMPTZ '2026-09-10 09:00:00+03',
    30,
    'scheduled'
);

-- Повтор пары «приём — диагноз» — составной PK
INSERT INTO appointment_diagnosis
    (appointment_id, diagnosis_id, is_primary)
VALUES (
    (SELECT appointment_id FROM appointment
     WHERE scheduled_at = TIMESTAMPTZ '2026-09-10 09:00:00+03'),
    (SELECT diagnosis_id FROM diagnosis WHERE code = 'Z00.0'),
    false
);

-- Второй основной диагноз на одном приёме — уникальный индекс
INSERT INTO appointment_diagnosis
    (appointment_id, diagnosis_id, is_primary)
VALUES (
    (SELECT appointment_id FROM appointment
     WHERE scheduled_at = TIMESTAMPTZ '2026-09-10 09:00:00+03'),
    (SELECT diagnosis_id FROM diagnosis WHERE code = 'I10'),
    true
);