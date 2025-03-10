import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixelarticons/pixelarticons.dart';

import 'package:google_fonts/google_fonts.dart';

import 'backyard.dart';

import 'dart:html'; // for web only
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'custom_widgets.dart';

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
                  const Spacer(),
                  Text(
                    widget.pin, // display pin here
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white38,
                    ),
                  ),

                  const Spacer(),

                  Tooltip(
                    message: 'Help keep the site running',
                    child: ElevatedButton(
                      onPressed: () {
                        // Open Patreon link
                        window.open('https://gameidea.org/about/', '_blank');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor:
                            Colors.indigo.shade800, //Color(0xFFf93),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text(
                        'Contact',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  FloatingActionButton(
                    tooltip: 'More options',
                    mini: true,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    onPressed: () {
                      // show list menu with 2 options
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                        items: [
                          PopupMenuItem(
                            child: ListTile(
                              title: const Text('Back to Home'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              title: const Text('Visit gameidea.org'),
                              onTap: () {
                                window.open(
                                  'https://gameidea.org/',
                                  '_blank',
                                );
                              },
                            ),
                          ),
                        ],
                      );
                      // end list menu
                    },
                    child: const Icon(Pixel.morevertical),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Color(0xFFFF5555)),
                ),

//
//

//
//
//
//

              bulkDownloadButtonWidget(context),

              ///
              ///
              ///
////
              ///
              ///
              ///

              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:
                      232.0, // Adjust minimum width per card here
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
              const SizedBox(height: 32),
              const Text(
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
          color: const Color(0xFF232136),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF524B49)),
        ),
        child: const Center(
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
          duration: const Duration(seconds: 2),
          showCloseIcon: true,
        ));
        // make get request to endpoint /files/<pin>/<filename>
        // download file - currently for web only TODO
        window.open(makeUrl('/files/${widget.pin}/$fileName'), '_blank');
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF232136),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF524B49)),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(fileName,
                      style: const TextStyle(color: Color(0xFFDAD8D4))),
                  const SizedBox(height: 10),
                  const Icon(CupertinoIcons.cloud_download,
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
                      child: const SizedBox(
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
        color: const Color(0xFF232136),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF524B49)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF232136),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF524B49)),
              ),
              child: TextField(
                controller: controller,
                maxLines: null,
                minLines: 32,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Courier New',
                  fontWeight: FontWeight.w100,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffffffff)),
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
                    child: const SizedBox(
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
                          // defined in backyard.dart
                          copyToClipboard(controller.text);

                          showCustomSnackBar(
                              context, 'Text copied to clipboard', true);
                        },
                        child: const SizedBox(
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
                          if (controller.text.length > MAX_TEXT_SIZE) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Text too long'),
                                  content: const Text(
                                      'Text size is more than 32 KB. Truncating to 32,768 characters (32 KB).'),
                                  contentTextStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        controller.text = controller.text
                                            .substring(0, MAX_TEXT_SIZE);
                                        Navigator.of(context).pop();
                                        onSave();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            onSave();
                          }
                        },
                        child: const SizedBox(
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
    // validate text size
    if (text.length > MAX_TEXT_SIZE) {
      text = text.substring(0, MAX_TEXT_SIZE);
      showCustomSnackBar(
          context,
          'Text size is more than ${MAX_TEXT_SIZE / 1024} KB. Truncated to ${MAX_TEXT_SIZE / 1024} KB and saving.',
          true);
    }
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
    return GestureDetector(
      onTap: _toggleModal,
      child: Container(
        color: Colors.black54,
        child: Center(
            child: GestureDetector(
          onTap: () {
            // do nothing when tapped inside modal
          },
          child: Container(
            width: 256,
            height: 164,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF232136),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF524B49)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Add new stuff!',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _uploadFileToServer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFeb6f92),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, color: Colors.white),
                      SizedBox(width: 5),
                      Text('Upload File',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _uploadTextToServer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Color(0xFF494),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Row(
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
        )),
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
    _toggleModal();
    selectAndUploadFile(endpoint: makeUrl('/upload/${widget.pin}'));
  }

  void _uploadTextToServer() async {
    _toggleModal();
    // make request to server at /texts/<pin>/-1 for new text
// create a new text item in widget.data and update the state
    final text = await getClipboardText();
    // now send the text to server
    String error = await saveTextAtIndex(-1, text);
    if (error.isNotEmpty) {
      print(error);
      showCustomSnackBar(context, 'Error saving text.', true);
      return;
    }
  }
  /*
  data = [
      {'file': 'filename.txt},
      {'text': 'Hello, world!'},
    ...
    ]
   */

  Future<void> selectAndUploadFile({required String endpoint}) async {
    // Modify FilePickerResult to allow multiple files
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      try {
        // Validate total size of all files
        int totalSize = result.files.fold(0, (sum, file) => sum + file.size);
        if (totalSize > MAX_FILE_SIZE * MAX_FILES_PER_UPLOAD) {
          showCustomSnackBar(
              context,
              'Total file size is more than ${(MAX_FILE_SIZE * MAX_FILES_PER_UPLOAD) / 1024 / 1024} MB',
              true);
          return;
        }

        // Create FormData with multiple files
        FormData formData = FormData();

        // Add each file to formData
        for (PlatformFile file in result.files) {
          if (file.size > MAX_FILE_SIZE) {
            showCustomSnackBar(
                context,
                'File ${file.name} is larger than ${MAX_FILE_SIZE / 1024 / 1024} MB',
                true);
            continue;
          }

          MultipartFile multipartFile = MultipartFile.fromBytes(
            file.bytes!,
            filename: file.name,
          );

          // Note the files[] array syntax for multiple files
          formData.files.add(MapEntry('files[]', multipartFile));
        }

        // Show upload progress dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Uploading files...'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  LinearProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Please wait while your files are being uploaded...'),
                ],
              ),
            );
          },
        );

        // Send POST request
        var response = await dio.post(
          endpoint,
          data: formData,
        );

        // Close progress dialog
        Navigator.pop(context);

        // Handle response
        var jsonResponse = json.decode(response.toString());

        if (response.statusCode == 200 &&
            jsonResponse['successful_uploads'] != null) {
          // Refresh data from server to get updated list
          var data = await fetchData(
            endpoint: makeUrl('/clipboard/${widget.pin}'),
          );

          setState(() {
            widget.data = List<Map<String, dynamic>>.from(data);
          });

          // Show summary of upload results
          showCustomSnackBar(
              context,
              '${jsonResponse['total_successful']} files uploaded successfully' +
                  (jsonResponse['total_failed'] > 0
                      ? ', ${jsonResponse['total_failed']} failed'
                      : ''),
              jsonResponse['total_failed'] > 0);
        } else {
          print(jsonResponse['error'] ?? 'Error uploading files');
          showCustomSnackBar(context, 'Error uploading files', true);
        }
      } catch (e) {
        print('Error uploading files: $e');
        showCustomSnackBar(context, 'Error uploading files', true);
      }
    } else {
      print('No files selected');
      showCustomSnackBar(context, 'No files selected', true);
    }
  }

  void _downloadAllContent() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Download files
      for (var item in widget.data) {
        if (item.containsKey('file')) {
          // Download file directly
          window.open(
              makeUrl('/files/${widget.pin}/${item['file']}'), '_blank');
          await Future.delayed(
              const Duration(milliseconds: 500)); // Add delay between downloads
        } else if (item.containsKey('text')) {
          // Create text file download
          _downloadTextAsFile(
              item['text'], 'text_${widget.data.indexOf(item)}.txt');
          await Future.delayed(
              const Duration(milliseconds: 500)); // Add delay between downloads
        }
      }

      // Hide loading indicator
      Navigator.pop(context);

      // Show success message
      showCustomSnackBar(
        context,
        'Started downloading all files and texts',
        false,
      );
    } catch (e) {
      // Hide loading indicator
      Navigator.pop(context);

      // Show error message
      showCustomSnackBar(
        context,
        'Error downloading content: $e',
        true,
      );
    }
  }

  void _downloadTextAsFile(String text, String filename) {
    // Create a Blob containing the text
    final blob = Blob([text], 'text/plain', 'native');

    // Create a URL for the Blob
    final url = Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and trigger download
    final anchor = AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();

    // Clean up by revoking the URL
    Url.revokeObjectUrl(url);
  }

