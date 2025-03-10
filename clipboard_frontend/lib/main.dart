import 'package:flutter/material.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'clipboard.dart';
import 'backyard.dart';
import 'component_enter_button.dart';
import 'custom_widgets.dart';
import 'component_particle_button.dart';

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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        splashColor: Colors.amber.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.amber.withOpacity(0.3),
            width: 1,
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(0.7),
            builder: (context) => newsPopup(context),
          );
        },
        icon: Icon(
          Icons.notifications_none_rounded,
          color: Colors.amber.withOpacity(0.9),
          size: 18,
        ),
        label: Text(
          'What\'s New',
          style: TextStyle(
            color: Colors.amber.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    const Icon(
                      Pixel.heart,
                      size: 100,
                      color: Colors.deepPurple,
                    ),
                    Text(
                      'The Clipboard',
                      style: GoogleFonts.redHatMono(
                        fontSize: 32,
                      ),
                    ),
                    const Text(
                      'Move text or files between devices!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const Divider(
                      color: Color(0xFF524B49),
                      thickness: 1,
                      height: 24,
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF232136),
                              borderRadius: BorderRadius.circular(32),
                              border:
                                  Border.all(color: const Color(0xFF524B49)),
                            ),
                            child: TextFormField(
                              controller: _pinController,
                              onFieldSubmitted: (value) {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _errorMessage = '';
                                  });
                                  submitPin();
                                }
                              },
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(height: 0),
                                hintText: 'Create or use existing PIN',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                                hintStyle: TextStyle(color: Colors.white54),
                                fillColor: Color(0xFF232136),
                              ),
                              style: const TextStyle(color: Colors.white),
                              validator: _validatePin,
                            ),
                          ),
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(
                                  color: Color(0xFFFF5555),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          if (_errorMessage.isEmpty) const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: EnterButton(
                              width: double.infinity,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _errorMessage = '';
                                  });
                                  submitPin();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF232136),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF524B49)),
                      ),
                      child: const Text(
                        'Clipboard is a handy tool that lets you save text, files, and links for later use across devices!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Made with ❤️ by Mujtaba',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFeb6f92)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'By using this software, you agree that this software is provided \'as-is\'. There is no warranty and author is not liable for any damage.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(left: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red[300],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Don't use clipboard for sensitive files, anyone with PIN can access it",
                      style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
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
