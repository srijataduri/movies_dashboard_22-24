import pymysql

def get_connection():
    return pymysql.connect(
        host="localhost",
        port=3306,
        user="flaskuser",
        password="flaskpass123!",
        database="db",
        cursorclass=pymysql.cursors.DictCursor
    )

def query(sql, params=None):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params or ())
            return cur.fetchall()
    finally:
        conn.close()