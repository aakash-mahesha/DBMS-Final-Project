from flask import render_template,session
from pacs import app

@app.route('/')
def landing():
    username = None
    first_name = None
    last_name = None
    if session.get('user'):
        username = session['user'].get('username',None)
        first_name = session['user'].get('first_name',None)
        last_name = session['user'].get('last_name',None)

        print(username, first_name,last_name)
    return render_template('welcome.html', username = username, first_name = first_name, last_name = last_name)