import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:generative_app_forge/data_widgets.dart';
import 'package:generative_app_forge/speech_recognition.dart';

class CombinedWidgetsScreen extends StatefulWidget {
  @override
  _CombinedWidgetsScreenState createState() => _CombinedWidgetsScreenState();
}

class _CombinedWidgetsScreenState extends State<CombinedWidgetsScreen> {
  TextEditingController _textEditingController = TextEditingController();
  List<String> _recognizedWords = [];
  Map<String, dynamic> pageData = {};
  late SpeechRecognition _speechRecognition;
  bool _isListening = false;
  @override
  void initState() {
    super.initState();
    fetchData();
    _speechRecognition = SpeechRecognition(
      onListeningStateChanged: (isListening) {
        setState(() {
          _isListening = isListening;
        });
      },
      onTextRecognized: (text) {
        setState(() {
          _textEditingController.text = text;
          _recognizedWords.add(text);
        });
      },
    );
  }

  Future<void> fetchData() async {
    try {
      var body = jsonEncode(
          {"jsonData": {}, "instruction": "reset page,add appbar on this"});

      final response = await http.post(
        Uri.parse('http://127.0.0.1:4000/generate'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          String jsonData = jsonDecode(response.body);
          print(jsonData);
          pageData = jsonDecode(jsonData);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Caught an exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Combined Widgets Demo'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: pageData.isNotEmpty
                      ? PageBuilder.buildPageFromData(pageData)
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        labelText: 'Converted Text',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _toggleListening,
                      child: Text(
                          _isListening ? 'Stop Listening' : 'Start Listening'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() {
    _speechRecognition.toggleListening();
  }

  void _stopListening() {
    _speechRecognition.toggleListening();
  }
}
