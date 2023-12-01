from flask import render_template
from pacs import app

@app.route('/')
def landing():
    return render_template('base.html')