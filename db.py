from dotenv import load_dotenv
import os
import mysql.connector

# Always load env for BOTH bash and WSGI (absolute path)
load_dotenv("/home/Schnittlauch202/mysite/.env")

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_DATABASE"),
    "port": int(os.getenv("DB_PORT", "3306")),
    "autocommit": True,
}

def get_conn():
    # Fail fast if env is missing (prevents silent localhost fallback)
    if not DB_CONFIG["host"] or not DB_CONFIG["user"] or not DB_CONFIG["database"]:
        raise RuntimeError(f"DB env not loaded correctly: {DB_CONFIG}")
    return mysql.connector.connect(**DB_CONFIG)

def db_read(sql, params=None, single=False):
    conn = get_conn()
    cur = None
    try:
        cur = conn.cursor(dictionary=True)
        cur.execute(sql, params or ())
        return cur.fetchone() if single else cur.fetchall()
    finally:
        if cur is not None:
            cur.close()
        conn.close()

def db_write(sql, params=None):
    conn = get_conn()
    cur = None
    try:
        cur = conn.cursor()
        cur.execute(sql, params or ())
        conn.commit()
    finally:
        if cur is not None:
            cur.close()
        conn.close()
