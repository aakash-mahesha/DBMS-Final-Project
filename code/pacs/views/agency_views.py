from flask import render_template, request, redirect, url_for
from pacs import app, connection

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
        print(request.form)

        # Create a new user instance
        try:
            db = connection()
            with db.cursor() as cursor:
                # Insert a new user into the database
                sql = "INSERT INTO animal_agency (agency_name, agency_password, agency_street_no, agency_street_name, agency_city, agency_state, agency_zip, agency_contact_first_name, agency_contact_last_name, agency_contact_number) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
                cursor.execute(sql, (agency_name, agency_password, agency_streetnumber, streetname, city, state, zipcode, first_name, last_name, contact))
                db.commit()
        except Exception as e:
            print(f"Error creating agency: {e}")
        finally:
            db.close()

        return redirect(url_for('agency'))

    return render_template('animal_agency/create_agency.html')

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
            print("Agency found: ", agency)

        print("request method", request.method)
        print("form:", request.form)
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
            # Commit the changes to the database
            with db.cursor() as cursor:
                sql = "UPDATE animal_agency SET agency_name = %s, agency_password = %s, agency_street_no = %s, agency_street_name = %s, agency_city = %s, agency_state = %s, agency_zip = %s, agency_contact_first_name = %s, agency_contact_last_name = %s, agency_contact_number = %s WHERE agency_name = %s"
                cursor.execute(sql, (agency_name, agency_password, agency_streetnumber, streetname, city, state, zipcode, first_name, last_name, contact, agency_name))
                db.commit()
            return redirect(url_for('agency'))
        
    except Exception as e:
        return f"Error: {e}"
    finally:
        db.close()

    return render_template('animal_agency/edit_agency.html', agency=agency)

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