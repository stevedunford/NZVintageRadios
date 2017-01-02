'''
NZ Vintage Radios Site - Steve Dunford steve@dunford.org.nz
Started: December 2016
Current version: 0.00.00.01 - a looong way to go
Based on Flask 0.11
dependencies (pip install): 
 - flask-mysql
 - flask-login   TODO: email address login - do away with login
 - flask-uploads TODO: IS this needed?
 - PIL (Pillow) for images
GitHub: github.com/stevedunford/NZVintageRadios
Licence: Beerware.  I need a beer, you need a website - perfect
'''

import glob, os # for file upload path determination and images
import errno
from flask import Flask, flash, session, request, render_template_string, render_template, redirect, url_for, g, abort
from flaskext.mysql import MySQL
from pymysql.cursors import DictCursor
from flask_wtf import Form
from wtforms import StringField, BooleanField, TextAreaField
from wtforms.validators import DataRequired
from PIL import Image

APP_ROOT = os.path.dirname(os.path.abspath(__file__))

WTF_CSRF_ENABLED = True
SECRET_KEY = 'uxjSShEJs}jbMSW\x80hMl\x80Yq1VFz\x82Wpg{y||GyYAXISqSJBFt\x83w}Y\x80E`AVTFQyhsKiGCVzoIROIRC\x81\x83\x82n]zCw`]ZYwZw`PO{UDPGiGH'

# app config
app = Flask(__name__)
app.secret_key = '}g\x83^jSvlazDyhxHCV^YUXw\\crxOddpw~\x83Q\x80eP|ZZqOSBcO\x80IGvlphvZkqCcv~\x7foJJHgYou|]rxvSDZN\x82OIo{Qis55N}Mo\x7fJK\x80G|Hdt'

# MySQL config
mysql = MySQL(cursorclass=DictCursor)
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


@app.route("/model/import_photos", methods=['GET', 'POST'])
def import_photos():
    if request.method == 'POST':
        path = request.form.get('path')
        files=[photo for photo in os.listdir(path) if photo[-4:].lower() == ".jpg" or photo[-4:].lower() == ".png"]
        thumbs = os.path.join(path, 'thumbs')
        try:
            os.mkdir(thumbs)
        except OSError as exception:
            if exception.errno != errno.EEXIST:
                abort(500)
        
        # get all the allowed image types (jpg and png) and make thumbnails
        files = glob.glob(os.path.join(path, '*.jpg'))
        files.extend(glob.glob(os.path.join(path, '*.png')))
        image_root = os.path.relpath(path, APP_ROOT + url_for("static", filename = ''))
        for image_file in files:
            img = Image.open(image_file)
            img.thumbnail((150,150))
            _, filename = os.path.split(image_file)
            img.save(os.path.join(thumbs, filename))
            
            # insert into images db if not already there
            model = query_db("SELECT id FROM model WHERE code='{0}'".format())
            conn = mysql.connect()
            cursor = conn.cursor()
            #query = "INSERT INTO images (name, path, type, type_id) VALUES ('{0}', '{1}', {2}, {3})".format(image_file.split('.')[0], )
            #cursor.execute(query)
            #conn.commit()
        
        return redirect('/model/import_photos')
    
    else:
        photo_root = APP_ROOT + url_for("static", filename="images/model")
        _directories = []
        for root, dirs, files in os.walk(photo_root):
            level = root.replace(photo_root, '').count(os.sep)
            indent = '---' * (level)
            _directories.append(('{0} {1}/'.format(indent, os.path.basename(root)), os.path.abspath(root)))
       
        return render_template("import_photos.html", directories=_directories)

    
