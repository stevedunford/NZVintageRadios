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
from flask import Flask, flash, session, request, render_template_string, render_template, redirect, url_for, g, abort
from flaskext.mysql import MySQL
from flask_wtf import Form
from wtforms import StringField, BooleanField, TextAreaField
from wtforms.validators import DataRequired

APP_ROOT = os.path.dirname(os.path.abspath(__file__))

WTF_CSRF_ENABLED = True
SECRET_KEY = 'uxjSShEJs}jbMSW\x80hMl\x80Yq1VFz\x82Wpg{y||GyYAXISqSJBFt\x83w}Y\x80E`AVTFQyhsKiGCVzoIROIRC\x81\x83\x82n]zCw`]ZYwZw`PO{UDPGiGH'

# app config
app = Flask(__name__)
app.secret_key = '}g\x83^jSvlazDyhxHCV^YUXw\\crxOddpw~\x83Q\x80eP|ZZqOSBcO\x80IGvlphvZkqCcv~\x7foJJHgYou|]rxvSDZN\x82OIo{Qis55N}Mo\x7fJK\x80G|Hdt'

# MySQL config
mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = 'nzvr_db'
app.config['MYSQL_DATABASE_PASSWORD'] = 'password'
app.config['MYSQL_DATABASE_DB'] = 'nzvr_db'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app) 

app.logger.debug('NZVRS Website Starting Up...')


'''
Web data entry
'''
class Distributor(Form):
    name = StringField('name', validators=[DataRequired()])
    alias = StringField('alias', validators=[DataRequired()])
    address = StringField('address', validators=[DataRequired()])
    nz_wide = BooleanField('nz_wide', default=False)
    notes = TextAreaField('notes', validators=[DataRequired()])
    

'''
SITE LOGIC
'''
@app.route("/")
@app.route("/home")
def index():
    return render_template("index.html", title="Welcome")


@app.route("/radio/<brand>/<id>")
@app.route("/radio/<brand>/<id>/<variant>")
def radio(brand, id, variant=None):
    conn = mysql.connect()
    cursor = conn.cursor()

    # find the db's id for the brand name
    cursor.execute("SELECT id, manufacturer_id FROM brand WHERE alias='{0}'".format(brand))
    _brand, _manufacturer = cursor.fetchone()
    
    # find the db's id for the radio model number
    if variant:
        cursor.execute("SELECT id FROM radio WHERE number='{0}' AND name='{1}'".format(id, variant))
    else:
        cursor.execute("SELECT id FROM radio WHERE number='{0}'".format(id))
    radio_id = cursor.fetchone()[0]
    
    # get the variant if specified, or all matching radios
    if variant:
        cursor.execute("SELECT * FROM radio WHERE brand_id='{0}' AND number='{1}' AND name='{2}'".format(_brand, id, variant))
    else:
        cursor.execute("SELECT * FROM radio WHERE brand_id='{0}' AND number='{1}'".format(_brand, id))
    models = cursor.fetchall()
    
    # get the manufacturer and alias (for link)
    cursor.execute("SELECT name, alias FROM manufacturer WHERE id='{0}'".format(_manufacturer))
    manufacturer, manufacturer_alias = cursor.fetchone()

    # get the images related to the radio (or primary image for each variant)
    cursor.execute("SELECT name, path, thumb, rank FROM images WHERE type=1 AND type_id={0} ORDER BY rank ASC".format(radio_id))
    images = cursor.fetchall()
    print(images)

        
    if models is None:
        return "NONE!"
    else:
        return render_template("radio.html", models=models, title=brand+' '+id, brand=brand, manufacturer=manufacturer, manufacturer_alias=manufacturer_alias, id=id, variant=variant, images=images)


    
@app.route('/new_distributor', methods=['GET', 'POST'])
def new_distributor():
    form = Distributor()
    if form.validate_on_submit():
        conn = mysql.connect()
        cursor = conn.cursor()
        flash('name = {0}'.format(form.name.data))
        query = "INSERT INTO distributor (name, alias, address, notes) VALUES ('{0}', '{1}', '{2}', '{3}')".format(form.name.data, form.alias.data, form.address.data, form.notes.data)
        cursor.execute(query)
        conn.commit()
        return redirect('/home')
    else:
        flash("All required (*) fields need to be filled in")
    return render_template('new_distributor.html', title='Add New Distributor', form=form)

@app.route("/distributors", methods=['GET', 'POST'])
def distributors():
    if request.method == "POST":
        return redirect(url_for('distributor', id=request.form.get('id')))
    else:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT id, name FROM distributor ORDER BY name ASC")
        distributors = cursor.fetchall()
        if distributors is None:
            out = []
        else:
            out = [[str(item[0]), str(item[1])] for item in distributors]
        
        return render_template("distributors.html", distributors=out, title='Distributors')
                
