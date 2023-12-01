from flask import render_template
from pacs import app
from pacs.models import Pet

@app.route('/pets')
def pets():
    pets_list = Pet.query.all()
    return render_template('pets.html', pets=pets_list)