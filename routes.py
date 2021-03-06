'''
NZ Vintage Radios Site - Steve Dunford steve@dunford.org.nz
Started: December 2016
Current version: 0.00.00.01 - a looong way to go
Based on Flask 0.11
dependencies (pip install):
 - flask-wtf
 - flask-mysql
 - flask-login   TODO: email address login - do away with login
 - flask-uploads TODO: IS this needed?
 - Pillow for images
GitHub: github.com/stevedunford/NZVintageRadios
Licence: Beerware.  I need a beer, you need a website - perfect
'''

import glob, os # for file upload path determination and images
import errno
from flask import Flask, flash, session, request, render_template_string, render_template, redirect, url_for, g, abort
from flaskext.mysql import MySQL
from pymysql.cursors import DictCursor
from flask_wtf import FlaskForm
from wtforms import StringField, IntegerField, BooleanField, TextAreaField, SelectField, FileField, FieldList
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


# so debug is available in templates as a 'flag' to show debug info
@app.context_processor
def inject_debug():
    return dict(debug=app.debug)


# Web data entry
class DistributorForm(FlaskForm):
    name = StringField('name', validators=[DataRequired()])
    alias = StringField('alias', validators=[DataRequired()])
    address = StringField('address', validators=[DataRequired()])
    nz_wide = BooleanField('nz_wide', default=False)
    notes = TextAreaField('notes', validators=[DataRequired()])


# basic search function - I'm so dreadfully embarrassed
def search_results(id):
    # check for models
    search = query_db("SELECT brand_id, code FROM model WHERE code='{0}'".format(id))
    if not search or len(search) == 0:
        # no models, look for brands - code gettin' ugly now
        search = query_db("SELECT alias FROM brand WHERE alias='{0}'".format(id))
        if len(search) != 1: # omg, really?! nesting!
            search = query_db("SELECT alias FROM manufacturer WHERE alias='{0}'".format(id))
            if len(search) != 1:
                abort(404) # about time!
            else:
                search_results = (url_for('manufacturer', alias=id))
        else:
            search_results = (url_for('brand', alias=id))

    elif len(search) == 1 and search[0]['brand_id'] != 0:
        search_results = url_for('model', brand=query_db("SELECT alias FROM brand WHERE id='{0}'".format(search[0]['brand_id']), single=True)['alias'], code=id)
    else:
        search_results = []
        for result in search:
            if result['brand_id'] != 0:
                search_results.append([query_db("SELECT alias FROM brand WHERE id='{0}'".format(result['brand_id']), single=True)['alias'], result['code']])
    return search_results


# SITE LOGIC
# ----------
@app.route("/")
@app.route("/<id>")  # simple search
@app.route("/home")
def index(id=None):
    if id: # super simple model search
        results = search_results(id)
        if type(results) == list: # several results matching
            return render_template("search.html", title='Search Results', search_results=results, search_term=id)
        else: # one result, go straight there
            return redirect(results)

    # And if you just wanted the home page...
    return render_template('index.html', title='Welcome')


def make_dir(path):
    try:
        os.makedirs(path) #makedirs is recursive
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            return False
    return True