@app.route("/distributor/<id>")
def distributor(id=None):
    conn = mysql.connect()
    cursor = conn.cursor()
    try:
        id = int(id) #id number - database id
        cursor.execute("SELECT alias FROM distributor WHERE id={0}".format(id))
        _distributor=cursor.fetchone()
        session['id'] = id
        print("================={0}=================".format(session['id']))
        return redirect(request.url.replace('/distributor/{0}'.format(id), '/distributor/{0}'.format(_distributor[0].lower().strip().replace(' ', '_'))))
    except ValueError: # id is not an int, ie: redirect worked
        num = session['id']
        print("================={0}=================".format(num))
        # find the distributors details
        cursor.execute("SELECT * FROM distributor WHERE alias='{0}'".format(id))
        _distributor=cursor.fetchone()
        
        # find all models currently sold by this distributor
        cursor.execute("SELECT * FROM brand WHERE distributor_id='{0}'".format(num))
        _brands=cursor.fetchall()
        
        _logo = url_for('static', filename='images/distributors/{0}.jpg'.format(_distributor[2]))
        if not os.path.isfile(APP_ROOT + _logo):
            _logo = None
    except: # if all else fails
        abort(404)        

    if _distributor is None:
        return "NONE!"
    else:
        return render_template("distributor.html", distributor=_distributor, title=_distributor[1], brands=_brands, logo=_logo)



@app.route("/manufacturers", methods=['GET', 'POST'])
def manufacturers():
    if request.method == "POST":
        return redirect(url_for('manufacturer', id=request.form.get('id')))
    else:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT id, name FROM manufacturer ORDER BY name ASC")
        manufacturers = cursor.fetchall()
        if manufacturers is None:
            out = []
        else:
            out = [[str(item[0]), str(item[1])] for item in manufacturers]
        
        return render_template("manufacturers.html", manufacturers=out, title='Manufacturers')
                
@app.route("/manufacturer/<id>")
def manufacturer(id=None):
    conn = mysql.connect()
    cursor = conn.cursor()
    try:
        id = int(id) #id number - database id
        cursor.execute("SELECT alias FROM manufacturer WHERE id={0}".format(id))
        _manufacturer=cursor.fetchone()
        return redirect(request.url.replace('/manufacturer/{0}'.format(id), '/manufacturer/{0}'.format(_manufacturer[0].lower().strip().replace(' ', '_'))))
    except ValueError: # id is not an int, ie: redirect worked
        # find the manufacturers details
        cursor.execute("SELECT * FROM manufacturer WHERE alias='{0}'".format(id))
        _manufacturer=cursor.fetchone()
        
        # find all models currently held for this manufacturer
        cursor.execute("SELECT * FROM brand WHERE manufacturer_id='{0}'".format(_manufacturer[0]))
        _brands=cursor.fetchall()
        
        _logo = url_for('static', filename='images/manufacturers/{0}.jpg'.format(_manufacturer[2]))
        if not os.path.isfile(APP_ROOT + _logo):
            _logo = None
    except: # if all else fails
        abort(404)        

    if _manufacturer is None:
        return "NONE!"
    else:
        return render_template("manufacturer.html", manufacturer=_manufacturer, title=_manufacturer[1], brands=_brands, logo=_logo)
  


@app.route("/brands", methods=['GET', 'POST'])
def brands():
    if request.method == "POST":
        return redirect(url_for('brand', id=request.form.get('id')))
    else:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT id, name FROM brand ORDER BY name ASC")
        brands = cursor.fetchall()
        print (brands)
        if brands is None:
            out = []
        else:
            out = [[str(item[0]), str(item[1])] for item in brands]
        
        return render_template("brands.html", brands=out, title='NZ Radio Brands')
                

'''
brand(id) takes an id which is either numeric or a string.
brands() passes it an int, taken from the brand table in the
db which is converted to a string in the 'try' section in
order to make a tidy url.  It then runs again with the string
type id and the lookup is done.  There may be a tidier way to
do this...
'''
@app.route("/brand/<id>")
def brand(id=None):
    conn = mysql.connect()
    cursor = conn.cursor()
    try:
        id = int(id) #id number - database id
        cursor.execute("SELECT alias FROM brand WHERE id={0}".format(id))
        _brand=cursor.fetchone()
        return redirect(request.url.replace('/brand/{0}'.format(id), '/brand/{0}'.format(_brand[0].lower().strip().replace(' ', '_'))))
    except ValueError: # id is not an int, ie: redirect worked
        # find the info for this brand
        cursor.execute("SELECT * FROM brand WHERE alias='{0}'".format(id))
        _brand=cursor.fetchone()
        print(_brand)
        print()
        
        #find the brand id
        cursor.execute("SELECT id FROM brand WHERE alias='{0}'".format(id))
        brand_id=cursor.fetchone()[0]
        
        # find all models for this brand
        cursor.execute("SELECT DISTINCT number FROM radio WHERE brand_id='{0}'".format(brand_id))
        _models=cursor.fetchall()
        if _models is None:
            _models = []
        else:
            _models = [str(item[0]) for item in _models]
        print(_models)
        print()
        
            
        
        _logo = url_for('static', filename='images/brands/{0}.jpg'.format(_brand[2]))
    except: # if all else fails
        abort(404)        

    if _brand is None:
        return "NONE!"
    else:
        return render_template("brand.html", title=_brand[1], brand=_brand, logo=_logo, models=_models)
  
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

        
@app.route("/uploads", methods=['GET', 'POST'])
def uploads():
    if request.method == "GET":
        return render_template('uploads.html')
    else:
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

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404


if __name__ == "__main__":
    app.run(debug=True)
