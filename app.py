import base64
import pdfkit
import os
from flask import Flask, request, jsonify
from flask_httpauth import HTTPBasicAuth
from dotenv import load_dotenv

app = Flask(__name__)
auth = HTTPBasicAuth()

load_dotenv() # load environment variables from .env file

@app.route('/', methods=['POST'])
@auth.login_required
def html_to_pdf():
    content = request.get_json()
    if content is None:
        return jsonify({"error": "No JSON data provided in request"}), 400
    html = content.get('html')
    title = content.get('title', 'Default Title')
    if html is None:
        return jsonify({"error": "No 'html' key found in provided JSON data"}), 400
    pdf = pdfkit.from_string(html, False, options={'title': title})
    return jsonify({'pdf': base64.b64encode(pdf).decode('utf-8')})

@auth.verify_password
def verify_password(username, password):
    if username == os.getenv('BASIC_AUTH_USERNAME') and password == os.getenv('BASIC_AUTH_PASSWORD'):
        return True
    return False

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4000)
