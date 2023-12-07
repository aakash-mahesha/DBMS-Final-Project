from flask import render_template, request, redirect, url_for, session
from pacs import app, connection

# Create
@app.route('/users/create', methods=['GET', 'POST'])
def create_user():
    if request.method == 'POST':
        # Get user data from the form
        username = request.form.get('username')
        email = request.form.get('email')
        user_password = request.form.get('user_password')
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')

        # Create a new user instance
        try:
            db = connection()
            with db.cursor() as cursor:
                # Insert a new user into the database
                sql = "INSERT INTO user (username, email, user_password, first_name, last_name) VALUES (%s, %s, %s, %s, %s)"
                cursor.execute(sql, (username, email, user_password, first_name, last_name))
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

# Update
@app.route('/users/edit/<string:username>', methods=['GET', 'POST'])
def edit_user(username):
    try:
        db = connection()
        with db.cursor() as cursor:
            sql = "SELECT * FROM user WHERE username = %s"
            cursor.execute(sql, (username,))
            user = cursor.fetchone()

        if request.method == 'POST':
            # Update user data from the form
            print(request.form.get('username'))
            username = request.form.get('username')
            email = request.form.get('email')
            user_password = request.form.get('password')
            first_name = request.form.get('first_name')
            last_name = request.form.get('last_name')

            # Commit the changes to the database
            with db.cursor() as cursor:
                sql = "UPDATE user SET username = %s, email = %s, user_password = %s, first_name = %s, last_name = %s WHERE username = %s"
                cursor.execute(sql, (username, email, user_password, first_name, last_name, username))
                db.commit()
                cursor.execute("SELECT * FROM user WHERE username = %s", (username,))
                new_user = cursor.fetchone()
                session['user'] = new_user
            return redirect(url_for('landing'))
    except Exception as e:
        return render_template('error.html', error_message=f"Error: {e}")
    finally:
        db.close()

    return render_template('users/edit_user.html', user=user)

# Delete
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


# (TODO) Add more functions/queries here. Decide whether to have methods in the db or here.