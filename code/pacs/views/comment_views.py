from flask import render_template, request, redirect, url_for, session
from pacs import app, connection
from datetime import datetime

@app.route('/adoption/pet/<int:pet_id>/delete_comment/<int:comment_id>', methods=['GET', 'POST'])
def delete_comment(pet_id, comment_id):
    if 'user' in session:
        print(comment_id)
        delete_comment_from_database(comment_id)

        return redirect(url_for('pet_details', pet_id=pet_id))
    else:
        return redirect(url_for('user_login'))

def delete_comment_from_database(comment_id):
    try:
        db = connection()
        with db.cursor() as cursor:
            cursor.callproc('delete_comment_by_id', (comment_id,))
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