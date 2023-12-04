from flask import render_template, request, redirect, url_for, session
from pacs import app, connection

# Adoption Menu
@app.route('/adoption/menu')
def adoption_menu():
    if 'user' in session:
        username = session['user']['username']
        pets = get_available_pets()

        return render_template('adoption_menu.html',username = username, pets=pets)
    else:
        # Redirect to login if the user is not logged in
        return redirect(url_for('login'))

# Function to get available pets from the database
def get_available_pets():
    try:
        db = connection()
        with db.cursor() as cursor:
            # Call the stored procedure
            cursor.callproc('get_pet_name_breed_image')
           
            result = cursor.fetchall()
            
            return result
    except Exception as e:
        print(f"Error getting available pets: {e}")
    finally:
        db.close()