'''
model   - this is a radio information page
brand   - the brand of radio, eg: Pacific Radio Co. Ltd, or Clipper
code    - the model number or chassis number, eg: 18, 6 Valve Dual Wave, or 5M4
variant - the cabinet style or model nickname, eg: Raleigh, Elite, Tiki

no brand, code or variant can contain an underscore due to this being used
to replace spaces for www url rules stating urls can't have spaces (FF handles
this gracefully, chrome currently replaces them with %20 which is not very
readable)
'''
@app.route("/model/<brand>/<code>")
@app.route("/model/<brand>/<code>/<variant>")
def model(brand, code, variant=None):
    # if spaces then reroute to the proper version
    if brand.strip().count(' ') > 0 or code.strip().count(' ') > 0 or (variant.strip().count(' ') > 0 if variant else False):
        brand = brand.replace(' ', '_').strip().lower()
        code = code.replace(' ', '_').strip().lower()
        variant = variant.replace(' ', '_').strip().lower() if variant else None
        print(brand, code, variant)
        return model(brand, code, variant)
    
    # for the purpose of db queries, convert '_' back to ' '
    brand = brand.replace('_', ' ').strip().lower()
    code = code.replace('_', ' ').strip().lower()
    variant = variant.replace('_', ' ').strip().lower() if variant else None
    
    # find the db's id for the brand name
    result = query_db("SELECT id, manufacturer_id FROM brand WHERE alias='{0}'".format(brand), single=True)
    _brand = result['id']
    _manufacturer = result['manufacturer_id']
    
    # find the db's id for the radio model number
    if variant:
        result = query_db("SELECT id FROM model WHERE LOWER(code='{0}') AND variant='{1}'".format(code, variant), single=True)
    else:
        result = query_db("SELECT id FROM model WHERE LOWER(code='{0}')".format(code), single=True)
    print("----")
    print(result, code, variant)
    print("----")
    if not result: # check to make sure a model was found
        abort(404)
    model_id = result['id']
    print("----")
    print(result)
    print("----")
    # get the variant if specified, or all matching radios
    if variant:
        models = query_db("SELECT * FROM model WHERE brand_id='{0}' AND code='{1}' AND variant='{2}'".format(_brand, code, variant))
    else:
        models = query_db("SELECT * FROM model WHERE brand_id='{0}' AND code='{1}'".format(_brand, code))
    
    # get the manufacturer and alias (for link)
    result = query_db("SELECT name, alias FROM manufacturer WHERE id='{0}'".format(_manufacturer), single=True)
    manufacturer = result['name']
    manufacturer_alias = result['alias']
    
    # get the images related to the radio (or primary image for each variant). type=1 means model images
    if len(models) > 1:
        images = []
        for mod in models:
            images.append(query_db("SELECT path FROM images WHERE rank=1 AND type=1 AND type_id={0}".format(mod['id']))[0])
        
    else: # get all the images for the single model
        images = query_db("SELECT name, path, rank FROM images WHERE type=1 AND type_id={0} ORDER BY rank ASC".format(model_id))
    
    # manually add thumbnail paths
    for image in images:
        path, filename = os.path.split(image['path'])
        image['thumb'] = os.path.join(path, 'thumbs', filename)
        
    return render_template("model.html", models=models, title=brand+' '+code, brand=brand, manufacturer=manufacturer, manufacturer_alias=manufacturer_alias, code=code, variant=variant, images=images)


    
@app.route("/brands", methods=['GET', 'POST'])
def brands():
    if request.method == "POST":
        return redirect(url_for('brand', alias=request.form.get('id')))
    else:
        brands = query_db("SELECT alias, name FROM brand ORDER BY name ASC")
        print (brands)
        if brands is None:
            out = []
        else:
            out = [[str(item['alias']), str(item['name'])] for item in brands]
        
        return render_template("brands.html", brands=out, title='NZ Radio Brands')
                

