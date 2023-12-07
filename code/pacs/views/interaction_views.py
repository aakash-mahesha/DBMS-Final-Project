from flask import render_template, request, redirect, url_for, session
from pacs import app, connection

# View for Editing Interaction
@app.route('/pet/<int:pet_id>/edit_interaction/<int:interaction_id>', methods=['GET', 'POST'])
def edit_interaction(pet_id,interaction_id):
    # Check if a user is logged in
    if 'user' in session:
        # Fetch interaction details from the database
        interaction = get_interaction_details(interaction_id)
        
        if request.method == 'POST':
            # Handle form submission and update the interaction details
            new_visit_date = request.form.get('visit_date')
            new_start_time = request.form.get('start_time')
            new_end_time = request.form.get('end_time')
            new_visit_type = request.form.get('visit_type')

            # Implement your logic to update the interaction in the database
            update_interaction_details(interaction_id,new_visit_date, new_start_time, new_end_time, new_visit_type)

            # Redirect to a page showing all scheduled interactions
            
            # return redirect(url_for('scheduled_interactions'))
            return redirect(url_for('pet_details',pet_id = pet_id))

        return render_template('edit_interaction.html',pet_id = pet_id,interaction=interaction)
    else:
        # Redirect to login if the user is not logged in
        return redirect(url_for('user_login'))


def get_interaction_details(interaction_id):
    try:
        db = connection()
        with db.cursor() as cursor:
            # Call the stored procedure to get interaction details by interaction_id
            cursor.callproc('get_interaction_details_by_id', (interaction_id,))
            
            # Fetch the result
            result = cursor.fetchone()
            return result

    except Exception as e:
        return render_template('error.html', error_message=f"Error getting interaction details: {e}")
    finally:
        db.close()


def update_interaction_details(interaction_id, new_visit_date, new_start_time, new_end_time, new_visit_type):
    try:
        db = connection()
        with db.cursor() as cursor:
            # Call the stored procedure to update interaction details by interaction_id
            cursor.callproc('update_interaction_details', (interaction_id, new_visit_date, new_start_time, new_end_time, new_visit_type))
            
            db.commit()
    except Exception as e:
        return render_template('error.html', error_message=f"Error updating interaction details: {e}")
    finally:
        db.close()


# View for Deleting Interaction
@app.route('/adoption/pet/<int:pet_id>/delete_interaction/<int:interaction_id>')
def delete_interaction(pet_id,interaction_id):
    # Check if a user is logged in
    if 'user' in session:
        # Implement your logic to delete the interaction from the database
        delete_interaction_from_database(interaction_id)

        # Redirect to a page showing all scheduled interactions
        # return redirect(url_for('scheduled_interactions'))
        return redirect(url_for('pet_details',pet_id = pet_id))
    else:
        # Redirect to login if the user is not logged in
        # return redirect(url_for('scheduled_interactions'))
        return redirect(url_for('user_login'))

def delete_interaction_from_database(interaction_id):
    try:
        db = connection()
        with db.cursor() as cursor:
            # Call the stored procedure to delete an interaction by interaction_id
            cursor.callproc('delete_interaction_by_id', (interaction_id,))
            
            db.commit()
            print('deleted')
    except Exception as e:
        return render_template('error.html', error_message=f"Error deleting interaction details: {e}")
    finally:
        db.close()
