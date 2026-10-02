-- ЛР №1, вариант 7: медицинская информационная система.
-- Выполнять в пустой базе данных PostgreSQL.
BEGIN;

CREATE TABLE specialty (
    specialty_id bigint GENERATED ALWAYS AS IDENTITY,
    name text NOT NULL,
    CONSTRAINT specialty_pk PRIMARY KEY (specialty_id),
    CONSTRAINT specialty_name_uk UNIQUE (name),
    CONSTRAINT specialty_name_not_blank CHECK (length(btrim(name)) > 0)
);

CREATE TABLE patient (
    patient_id bigint GENERATED ALWAYS AS IDENTITY,
    medical_record_number varchar(20) NOT NULL,
    full_name text NOT NULL,
    birth_date date NOT NULL,
    phone varchar(20),
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT patient_pk PRIMARY KEY (patient_id),
    CONSTRAINT patient_record_number_uk UNIQUE (medical_record_number),
    CONSTRAINT patient_name_not_blank CHECK (length(btrim(full_name)) > 0),
    CONSTRAINT patient_record_number_not_blank CHECK (length(btrim(medical_record_number)) > 0)
);

CREATE TABLE doctor (
    doctor_id bigint GENERATED ALWAYS AS IDENTITY,
    specialty_id bigint NOT NULL,
    license_number varchar(30) NOT NULL,
    full_name text NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    CONSTRAINT doctor_pk PRIMARY KEY (doctor_id),
    CONSTRAINT doctor_license_number_uk UNIQUE (license_number),
    CONSTRAINT doctor_name_not_blank CHECK (length(btrim(full_name)) > 0),
    CONSTRAINT doctor_specialty_fk FOREIGN KEY (specialty_id)
        REFERENCES specialty (specialty_id) ON DELETE RESTRICT
);

CREATE TABLE diagnosis (
    diagnosis_id bigint GENERATED ALWAYS AS IDENTITY,
    code varchar(12) NOT NULL,
    name text NOT NULL,
    CONSTRAINT diagnosis_pk PRIMARY KEY (diagnosis_id),
    CONSTRAINT diagnosis_code_uk UNIQUE (code),
    CONSTRAINT diagnosis_name_not_blank CHECK (length(btrim(name)) > 0)
);

CREATE TABLE appointment (
    appointment_id bigint GENERATED ALWAYS AS IDENTITY,
    patient_id bigint NOT NULL,
    doctor_id bigint NOT NULL,
    scheduled_at timestamptz NOT NULL,
    duration_minutes integer NOT NULL DEFAULT 30,
    status text NOT NULL DEFAULT 'scheduled',
    complaint text,
    CONSTRAINT appointment_pk PRIMARY KEY (appointment_id),
    CONSTRAINT appointment_doctor_time_uk UNIQUE (doctor_id, scheduled_at),
    CONSTRAINT appointment_patient_time_uk UNIQUE (patient_id, scheduled_at),
    CONSTRAINT appointment_duration_ck CHECK (duration_minutes BETWEEN 10 AND 240),
    CONSTRAINT appointment_status_ck CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    CONSTRAINT appointment_patient_fk FOREIGN KEY (patient_id)
        REFERENCES patient (patient_id) ON DELETE RESTRICT,
    CONSTRAINT appointment_doctor_fk FOREIGN KEY (doctor_id)
        REFERENCES doctor (doctor_id) ON DELETE RESTRICT
);

CREATE TABLE appointment_diagnosis (
    appointment_id bigint NOT NULL,
    diagnosis_id bigint NOT NULL,
    is_primary boolean NOT NULL DEFAULT false,
    notes text,
    CONSTRAINT appointment_diagnosis_pk PRIMARY KEY (appointment_id, diagnosis_id),
    CONSTRAINT appointment_diagnosis_appointment_fk FOREIGN KEY (appointment_id)
        REFERENCES appointment (appointment_id) ON DELETE RESTRICT,
    CONSTRAINT appointment_diagnosis_diagnosis_fk FOREIGN KEY (diagnosis_id)
        REFERENCES diagnosis (diagnosis_id) ON DELETE RESTRICT
);

-- Частичный уникальный индекс: не более одного основного диагноза на приём.
CREATE UNIQUE INDEX appointment_one_primary_diagnosis_uk
    ON appointment_diagnosis (appointment_id) WHERE is_primary;

CREATE TABLE prescription (
    prescription_id bigint GENERATED ALWAYS AS IDENTITY,
    appointment_id bigint NOT NULL,
    medication_name text NOT NULL,
    single_dose numeric(8, 2) NOT NULL,
    dose_unit text NOT NULL,
    times_per_day smallint NOT NULL,
    duration_days smallint NOT NULL,
    instructions text,
    CONSTRAINT prescription_pk PRIMARY KEY (prescription_id),
    CONSTRAINT prescription_medication_not_blank CHECK (length(btrim(medication_name)) > 0),
    CONSTRAINT prescription_dose_positive_ck CHECK (single_dose > 0),
    CONSTRAINT prescription_times_per_day_ck CHECK (times_per_day BETWEEN 1 AND 12),
    CONSTRAINT prescription_duration_days_ck CHECK (duration_days BETWEEN 1 AND 365),
    CONSTRAINT prescription_dose_unit_not_blank CHECK (length(btrim(dose_unit)) > 0),
    CONSTRAINT prescription_appointment_fk FOREIGN KEY (appointment_id)
        REFERENCES appointment (appointment_id) ON DELETE RESTRICT
);

CREATE INDEX appointment_patient_idx ON appointment (patient_id);
CREATE INDEX doctor_specialty_idx ON doctor (specialty_id);
CREATE INDEX appointment_diagnosis_diagnosis_idx ON appointment_diagnosis (diagnosis_id);
CREATE INDEX prescription_appointment_idx ON prescription (appointment_id);

COMMIT;
