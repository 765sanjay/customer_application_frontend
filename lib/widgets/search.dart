import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sklyit/pages/search_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';

class Search extends StatefulWidget {
  Search({super.key, this.search, this.filter});

  VoidCallback? search;
  void Function(String)? filter;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String keyword = "";
  int _currentPlaceholderIndex = 0;
  final List<String> _placeholders = ['toys', 'earrings', 'salons', 'spas', 'gyms'];
  Timer? _typingAnimationTimer;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _startTypingAnimation();
  }

  @override
  void dispose() {
    _typingAnimationTimer?.cancel();
    super.dispose();
  }

  void _startTypingAnimation() {
    _typingAnimationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentPlaceholderIndex = (_currentPlaceholderIndex + 1) % _placeholders.length;
      });
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) => setState(() => _isListening = false),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              keyword = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Handle the captured image here
      print('Image path: ${image.path}');
      // You would typically process the image for visual search here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 50,
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.tertiary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(15, 100, 100, 100),
        ),
        child: Row(
          children: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultsPage(
                        searchQuery: keyword,
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for ${_placeholders[_currentPlaceholderIndex]}',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    keyword = query;
                  });
                },
              ),
            ),
            // Voice recognition button
            IconButton(
              icon: Icon(
                Icons.mic,
                color: _isListening ? Colors.red : null,
              ),
              onPressed: _listen,
            ),
            // Camera button
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: _openCamera,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}