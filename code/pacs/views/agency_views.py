from flask import render_template, request, redirect, url_for, session
from pacs import app, connection
from pacs.views.pet_views import get_pet_details
from pacs.utils.upload_file import upload_to_s3
from time import time
from random import randint

# Create
@app.route('/agency/create', methods=['GET', 'POST'])
def create_agency():
    if request.method == 'POST':
        # Get agency data from the form
        agency_name = request.form.get('name')
        agency_password = request.form.get('password')
        agency_streetnumber = request.form.get('street_no')
        streetname = request.form.get('street_name')
        city = request.form.get('city')
        state = request.form.get('state')
        zipcode = request.form.get('zipcode')
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')
        contact = request.form.get('contact')
        hospital_associated = request.form.get('hospital_associated')
        print("Hospital Associated: ", hospital_associated)
        # print(request.form)

        # Create a new user instance
        try:
            db = connection()
            with db.cursor() as cursor:
                # Insert a new user into the database
                sql = "INSERT INTO animal_agency (agency_name, agency_password, agency_street_no, agency_street_name, agency_city, agency_state, agency_zip, agency_contact_first_name, agency_contact_last_name, agency_contact_number) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
                cursor.execute(sql, (agency_name, agency_password, agency_streetnumber, streetname, city, state, zipcode, first_name, last_name, contact))
                db.commit()
                sql = "SELECT * FROM animal_agency WHERE agency_name = %s"
                cursor.execute(sql, (agency_name))
                agency = cursor.fetchone()
                print("AGENCY: ", agency)
                session['agency'] = agency
                cursor.execute("INSERT INTO agency_partnered_vet_hospitals(agency_name, hospital_name) VALUES (%s, %s)",
                               (agency_name, hospital_associated))
                db.commit()
        except Exception as e:
            return f"Error creating agency: {e}"
        finally:
            db.close()

        return redirect(url_for('landing'))

    hospitals = get_hospitals()
    return render_template('animal_agency/create_agency.html', hospitals = hospitals)


def get_hospitals():
    try:
        db = connection()
        with db.cursor() as cursor:
            cursor.execute("SELECT hospital_name FROM vet_hospital")
            hospital_results = cursor.fetchall()
            print("Hospitals: ", hospital_results)
            return hospital_results
    except Exception as e:
        return f"Error: {e}"
    finally:
        db.close()

# Read
@app.route('/agency')
def agency():
    db = connection()
    try:
        with db.cursor() as cursor:
            sql = "SELECT * FROM animal_agency"
            cursor.execute(sql)
            result = cursor.fetchall()
            print(result)
            return render_template('animal_agency/agencies.html', agencies=result)
            # return result
    except Exception as e:
        return f"Error: {e}"
    finally:
        db.close()

# Update
@app.route('/agency/edit/<string:agency_name>', methods=['GET', 'POST'])
def edit_agency(agency_name):
    try:
        db = connection()
        with db.cursor() as cursor:
            sql = "SELECT * FROM animal_agency WHERE agency_name = %s"
            cursor.execute(sql, (agency_name,))
            agency = cursor.fetchone()
            sql = "SELECT hospital_name FROM agency_partnered_vet_hospitals WHERE agency_name = %s"
            cursor.execute(sql, (agency_name,))
            hospital_name = cursor.fetchone()
            hospital_results = get_hospitals()
            

        # print("request method", request.method)
        # print("form:", request.form)
        if request.method == 'POST':
            # Update user data from the form
            print("FORM:******", request.form)
            agency_name = request.form.get('name')
            agency_password = request.form.get('password')
            agency_streetnumber = request.form.get('street_no')
            streetname = request.form.get('street_name')
            city = request.form.get('city')
            state = request.form.get('state')
            zipcode = request.form.get('zipcode')
            first_name = request.form.get('first_name')
            last_name = request.form.get('last_name')
            contact = request.form.get('contact')
            hospital_associated = request.form.get('hospital_associated')
            print("Hospital associated", hospital_associated)
            # Commit the changes to the database
            with db.cursor() as cursor:
                sql = "UPDATE animal_agency SET agency_name = %s, agency_password = %s, agency_street_no = %s, agency_street_name = %s, agency_city = %s, agency_state = %s, agency_zip = %s, agency_contact_first_name = %s, agency_contact_last_name = %s, agency_contact_number = %s WHERE agency_name = %s"
                cursor.execute(sql, (agency_name, agency_password, agency_streetnumber, streetname, city, state, zipcode, first_name, last_name, contact, agency_name))
                db.commit()
                cursor.execute("UPDATE agency_partnered_vet_hospitals SET agency_name = %s, hospital_name = %s WHERE agency_name= %s",
                               (agency_name, hospital_associated, agency_name))
                db.commit()
            return redirect(url_for('landing'))
        
    except Exception as e:
        return f"Error: {e}"
    finally:
        db.close()

    return render_template('animal_agency/edit_agency.html', agency=agency, hospitals = hospital_results, selected_h_name = hospital_name)

