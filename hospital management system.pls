-- Step 1: Create tables to store data for patients, appointments, and medical staff
-- ===============================================================================

-- Table for storing patient details
CREATE TABLE patients (
    patient_id NUMBER PRIMARY KEY,        -- Unique identifier for each patient
    first_name VARCHAR2(50),              -- Patient's first name
    last_name VARCHAR2(50),               -- Patient's last name
    date_of_birth DATE,                   -- Patient's date of birth
    gender CHAR(1),                       -- Patient's gender (M/F)
    contact_info VARCHAR2(100)           -- Patient's contact details
);

-- Table for storing appointment details
CREATE TABLE appointments (
    appointment_id NUMBER PRIMARY KEY,    -- Unique identifier for each appointment
    patient_id NUMBER REFERENCES patients(patient_id), -- Foreign key referencing the patient
    appointment_date DATE,                -- Date of the appointment
    doctor_name VARCHAR2(50),             -- Name of the assigned doctor
    reason VARCHAR2(200)                  -- Reason for the appointment
);

-- Table for storing medical history
CREATE TABLE medical_history (
    history_id NUMBER PRIMARY KEY,        -- Unique identifier for each medical record
    patient_id NUMBER REFERENCES patients(patient_id), -- Foreign key referencing the patient
    diagnosis VARCHAR2(200),              -- Medical diagnosis
    treatment VARCHAR2(200),              -- Treatment prescribed
    notes VARCHAR2(500),                  -- Additional notes
    recorded_date DATE DEFAULT SYSDATE    -- Date when the record was created
);

-- ===============================================================================

-- Step 2: Create a sequence to generate unique IDs for each table
-- ===============================================================================

CREATE SEQUENCE seq_patient_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_appointment_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_history_id START WITH 1 INCREMENT BY 1;

-- ===============================================================================

-- Step 3: Create procedures for system functionality
-- ===============================================================================

-- Procedure to add a new patient
CREATE OR REPLACE PROCEDURE add_patient(
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_date_of_birth IN DATE,
    p_gender IN CHAR,
    p_contact_info IN VARCHAR2
) IS
    new_patient_id NUMBER;
BEGIN
    -- Generate a new patient ID
    new_patient_id := seq_patient_id.NEXTVAL;

    -- Insert the new patient record
    INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, contact_info)
    VALUES (new_patient_id, p_first_name, p_last_name, p_date_of_birth, p_gender, p_contact_info);

    DBMS_OUTPUT.PUT_LINE('New patient added with ID: ' || new_patient_id);
END;
/

-- Procedure to schedule an appointment
CREATE OR REPLACE PROCEDURE schedule_appointment(
    p_patient_id IN NUMBER,
    p_appointment_date IN DATE,
    p_doctor_name IN VARCHAR2,
    p_reason IN VARCHAR2
) IS
    new_appointment_id NUMBER;
BEGIN
    -- Generate a new appointment ID
    new_appointment_id := seq_appointment_id.NEXTVAL;

    -- Insert the appointment record
    INSERT INTO appointments (appointment_id, patient_id, appointment_date, doctor_name, reason)
    VALUES (new_appointment_id, p_patient_id, p_appointment_date, p_doctor_name, p_reason);

    DBMS_OUTPUT.PUT_LINE('Appointment scheduled with ID: ' || new_appointment_id);
END;
/

-- Procedure to add a medical history record
CREATE OR REPLACE PROCEDURE add_medical_history(
    p_patient_id IN NUMBER,
    p_diagnosis IN VARCHAR2,
    p_treatment IN VARCHAR2,
    p_notes IN VARCHAR2
) IS
    new_history_id NUMBER;
BEGIN
    -- Generate a new medical history ID
    new_history_id := seq_history_id.NEXTVAL;

    -- Insert the medical history record
    INSERT INTO medical_history (history_id, patient_id, diagnosis, treatment, notes)
    VALUES (new_history_id, p_patient_id, p_diagnosis, p_treatment, p_notes);

    DBMS_OUTPUT.PUT_LINE('Medical history added with ID: ' || new_history_id);
END;
/

-- Procedure to generate a medical report for a patient
CREATE OR REPLACE PROCEDURE generate_medical_report(
    p_patient_id IN NUMBER
) IS
BEGIN
    -- Display patient details
    DBMS_OUTPUT.PUT_LINE('Medical Report for Patient ID: ' || p_patient_id);
    FOR patient IN (SELECT first_name, last_name, date_of_birth, gender, contact_info
                    FROM patients
                    WHERE patient_id = p_patient_id) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || patient.first_name || ' ' || patient.last_name);
        DBMS_OUTPUT.PUT_LINE('Date of Birth: ' || patient.date_of_birth);
        DBMS_OUTPUT.PUT_LINE('Gender: ' || patient.gender);
        DBMS_OUTPUT.PUT_LINE('Contact Info: ' || patient.contact_info);
    END LOOP;

    -- Display medical history
    DBMS_OUTPUT.PUT_LINE('--- Medical History ---');
    FOR history IN (SELECT diagnosis, treatment, notes, recorded_date
                    FROM medical_history
                    WHERE patient_id = p_patient_id) LOOP
        DBMS_OUTPUT.PUT_LINE('Diagnosis: ' || history.diagnosis);
        DBMS_OUTPUT.PUT_LINE('Treatment: ' || history.treatment);
        DBMS_OUTPUT.PUT_LINE('Notes: ' || history.notes);
        DBMS_OUTPUT.PUT_LINE('Recorded Date: ' || history.recorded_date);
    END LOOP;
END;
/

--Usage:

    --1. Add a new patient:
    
    BEGIN
    add_patient('John', 'Doe', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 'M', 'john.doe@example.com');
END;
/


    --2 Schedule an appointment:
    
BEGIN
    schedule_appointment(1, TO_DATE('2025-01-10', 'YYYY-MM-DD'), 'Dr. Smith', 'Routine Checkup');
END;
/


    -- 3.Add a medical history record:
    
    BEGIN
    add_medical_history(1, 'Hypertension', 'Medication', 'Follow-up in 6 months');
END;
/


    --4. Generate a medical report:
    
    BEGIN
    generate_medical_report(1);
END;
/

    
    
    
    
    
    
    