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
from flask_wtf import FlaskForm
from wtforms import StringField, IntegerField, BooleanField, TextAreaField, SelectField, FileField
from wtforms.validators import ValidationError, DataRequired, NumberRange, Optional, Regexp
from werkzeug.utils import secure_filename
from PIL import Image

APP_ROOT = os.path.dirname(os.path.abspath(__file__))

# TODO: change this and app key to something secure that wasn't
# used during development :)
WTF_CSRF_ENABLED = True
WTF_CSRF_SECRET_KEY = "saycheese"

# app config
app = Flask(__name__)
# TODO: change this to something secure
app.secret_key = "smile"

# site config
app.config['MAX_CONTENT_LENGTH'] = 8 * 1024 * 1024 # 8Mb upload limit
app.config['UPLOAD_FOLDER'] = os.path.join('static', 'images')
ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])

# MySQL config
mysql = MySQL(cursorclass=DictCursor)
app.config['MYSQL_DATABASE_USER'] = 'nzvr_db'
app.config['MYSQL_DATABASE_PASSWORD'] = 'password'
app.config['MYSQL_DATABASE_DB'] = 'nzvr_db'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app) 

app.logger.debug('NZVRS Website Starting Up...')


# check upload is a file and has an allowed extension
def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

'''
Web data entry
'''
class DistributorForm(FlaskForm):
    name = StringField('name', validators=[DataRequired()])
    alias = StringField('alias', validators=[DataRequired()])
    address = StringField('address', validators=[DataRequired()])
    nz_wide = BooleanField('nz_wide', default=False)
    notes = TextAreaField('notes', validators=[DataRequired()])
    
