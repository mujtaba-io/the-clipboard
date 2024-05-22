import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: Color(0xFF191724),
        textTheme: TextTheme(
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = ''; // Reset error message on valid input
      });
    }
  }

  String? _validatePin(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a PIN';
      });
      return '';
    } else if (value.length < 4 || value.length > 32) {
      setState(() {
        _errorMessage = 'PIN must be between 4 and 32 characters';
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
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'The Clipboard',
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create or enter your clipboard\'s pin',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF232136),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Color(0xFF524B49)),
                        ),
                        child: TextFormField(
                          controller: _pinController,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                                height: 0), // to disable default error message
                            hintText: 'PIN',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            hintStyle: TextStyle(color: Colors.white54),
                            fillColor: Color(0xFF232136),
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: _validatePin,
                        ),
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(
                              color: Color(0xFFFF5555),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if (_errorMessage.isEmpty) const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFeb6f92),
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: Text(
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
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF232136),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFF524B49)),
                  ),
                  child: const Text(
                    'Clipboard is a handy tool that lets you save text, files, and links for later use across devices!',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
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
}
