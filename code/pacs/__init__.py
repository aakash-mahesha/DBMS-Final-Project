from flask import Flask
import pymysql
from pacs.config import Config
from flask_session import Session
app = Flask(__name__)
app.secret_key = 'pacs_dbms'
app.config['SESSION_TYPE'] = 'filesystem'
Session(app)
def connection():
    db = pymysql.connect(host=Config.MYSQL_HOST,
                    user=Config.MYSQL_USER,
                    password=Config.MYSQL_PASSWORD,
                    db=Config.MYSQL_DB,
                    cursorclass=pymysql.cursors.DictCursor)
    return db

from pacs.views import landing, pet_views, user_views,login_views,user_menu_view,pet_views,interaction_views,agency_views,comment_views
