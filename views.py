from flask import Flask, render_template, send_from_directory, request
import os
import psycopg2
from psycopg2 import errorcodes 
import socket
import util

app = Flask(__name__)

app_path = os.path.dirname(os.path.abspath(__file__))


db_connect_command = "dbname='docker' user='docker' host='localhost' password='docker'"
sql_file = ['data/student.sql']
# sql_file = ['data/company.sql','data/student.sql','data/world.sql']
# cursor = conn.cursor()

@app.route('/api/execute_sql/<sql_query>', methods=['GET'])
def execute_sql(sql_query=''):
    '''
    TODO, execute sql and return results for post requests
    '''
    # sql_command = 'select * from student;'
    conn = util.connect_db(db_connect_command)
    cursor = conn.cursor()

    try:
        cursor.execute(sql_query)
        conn.commit()
        conn.close()
        return 'Query has been Done.'
    except psycopg2.Error as e:
        conn.rollback()
        conn.close()
        return errorcodes.lookup(e.pgcode[:2])
    

@app.route('/api/execute_sql_display/<sql_query>', methods=['GET'])
def execute_sql_display(sql_query=''):
    '''
    begin with select, so return results back
    '''
    conn = util.connect_db(db_connect_command)
    cursor = conn.cursor()

    try:
        cursor.execute(sql_query)
        result = cursor.fetchall()
        # conn.commit()
        conn.close()
        return str(result)
    except psycopg2.Error as e:
        conn.rollback()
        conn.close()
        return errorcodes.lookup(e.pgcode[:2])

    

@app.route('/')
def index():
    conn = util.connect_db(db_connect_command)
    if conn == 0:
        info = 'error'
    else:
        cursor = conn.cursor()
        try:
            sql_command = 'select * from student;'
            cursor.execute(sql_command)
            info = cursor.fetchall()
            conn.close()
        except psycopg2.Error as e:
            conn.close()
            info = errorcodes.lookup(e.pgcode[:2])
    return render_template('index.html', info = info)


if __name__ == '__main__':
    app.debug = True
    print 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    # test
    # util.init_db(sql_file, db_connect_command)

    # app.run(host = '0.0.0.0')

    # get current machine IP
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    ip = s.getsockname()[0]
    s.close()
    app.run(host=ip)


# a possible template: https://blackrockdigital.github.io/startbootstrap-sb-admin-2/pages/index.html#