@app.route("/photoimport/<source>", methods=['GET', 'POST'])
def import_photos(source="model"):
    if request.method == 'POST':
        path = request.form.get('path')
        files=[photo for photo in os.listdir(path) if photo[-4:].lower() == ".jpg" or photo[-4:].lower() == ".png"]
        thumbs = os.path.join(path, 'thumbs')
        lowres  = os.path.join(path, 'lowres')
        if not make_dir(thumbs):
            abort(500)
        if not make_dir(lowres):
            abort(500)
        
        # get all the allowed image types (jpg and png) and make thumbnails
        files = glob.glob(os.path.join(path, '*.jpg'))
        files.extend(glob.glob(os.path.join(path, '*.png')))
        # find the db-ready path to the images, strip any trailing slash
        image_root = os.path.relpath(path, APP_ROOT + url_for("static", filename = ''))
        # this should be ['images','model', brand, code>]
        # so the indexes are: 0       1       2      3  (len 4)
        folder_names = image_root.split(os.sep)
        if len(folder_names) != 4:
            flash("{0}:image folder layout problem, contact admin, cry a little bit".format(folder_names), 'error')
            abort(500)
        code = folder_names[3]
        brand = folder_names[2] # brand doubles as manufacturer for chassis
        # find the model id for the photos (yuk!)
        if source == "models":
            model = query_db("SELECT id FROM model WHERE LOWER(code='{0}') AND brand_id=(SELECT id FROM brand WHERE LOWER(alias='{1}'))".format(code, brand), single=True)
        else: # its a chassis, so brand is actually manufacturer
            model = query_db("SELECT id FROM model WHERE LOWER(code='{0}') AND brand_id=(SELECT id FROM manufacturer WHERE LOWER(alias='{1}'))".format(brand+' '+code, brand), single=True)

        if not model or len(model) == 0:
            flash("No record held for a {0} by {1}".format(code, brand))
            abort(500)
        
        for image_file in files:
            thumb = Image.open(image_file)
            thumb.thumbnail((200,200), Image.ANTIALIAS)
            _, filename = os.path.split(image_file)
            thumb.save(os.path.join(thumbs, filename), quality=95)
            small = Image.open(image_file)
            small.thumbnail((800,800), Image.ANTIALIAS)
            _, filename = os.path.split(image_file)
            small.save(os.path.join(lowres, filename), quality=75)
            
            # insert into images db if not already there
            check_existing = query_db("SELECT id FROM images WHERE filename='{0}' AND type=1 AND type_id={1}".format(filename, model['id']), single=True)
            conn = mysql.connect()
            cursor = conn.cursor()
            if not check_existing:
                query = "INSERT INTO images (title, filename, type, type_id) VALUES ('{0}', '{1}', {2}, {3})".format(brand.title() + ' ' + code.title(), filename, 1, model['id'])
                cursor.execute(query)
                conn.commit()
        flash('Images added successfully')
        return redirect('/all')
    
    # ['GET']
    else:
        if source == "models":
            import_type = "/photoimport/models"
        elif source == "chassis":
            import_type = "/photoimport/chassis"
        else:
            flash("Either models or chassis - nothing else will do")
            abort(404)
        photo_root = APP_ROOT + url_for("static", filename="images/models" if source == "models" else "images/chassis")
        _directories = []
        for root, dirs, files in os.walk(photo_root):
            level = root.replace(photo_root, '').count(os.sep)
            indent = '---' * (level)
            _directories.append(('{0} {1}/'.format(indent, os.path.basename(root)), os.path.abspath(root)))
        #print (_directories)
        return render_template("import_photos.html", import_type=import_type, directories=_directories)