//

//

  ///
  ///

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  Widget bulkDownloadButtonWidget(BuildContext ctx) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 600;

        final downloadButton = Tooltip(
          message: 'Download all files and texts',
          child: ElevatedButton.icon(
            onPressed: widget.data.isEmpty ? null : () => _downloadAllContent(),
            icon: const Icon(
              CupertinoIcons.cloud_download,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Download All',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 20 : 16,
                vertical: 12,
              ),
              backgroundColor: Colors.blue.shade700,
              elevation: 4,
              shadowColor: Colors.blue.shade900.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        );

        // Calculate available width for the info container
        // Consider padding and button width
        final double buttonWidth = 150; // Estimated button width
        final double horizontalPadding =
            isWideScreen ? 48 : 32; // Total horizontal padding
        final double availableWidth =
            constraints.maxWidth - buttonWidth - horizontalPadding;

        final infoContainer = Container(
          // Allow container to take available space but not more than needed
          constraints: BoxConstraints(
            maxWidth: isWideScreen ? availableWidth : double.infinity,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isWideScreen ? 16 : 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.shade900.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.blue.shade300.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.info_circle,
                color: Colors.blue.shade300,
                size: 16,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Clipboard is free! If you love it, let me know :)',
                  style: GoogleFonts.inter(
                    color: Colors.blue.shade300,
                    fontSize: isWideScreen ? 14 : 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  // Only use ellipsis when screen is narrow
                  overflow: isWideScreen
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );

        return Container(
          margin: EdgeInsets.symmetric(
            vertical: isWideScreen ? 12 : 8,
            horizontal: isWideScreen ? 0 : 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF232136).withOpacity(0.7),
            border: Border.all(
              color: Colors.blue.shade700.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade900.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWideScreen ? 24 : 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: isWideScreen
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: [
                downloadButton,
                if (!isWideScreen) const SizedBox(width: 12),
                Flexible(
                  fit: isWideScreen ? FlexFit.loose : FlexFit.tight,
                  child: infoContainer,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
