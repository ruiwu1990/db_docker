import os, subprocess
from pathlib import Path
import psycopg2
from psycopg2 import errorcodes 

app_path = os.path.dirname(os.path.abspath(__file__))

def init_db(filename_list, connect_command):
    '''
    '''
    conn = connect_db(connect_command)
    if conn == 0:
        print('cannot connect to db')
    else:
        cursor = conn.cursor()
        try:
            # setup database
            for filename in filename_list:
                fp = open(filename, 'r')
                cursor.execute(fp.read())

                fp.close()
            conn.commit()
            conn.close()
            return 1
        except psycopg2.Error as e:
            # print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
            print(errorcodes.lookup(e.pgcode[:2]))
            return 0


    # print('aaaaaaaaaaaaaaaaaaaaaa')
    # filename = 'data/student.sql'
    # fp = open(filename, 'r')
    # cursor.execute(fp.read())
    # fp.close()
    # conn.commit()
    # cursor.close()
    # conn.close()
    # return 1

def connect_db(connect_command):
    '''
    '''
    try:
        conn = psycopg2.connect("dbname='docker' user='docker' host='localhost' password='docker'")        
    except psycopg2.Error as e:
        print(errorcodes.lookup(e.pgcode[:2]))
        return 0

    return conn
    