'''
SITE LOGIC
'''
@app.route("/")
@app.route("/<id>") #simple search
@app.route("/home")
def index(id=None):
    results = None
    if id: # super simple model search
        results = query_db("SELECT brand_id, code, variant FROM model WHERE code='{0}' OR variant='{0}'".format(id))
        if not results or len(results) == 0:
            abort(404)
        elif len(results) == 1:
            brand = query_db("SELECT alias FROM brand WHERE id='{0}'".format(results[0]['brand_id']), single=True) 
            return redirect(url_for('model', brand=brand['alias'], code=results[0]['code'], variant=results[0]['variant']))
        else:
            search_results = []
            for result in results:
                search_results.append([query_db("SELECT alias FROM brand WHERE id='{0}'".format(result['brand_id']), single=True)['alias'], result['code'], result['variant']])
            return render_template("search.html", title='Search Results', search_results=search_results, search_term=id)
        
    # And if you just wanted the home page...
    return render_template('index.html', title='Welcome')


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
        # find the db-ready path to the images, strip any trailing slash
        image_root = os.path.relpath(path, APP_ROOT + url_for("static", filename = ''))
        # this should be ['images','model', brand, code, <variant?>]
        # so the indexes are: 0       1       2      3        4?  (len 4 or 5)
        folder_names = image_root.split(os.sep)
        if len(folder_names) != 4 and len(folder_names) != 5:
            flash("{0}:image folder layout problem, contact admin, cry a little bit".format(folder_names), 'error')
            abort(500)
        variant = folder_names[4] if len(folder_names) == 5 else None
        code = folder_names[3]
        brand = folder_names[2]
        # find the model id for the photos (yuk!)
        model = query_db("SELECT id FROM model WHERE LOWER(code='{0}') {1} AND brand_id=(SELECT id FROM brand WHERE LOWER(alias='{2}'))".format(code, "AND LOWER(variant='{0}')".format(variant) if variant else 'AND variant IS NULL', brand), single=True)
        print("SELECT id FROM model WHERE LOWER(code='{0}') {1} AND brand_id=(SELECT id FROM brand WHERE LOWER(alias='{2}'))".format(code, "AND LOWER(variant='{0}')".format(variant) if variant else 'AND variant IS NULL', brand))
        print(model, code, variant, brand)
        if not model or len(model) == 0:
            flash("No record held for a {0} {1} by {2}".format(code, variant if variant else '', brand))
            abort(500)
        
        for image_file in files:
            img = Image.open(image_file)
            img.thumbnail((200,200), Image.ANTIALIAS)
            _, filename = os.path.split(image_file)
            img.save(os.path.join(thumbs, filename), quality=95)
            
            # insert into images db if not already there
            check_existing = query_db("SELECT id FROM images WHERE filename='{0}' AND type=1 AND type_id={1}".format(filename, model['id']), single=True)
            conn = mysql.connect()
            cursor = conn.cursor()
            if not check_existing:
                query = "INSERT INTO images (title, filename, type, type_id) VALUES ('{0}', '{1}', {2}, {3})".format((brand.title() + ' ' + variant.title()) if variant else (brand.title() + ' ' + code.title()), filename, 1, model['id'])
                cursor.execute(query)
                conn.commit()
        flash('Images added successfully')
        return redirect('/model/import_photos')
    
    # GET
    else:
        photo_root = APP_ROOT + url_for("static", filename="images/model")
        _directories = []
        for root, dirs, files in os.walk(photo_root):
            level = root.replace(photo_root, '').count(os.sep)
            indent = '---' * (level)
            _directories.append(('{0} {1}/'.format(indent, os.path.basename(root)), os.path.abspath(root)))
        #print (_directories)
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
        _brand = brand.replace(' ', '_').strip().lower()
        _code = code.replace(' ', '_').strip().lower()
        _variant = variant.replace(' ', '_').strip().lower() if variant else None
        if variant:
            return redirect(request.url.replace('/model/{0}/{1}/{2}'.format(brand, code, variant), '/model/{0}/{1}/{2}'.format(_brand, _code, _variant)))
        else:
            return redirect(request.url.replace('/model/{0}/{1}'.format(brand, code), '/model/{0}/{1}'.format(_brand, _code)))
    
    # for the purpose of db queries, convert '_' back to ' '
    brand = brand.replace('_', ' ').strip().lower()
    code = code.replace('_', ' ').strip().lower()
    variant = variant.replace('_', ' ').strip().lower() if variant else None
    
    # find the db's id for the brand name
    result = query_db("SELECT id, manufacturer_id, distributor_id FROM brand WHERE alias='{0}'".format(brand), single=True)
    _brand = result['id']
    _manufacturer = result['manufacturer_id']
    _distributor = result['distributor_id']
    
    # find the db's id for the radio model number
    if variant:
        result = query_db("SELECT id FROM model WHERE LOWER(code='{0}') AND variant='{1}'".format(code, variant), single=True)
    else:
        result = query_db("SELECT id FROM model WHERE LOWER(code='{0}') AND LOWER(brand_id='{1}')".format(code, _brand), single=True)
    if not result: # check to make sure a model was found
        abort(404)
    model_id = result['id']
    print (model_id)
    # get the variant if specified, or all matching radios
    if variant:
        models = query_db("SELECT * FROM model WHERE brand_id='{0}' AND code='{1}' AND variant='{2}'".format(_brand, code, variant))
    else:
        models = query_db("SELECT * FROM model WHERE brand_id='{0}' AND code='{1}' ORDER BY start_year ASC".format(_brand, code))
    print (models)
    # get the manufacturer and alias (for link)
    result = query_db("SELECT name, alias FROM manufacturer WHERE id='{0}'".format(_manufacturer), single=True)
    manufacturer = result['name']
    manufacturer_alias = result['alias']
    
    # get the distributor and alias (for link)
    distributor = query_db("SELECT name, alias FROM distributor WHERE id='{0}'".format(_distributor), single=True)
    
    # get the images related to the radio (or primary image for each variant). type=1 means model images
    if len(models) > 1:
        images = []
        for model in models:
            images.append(query_db("SELECT filename FROM images WHERE rank=1 AND type=1 AND type_id={0}".format(model['id']))[0])
            images[-1]['variant'] = model['variant'].lower()
        
    else: # get all the images for the single model
        images = query_db("SELECT title, filename, rank FROM images WHERE type=1 AND type_id={0} ORDER BY rank ASC".format(model_id))
    
    # build image and thumb paths
    # didn't use url_for for static due to stupid slashes it adds
    # TODO: eventually have this automate the import process or at least thumbs
    for image in images:
        _variant = variant if not 'variant' in image else image['variant']
        thumbfile = os.path.join(os.sep, 'static', 'images', 'model', brand, code, (_variant if _variant else ''), 'thumbs', image['filename'])
        imgfile = os.path.join(os.sep, 'static', 'images', 'model', brand, code, _variant if _variant else '', image['filename'])
        image['filename'] = imgfile
        image['thumb'] = thumbfile if os.path.exists(APP_ROOT + thumbfile) else imgfile
        
    title = brand + ' ' + code if not code.isnumeric() else brand + ' model ' + code
    
    # highlight the valves in the lineup
    # TODO: make this more efficient, its hideous on long valve lineup lines
    # and also appears to try matching blank lines
    lineup = models[0]['valve_lineup']
    if lineup:
        pos = len(lineup) -1
        while pos >= 0:
            end = pos
            while pos >= 0 and lineup[pos].isalnum(): 
                pos -= 1
            valve = query_db("SELECT name, filename, type FROM valve WHERE name='{0}'".format(lineup[pos+1:end+1].strip()), single=True)
            if valve and valve['name'] in lineup[pos+1:end+1]:
                lineup = lineup[:pos+1] + '<a class="valves" title="' + valve['type'] + '" href="/static/images/valves/' + valve['filename'] + '">' + valve['name'] + '</a>' + lineup[end+1:]
            pos -= 1
        models[0]['valve_lineup'] = lineup
    
    return render_template("model.html", models=models, title=title, brand=brand, manufacturer=manufacturer, manufacturer_alias=manufacturer_alias, distributor=distributor, code=code, variant=variant, images=images)


    
