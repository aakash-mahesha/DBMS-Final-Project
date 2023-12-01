from flask import Flask
import pymysql
from pacs.config import Config

app = Flask(__name__)
app.secret_key = 'pacs_dbms'
def connection():
    db = pymysql.connect(host=Config.MYSQL_HOST,
                    user=Config.MYSQL_USER,
                    password=Config.MYSQL_PASSWORD,
                    db=Config.MYSQL_DB,
                    cursorclass=pymysql.cursors.DictCursor)
    return db

from pacs.views import landing, pet_views, user_views,login_views