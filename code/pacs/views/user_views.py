from flask import render_template, request, redirect, url_for
from pacs import app, db
from pacs.models import User

# Create
@app.route('/users/create', methods=['GET', 'POST'])
def create_user():
    if request.method == 'POST':
        # Get user data from the form
        username = request.form.get('username')
        email = request.form.get('email')
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')

        # Create a new user instance
        new_user = User(username=username, email=email, first_name=first_name, last_name=last_name)

        # Add the user to the database
        db.session.add(new_user)
        db.session.commit()

        return redirect(url_for('users'))

    return render_template('create_user.html')

# Read
@app.route('/users')
def users():
    users_list = User.query.all()
    return render_template('users.html', users=users_list)

# Update
@app.route('/users/edit/<string:username>', methods=['GET', 'POST'])
def edit_user(username):
    user = User.query.filter_by(username=username).first()

    if request.method == 'POST':
        # Update user data from the form
        user.username = request.form.get('username')
        user.email = request.form.get('email')
        user.first_name = request.form.get('first_name')
        user.last_name = request.form.get('last_name')

        # Commit the changes to the database
        db.session.commit()

        return redirect(url_for('users'))

    return render_template('edit_user.html', user=user)

# Delete
@app.route('/users/delete/<string:username>')
def delete_user(username):
    user = User.query.filter_by(username=username).first()

    # Check if the user exists
    if user:
        # Delete the user from the database
        db.session.delete(user)
        db.session.commit()

    return redirect(url_for('users'))


# (TODO) Add more functions/queries here. Decide whether to have methods in the db or here.