@app.route("/brands", methods=['GET', 'POST'])
def brands():
    if request.method == "POST":
        return redirect(url_for('brand', alias=request.form.get('id')))
    else:
        brands = query_db("SELECT alias, name FROM brand ORDER BY name ASC")
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
    
    _brand['notes'] = strip_outer_p_tags(_brand['notes'])
        
    # find the manufacturer
    _manufacturer = query_db("SELECT name, alias FROM manufacturer WHERE id={0}".format(_brand['manufacturer_id']), single=True)
    
    # find all models for this brand
    _models = (query_db("SELECT DISTINCT start_year, code FROM model WHERE brand_id='{0}' ORDER BY start_year ASC".format(_brand['id'])))
    
    _logo = url_for('static', filename='images/brands/{0}.jpg'.format(_brand['alias']))     
    if not os.path.isfile(APP_ROOT + _logo):
        _logo = None 
        
    return render_template("brand.html", title=_brand['name'], brand=_brand, manufacturer=_manufacturer, logo=_logo, models=_models)
  
class ManufacturerForm(FlaskForm):
    def check_year_range(form, field):
        print(field.name)
        if field.data:
            if field.data < form.year_started.data:
                raise ValidationError('A manufacturer can not end manufacturing before it starts...')
    
    def check_existing(form, field):
        query = query_db("SELECT id FROM manufacturer WHERE {0}='{1}'".format(field.name, field.data), single=True)
        if query:
            raise ValidationError('{0}: {1} already exists in the database'.format(field.name, field.data))
    
    name = StringField('name', validators=[DataRequired(), check_existing])
    alias = StringField('alias', validators=[DataRequired(), check_existing])
    year_started = IntegerField('start', validators=[Optional(), NumberRange(min=1800, max=2017)], default=None)
    year_started_approx = BooleanField('start_appr', default=False)
    year_ended = IntegerField('end', validators=[Optional(), NumberRange(min=1800, max=2017), check_year_range], default=None)
    year_ended_approx = BooleanField('end_appr', default=False)
    address = StringField('address', validators=[Optional()], filters=[lambda x: x or None])
    became = SelectField('became', validators=[Optional()], default=None, coerce=int)
    became_how = SelectField('how', validators=[Optional()], choices=[('', ''), ('merged with', 'Merged'), ('were taken over by', 'Taken Over'), ('sold out to', 'Sold to'), ('rebranded as', 'Rebranded')], default=None)
    notes = TextAreaField('notes', validators=[DataRequired()])
    logo = FileField('logo') #, default=None, validators=[Regexp(r"(^[^/\\]+(\.(?i)(jpg|png|gif))$)")]
    
