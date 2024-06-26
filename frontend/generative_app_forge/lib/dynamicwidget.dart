import 'dart:convert';
import 'package:flutter/material.dart';
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
  bool _sendPageData = true;
  bool _isErrorDialogShown = false;
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(46, 2, 0, 0),
      appBar: AppBar(
        title: Text('Generative Widgets'),
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
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: pageData.isNotEmpty
                      ? PageBuilder.buildPageFromData(context, pageData)
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(131, 54, 105, 244),
                          labelText: 'Text',
                          border: OutlineInputBorder(),
                        ),
                        minLines: 3, // Increase the height of the text field
                        maxLines: 5,
                      ),
                      SizedBox(height: 10),
                      Checkbox(
                        value: _sendPageData,
                        onChanged: (bool? value) {
                          setState(() {
                            _sendPageData = value!;
                          });
                        },
                      ),
                      Text('context'),
                      SizedBox(height: 10),
                      Row(
                        // Add this
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly, // Add this
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: _toggleListening,
                            child: Text(_isListening
                                ? 'Stop Listening'
                                : 'Start Listening'),
                          ),
                          ElevatedButton(
                            onPressed: () => _handleSubmit(context),
                            child: Text('Submit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    if (_isListening) {
      setState(() {
        _isListening = false;
      });
      _stopListening();
    }

    var body = jsonEncode({
      "jsonData": _sendPageData ? pageData : {}, // Check _sendPageData here
      "instruction": _textEditingController.text.trim(),
    });

    fetchData(context, body);
  }

  Future<void> fetchData(BuildContext context, String body) async {
    try {
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
      if (!_isErrorDialogShown) {
        _isErrorDialogShown = true;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred'),
            content: Text('$e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _isErrorDialogShown = false;
                },
              ),
            ],
          ),
        );
      }
    }
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