# Delete
@app.route('/agency/delete/<string:agency_name>')
def delete_agency(agency_name):
    try:
        db = connection()
        with db.cursor() as cursor:
            sql = "DELETE FROM animal_agency WHERE agency_name = %s"
            cursor.execute(sql, (agency_name,))
            db.commit()
    except Exception as e:
        return f"Error: {e}"
    finally:
        db.close()

    return redirect(url_for('agency'))

@app.route('/agency/pets')
def get_agency_pets():
    if session['agency']:
        agency_name = session['agency']['agency_name']
        print("agency name", agency_name)
        print("Found agency and session")
    else:
        return render_template('welcome.html')
    try:
        db = connection()
        with db.cursor() as cursor:
            cursor.callproc('get_pets_for_agency', (agency_name,))
            pet_data = cursor.fetchall()
            pet_deets = []
            if(len(pet_data) > 0):
                for pet in pet_data:
                    pet_id = pet.get('pet_id')
                    pet_details = get_pet_details(pet_id)
                    pet_deets.append(pet_details)
                    # print(pet_details)
            
        return render_template('pets/agency_pet_list.html', pets=pet_data)

    except Exception as e:
        return f"Error: {e}"
    finally:
        db.close()

def add_image_to_pet():
    # Call procedure to enter

    pass

@app.route('/agency/pets/add', methods = ['GET','POST'])
def add_agency_pet():
    if session['agency']:
        agency_name = session['agency']['agency_name']
    else:
        return render_template('welcome.html')
    if request.method == 'POST':
        # Get agency data from the form
        pet_name = request.form.get('pet_name')
        pet_type = request.form.get('pet_type')
        age = request.form.get('age')
        height = request.form.get('height')
        weight = request.form.get('weight')
        color = request.form.get('color')
        breed_name = request.form.get('breed_name')
        adopted = request.form.get('adopted', False)
        adopted_by = request.form.get('adopted_by')
        adoption_date = request.form.get('adoption_date', 'null')

        uploaded_images_urls = []

        if 'images' in request.files:
            # print("got images ********", request.files.getlist())
            images = request.files.getlist('images')
            for image in images:
                image_name = str(randint(2,100)*time())+".jpg"
                print("image name::::", image_name)
                uploaded_url = upload_to_s3(image, 'pacs-dbms-neu', image_name)
                uploaded_images_urls.append(uploaded_url)

        if adopted == False:
            adopted_by = None
            adoption_date = None
        provided_by_agency = agency_name
        try:
            db = connection()
            with db.cursor() as cursor:
                cursor.callproc('insert_pet_data',
                                (pet_name,
                                pet_type,
                                age,
                                height,
                                weight,
                                color,
                                breed_name,
                                adopted,
                                adopted_by,
                                adoption_date,
                                provided_by_agency,))
                
                result = cursor.fetchone()
                db.commit()
                print("Pet ID retrieved: *********",result['pet_id_result'])
                print(uploaded_images_urls)
                # Upload to pet_images db
                for image in uploaded_images_urls:
                    cursor.callproc('set_pet_images',(image, result['pet_id_result']))
                db.commit()  
            return redirect(url_for('get_agency_pets'))
        

        except Exception as e:
            return render_template('error.html', error_message=e)
        finally:
            db.close()
        
    return render_template('pets/pet_entry.html')

@app.route('/agency/pets/<int:pet_id>')
def delete_agency_pet(pet_id):
    try:
        db = connection()
        with db.cursor() as cursor:
            sql = "DELETE FROM pet WHERE pet_id = %s"
            cursor.execute(sql, (pet_id,))
            db.commit()
    except Exception as e:
        return render_template('error.html', error_message=e)
    finally:
        db.close()

    return redirect(url_for('get_agency_pets'))
