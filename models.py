# *** Model Sample ***

from flaskext.mysql import MySQL


class DB(object):
    
    def __init__(self, db, password, address):
        # MySQL config
        mysql = MySQL()
        
        super.app.config['MYSQL_DATABASE_USER'] = db
        super.app.config['MYSQL_DATABASE_PASSWORD'] = 'password'
        super.app.config['MYSQL_DATABASE_DB'] = db
        super.app.config['MYSQL_DATABASE_HOST'] = address
        
        mysql.init_app(super.app)
        
        conn = mysql.connect()
        self.cursor = conn.cursor()
    
    
class Brand(DB):
    
    def __init__(self):
        pass
    
