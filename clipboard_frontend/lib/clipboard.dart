import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixelarticons/pixelarticons.dart';

import 'package:google_fonts/google_fonts.dart';

import 'backyard.dart';

import 'dart:html'; // for web only
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class Clipboard extends StatefulWidget {
  String pin;
  List<Map<String, dynamic>> data;
  Clipboard({required this.pin, required this.data});
  @override
  _ClipboardState createState() => _ClipboardState();
}

class _ClipboardState extends State<Clipboard> {
  String _errorMessage = '';
  bool _showModal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Tooltip(
                    message: 'Go back to home page',
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to home
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Clipboard',
                        style: GoogleFonts.redHatMono(
                            fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),

// print abcd as a very small text
                  Spacer(),
                  Text(
                    widget.pin, // display pin here
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white38,
                    ),
                  ),

                  Spacer(),

                  Tooltip(
                    message: 'Help keep the site running',
                    child: ElevatedButton(
                      onPressed: () {
                        // Open Patreon link
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16),
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
                  FloatingActionButton(
                    tooltip: 'More options',
                    mini: true,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: CircleBorder(),
                    onPressed: () {},
                    child: Icon(Pixel.morevertical),
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
                itemCount: widget.data.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildAddCard();
                  } else {
                    return _buildItemCard(index);
                  }
                },
              ),
              SizedBox(height: 20),
              Text(
                'Made with ❤️ by Mujtaba',
                style: TextStyle(color: Color(0xFFeb6f92)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _showModal ? _buildAddNewStuffModal() : null,
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

  Widget _buildFileCard(int index, String fileName, Function onDelete) {
    return GestureDetector(
      onTap: () {
        // show toast message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Downloading $fileName'),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ));
        // make get request to endpoint /files/<pin>/<filename>
        // download file - currently for web only TODO
        window.open(makeUrl('/files/${widget.pin}/$fileName'), '_blank');
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
                  Text(fileName, style: TextStyle(color: Color(0xFFDAD8D4))),
                  SizedBox(height: 10),
                  Icon(CupertinoIcons.cloud_download,
                      size: 48, color: Color(0xFFDAD8D4)),
                ],
              ),
            ),

            // make a delete button on bottom left and a row with 2 buttons on bottom right: one for save and one for copy text
            Positioned(
              bottom: 4, // 2,
              left: 4, //12,
              child: Tooltip(
                message: 'Delete file',
                child: ClipOval(
                  child: Material(
                    color: Colors.deepPurple, // Button color
                    child: InkWell(
                      splashColor: Colors.white30, // Splash color
                      onTap: () {
                        onDelete();
                      },
                      child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Icon(
                            CupertinoIcons.delete,
                            size: 16,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextAreaCard(int index, TextEditingController controller,
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
            bottom: 4, // 2,
            left: 4, //12,
            child: Tooltip(
              message: 'Delete text',
              child: ClipOval(
                child: Material(
                  color: Colors.deepPurple, // Button color
                  child: InkWell(
                    splashColor: Colors.white30, // Splash color
                    onTap: () {
                      onDelete();
                    },
                    child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                          CupertinoIcons.delete,
                          size: 16,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 4,
            right: 4,
            child: Row(
              children: [
                Tooltip(
                  message: 'Copy text',
                  child: ClipOval(
                    child: Material(
                      color: Colors.blueGrey, // Button color
                      child: InkWell(
                        splashColor: Colors.white30, // Splash color
                        onTap: () {
                          copyToClipboard(
                              controller.text); // defined in backyard.dart
                        },
                        child: SizedBox(
                            width: 24,
                            height: 24,
                            child: Icon(
                              CupertinoIcons.doc_on_clipboard,
                              size: 16,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Tooltip(
                  message: 'Save text',
                  child: ClipOval(
                    child: Material(
                      color: Colors.green, // Button color
                      child: InkWell(
                        splashColor: Colors.white30, // Splash color
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
                                        controller.text = controller.text
                                            .substring(0, 64 * 1024);
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
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Icon(
                            Icons.save_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// --index is what the actual index of item in server
  Widget _buildItemCard(int index) {
    // get the index eleent of data
    var item_serverIndex = index - 1;
    var item = widget.data[item_serverIndex] as Map<String, dynamic>;

    if (item.containsKey('file')) {
      return _buildFileCard(
        index,
        item['file'],
        () {
          deleteItemAtIndex(item_serverIndex);
        },
      );
    } else if (item.containsKey('text')) {
      TextEditingController textEditingController =
          TextEditingController(text: item['text']);
      return _buildTextAreaCard(
        index,
        textEditingController,
        () {
          // delete
          deleteItemAtIndex(item_serverIndex);
        },
        () {
          // save
          saveTextAtIndex(item_serverIndex, textEditingController.text);
        },
      );
    }
    return Container();
  }

  void deleteItemAtIndex(int item_serverIndex) async {
    print('delteing item at index $item_serverIndex');
    // make request to server at /delete/pin/index
    final status = await fetchData(
            endpoint: makeUrl('/delete/${widget.pin}/$item_serverIndex'))
        as Map<String, dynamic>;
    if (status.containsKey('error')) {
      print(status['error']);
    } else {
      // remove item from widget.data
      setState(() {
        widget.data.removeAt(item_serverIndex);
      });
    }
  }

  Future<String> saveTextAtIndex(int item_serverIndex, String text) async {
    // make request to server at /save/pin/index
    final status = await fetchData(
        endpoint: makeUrl('/texts/${widget.pin}/$item_serverIndex'),
        data: {'text': text}) as Map<String, dynamic>;
    if (status.containsKey('error')) {
      return status['error'];
    } else if (item_serverIndex != -1) {
      // if its not new text being added
      // update status text
      setState(() {
        widget.data[item_serverIndex]['text'] = text;
      });
    } else {
      setState(() {
        widget.data.add({'text': text});
      });
    }
    return '';
  }

  Widget _buildAddNewStuffModal() {
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
                onPressed: _uploadFileToServer,
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
                onPressed: _uploadTextToServer,
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

  void _uploadFileToServer() async {
    selectAndUploadFile(endpoint: makeUrl('/upload/${widget.pin}'));
    _toggleModal();
  }

  void _uploadTextToServer() async {
    // make request to server at /texts/<pin>/-1 for new text
// create a new text item in widget.data and update the state
    final text = await getClipboardText();
    // now send the text to server
    String error = await saveTextAtIndex(-1, text);
    if (error.isNotEmpty) {
      print(error);
      return;
    }
    _toggleModal();
  }
  /*
  data = [
      {'file': 'filename.txt},
      {'text': 'Hello, world!'},
    ...
    ]
   */

  //
  //
  //
  //
  Future<void> selectAndUploadFile({required String endpoint}) async {
    // Pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      // Get the file
      PlatformFile file = result.files.first;

      try {
        // Convert file bytes to MultipartFile
        MultipartFile multipartFile = MultipartFile.fromBytes(
          file.bytes!,
          filename: file.name,
        );

        // Create FormData object
        FormData formData = FormData.fromMap({
          'file': multipartFile,
        });

        // Create Dio instance
        Dio dio = Dio();

        // Send POST request
        var response = await dio.post(
          endpoint,
          data: formData,
        );

        // Handle response
        var jsonResponse = json.decode(response.toString());
        if (response.statusCode == 200 && jsonResponse['success'] != null) {
          setState(() {
            widget.data.add({'file': file.name});
          });
        } else {
          print(jsonResponse['error'] ?? 'Error uploading file');
        }
      } catch (e) {
        print('Error uploading file: $e');
      }
    } else {
      print('No file selected');
    }
  }
}
