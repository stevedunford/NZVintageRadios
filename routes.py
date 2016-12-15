'''
NZ Vintage Radios Site - Steve Dunford steve@dunford.org.nz
Started: December 2016
Current version: 0.00.00.01 - a looong way to go
Based on Flask 0.11
dependencies (pip install): 
 - flask-mysql
 - flask-login   TODO: email address login - do away with login
 - flask-uploads TODO: IS this needed?
GitHub: github.com/stevedunford/NZVintageRadios
Licence: Beerware.  I need a beer, you need a website - perfect
'''

import os # for file upload path determination
from flask import Flask, flash, session, request, render_template, redirect, url_for
from flaskext.mysql import MySQL
#from flask_login import LoginManager

APP_ROOT = os.path.dirname(os.path.abspath(__file__))

# app config
app = Flask(__name__)
app.secret_key = "~1\xe4\xa77b\x04\x0c\xcc1\x89\xb9\xce\x1c\xa1H\xc7\x82\xe2\xc3\x97\xe9\x13z"

# MySQL config
mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = 'nzvr_db'
app.config['MYSQL_DATABASE_PASSWORD'] = 'password'
app.config['MYSQL_DATABASE_DB'] = 'nzvr_db'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app) 

# User login config
#login_manager = LoginManager()
#login_manager.init_app(app)


#TODO before live - salt and db password

'''
USER MANAGEMENT
'''
#@login_manager.user_loader
#def load_user(user_id):
#    return User.get(user_id)

#class User():
#    pass

#@app.route("/logout")
#@login_required         #Only for logged-in users
#def logout():
#    logout_user()
#    return redirect(somewhere)

@app.route("/login", methods=['GET', 'POST'])
def login():
    
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM user WHERE username='" + username + "' AND password='" + password + "'")
    data = cursor.fetchone()
    if data is None:
        return "WRONG!" + password
    else:
        logged_in = 1
        return redirect(redirect_url())


'''
SITE LOGIC
'''
@app.route("/")
def index():
    return render_template("index.html")

@app.route("/radio", methods=['GET', 'POST'])
def radio():
    if request.method == "POST":
        return ("POST this time around")
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM manufacturer ORDER BY name ASC")
    data = cursor.fetchall()
    if data is None:
        return "NONE!"
    else:
        out = [str(item[0]) for item in data]
        return render_template("radio.html", manufacturers=out)

@app.route("/brand/<id>")
def brand(id):
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM brand WHERE id={0}".format(id))
    _brand=cursor.fetchall()
    print(_brand)
    print("-------")
    print(_brand[0])
    return render_template("brand.html", brand=_brand)
  
@app.route("/echo", methods=['POST'])
def echo():
    flash(request.form['text'])
    return '<a href="/">Click here</a> to test Flash Messages'

# Return to previous page helper function
# http://flask.pocoo.org/docs/reqcontext/
def redirect_url(default='index'):
    return request.args.get('next') or \
           request.referrer or \
           url_for(default)

@app.route("/radio1")
def radio1():
    path = "/".join([APP_ROOT, 'static/images'])
    print("___________________________\n {0} \n ---------------------------------".format(path))
    logo = os.listdir(path)[0]
    return render_template("index.html", rad=True, logo=logo)

@app.route("/uploads", methods=['POST'])
def uploads():
	target=os.path.join(APP_ROOT, 'images/')
	print("images dir: " + target)

	# check to see if images directory exists, make if not
	if not os.path.isdir(target):
		os.mkdir(target)

	for file in request.files.getlist("file"):
		print ("filename: " + str(file))
		filename = file.filename
		destination = "/".join([target, filename])
		print("file being stored in: " + destination)
		file.save(destination)

	return render_template("index.html", logged_in=logged_in)



if __name__ == "__main__":
    app.run(debug=True)
