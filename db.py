from dotenv import load_dotenv
import os
from mysql.connector import pooling

# On PythonAnywhere, use an absolute path so WSGI reliably loads the env file.
load_dotenv("/home/Schnittlauch202/mysite/.env")

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_DATABASE"),
    "autocommit": True,
}

# PythonAnywhere MySQL user limit is low; start with 1.
POOL_SIZE = int(os.getenv("DB_POOL_SIZE", "1"))
POOL_SIZE = max(1, min(POOL_SIZE, 2))

pool = pooling.MySQLConnectionPool(pool_name="pool", pool_size=2, **DB_CONFIG)

def get_conn():
    return pool.get_connection()

def db_read(sql, params=None, single=False):
    conn = get_conn()
    cur = None
    try:
        cur = conn.cursor(dictionary=True)
        cur.execute(sql, params or ())
        return cur.fetchone() if single else cur.fetchall()
    finally:
        try:
            if cur is not None:
                cur.close()
        finally:
            conn.close()

def db_write(sql, params=None):
    conn = get_conn()
    cur = None
    try:
        cur = conn.cursor()
        cur.execute(sql, params or ())
        conn.commit()
    finally:
        try:
            if cur is not None:
                cur.close()
        finally:
            conn.close()
