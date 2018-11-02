from flask import Flask, render_template, send_from_directory, request
import os
import psycopg2
import socket


app = Flask(__name__)

app_path = os.path.dirname(os.path.abspath(__file__))

try:
    conn = psycopg2.connect("dbname='docker' user='docker' host='localhost' password='docker'")
except:
    print("I am unable to connect to the database")

sql_file = ['data/student.sql']
# sql_file = ['data/company.sql','data/student.sql','data/world.sql']
cursor = conn.cursor()

@app.route('/execute_sql')
def execute_sql():
    '''
    TODO, execute sql and return results for post requests
    '''


@app.route('/')
def index():
    # test tmp
    # log = util.py_file_code_convention_analysis('test.py')
    log = 'Reviews will be displayed here.'
    
    return render_template('index.html', log_html = log)


if __name__ == '__main__':
    app.debug = True
    # setup database
    for filename in sql_file:
        fp = open(filename, 'r')
        cursor.execute(fp.read())
        fp.close()

    # get current machine IP
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    ip = s.getsockname()[0]
    s.close()
    app.run(host=ip)

# app.run(host='150.216.56.49')
# a possible template: https://blackrockdigital.github.io/startbootstrap-sb-admin-2/pages/index.html#