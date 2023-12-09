from flask import render_template,session
from pacs import app

@app.route('/')
def landing():

    return render_template('welcome.html')