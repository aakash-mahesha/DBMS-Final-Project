from flask import render_template, request, redirect, url_for, session
from pacs import app, connection
import datetime as dt

# Pet Details and Actions
@app.route('/adoption/pet/<int:pet_id>', methods=['GET', 'POST'])
def pet_details(pet_id):
    
    # Check if a user is logged in
    if 'user' in session:
        username = session['user']['username']
        pet = get_pet_details(pet_id)
        
            # Handle adoption, scheduling visits, commenting, etc.
            # Implement your logic based on the actions you want to support
            
        # Fetch pet details from the database
        if request.method == 'POST':

            visit_date = request.form.get('visit_date')
            start_time = request.form.get('start_time')
            end_time = request.form.get('end_time')
            visit_type = request.form.get('visit_type')

            

            schedule_pet_interaction(username,pet_id,visit_type,visit_date,start_time,end_time)

       
        interaction_list = get_schedule_list_per_pet(pet_id)
        return render_template('/pets/pet_details.html', username=username, pet=pet,user_interaction_list = interaction_list)
    else:
        # Redirect to login if the user is not logged in
        return redirect(url_for('login'))

# Function to get pet details from the database
def get_pet_details(pet_id):
    try:
        db = connection()
        with db.cursor() as cursor:
            sql = "SELECT * FROM pet WHERE pet_id = %s"
            cursor.execute(sql, (pet_id,))
            pet = cursor.fetchone()
            print(pet)
            return pet
    except Exception as e:
        if(db):
            db.close()
        print(f"Error getting pet details: {e}")
    finally:
        db.close()

def get_schedule_list_per_pet(pet_id):
    print('in get_schedule_list_per_pet')

    try:
        db = connection()
        with db.cursor() as cursor:
            sql = "SELECT * FROM user_pet_interactions WHERE pet_id = %s and username = %s"
            cursor.execute(sql, (int(pet_id),session['user']['username']))
            interactions = cursor.fetchall()
            interactions_list = []
            for interaction in interactions:
                interactions_list.append((dt.date.strftime(interaction['interaction_date'],"%m-%d-%Y"), ":".join(str(interaction['interaction_start_time']).split(":")[0:2]),":".join(str(interaction['interaction_end_time']).split(":")[0:2])))
            return interactions_list
            
    except Exception as e:
        if(db):
            db.close()
        print(f"Error getting pet details: {e}")
    finally:
        db.close() 


def schedule_pet_interaction(username, pet_id, interaction_type, interaction_date, interaction_start_time, interaction_end_time):
    try:
        db = connection()
        with db.cursor() as cursor:
            # Insert interaction details into the 'user_pet_interactions' table
            sql = """
                INSERT INTO user_pet_interactions 
                    (username, pet_id, interaction_type, interaction_date, interaction_start_time, interaction_end_time)
                VALUES (%s, %s, %s, %s, %s, %s)
            """
            cursor.execute(
                sql,
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