@app.route('/new') # only here for help
@app.route('/new/<what>', methods=['GET', 'POST'])
@app.route('/edit/<what>/<alias>', methods=['GET', 'POST'])
def edit(what=None, alias=None):
    if what == alias == None: # help
        flash('New what?  Use /new/manufacturer, /new/model etc...', 'error')
        abort(404)
        
    if what != 'manufacturer':
        flash('Only manufacturers thus far...', 'error')
        abort(404)
    
    # Set up the form with a list of manufacturers for 'became'
    manufacturers = query_db("SELECT id, name FROM manufacturer ORDER BY name ASC")
    form = ManufacturerForm()
    form.became.choices = [(man['id'], man['name']) for man in manufacturers]
    form.became.choices.insert(0, (0, ''))
        
    if form.validate_on_submit():
        print("+++++++++++")
        print(form.logo.data)
        if len(form.logo.data.filename) > 0: # is there a logo submitted
            logo = secure_filename(form.logo.data.filename)
            # is the filename safe?
            if len(logo) > 0:
                # rename the file as the alias so it can be found
                logo = form.alias.data + logo[logo.rfind('.'):]
                #put it in the right place
                logo_path = os.path.join(APP_ROOT, 'static', 'images', 'manufacturers', logo)
                form.logo.data.save(logo_path)
                # now resize to 360x360 
                # TODO: make this more dynamic
                img = Image.open(logo_path)
                img.thumbnail((360,360), Image.ANTIALIAS)
                img.save(logo_path, quality=95)


            else:
                flash("Filename Failed to Format Functionally, Fek!", 'error')
                raise Exception("BUGGER!")

        form.year_started_approx.data = 1 if form.year_started_approx.data else 0
        form.year_ended_approx.data = 1 if form.year_ended_approx.data else 0
        conn = mysql.connect()
        cursor = conn.cursor()
        query = ("INSERT INTO {0} (name, alias, address, year_started, year_started_approx, year_ended, year_ended_approx, became, became_how, notes) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)".format(what))
        query_data = (form.name.data, form.alias.data, form.address.data, form.year_started.data, form.year_started_approx.data, form.year_ended.data, form.year_ended_approx.data, form.became.data, form.became_how.data, form.notes.data)
        try:
            cursor.execute(query, query_data)
            conn.commit()
            flash('added {0} successfully'.format(form.name.data))
            return redirect('manufacturer\{0}'.format(form.alias.data))
        except Exception as e:
            flash(e, 'error')
            filename = None

    else:
        print("DID NOT COMPUTE!")
        filename = None
    
    return render_template('new_manufacturer.html', title='Add New Manufacturer', form=form, filename=filename, edit=True)
            
        
@app.route('/new_distributor', methods=['GET', 'POST'])
def new_distributor():
    form = DistributorForm()
    if form.validate_on_submit():
        address = 'Nationwide' if form.nz_wide.data else form.address.data
        
        conn = mysql.connect()
        cursor = conn.cursor()
        flash('name = {0}'.format(form.name.data))
        query = "INSERT INTO distributor (name, alias, address, notes) VALUES ('{0}', '{1}', '{2}', '{3}')".format(form.name.data, form.alias.data, address, form.notes.data)
        cursor.execute(query)
        conn.commit()
        return redirect('/home')
    else:
        flash("All required sections of the form (marked with an asterisk*) need to be filled in")
    return render_template('new_distributor.html', title='Add New Distributor', form=form)

@app.route("/distributors", methods=['GET', 'POST'])
def view_distributors():
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
def view_distributor(alias=None):
    # find the distributors details
    _distributor=query_db("SELECT * FROM distributor WHERE alias='{0}'".format(alias), single=True)
    if not _distributor:
        abort(404) # Not found

    _distributor['notes'] = strip_outer_p_tags(_distributor['notes'])
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
        
    _manufacturer['notes'] = strip_outer_p_tags(_manufacturer['notes'])
    _new_co = None
    if _manufacturer['became']:
        _new_co = query_db("SELECT name, alias FROM manufacturer WHERE id={0}".format(_manufacturer['became']), single=True)
    # find all models currently held for this manufacturer
    _brands = query_db("SELECT * FROM brand WHERE manufacturer_id='{0}'".format(_manufacturer['id']))

    img_types=['jpg', 'jpeg', 'png', 'gif']
    for img_type in img_types:
        _logo = url_for('static', filename='images/manufacturers/{0}.{1}'.format(_manufacturer['alias'], img_type))
        if os.path.isfile(APP_ROOT + _logo):
            break
        else:
            _logo = None

    if _manufacturer is None:
        return "NONE!"
    else:
        return render_template("manufacturer.html", manufacturer=_manufacturer, title=_manufacturer['name'], new_co=_new_co, brands=_brands, logo=_logo)
 

@app.route("/tech")
def tips():
    return render_template("tech.html", title="Technical Info")
    
@app.route("/publications")
def publications():
    return render_template("publications.html", title="Publications")
    
@app.route("/about")
def about():
    return render_template("about.html", title="About")
    
@app.route("/echo", methods=['POST'])
def echo():
    flash("NOTICE: notification message here", 'message')
    flash("ERROR: " + request.form['text'], 'error')
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
    
# strip enclosing <p> tag if in notes, so that the logo can be
# encapsulated in the main notes paragraph
def strip_outer_p_tags(text): 
    if text[:3] == '<p>':
        text = text[3:]
    if text[-4:] == '</p>':
        text = text[:-4]
    return text


if __name__ == "__main__":
    app.run(debug=True)
