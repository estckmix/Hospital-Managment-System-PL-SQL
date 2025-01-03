# Hospital-Managment-System-PL-SQL
PL/SQL code implementation for a basic Hospital Management System with comments explaining each part of the code. This code creates the required tables, procedures, and functionality for managing patients, appointments, and medical records.

Usage:

    -- Add a new patient:

BEGIN
    add_patient('John', 'Doe', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 'M', 'john.doe@example.com');
END;
/

  -- Schedule an appointment:

BEGIN
    schedule_appointment(1, TO_DATE('2025-01-10', 'YYYY-MM-DD'), 'Dr. Smith', 'Routine Checkup');
END;
/

  -- Add a medical history record:

BEGIN
    add_medical_history(1, 'Hypertension', 'Medication', 'Follow-up in 6 months');
END;
/

  -- Generate a medical report:

    BEGIN
        generate_medical_report(1);
    END;
    /

