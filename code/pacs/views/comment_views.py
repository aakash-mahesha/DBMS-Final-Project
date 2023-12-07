from flask import render_template, request, redirect, url_for, session
from pacs import app, connection
from datetime import datetime

# Delete Comment View
@app.route('/adoption/pet/<int:pet_id>/delete_comment/<int:comment_id>', methods=['GET', 'POST'])
def delete_comment(pet_id, comment_id):
    if 'user' in session:
        # Delete the comment from the database
        print(comment_id)
        delete_comment_from_database(comment_id)

        return redirect(url_for('pet_details', pet_id=pet_id))
    else:
        return redirect(url_for('user_login'))

def delete_comment_from_database(comment_id):
    try:
        db = connection()
        with db.cursor() as cursor:
            # Call the stored procedure to delete a comment by comment_id
            cursor.callproc('delete_comment_by_id', (comment_id,))
            # Commit the changes
            db.commit()

    except Exception as e:
        return render_template('error.html', error_message=f"Error deleting comment: {e}")
    finally:
        db.close()

@app.route('/adoption/pet/<int:pet_id>/add_comment', methods=['POST'])
def add_comment(pet_id):
    if 'user' in session:
        username = session['user']['username']
        comment_text = request.form.get('comment_text')
        pet_id = pet_id
        comment_date = datetime.now()

        # Add logic to store the comment in the database
        try:
            db = connection()
            with db.cursor() as cursor:
                cursor.callproc("add_comment_to_database",
                            (pet_id, username, comment_text, comment_date))
            db.commit()
        except Exception as e:
            return render_template('error.html', error_message=e)
        finally:
            db.close()
        return redirect(url_for('pet_details', pet_id=pet_id))
    else:
        return redirect(url_for('user_login'))