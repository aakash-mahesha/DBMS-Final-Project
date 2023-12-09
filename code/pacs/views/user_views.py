from flask import render_template, request, redirect, url_for, session
from pacs import app, connection

@app.route('/users/create', methods=['GET', 'POST'])
def create_user():
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        user_password = request.form.get('user_password')
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')

        street_no = request.form.get('street_no')
        street_name = request.form.get('street_name')
        city = request.form.get('city')
        state = request.form.get('state')
        zip_code = request.form.get('zip')

        try:
            db = connection()
            with db.cursor() as cursor:
                cursor.callproc('insert_new_user',(username, 
                                                   user_password, 
                                                   email,
                                                   first_name, 
                                                   last_name,
                                                   street_no,
                                                   street_name,
                                                   city,
                                                   state,
                                                   zip_code))
                db.commit()
        except Exception as e:
            return render_template('error.html', error_message=f"Error creating user: {e}")
        finally:
            db.close()

        return redirect(url_for('user_login'))

    return render_template('users/create_user.html')

# Read
@app.route('/users')
def users():
    db = connection()
    try:
        with db.cursor() as cursor:
            sql = "SELECT * FROM user"
            cursor.execute(sql)
            result = cursor.fetchall()
            print(result)
            return render_template('users/users.html', users=result)
    except Exception as e:
        return render_template('error.html', error_message=f"Error: {e}")
    finally:
        db.close()

@app.route('/users/edit/<string:username>', methods=['GET', 'POST'])
def edit_user(username):
    try:
        db = connection()
        with db.cursor() as cursor:
            sql = "SELECT * FROM user WHERE username = %s"
            cursor.execute(sql, (username,))
            user = cursor.fetchone()


            address_id = user['address_id']
            sql = "SELECT * FROM user_address WHERE address_id = %s"
            cursor.execute(sql,(address_id,))
            address = cursor.fetchone()

        if request.method == 'POST':
            print(request.form.get('username'))
            username = username
            email = request.form.get('email')
            user_password = request.form.get('password')
            first_name = request.form.get('first_name')
            last_name = request.form.get('last_name')
            street_no = request.form.get('street_no')
            street_name = request.form.get('street_name')
            city = request.form.get('city')
            state = request.form.get('state')
            zip_code = request.form.get('zip')

            print("****",username, 
                                 email, 
                                 user_password, 
                                 first_name, 
                                 last_name,
                                 street_no,
                                 street_name,
                                 city,
                                 state,
                                 zip_code)
            with db.cursor() as cursor:
                cursor.callproc('update_user',
                                (username, 
                                 user_password, 
                                 email, 
                                 first_name, 
                                 last_name,
                                 street_no,
                                 street_name,
                                 city,
                                 state,
                                 zip_code))
                db.commit()
                cursor.execute('select * from user where username = %s',(username,))
                new_user = cursor.fetchone()
                print("updated user:",new_user)
                session['user'] = new_user
            return redirect(url_for('landing'))
    except Exception as e:
        return render_template('error.html', error_message=f"Error: {e}")
    finally:
        db.close()

    return render_template('users/edit_user.html', user=user, address=address)

@app.route('/users/delete/<string:username>')
def delete_user(username):
    try:
        db = connection()
        with db.cursor() as cursor:
            sql = "DELETE FROM user WHERE username = %s"
            cursor.execute(sql, (username,))
            db.commit()
    except Exception as e:
        return render_template('error.html', error_message=f"Error: {e}")
    finally:
        db.close()

    return redirect(url_for('landing'))