'''
brand(alias) takes the alias for a brand and passes all the data for that brand and its logo - as well as all of the documented models for that brand - to brand.html 
'''
@app.route("/brand/<alias>")
def brand(alias=None):
    # find the info for this brand
    _brand = query_db("SELECT * FROM brand WHERE alias='{0}'".format(alias), single=True)
    if not _brand:
        abort(404) # Not found
        
    # find the brand id
    brand_id = (query_db("SELECT id FROM brand WHERE alias='{0}'".format(alias), single=True))['id']

    # find all models for this brand
    _models = (query_db("SELECT DISTINCT start_year, code FROM model WHERE brand_id='{0}'".format(brand_id)))
    
    _logo = url_for('static', filename='images/brands/{0}.jpg'.format(_brand['alias']))     
    if not os.path.isfile(APP_ROOT + _logo):
        _logo = None 
        
    return render_template("brand.html", title=_brand['name'], brand=_brand, logo=_logo, models=_models)
  

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
        return redirect(url_for('distributor', alias=request.form.get('id')))
    else:
        distributors = query_db("SELECT alias, name FROM distributor ORDER BY name ASC")
        if distributors is None:
            out = []
        else:
            out = [[str(item['alias']), str(item['name'])] for item in distributors]
        
        return render_template("distributors.html", distributors=out, title='Distributors')
                
@app.route("/distributor/<alias>")
def distributor(alias=None):
    # find the distributors details
    _distributor=query_db("SELECT * FROM distributor WHERE alias='{0}'".format(alias), single=True)
    if not _distributor:
        abort(404) # Not found

    # find all models currently sold by this distributor
    _distributor_id = (query_db("SELECT id FROM distributor WHERE alias='{0}'".format(alias), single=True))['id']
    _brands = query_db("SELECT alias, name FROM brand WHERE distributor_id='{0}'".format(_distributor_id))

    _logo = url_for('static', filename='images/distributors/{0}.jpg'.format(_distributor['alias']))
    if not os.path.isfile(APP_ROOT + _logo):
        _logo = None       

    return render_template("distributor.html", distributor=_distributor, title=_distributor['name'], brands=_brands, logo=_logo)



@app.route("/manufacturers", methods=['GET', 'POST'])
def manufacturers():
    if request.method == "POST":
        return redirect(url_for('manufacturer', alias=request.form.get('id')))
    else:
        manufacturers = query_db("SELECT name, alias FROM manufacturer ORDER BY name ASC")
        if manufacturers is None:
            out = []
        else:
            out = [[str(item['name']), str(item['alias'])] for item in manufacturers]
        
        return render_template("manufacturers.html", manufacturers=out, title='Manufacturers')
                
@app.route("/manufacturer/<alias>")
def manufacturer(alias=None):
    _manufacturer = query_db("SELECT * FROM manufacturer WHERE alias='{0}'".format(alias), single=True)
    if not _manufacturer:
        abort(404) # Not found
        
    _new_co = None
    if _manufacturer['became']:
        _new_co = query_db("SELECT name, alias FROM manufacturer WHERE id={0}".format(_manufacturer['became']), single=True)
    # find all models currently held for this manufacturer
    _brands = query_db("SELECT * FROM brand WHERE manufacturer_id='{0}'".format(_manufacturer['id']))

    _logo = url_for('static', filename='images/manufacturers/{0}.jpg'.format(_manufacturer['alias']))
    if not os.path.isfile(APP_ROOT + _logo):
        _logo = None     

    if _manufacturer is None:
        return "NONE!"
    else:
        return render_template("manufacturer.html", manufacturer=_manufacturer, title=_manufacturer['name'], new_co=_new_co, brands=_brands, logo=_logo)
 

@app.route("/tips")
def tips():
    return render_template("tips.html", title="Tips & Tricks")
    
@app.route("/publications")
def publications():
    return render_template("publications.html", title="Publications")
    
@app.route("/about")
def about():
    return render_template("about.html", title="About")
    
@app.route("/echo", methods=['POST'])
def echo():
    flash("You should see a nice green message here", 'message')
    flash(request.form['text'], 'error')
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
    return render_template('404.html', title="404"), 404

@app.errorhandler(500)
def server_broke(e):
    return render_template('500.html', title="Server Error"), 500


def query_db(query, single=False):
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute(query)
    result = cursor.fetchone() if single else cursor.fetchall()
    return result
    


if __name__ == "__main__":
    app.run(debug=True)
