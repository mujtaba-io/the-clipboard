import 'package:flutter/material.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'clipboard.dart';
import 'backyard.dart';

void main() {
  runApp(ClipboardApp());
}

class ClipboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Clipboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Segoe UI',
        scaffoldBackgroundColor: const Color(0xFF191724),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFDAD8D4)),
        ),
      ),
      home: ClipboardHomePage(),
    );
  }
}

class ClipboardHomePage extends StatefulWidget {
  @override
  _ClipboardHomePageState createState() => _ClipboardHomePageState();
}

class _ClipboardHomePageState extends State<ClipboardHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  String _errorMessage = '';

  String? _validatePin(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a PIN';
      });
      return '';
    } else if (value.length < MIN_PIN_SIZE || value.length > MAX_PIN_SIZE) {
      setState(() {
        _errorMessage =
            'PIN must be between $MIN_PIN_SIZE and $MAX_PIN_SIZE characters';
      });
      return '';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background decorations
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF312F4F).withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            bottom: -180,
            right: -150,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEB6F92).withOpacity(0.25),
              ),
            ),
          ),
          // Main content centered
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Header Section
                    const Icon(
                      Pixel.heart,
                      size: 64,
                      color: Color(0xFFEB6F92),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'The Clipboard',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pressStart2p(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE0DEF4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Move text or files between devices!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF908CAA),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Form Section
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            controller: _pinController,
                            onFieldSubmitted: (value) => submitPin(),
                            decoration: InputDecoration(
                              hintText: 'Enter your PIN',
                              hintStyle:
                                  const TextStyle(color: Color(0xFF6E6A86)),
                              filled: true,
                              fillColor: const Color(0xFF232136),
                              errorStyle: const TextStyle(
                                  height: 0.01, color: Colors.transparent),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF3E3A59),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF3E3A59),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFEB6F92),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            style: const TextStyle(color: Color(0xFFE0DEF4)),
                            validator: _validatePin,
                          ),
                          // Display error message below the text field
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SizeTransition(
                                  sizeFactor: animation,
                                  axisAlignment: -1.0,
                                  child: child,
                                ),
                              );
                            },
                            child: _errorMessage.isNotEmpty
                                ? Padding(
                                    key: const ValueKey('error'),
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 4.0),
                                    child: Text(
                                      _errorMessage,
                                      style: const TextStyle(
                                        color: Color(0xFFF6C177),
                                        fontSize: 13,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(
                                    key: ValueKey('no_error')),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFFEB6F92),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _errorMessage = '';
                                });
                                submitPin();
                              }
                            },
                            child: const Text(
                              'Submit PIN',
                              style: TextStyle(
                                color: Color(0xFF191724),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Warning & Footer Section
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6C177).withOpacity(0.1),
                        border: Border.all(
                            color: const Color(0xFFF6C177).withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: const Color(0xFFF6C177),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              "Don't use for sensitive data, as it's publicly accessible with a PIN.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFF6C177),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Made with ❤️ by Mujtaba',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF908CAA)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This software is provided \'as-is\' without warranty of any kind. The author is not liable for any damage.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xFF6E6A86)),
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

  void submitPin() async {
    print('submitting pin');
    try {
      Map<String, dynamic> data = {
        'pin': _pinController.text,
      };
      Map<String, dynamic> response = await fetchData(
        endpoint: makeUrl('/'),
        data: data,
      );

      if (response.containsKey('pin')) {
        print(response['pin']);
        final data =
            await fetchData(endpoint: makeUrl('clipboard/' + response['pin']))
                as List<dynamic>;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Clipboard(
                pin: response['pin'],
                data: List<Map<String, dynamic>>.from(data)),
          ),
        );
      } else {
        setState(() {
          _errorMessage = response['error'];
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
