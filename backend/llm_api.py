import os
import json
import google.generativeai as genai
from flask import Flask, request, jsonify
from flask_cors import CORS

with open('config.json') as f:
    config = json.load(f)
    api_key = config["API_KEY"]
os.environ["API_KEY"] = api_key
genai.configure(api_key=os.environ["API_KEY"])
model = genai.GenerativeModel('gemini-pro')


app = Flask(__name__)
CORS(app)

@app.route('/generate', methods=['POST', 'GET'])
def generate():
    try:
        if request.method == 'POST':
            jsonData = request.json.get('jsonData')
            instruction = request.json.get('instruction')
        elif request.method == 'GET':
            jsonData = request.args.get('jsonData')
            instruction = request.args.get('instruction')

        print("Received JSON data:", jsonData)
        print("Instruction:", instruction)
        response = model.generate_content(f"{instruction} {json.dumps(jsonData)}")
        return jsonify(response.text)
    except Exception as e:
        print("Error processing request:", e)
        return jsonify({'error': 'Invalid request'})


if __name__ == '__main__':
    app.run(port=4000)