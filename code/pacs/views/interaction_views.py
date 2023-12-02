from flask import render_template, request, redirect, url_for, session
from pacs import app, connection

# View for Editing Interaction
@app.route('/adoption/pet/edit_interaction/<int:interaction_id>', methods=['GET', 'POST'])
def edit_interaction(interaction_id):
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
            return redirect(url_for('edit_interaction',interaction_id = interaction_id))

        return render_template('edit_interaction.html', interaction=interaction)
    else:
        # Redirect to login if the user is not logged in
        return redirect(url_for('login'))


def get_interaction_details(interaction_id):
    try:
        db = connection()
        with db.cursor() as cursor:
            sql = "SELECT * FROM user_pet_interactions WHERE interaction_id = %s"
            cursor.execute(sql,(interaction_id,))
            interaction = cursor.fetchone()
            return interaction
        
    except Exception as e:
        print(f"Error getting interaction: {e}")
    finally:
        db.close()


def update_interaction_details(interaction_id, new_visit_date, new_start_time, new_end_time, new_visit_type):
    try:
        db = connection()
        with db.cursor() as cursor:
            # Update interaction details in the 'user_pet_interactions' table
            sql = """
                UPDATE user_pet_interactions
                SET interaction_date = %s, interaction_start_time = %s, interaction_end_time = %s, interaction_type = %s
                WHERE interaction_id = %s
            """
            cursor.execute(sql, (new_visit_date, new_start_time, new_end_time, new_visit_type, interaction_id))
            print('updated')
            db.commit()
    except Exception as e:
        print(f"Error updating interaction details: {e}")
    finally:
        db.close()


# View for Deleting Interaction
@app.route('/adoption/pet/delete_interaction/<int:interaction_id>')
def delete_interaction(interaction_id):
    # Check if a user is logged in
    if 'user' in session:
        # Implement your logic to delete the interaction from the database
        delete_interaction_from_database(interaction_id)

        # Redirect to a page showing all scheduled interactions
        # return redirect(url_for('scheduled_interactions'))
        return redirect(url_for('landing'))
    else:
        # Redirect to login if the user is not logged in
        # return redirect(url_for('scheduled_interactions'))
        return redirect(url_for('landing'))

def delete_interaction_from_database(interaction_id):
    try:
        db = connection()
        with db.cursor() as cursor:
            # delete an interaction details in the from user_pet_interactions table
            sql = "DELETE FROM user_pet_interactions WHERE interaction_id = %s"
            cursor.execute(sql, (interaction_id,))
            db.commit()
            print('deleted')
            
    except Exception as e:
        print(f"Error deleting interaction details: {e}")
    finally:
        db.close()
    
# # View for Displaying All Scheduled Interactions
# @app.route('/adoption/pet/scheduled_interactions')
# def scheduled_interactions():
#     # Check if a user is logged in
#     if 'user' in session:
#         username = session['user']['username']

#         # Fetch all scheduled interactions for the user from the database
#         interactions = get_all_user_interactions(username)

#         return render_template('/pets/scheduled_interactions.html', username=username, interactions=interactions)
#     else:
#         # Redirect to login if the user is not logged in
#         return redirect(url_for('login'))