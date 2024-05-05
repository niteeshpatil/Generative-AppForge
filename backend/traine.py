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


def read_json_file(filename):
    with open(filename, 'r') as file:
        return json.load(file)


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

        home_json = read_json_file('assets/home.json')
        reset_json = read_json_file('assets/reset.json')
        login_json = read_json_file('assets/login.json')
        schema_json = read_json_file('assets/schema.json')
        
        rule = "Follow the rule: don't add anything outside of the provided schema, It's important to only change the values of the three given JSON objects for any instructions, without adding anything more, retaining only the JSON object similar to the provided three JSON objects not add anying more on JSON objects important."
        generated_json = model.generate_content(f"{home_json}\n {reset_json}\n {login_json}\n  schema: {schema_json}\n rule: {rule}\n Instruction: {instruction}\n Input JSON: {jsonData}")
        print(generated_json.text)
        generated_dict = eval(generated_json.text)
        generated_double_quotes = json.dumps(generated_dict)
        json_data = jsonify(generated_double_quotes)
        print("return json_data",json_data)
        return json_data
    except Exception as e:
        print("Error processing request:", e)
        return jsonify({'error': 'Invalid request'})

if __name__ == '__main__':
    app.run(port=4000)
