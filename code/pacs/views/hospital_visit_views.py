from flask import render_template, request, redirect, url_for, session, jsonify
from pacs import app, connection

@app.route('/agency/<string:agency_name>/doctor_visit_form/pet/<int:pet_id>', methods=['GET', 'POST'])
def doctor_visit_form(agency_name,pet_id):
    # Simulated data, replace with actual data retrieval logic
    hospitals = get_hospitals_by_agency(agency_name)
    print(hospitals)
    
    if request.method == 'POST':
        # Handle form submission here
        doctor_id = request.form.get('doctor')
        visit_date = request.form.get('visit_date')
        diagnosis = request.form.get('diagnosis')
        medications = request.form.get('medications')
        health_level = request.form.get('health_level')

        # Insert data into pet_visit_doctor table (replace with your logic)
        # ...
        insert_into_pet_visit_doctor(pet_id,doctor_id,visit_date,diagnosis,medications,health_level)
        return redirect(url_for('doctor_visit_form',agency_name = agency_name, pet_id = pet_id, hospitals=hospitals))  # Redirect to a success page

    return render_template('animal_agency/doctor_visit_form.html', agency_name = agency_name, pet_id = pet_id, hospitals=hospitals)

def get_hospitals_by_agency(agency_name):
    db = connection()
    try:
        with db.cursor() as cursor:
            # Call the stored procedure
            cursor.callproc('get_hospitals_by_agency', (agency_name,))
            # Fetch the results
            result = cursor.fetchall()
            hospitals = []
            for h in result:
                hospitals.append(h['hospital_name'])
            return hospitals
    finally:
        db.close()

@app.route('/get_doctors', methods=['POST'])
def get_doctors():
    try:
        selected_hospital = request.form.get('hospital')

        # Call the stored procedure to fetch doctors based on the selected hospital
        # Replace 'call_procedure_to_fetch_doctors' with the actual name of your procedure
        # You should replace the following line with your actual logic to fetch doctors
        doctors = fetch_doctors_by_hospital(selected_hospital)

        return jsonify(doctors)
    except Exception as e:
        return render_template('error.html', error_message=jsonify({'error': str(e)}))
    
def fetch_doctors_by_hospital(selected_hospital):
    print('_fetch_doctors', selected_hospital)
    db = connection()
    try:
        with db.cursor() as cursor:
            # Call the stored procedure
            cursor.callproc('get_doctors_by_hospital', (selected_hospital,))
            # Fetch the results
            result = cursor.fetchall()
            return result
            
    finally:
        db.close()

def insert_into_pet_visit_doctor(pet_id,doctor_id,visit_date,diagnosis,medications,health_level):
    try:
        # Connect to the database
        db = connection()

        # Insert data into the pet_visit_doctor table
        with db.cursor() as cursor:
            # Call the stored procedure or write SQL query to insert data
            # Replace the following line with your logic
            cursor.callproc('insert_pet_visit_doctor', (pet_id, doctor_id, visit_date, diagnosis, medications, health_level))
            db.commit()

        return redirect(url_for('success_page'))  # Redirect to a success page

    except Exception as e:
        return render_template('error.html', error_message=f"Error inserting doctor visit details: {e}")

    finally:
        db.close() 