from flask import Flask, redirect, render_template, request, url_for, jsonify
from dotenv import load_dotenv
import os
import git
import hmac
import hashlib
from db import db_read, db_write
from auth import login_manager, authenticate, register_user
from flask_login import login_user, logout_user, login_required, current_user
import logging

logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)

# Load .env variables
load_dotenv("/home/Schnittlauch202/mysite/.env")
W_SECRET = os.getenv("W_SECRET")

# Init flask app
app = Flask(__name__)
app.config["DEBUG"] = True
app.secret_key = "supersecret"

# Init auth
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login"

# DON'T CHANGE
def is_valid_signature(x_hub_signature, data, private_key):
    hash_algorithm, github_signature = x_hub_signature.split('=', 1)
    algorithm = hashlib.__dict__.get(hash_algorithm)
    encoded_key = bytes(private_key, 'latin-1')
    mac = hmac.new(encoded_key, msg=data, digestmod=algorithm)
    return hmac.compare_digest(mac.hexdigest(), github_signature)

# DON'T CHANGE
@app.post('/update_server')
def webhook():
    x_hub_signature = request.headers.get('X-Hub-Signature')
    if is_valid_signature(x_hub_signature, request.data, W_SECRET):
        repo = git.Repo('./mysite')
        origin = repo.remotes.origin
        origin.pull()
        return 'Updated PythonAnywhere successfully', 200
    return 'Unathorized', 401

# Auth routes
@app.route("/login", methods=["GET", "POST"])
def login():
    error = None

    if request.method == "POST":
        user = authenticate(
            request.form["username"],
            request.form["password"]
        )

        if user:
            login_user(user)
            return redirect(url_for("index"))

        error = "Benutzername oder Passwort ist falsch."

    return render_template(
        "auth.html",
        title="In dein Konto einloggen",
        action=url_for("login"),
        button_label="Einloggen",
        error=error,
        footer_text="Noch kein Konto?",
        footer_link_url=url_for("register"),
        footer_link_label="Registrieren"
    )


@app.route("/register", methods=["GET", "POST"])
def register():
    error = None

    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        ok = register_user(username, password)
        if ok:
            return redirect(url_for("login"))

        error = "Benutzername existiert bereits."

    return render_template(
        "auth.html",
        title="Neues Konto erstellen",
        action=url_for("register"),
        button_label="Registrieren",
        error=error,
        footer_text="Du hast bereits ein Konto?",
        footer_link_url=url_for("login"),
        footer_link_label="Einloggen"
    )

@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("index"))



# App routes
@app.route("/", methods=["GET", "POST"])
@login_required
def index():
    # GET
    if request.method == "GET":
        todos = db_read("SELECT id, content, due FROM todos WHERE user_id=%s ORDER BY due", (current_user.id,))
        return render_template("main_page.html", todos=todos)

    # POST
    content = request.form["contents"]
    due = request.form["due_at"]
    db_write("INSERT INTO todos (user_id, content, due) VALUES (%s, %s, %s)", (current_user.id, content, due, ))
    return redirect(url_for("index"))

@app.post("/complete")
@login_required
def complete():
    todo_id = request.form.get("id")
    db_write("DELETE FROM todos WHERE user_id=%s AND id=%s", (current_user.id, todo_id,))
    return redirect(url_for("index"))

# -----------------------------
# DB Explorer
# -----------------------------

def _get_table_names():
    rows = db_read("""
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = DATABASE()
        ORDER BY table_name
    """)
    return [r["table_name"] for r in rows]


def _get_table_columns(table_name: str):
    rows = db_read(f"SHOW COLUMNS FROM `{table_name}`")
    # dicts like {"Field": "...", "Type": "...", ...}
    return [r["Field"] for r in rows]



@app.route("/dbexplorer", methods=["GET"])
@login_required
def dbexplorer():
    tables = _get_table_names()
    return render_template("dbexplorer.html", tables=tables)


@app.route("/dbexplorer/api/table", methods=["POST"])
@login_required
def dbexplorer_api_table():
    payload = request.get_json(silent=True) or {}

    table = (payload.get("table") or "").strip()
    limit = payload.get("limit", 50)
    offset = payload.get("offset", 0)
    filter_column = (payload.get("filter_column") or "").strip()
    filter_value = (payload.get("filter_value") or "").strip()

    # Defensive parsing / caps
    try:
        limit = int(limit)
    except Exception:
        limit = 50
    try:
        offset = int(offset)
    except Exception:
        offset = 0

    limit = max(1, min(limit, 500))     # cap to keep UI responsive
    offset = max(0, offset)

    # Whitelist table name
    allowed_tables = set(_get_table_names())
    if table not in allowed_tables:
        return jsonify({"ok": False, "error": "Unknown or disallowed table."}), 400

    # Whitelist columns for that table
    columns = _get_table_columns(table)
    allowed_columns = set(columns)

    where_sql = ""
    params = []

    if filter_value:
        # If a column is provided, constrain filtering to that column;
        # else do a simple OR-LIKE across all columns (cast to char)
        if filter_column:
            if filter_column not in allowed_columns:
                return jsonify({"ok": False, "error": "Unknown or disallowed column."}), 400
            where_sql = f"WHERE CAST(`{filter_column}` AS CHAR) LIKE %s"
            params.append(f"%{filter_value}%")
        else:
            # OR-LIKE across columns (best-effort; still safe via whitelisting)
            ors = []
            for c in columns:
                ors.append(f"CAST(`{c}` AS CHAR) LIKE %s")
                params.append(f"%{filter_value}%")
            where_sql = "WHERE " + " OR ".join(ors)

    # Build query using only whitelisted identifiers
    sql = f"SELECT * FROM `{table}` {where_sql} LIMIT %s OFFSET %s"
    params.extend([limit, offset])

    rows = db_read(sql, tuple(params))

    return jsonify({
        "ok": True,
        "table": table,
        "columns": columns,
        "rows": rows,
        "limit": limit,
        "offset": offset,
        "returned": len(rows),
    })

if __name__ == "__main__":
    app.run(debug=True, use_reloader=False)
