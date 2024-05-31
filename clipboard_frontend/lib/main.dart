// MAKESURE LINE: 218 REPLACE

import 'package:flutter/material.dart';
import 'package:pixelarticons/pixelarticons.dart';

import 'clipboard.dart';
import 'backyard.dart';

import 'package:google_fonts/google_fonts.dart';

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

  //bool _isPinSecure = false;
  //final TextEditingController _passwordController = TextEditingController();

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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                //const SizedBox(height: 10),
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
                          border: Border.all(color: const Color(0xFF524B49)),
                        ),
                        child: TextFormField(
                          controller: _pinController,
                          onFieldSubmitted: (value) {
                            // if pressed enter
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _errorMessage = '';
                              });
                              submitPin();
                            }
                          },
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                                height: 0), // to disable default error message
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
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Color(0xFFFF5555),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if (_errorMessage.isEmpty) const SizedBox(height: 16),

// cb new -------------------------
                      // add a chackbox 'secure my pin' and pressing it creates
                      // a dialogbox which asks password

                      /*CheckboxListTile(
                        hoverColor: Colors.white54,
                        title: const Text(
                            'Secure my pin with password (optional)',
                            style:
                                TextStyle(color: Colors.white60, fontSize: 12)),
                        value: _isPinSecure,
                        onChanged: (bool? value) {
                          setState(() {
                            _isPinSecure = value!;
                          });
                        },
                      ),*/

                      // --------------------------------------------- CB new

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _errorMessage = '';
                              });
                              submitPin();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFeb6f92),
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: const Text(
                            'Enter',
                            style: TextStyle(color: Colors.white),
                          ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // make server post request
  void submitPin() async {
    print('submitting pin');
    try {
      Map<String, dynamic> data = {
        'pin': _pinController.text,
        // TODO: CURRENTLY NO PASSWORD SUPPORT UNTIL BASE SYSTEM DONE
        /*'password': _passwordController.text,
        'is_secure': _isPinSecure ? true : false,*/
      };
      Map<String, dynamic> response = await fetchData(
        endpoint: makeUrl('/'), // domain.com/
        data: data,
      );

      // if 'pin' is in response, navigate to Clipboard() screen
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
        // show error message
        setState(() {
          _errorMessage = response['error'];
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
