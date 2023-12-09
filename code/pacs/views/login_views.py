from flask import render_template, request, redirect, url_for, session
from pacs import app, connection

@app.route('/user_login', methods=['GET', 'POST'])
def user_login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        try:
            db = connection()
            with db.cursor() as cursor:
                sql = "SELECT * FROM user WHERE username = %s"
                cursor.execute(sql, (username,))
                user = cursor.fetchone()

                if user and user['user_password'] == password:
                    session['user'] = user
                    return redirect(url_for('get_adopted_pets_list'))
                else:
                    return render_template('user_login.html', error="Invalid username or password")
        except Exception as e:
            return render_template('error.html', error_message=f"Error: {e}")
        finally:
            db.close()

    return render_template('user_login.html')

@app.route('/agency_login', methods=['GET', 'POST'])
def agency_login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        try:
            db = connection()
            with db.cursor() as cursor:
                sql = "SELECT * FROM animal_agency WHERE agency_name = %s"
                cursor.execute(sql, (username,))
                agency = cursor.fetchone()

                if agency and agency['agency_password'] == password:
                    session['agency'] = agency
                    return redirect(url_for('landing'))
                else:
                    return render_template('agency_login.html', error="Invalid username or password")
        except Exception as e:
            return render_template('error.html', error_message=f"Error: {e}")
        finally:
            db.close()

    return render_template('agency_login.html')

@app.route('/logout')
def logout():
    if session.get('user', None):
        session.pop('user')
    if session.get('agency', None):
        session.pop('agency')

    return redirect(url_for('landing'))