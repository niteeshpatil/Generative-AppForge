from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # This enables CORS for all routes in your Flask app

@app.route('/home', methods=['GET'])
def get_home():
    with open('assets/home.json', 'r') as f:
        data = f.read()
    return jsonify(data)

@app.route('/reset', methods=['GET'])
def get_reset():
    with open('assets/reset.json', 'r') as f:
        data = f.read()
    return jsonify(data)

@app.route('/login', methods=['GET'])
def get_login():
    with open('assets/login.json', 'r') as f:
        data = f.read()
    return jsonify(data)

if __name__ == '__main__':
    app.run(port=4000)
