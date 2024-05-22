import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ClipboardApp());
}

class ClipboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Clipboard",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF191724),
        scaffoldBackgroundColor: Color(0xFF191724),
        fontFamily: 'Segoe UI',
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
  final TextEditingController _pinController = TextEditingController();
  String _errorMessage = '';
  bool _showModal = false;

  void _toggleModal() {
    setState(() {
      _showModal = !_showModal;
    });
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  void _uploadFile() {
    // Handle file upload
    _toggleModal();
  }

  void _pasteText() {
    // Handle paste text
    _toggleModal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    message: 'Click to go back to home page',
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to home
                      },
                      child: Text(
                        'Clipboard',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),

// print abcd as a very small text
                  Text(
                    '1234',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white38,
                    ),
                  ),

                  Tooltip(
                    message: 'Helps keep the site running',
                    child: ElevatedButton(
                      onPressed: () {
                        // Open Patreon link
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.yellow.shade800, //Color(0xFFf93),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Text(
                        'Donate',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Color(0xFFFF5555)),
                ),
              SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:
                      290.0, // Adjust minimum width per card here
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: 10, // Replace with actual item count
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildAddCard();
                  } else {
                    return _buildCard(index);
                  }
                },
              ),

              SizedBox(height: 12),

// make a grid view of text area cards
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 290.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return buildTextAreaCard(
                      index,
                      TextEditingController(),
                      () {
                        // Handle delete
                      },
                      () {
                        // Handle save
                      },
                    );
                  } else {
                    return buildTextAreaCard(
                      index,
                      TextEditingController(text: 'This is a sample text.'),
                      () {
                        // Handle delete
                      },
                      () {
                        // Handle save
                      },
                    );
                  }
                },
              ),
              // testt tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt

              SizedBox(height: 20),
              Text(
                'Made with ❤️ by Mujtaba',
                style: TextStyle(color: Color(0xFFeb6f92)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _showModal ? _buildModal() : null,
    );
  }

  Widget _buildAddCard() {
    return GestureDetector(
      onTap: _toggleModal,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF232136),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFF524B49)),
        ),
        child: Center(
          child: Icon(Icons.add, size: 48, color: Color(0xFFDAD8D4)),
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    return GestureDetector(
      onTap: () {
        // Handle card tap
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF232136),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFF524B49)),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('my-old-weird-songs.mp4',
                      style: TextStyle(color: Color(0xFFDAD8D4))),
                  SizedBox(height: 10),
                  Icon(Icons.insert_drive_file,
                      size: 48, color: Color(0xFFDAD8D4)),
                ],
              ),
            ),

            // make a delete button on bottom left and a row with 2 buttons on bottom right: one for save and one for copy text
            Positioned(
              bottom: 2,
              left: 12,
              child: Tooltip(
                message: 'Delete file',
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      //color: Color(0xff904040),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.delete_forever_rounded,
                        size: 20, color: Colors.red),
                  ),
                ),
              ),
            ),

            // display status text in between them
            Positioned(
              bottom: 5,
              left: 40,
              child: Text(
                '356KB | 2 days ago',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ),

            Positioned(
              bottom: 2,
              right: 12,
              child: Row(
                children: [
                  Tooltip(
                    message: 'Download',
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          //color: Color(0xff404090),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.download_rounded,
                            size: 20, color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextAreaCard(int index, TextEditingController controller,
      Function onDelete, Function onSave) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF232136),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF524B49)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF232136),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF524B49)),
              ),
              child: TextField(
                controller: controller,
                maxLines: null,
                minLines: 32,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Courier New',
                  fontWeight: FontWeight.w100,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffffffff)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          // make a delete button on bottom left and a row with 2 buttons on bottom right: one for save and one for copy text
          Positioned(
            bottom: 2,
            left: 12,
            child: Tooltip(
              message: 'Delete text',
              child: GestureDetector(
                onTap: () {
                  onDelete();
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    //color: Color(0xff904040),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.delete_forever_rounded,
                      size: 20, color: Colors.red),
                ),
              ),
            ),
          ),

          // display status text in between them
          Positioned(
            bottom: 5,
            left: 40,
            child: Text(
              '356KB | 2 days ago',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ),

          Positioned(
            bottom: 2,
            right: 12,
            child: Row(
              children: [
                Tooltip(
                  message: 'Copy text',
                  child: GestureDetector(
                    onTap: () {
                      // Handle copy all text
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        //color: Color(0xff404090),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.copy_rounded,
                          size: 20, color: Colors.blueGrey),
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Save text',
                  child: GestureDetector(
                    onTap: () {
                      if (controller.text.length > 64 * 1024) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Text too long'),
                              content: Text(
                                  'Text size is more than 64 KB. Truncating to 65,536 characters (64 KB).'),
                              contentTextStyle: TextStyle(
                                color: Colors.black,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    controller.text =
                                        controller.text.substring(0, 64 * 1024);
                                    Navigator.of(context).pop();
                                    onSave();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        onSave();
                      }
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        //color: Color(0xff409040),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.save_rounded,
                          size: 20, color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),

/*
// make a faint copy-all-text icon on top right
          Positioned(
            top: -2,
            right: -2,
            child: Tooltip(
              message: 'Copy text',
              child: GestureDetector(
                onTap: () {
                  // Handle copy all text
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Color(0xff404090),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.copy, size: 16, color: Color(0xFFDAD8D4)),
                ),
              ),
            ),
          ),

          Positioned(
              top: 0,
              left: 0,
              child: Tooltip(
                message: "Delete text",
                child: GestureDetector(
                  onTap: () {
                    onDelete();
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Color(0xff904040),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Icon(Icons.delete, size: 16, color: Color(0xFFDAD8D4)),
                  ),
                ),
              )),
          Positioned(
            bottom: 0,
            right: 0,
            child: Tooltip(
              message: 'Save text',
              child: GestureDetector(
                onTap: () {
                  if (controller.text.length > 64 * 1024) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Text Too Long'),
                          content: Text(
                              'Text size is more than 64 KB. Truncating to 65,536 characters (64 KB).'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                controller.text =
                                    controller.text.substring(0, 64 * 1024);
                                Navigator.of(context).pop();
                                onSave();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    onSave();
                  }
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Color(0xff409040),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.save, size: 16, color: Color(0xFFDAD8D4)),
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildModal() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 256,
          height: 164,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF232136),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFF524B49)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add new stuff!',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _uploadFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFeb6f92),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Upload File', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pasteText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Color(0xFF494),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.paste, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Paste Text', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
