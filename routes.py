import os
from flask import Flask, flash, session, request, render_template, url_for
from flaskext.mysql import MySQL
from flask.ext.hashing import Hashing

mysql = MySQL()
app = Flask(__name__)
app.secret_key = "~1\xe4\xa77b\x04\x0c\xcc1\x89\xb9\xce\x1c\xa1H\xc7\x82\xe2\xc3\x97\xe9\x13z"
APP_ROOT = os.path.dirname(os.path.abspath(__file__))
app.config['MYSQL_DATABASE_USER'] = 'nzvr_db'
app.config['MYSQL_DATABASE_PASSWORD'] = 'password'
app.config['MYSQL_DATABASE_DB'] = 'nzvr_db'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)
hashing = Hashing(app)
SALT = 'salt'  

#TODO before live - salt and db password


@app.route("/")
def index():
    return render_template("index.html")

@app.route("/authenticate")
def authenticate():
    username = request.args.get('username')
    password = hashing.hash_value(request.args.get('password'), salt=SALT)
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM user WHERE username='" + username + "' AND password='" + password + "'")
    data = cursor.fetchone()
    if data is None:
        return "WRONG!" + password
    else:
        return "YAY!"
  
@app.route("/echo", methods=['POST'])
def echo():
    flash(request.form['text'])
    return '<a href="/">Click here</a> to test Flash Messages'

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

	return render_template("index.html")



if __name__ == "__main__":
    app.run(debug=True)
