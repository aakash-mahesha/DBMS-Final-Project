from flask import render_template, request, redirect, url_for, session
from pacs import app, connection
import datetime as dt
from datetime import datetime

# Pet Details and Actions
@app.route('/adoption/pet/<int:pet_id>', methods=['GET', 'POST'])
def pet_details(pet_id):
    
    # Check if a user is logged in
    if 'user' in session:
        username = session['user']['username']
        pet_details, pet_images , pet_comments = get_pet_details(pet_id)
           
        # Fetch pet details from the database
        print(pet_details, pet_images)
        if request.method == 'POST':

            visit_date = request.form.get('visit_date')
            start_time = request.form.get('start_time')
            end_time = request.form.get('end_time')
            visit_type = request.form.get('visit_type')

            

            schedule_pet_interaction(username,pet_id,visit_type,visit_date,start_time,end_time)

       
        interaction_list = get_schedule_list_per_pet(pet_id)
        return render_template('/pets/pet_details.html', username=username, 
                               pet=pet_details[0],pet_images = pet_images, 
                               user_interaction_list = interaction_list,
                               pet_comments = pet_comments)
    else:
        # Redirect to login if the user is not logged in
        return redirect(url_for('login'))

# Function to get pet details from the database
def get_pet_details(pet_id):
    pet_data = None
    pet_images = None
    pet_comments = None
    try:
        db = connection()
        with db.cursor() as cursor:
            cursor.callproc('get_all_pet_details', (pet_id,))
            pet_data = cursor.fetchall()

            cursor.callproc('get_pet_images_links', (pet_id,))
            pet_images = cursor.fetchall()

            cursor.callproc('get_user_comments_for_pet',(pet_id,))
            pet_comments = cursor.fetchall()

            return (pet_data, pet_images, pet_comments)
        
    except Exception as e:
        print(f"Error getting pet details, images, and pet_comments: {e}")
    finally:
        db.close()
    


    

def get_schedule_list_per_pet(pet_id):
    try:
        db = connection()
        with db.cursor() as cursor:
            cursor.callproc('get_schedule_list_per_pet', (int(pet_id), session['user']['username']))
            interactions = cursor.fetchall()
            interactions_list = []
            for interaction in interactions:
                interactions_list.append((dt.date.strftime(interaction['interaction_date'],"%m-%d-%Y"), ":".join(str(interaction['interaction_start_time']).split(":")[0:2]),":".join(str(interaction['interaction_end_time']).split(":")[0:2])))
            return interactions_list
            
    except Exception as e:
        print(f"Error getting pet details: {e}")
    finally:
        db.close() 


def schedule_pet_interaction(username, pet_id, interaction_type, interaction_date, interaction_start_time, interaction_end_time):
    try:
        db = connection()
        with db.cursor() as cursor:
            # Insert interaction details into the 'user_pet_interactions' table
            
            cursor.callproc(
                "insert_user_pet_interaction",
                (
                    username,
                    pet_id,
                    interaction_type,
                    interaction_date,
                    interaction_start_time,
                    interaction_end_time
                )
            )
            db.commit()
    except Exception as e:
        if(db):
            db.close()
        print(f"Error scheduling pet interaction: {e}")
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
            print(f"Error getting pet details, images, and pet_comments: {e}")
        finally:
            db.close()
        return redirect(url_for('pet_details', pet_id=pet_id))
    else:
        return redirect(url_for('login'))