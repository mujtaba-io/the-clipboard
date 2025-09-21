import 'dart:convert';
import 'dart:html' as html; // for web only
import 'dart:html'; // for web only
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelarticons/pixelarticons.dart';

import 'backyard.dart';
import 'custom_widgets.dart';

class Clipboard extends StatefulWidget {
  String pin;
  List<Map<String, dynamic>> data;
  Clipboard({super.key, required this.pin, required this.data});
  @override
  _ClipboardState createState() => _ClipboardState();
}

class _ClipboardState extends State<Clipboard> {
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background decorations from the main page for consistency
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
          // Main Scrollable Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 20.0),
                  sliver: SliverToBoxAdapter(
                    child: _buildHeader(context),
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 8.0),
                      child: Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFF6C177)),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.all(24.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250.0,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.9,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == 0) {
                          return _buildAddCard();
                        } else {
                          return _buildItemCard(index);
                        }
                      },
                      childCount: widget.data.length + 1,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32.0, bottom: 48.0),
                    child: const Text(
                      'Made with ❤️ by Mujtaba',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF908CAA)),
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button/Title
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.arrow_back_ios,
                    color: Color(0xFF908CAA), size: 16),
                const SizedBox(width: 8),
                Text(
                  'Clipboard',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 20,
                    color: const Color(0xFFE0DEF4),
                  ),
                ),
              ],
            ),
          ),
        ),
        // PIN display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF232136),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF3E3A59)),
          ),
          child: Text(
            'PIN: ${widget.pin}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF908CAA),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // More Options
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'contact') {
              window.open('https://gameidea.org/about/', '_blank');
            } else if (value == 'home') {
              Navigator.pop(context);
            } else if (value == 'download_all') {
              _downloadAllContent();
            }
          },
          color: const Color(0xFF232136),
          icon: const Icon(Pixel.morevertical, color: Color(0xFFE0DEF4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(color: Color(0xFF3E3A59)),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'download_all',
              child: const ListTile(
                leading: Icon(Icons.download_rounded, color: Color(0xFFE0DEF4)),
                title: Text('Download All',
                    style: TextStyle(color: Color(0xFFE0DEF4))),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'contact',
              child: const ListTile(
                leading: Icon(Icons.support_agent, color: Color(0xFFE0DEF4)),
                title:
                    Text('Contact', style: TextStyle(color: Color(0xFFE0DEF4))),
              ),
            ),
            PopupMenuItem<String>(
              value: 'home',
              child: const ListTile(
                leading: Icon(Icons.home_rounded, color: Color(0xFFE0DEF4)),
                title: Text('Back to Home',
                    style: TextStyle(color: Color(0xFFE0DEF4))),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddCard() {
    return GestureDetector(
      onTap: () => _showAddNewItemDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF232136).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF3E3A59),
            width: 2.0,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline_rounded,
                  size: 48, color: Color(0xFF908CAA)),
              SizedBox(height: 12),
              Text('Add New', style: TextStyle(color: Color(0xFF908CAA))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileCard(int index, String fileName, Function onDelete) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232136),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3A59)),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.doc_fill,
                      size: 48, color: Color(0xFFE0DEF4)),
                  const SizedBox(height: 16),
                  Text(
                    fileName,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(color: Color(0xFFE0DEF4)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              tooltip: 'Delete file',
              icon: const Icon(CupertinoIcons.delete,
                  size: 18, color: Color(0xFF908CAA)),
              onPressed: () => onDelete(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              color: const Color(0xFF3E3A59).withOpacity(0.5),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Downloading $fileName...'),
                    backgroundColor: const Color(0xFF232136),
                    behavior: SnackBarBehavior.floating,
                  ));
                  window.open(
                      makeUrl('/files/${widget.pin}/$fileName'), '_blank');
                },
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(12)),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.cloud_download,
                          size: 18, color: Color(0xFFE0DEF4)),
                      SizedBox(width: 8),
                      Text('Download',
                          style: TextStyle(color: Color(0xFFE0DEF4))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextAreaCard(int index, TextEditingController controller,
      Function onDelete, Function onSave) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232136),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3A59)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                maxLines: 100, // Effectively infinite lines
                minLines: 10,
                style: GoogleFonts.sourceCodePro(
                  color: const Color(0xFFE0DEF4),
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: const Color(0xFF191724),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF3E3A59)),
                  ),
                ),
              ),
            ),
          ),
          // Action buttons bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF191724).withOpacity(0.7),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: 'Delete text',
                  icon: const Icon(CupertinoIcons.delete,
                      size: 18, color: Color(0xFF908CAA)),
                  onPressed: () => onDelete(),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Copy text',
                      icon: const Icon(CupertinoIcons.doc_on_clipboard,
                          size: 18, color: Color(0xFF908CAA)),
                      onPressed: () {
                        copyToClipboard(controller.text);
                        showCustomSnackBar(
                            context, 'Text copied to clipboard!', false);
                      },
                    ),
                    IconButton(
                      tooltip: 'Save text',
                      icon: const Icon(Icons.save_rounded,
                          size: 20, color: Color(0xFFEB6F92)),
                      onPressed: () {
                        if (controller.text.length > MAX_TEXT_SIZE) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Text too long'),
                                content: const Text(
                                    'Text size is more than 32 KB. Truncating to 32,768 characters (32 KB).'),
                                contentTextStyle:
                                    const TextStyle(color: Colors.black),
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
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddNewItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232136),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(color: Color(0xFF3E3A59)),
          ),
          title: const Text(
            'Add New Item',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFE0DEF4)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file, color: Color(0xFF191724)),
                label: const Text('Upload File',
                    style: TextStyle(color: Color(0xFF191724))),
                onPressed: () {
                  Navigator.of(context).pop();
                  _uploadFileToServer();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color(0xFFEB6F92),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.paste, color: Color(0xFF191724)),
                label: const Text('Paste from Clipboard',
                    style: TextStyle(color: Color(0xFF191724))),
                onPressed: () {
                  Navigator.of(context).pop();
                  _uploadTextToServer();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor:
                      const Color(0xFF9CCFD8), // A new complementary color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // -- ALL BUSINESS LOGIC FUNCTIONS REMAIN UNCHANGED --

  Widget _buildItemCard(int index) {
    var item_serverIndex = index - 1;
    var item = widget.data[item_serverIndex];

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
          deleteItemAtIndex(item_serverIndex);
        },
        () {
          saveTextAtIndex(item_serverIndex, textEditingController.text);
        },
      );
    }
    return Container(); // Should not happen
  }

  void deleteItemAtIndex(int item_serverIndex) async {
    print('deleting item at index $item_serverIndex');
    final status = await fetchData(
            endpoint: makeUrl('/delete/${widget.pin}/$item_serverIndex'))
        as Map<String, dynamic>;
    if (status.containsKey('error')) {
      print(status['error']);
      _showError(status['error']);
    } else {
      setState(() {
        widget.data.removeAt(item_serverIndex);
      });
    }
  }

  Future<String> saveTextAtIndex(int item_serverIndex, String text) async {
    if (text.length > MAX_TEXT_SIZE) {
      text = text.substring(0, MAX_TEXT_SIZE);
      showCustomSnackBar(
          context,
          'Text size is more than ${MAX_TEXT_SIZE / 1024} KB. Truncated and saved.',
          false);
    }
    final status = await fetchData(
        endpoint: makeUrl('/texts/${widget.pin}/$item_serverIndex'),
        data: {'text': text}) as Map<String, dynamic>;
    if (status.containsKey('error')) {
      return status['error'];
    } else {
      setState(() {
        if (item_serverIndex != -1) {
          widget.data[item_serverIndex]['text'] = text;
        } else {
          widget.data.add({'text': text});
        }
      });
      showCustomSnackBar(context, 'Text saved successfully!', false);
    }
    return '';
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  void _uploadFileToServer() async {
    selectAndUploadFile(endpoint: makeUrl('/upload/${widget.pin}'));
  }

  void _uploadTextToServer() async {
    final text = await getClipboardText();
    String error = await saveTextAtIndex(-1, text);
    if (error.isNotEmpty) {
      print(error);
      showCustomSnackBar(context, 'Error saving text: $error', true);
    }
  }

  Future<void> selectAndUploadFile({required String endpoint}) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      try {
        int totalSize = result.files.fold(0, (sum, file) => sum + file.size);
        if (totalSize > MAX_FILE_SIZE * MAX_FILES_PER_UPLOAD) {
          showCustomSnackBar(
              context,
              'Total file size is more than ${(MAX_FILE_SIZE * MAX_FILES_PER_UPLOAD) / 1024 / 1024} MB',
              true);
          return;
        }

        FormData formData = FormData();
        for (PlatformFile file in result.files) {
          if (file.size > MAX_FILE_SIZE) {
            showCustomSnackBar(
                context,
                'File ${file.name} is larger than ${MAX_FILE_SIZE / 1024 / 1024} MB and was skipped.',
                true);
            continue;
          }
          formData.files.add(MapEntry('files[]',
              MultipartFile.fromBytes(file.bytes!, filename: file.name)));
        }

        if (formData.files.isEmpty) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF232136),
              title: const Text('Uploading files...',
                  style: TextStyle(color: Color(0xFFE0DEF4))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  LinearProgressIndicator(color: Color(0xFFEB6F92)),
                  SizedBox(height: 16),
                  Text('Please wait...',
                      style: TextStyle(color: Color(0xFFE0DEF4))),
                ],
              ),
            );
          },
        );

        var response = await dio.post(endpoint, data: formData);
        Navigator.pop(context);

        var jsonResponse = json.decode(response.toString());

        if (response.statusCode == 200 &&
            jsonResponse['successful_uploads'] != null) {
          var data =
              await fetchData(endpoint: makeUrl('/clipboard/${widget.pin}'));
          setState(() {
            widget.data = List<Map<String, dynamic>>.from(data);
          });
          showCustomSnackBar(
              context,
              '${jsonResponse['total_successful']} files uploaded' +
                  (jsonResponse['total_failed'] > 0
                      ? ', ${jsonResponse['total_failed']} failed'
                      : ''),
              jsonResponse['total_failed'] > 0);
        } else {
          print(jsonResponse['error'] ?? 'Error uploading files');
          showCustomSnackBar(context, 'Error uploading files', true);
        }
      } catch (e) {
        if (mounted) Navigator.pop(context);
        print('Error uploading files: $e');
        showCustomSnackBar(context, 'Error uploading files', true);
      }
    }
  }

  void _downloadAllContent() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFEB6F92)),
      ),
    );

    try {
      for (var item in widget.data) {
        if (item.containsKey('file')) {
          window.open(
              makeUrl('/files/${widget.pin}/${item['file']}'), '_blank');
          await Future.delayed(const Duration(milliseconds: 500));
        } else if (item.containsKey('text')) {
          _downloadTextAsFile(
              item['text'], 'clipboard_text_${widget.data.indexOf(item)}.txt');
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      Navigator.pop(context);
      showCustomSnackBar(
        context,
        'Download started for all items.',
        false,
      );
    } catch (e) {
      Navigator.pop(context);
      showCustomSnackBar(
        context,
        'Error downloading content: $e',
        true,
      );
    }
  }

  void _downloadTextAsFile(String text, String filename) {
    final blob = Blob([text], 'text/plain', 'native');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    Url.revokeObjectUrl(url);
  }
}
