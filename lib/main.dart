import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: FadingTextAnimation(
        isDarkMode: _isDarkMode,
        toggleTheme: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
      ),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const FadingTextAnimation({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  Color _textColor = Colors.black;
  bool _showFrame = false; // for toggling the image border
  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _textColor;
        return AlertDialog(
          title: const Text('Pick a text color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _textColor,
              onColorChanged: (color) {
                tempColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('SELECT'),
              onPressed: () {
                setState(() {
                  _textColor = tempColor;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // two screens
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fading Text Animation'),
          actions: [
            IconButton(
              icon: const Icon(Icons.color_lens),
              onPressed: _pickColor,
            ),
            IconButton(
              icon: Icon(
                widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              ),
              onPressed: widget.toggleTheme,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Screen 1'),
              Tab(text: 'Screen 2'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Screen 1: fading text
            Center(
              child: GestureDetector(
                onTap: toggleVisibility,
                child: AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: Text(
                    'Hello, Flutter!',
                    style: TextStyle(fontSize: 24, color: _textColor),
                  ),
                ),
              ),
            ),

            // Screen 2: fading text with different duration + image with frame toggle
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: toggleVisibility,
                  child: AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: const Duration(seconds: 3),
                    curve: Curves.easeInOut,
                    child: Text(
                      'Second Screen Fade!',
                      style: TextStyle(fontSize: 24, color: _textColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: _showFrame
                      ? BoxDecoration(
                          border: Border.all(color: Colors.blueAccent, width: 4),
                          borderRadius: BorderRadius.circular(16),
                        )
                      : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://picsum.photos/250?image=9',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Show Frame'),
                  value: _showFrame,
                  onChanged: (bool value) {
                    setState(() {
                      _showFrame = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: toggleVisibility,
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
