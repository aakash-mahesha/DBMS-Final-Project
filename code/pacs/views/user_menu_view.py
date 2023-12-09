from flask import render_template, request, redirect, url_for, session
from pacs import app, connection

@app.route('/adoption/menu')
def adoption_menu():
    if 'user' in session:
        username = session['user']['username']
        pets = get_available_pets()

        return render_template('adoption_menu.html',username = username, pets=pets, adopted=False)
    else:
        return redirect(url_for('user_login'))

def get_available_pets():
    try:
        db = connection()
        with db.cursor() as cursor:
            cursor.callproc('get_pet_name_breed_image')
           
            result = cursor.fetchall()
            
            return result
    except Exception as e:
        return render_template('error.html', error_message=f"Error getting available pets: {e}")
    finally:
        db.close()


@app.route('/adopted_pets/menu')
def get_adopted_pets_list():
    if 'user' in session:
        username = session['user']['username']

        try:
            db = connection()
            with db.cursor() as cursor:
                cursor.callproc('get_adopted_pets_by_user',(username,))
            
                pets = cursor.fetchall()
                return render_template('adoption_menu.html',username = username, pets=pets, adopted=True)
                
        except Exception as e:
            return render_template('error.html', error_message=f"Error getting adopted pets: {e}")
        finally:
            db.close()
        
    else:
        return redirect(url_for('user_login'))