# MODEL - this is a radio information page
@app.route("/model/<brand>/<code>")
@app.route("/model/<brand>/<code>/<nickname>")
@app.route("/model/<brand>/<code>/<edit>")
@app.route("/model/<brand>/<code>/<nickname>/<edit>")
def model(brand, code, nickname=None, edit=False):
    edit = True if edit == "edit" else False
    # if spaces then reroute to the proper version
    if brand.strip().count(' ') > 0 or code.strip().count(' ') > 0:
        _brand = brand.replace(' ', '_').strip().lower() #TODO Check this works with strip not being first
        _code = code.replace(' ', '_').strip().lower()
        _nickname = nickname.replace(' ', '_').strip().lower() if nickname else None
        return redirect(request.url.replace('/model/{0}/{1}'.format(brand, code), '/model/{0}/{1}'.format(_brand, _code)))
    
    # for the purpose of image paths, lower case and convert '_' back to ' '
    brand = brand.replace('_', ' ').strip().lower()
    code = code.replace('_', ' ').strip().lower()
    nickname = nickname.replace('_', ' ').strip().lower() if nickname else None
    print(brand, code, nickname) # DEBUG
    
    # find the brand name id
    result = query_db("SELECT id, manufacturer_id, distributor_id FROM brand WHERE alias='{0}'".format(brand), single=True)
    brand_id = result['id']
    manufacturer_id = result['manufacturer_id']
    distributor_id = result['distributor_id']
    
    # find the radio model and chassis info if pertinent
    if nickname:
        model = query_db("SELECT * FROM model WHERE code='{0}' AND nickname='{1}' AND brand_id='{2}'".format(code, nickname, brand_id), single=True)
    else:
        model = query_db("SELECT * FROM model WHERE code='{0}' AND brand_id='{1}'".format(code, brand_id), single=True)
    if not model: # check to make sure a model was found
        abort(404)
    chassis = query_db("SELECT * FROM chassis WHERE id={0}".format(model['chassis_id']), single=True)

    # get the manufacturer and alias (for link)
    manufacturer = query_db("SELECT name, alias FROM manufacturer WHERE id='{0}'".format(manufacturer_id), single=True)
    
    # get the distributor and alias (for link)
    distributor = query_db("SELECT name, alias FROM distributor WHERE id='{0}'".format(distributor_id), single=True)
    
    # get all other listed models with this chassis
    other_models = query_db("SELECT code, brand_id, start_year FROM model where chassis_id={0}".format(model['chassis_id']))
    for other_model in other_models:
        other_model['brand'] = query_db("SELECT name FROM brand WHERE id={0}".format(other_model['brand_id']), single=True)['name']

    # get all the images for the model
    images = query_db("SELECT title, filename, rank, is_schematic, attribution FROM images WHERE type=1 AND type_id={0} ORDER BY rank ASC".format(model['id']))
    chassis_images = query_db("SELECT title, filename, rank, is_schematic, attribution FROM images WHERE type=2 AND type_id={0} ORDER BY rank ASC".format(chassis['id']))

    # build image and thumb paths
    # didn't use url_for for static due to stupid slashes it adds
    # TODO: eventually have this automate the import process or at least thumbs
    for image in images:
        if nickname:
            thumbfile = os.path.join(os.sep, 'static', 'images', 'models', brand, code, nickname, 'thumbs', image['filename'])
            smallimage = os.path.join(os.sep, 'static', 'images', 'models', brand, code, nickname, 'lowres', image['filename'])
            imgfile = os.path.join(os.sep, 'static', 'images', 'models', brand, code, nickname, image['filename'])
        else:
            thumbfile = os.path.join(os.sep, 'static', 'images', 'models', brand, code, 'thumbs', image['filename'])
            smallimage = os.path.join(os.sep, 'static', 'images', 'models', brand, code, 'lowres', image['filename'])
            imgfile = os.path.join(os.sep, 'static', 'images', 'models', brand, code, image['filename'])
        # If low-bandwidth mode is set, use lowres images not full unless its a schematic
        if get_fullres() or image['is_schematic']:
            image['filename'] = imgfile
        else: # but only use them if they're there
            image['filename'] = smallimage if os.path.exists(APP_ROOT + smallimage) else imgfile
        image['thumb'] = thumbfile if os.path.exists(APP_ROOT + thumbfile) else imgfile
        print("\n\n{0}".format(image)) # DEBUG
    for image in chassis_images:
        thumbfile = os.path.join(os.sep, 'static', 'images', 'chassis', manufacturer['alias'], code, 'thumbs', image['filename'])
        smallimage = os.path.join(os.sep, 'static', 'images', 'chassis', manufacturer['alias'], code, 'lowres', image['filename'])
        imgfile = os.path.join(os.sep, 'static', 'images', 'chassis', manufacturer['alias'], code, image['filename'])
        # If low-bandwidth mode is set, use lowres images not full unless its a schematic
        if get_fullres() or image['is_schematic']:
            image['filename'] = imgfile
        else:  # but only use them if they're there
            image['filename'] = smallimage if os.path.exists(APP_ROOT + smallimage) else imgfile
        image['thumb'] = thumbfile if os.path.exists(APP_ROOT + thumbfile) else imgfile

    title = brand + ' ' + code if not code.isnumeric() else brand + ' model ' + code
    
    # highlight the valves in the lineup
    # TODO: make this more efficient if possible, its hideous on long valve lineup lines (0.33s for bell colt page)
    # and also appears to try matching blank lines
    lineup = chassis['valve_lineup']
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
        model['valve_lineup'] = lineup

    model['if'] = chassis['if_peak']
    
    model['notes'] = strip_outer_p_tags(model['notes'])
    chassis['notes'] = strip_outer_p_tags(chassis['notes'])
    model['chassis_notes'] = chassis['notes']

    print("-----------\n",edit,"\n------------")
    return render_template("model.html", model=model, other_models=other_models, title=title, brand=brand, manufacturer=manufacturer, distributor=distributor, code=code, nickname=nickname, images=images, chassis_images=chassis_images, edit=edit)

    
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
                

