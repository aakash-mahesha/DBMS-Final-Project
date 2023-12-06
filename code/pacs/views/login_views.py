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
                    # Authentication successful
                    session['user'] = user
                    return redirect(url_for('adoption_menu'))
                else:
                    # Authentication failed
                    return render_template('user_login.html', error="Invalid username or password")
        except Exception as e:
            return f"Error: {e}"
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
                    # Authentication successful
                    session['agency'] = agency
                    return redirect(url_for('landing'))
                else:
                    # Authentication failed
                    return render_template('agency_login.html', error="Invalid username or password")
        except Exception as e:
            return f"Error: {e}"
        finally:
            db.close()

    return render_template('agency_login.html')

@app.route('/logout')
def logout():
    # Clear user-related information from the session
    if session.get('user', None):
        session.pop('user')
    if session.get('agency', None):
        session.pop('agency')

    # Redirect to the landing page or any other desired page after logout
    return redirect(url_for('landing'))