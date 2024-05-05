import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognition {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late Function(bool) _onListeningStateChanged;
  late Function(String) _onTextRecognized;

  SpeechRecognition({
    required Function(bool) onListeningStateChanged,
    required Function(String) onTextRecognized,
  }) {
    _onListeningStateChanged = onListeningStateChanged;
    _onTextRecognized = onTextRecognized;
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  void _initSpeech() {
    _speech.initialize(
      onError: (error) {
        print('Speech recognition error: $error');
        _stopListening();
      },
    );
  }

  void toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  Future<void> _startListening() async {
    if (await _speech.initialize()) {
      _isListening = true;
      _onListeningStateChanged(true);
      _speech.listen(
        onResult: (result) {
          _onTextRecognized(result.recognizedWords ?? '');
        },
        listenFor: null,
        partialResults: true,
      );
    }
  }

  void _stopListening() {
    _isListening = false;
    _onListeningStateChanged(false);
    _speech.stop();
  }
}