# brand(alias) takes the alias for a brand and passes all the data for that brand and its logo
# as well as all of the documented models for that brand - to brand.html
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
    _models = (query_db("SELECT DISTINCT start_year, code, nickname FROM model WHERE brand_id='{0}' ORDER BY start_year ASC".format(_brand['id'])))
    for model in _models:
        model['url'] = url_for('model', brand=_brand['name'], code=model['code'], nickname=model['nickname']).rstrip('/')
        print(model)
    
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
    logo = FileField('logo')  # , default=None, validators=[Regexp(r"(^[^/\\]+(\.(?i)(jpg|png|gif))$)")]


@app.route('/new/manufacturer', methods=['GET', 'POST'])
def new_manufacturer():
    form = ManufacturerForm()
    # Set up the form with a list of manufacturers for 'became'
    manufacturers = query_db("SELECT id, name FROM manufacturer ORDER BY name ASC")
    form.became.choices = [(man['id'], man['name']) for man in manufacturers]
    form.became.choices.insert(0, (0, ''))
        
    if form.validate_on_submit():
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
        print(form.notes.data)
        conn = mysql.connect()
        cursor = conn.cursor()
        query = ("INSERT INTO manufacturer (name, alias, address, year_started, year_started_approx, year_ended, year_ended_approx, became, became_how, notes) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
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
        if request.method == "POST":
            flash("Form failed validation, see the errors posted in red", "error")
        filename = None
    
    return render_template('new_manufacturer.html', title='Add New Manufacturer', form=form, filename=filename, edit=True)
            

class ModelForm(FlaskForm):
    def check_year_range(form, field):
        if field.data:
            if field.data < form.year_started.data:
                raise ValidationError('A model can not end before it begins...')
    
    brand_id = SelectField('brand_id', validators=[Optional()], default=None, coerce=int)
    code = StringField('code', validators=[DataRequired()])
    nickname = StringField('nickname', validators=[Optional()], default=None)
    
    year_started = IntegerField('start', validators=[Optional(), NumberRange(min=1800, max=2017)], default=None)
    year_started_approx = BooleanField('start_appr', default=False)
    year_ended = IntegerField('end', validators=[Optional(), NumberRange(min=1800, max=2017), check_year_range], default=None)
    year_ended_approx = BooleanField('end_appr', default=False)
    
    notes = TextAreaField('notes', validators=[DataRequired()], default="Nothing here...")
    
    manufacturer = SelectField('manufacturer', validators=[Optional()], default=None, coerce=int)
    distributor = SelectField('distributor', validators=[Optional()], default=None, coerce=int)
    chassis_id = SelectField('chassis_id', validators=[Optional()], default=None, coerce=int)
    num_valves = IntegerField('num_valves', validators=[Optional(), NumberRange(min=0, max=127)], default=None) # 0 valves for crystal sets etc
    valve_lineup = StringField('valve_lineup', validators=[Optional()])
    bands = IntegerField('bands', validators=[Optional(), NumberRange(min=1, max=127)], default=None)
    if_peak = StringField('if_peak', validators=[Optional()])     
    chassis_notes = TextAreaField('chassis_notes', validators=[Optional()])


#TODO SORT THIS OUT!  No images yet and no checking around chassis_id (selected from drop down 
# or created from scratch)
@app.route('/new/model', methods=['GET', 'POST'])
def new_model():
    cabinet_id = 1 # Not used at the moment, so id 1 is a default
    form = ModelForm()
    # Set up the form with a list of manufacturers and distributors
    manufacturers = query_db("SELECT id, name FROM manufacturer ORDER BY name ASC")
    distributors = query_db("SELECT id, name FROM distributor ORDER BY name ASC")
    brands = query_db("SELECT id, name FROM brand ORDER BY name ASC")
    chassiss = query_db("SELECT chassis.id, code, manufacturer_id, manufacturer.name FROM chassis INNER JOIN manufacturer on manufacturer.id=chassis.manufacturer_id ORDER BY name, code ASC")

    form.manufacturer.choices = [(man['id'], man['name']) for man in manufacturers]
    form.manufacturer.choices.insert(0, (0, ''))
    form.distributor.choices = [(dis['id'], dis['name']) for dis in distributors]
    form.distributor.choices.insert(0, (0, ''))
    form.brand_id.choices = [(brand['id'], brand['name']) for brand in brands]
    form.brand_id.choices.insert(0, (0, 'Unknown or unlisted brand'))
    form.chassis_id.choices = [(chassis['id'], "{0} --- {1}".format(chassis['name'], chassis['code'])) for chassis in chassiss]
    form.chassis_id.choices.insert(0, (0, 'New chassis - Not here yet...'))
    
    if form.validate_on_submit():
        form.year_started_approx.data = 1 if form.year_started_approx.data else 0
        form.year_ended_approx.data = 1 if form.year_ended_approx.data else 0
        print(form.notes.data)
        conn = mysql.connect()
        cursor = conn.cursor()
        if form.chassis_id.data == 0: # An existing chassis was not selected, so create one
            query = ("INSERT INTO chassis (code, manufacturer_id, start_year, start_year_approx, bands, num_valves, valve_lineup, if_peak, notes) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)")
            query_data = (form.code.data, form.manufacturer.data, form.year_started.data, form.year_started_approx.data, form.bands.data, form.num_valves.data, form.valve_lineup.data, form.if_peak.data, form.chassis_notes.data)
        try:
            cursor.execute(query, query_data)
            conn.commit()
            cursor.execute("SELECT LAST_INSERT_ID() AS id")
            form.chassis_id.data = cursor.fetchone()['id']
            print(form.chassis_id.data) #DEBUG
        except Exception as e:
            flash(e, 'error')
            
        query = ("INSERT INTO model (code, nickname, chassis_id, brand_id, cabinet_id, start_year, start_year_approx, end_year, end_year_approx, notes) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
        query_data = (form.code.data, form.nickname.data, form.chassis_id.data, form.brand_id.data, cabinet_id, form.year_started.data, form.year_started_approx.data, form.year_ended.data, form.year_ended_approx.data, form.notes.data)
        try:
            cursor.execute(query, query_data)
            conn.commit()
            cursor.execute("SELECT LAST_INSERT_ID() AS id")
            newmodel_id = cursor.fetchone()['id']
            flash('added model {0} successfully'.format(form.code.data))
            fail = False
        except Exception as e:
            flash(e, 'error')
            fail = True
        
        # find the brandname and then add any images
        brandname = "unknown"
        for brand in brands:
            if brand['id'] == form.brand_id.data: 
                brandname = brand['name'].lower()
#        for file in form.images.entries:
#            if file is not None and file.data: # each successive failed submit adds 10 more None type image fields... so check for None as well.
#                filename = secure_filename(file.data.filename)
#                path = os.path.abspath(APP_ROOT + url_for("static", filename="images/models/{0}/{1}{2}".format(brandname, form.code.data, '/'+form.nickname.data if form.nickname.data else '')))
#                make_dir(path)
#                file.data.save(os.path.join(path, filename))
        
        if not fail:
            return redirect('/model/{0}/{1}'.format(brandname, form.code.data))

    else:
        if request.method == "POST":
            flash("Form failed validation, see the errors posted in red", "error")
    
    return render_template('new_model.html', title='Add New Model', form=form)
            

def add_photos(photos, brand=None, code=None, nickname=None, manufacturer=None, source="model"):
    if source not in ['model', 'chassis']:
        flash("Either 'model' or 'chassis' - nothing else will do")
        abort(404)
    path = APP_ROOT + url_for("static", filename="images/models/{0}/{1}{2}".format(brand, code, '/'+nickname if nickname else '') if source == "model" else "images/chassis")
        
    files=[photo for photo in photos if photo[-4:].lower() in ['.jpg', '.png']]
    
    # upload the images
    
    
    thumbs = os.path.join(path, 'thumbs')
    lowres  = os.path.join(path, 'lowres')
    if not make_dir(thumbs):
        abort(500)
    if not make_dir(lowres):
        abort(500)

    # get all the allowed image types (jpg and png) and make thumbnails
    files = glob.glob(os.path.join(path, '*.jpg'))
    files.extend(glob.glob(os.path.join(path, '*.png')))
    # find the db-ready path to the images, strip any trailing slash
    image_root = os.path.relpath(path, APP_ROOT + url_for("static", filename = ''))
    # this should be ['images','model', brand, code>]
    # so the indexes are: 0       1       2      3  (len 4)
    folder_names = image_root.split(os.sep)
    if len(folder_names) != 4:
        flash("{0}:image folder layout problem, contact admin, cry a little bit".format(folder_names), 'error')
        abort(500)
    code = folder_names[3]
    brand = folder_names[2] # brand doubles as manufacturer for chassis
    # find the model id for the photos (yuk!)
    if source == "models":
        model = query_db("SELECT id FROM model WHERE LOWER(code='{0}') AND brand_id=(SELECT id FROM brand WHERE LOWER(alias='{1}'))".format(code, brand), single=True)
    else: # its a chassis, so brand is actually manufacturer
        model = query_db("SELECT id FROM model WHERE LOWER(code='{0}') AND brand_id=(SELECT id FROM manufacturer WHERE LOWER(alias='{1}'))".format(brand+' '+code, brand), single=True)

    if not model or len(model) == 0:
        flash("No record held for a {0} by {1}".format(code, brand))
        abort(500)

    for image_file in files:
        thumb = Image.open(image_file)
        thumb.thumbnail((200,200), Image.ANTIALIAS)
        _, filename = os.path.split(image_file)
        thumb.save(os.path.join(thumbs, filename), quality=95)
        small = Image.open(image_file)
        small.thumbnail((800,800), Image.ANTIALIAS)
        _, filename = os.path.split(image_file)
        small.save(os.path.join(lowres, filename), quality=75)

        # insert into images db if not already there
        check_existing = query_db("SELECT id FROM images WHERE filename='{0}' AND type=1 AND type_id={1}".format(filename, model['id']), single=True)
        conn = mysql.connect()
        cursor = conn.cursor()
        if not check_existing:
            query = "INSERT INTO images (title, filename, type, type_id) VALUES ('{0}', '{1}', {2}, {3})".format(brand.title() + ' ' + code.title(), filename, 1, model['id'])
            cursor.execute(query)
            conn.commit()
    flash('Images added successfully')
        
        
        
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
        print(request.form)
        return redirect(url_for('view_distributor', alias=request.form.get('id')))
    else:
        distributors = query_db("SELECT alias, name FROM distributor ORDER BY name ASC")
        if distributors is None:
            out = []
        else:
            out = [[str(item['alias']), str(item['name'])] for item in distributors]
        
        return render_template("distributors.html", distributors=out, title='Distributors')


@app.route("/distributor/<alias>")
def view_distributor(alias=None):
    session['fullres']=False
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


@app.route("/links")
def links():
    return render_template("links.html", title="Useful Links")


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

        return render_template("index.html", logged_in=True)  # TODO: FIX THIS

    
@app.route("/help")
def help():
    return render_template("help.html", title="Site Help")


# return the session setting for full resolution photos
def get_fullres():
    if not 'fullres' in session:
        session['fullres'] = True
    return session['fullres']


def set_fullres(on):
    session['fullres'] = on
    return session['fullres']


@app.route("/fullres")
def hires_on():
    set_fullres(True)
    flash("High-res photos in use")
    return redirect("home")


@app.route("/lowres")
def hires_off():
    set_fullres(False)
    flash("Low bandwidth photos in use")
    return redirect("home")


@app.route("/all")
def all():
    models = query_db("SELECT code, brand_id, start_year, name FROM model INNER JOIN brand on brand.id=model.brand_id ORDER BY name, start_year, code")
    return render_template("all.html", title="ALL RADIOS", models=models)


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
