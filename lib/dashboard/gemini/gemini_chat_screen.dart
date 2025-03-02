import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/services.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:studylink/constants/color_constants.dart';
import 'package:studylink/dashboard/widgets/custom_appbar.dart';

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({super.key});

  @override
  _GeminiChatScreenState createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  File? _uploadedFile;
  bool _isProcessing = false;
  bool _stopResponse = false;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _chatMessages = [];
  String _typingText = "";
  String? _fileName;

  final GenerativeModel _geminiModel = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: 'AIzaSyCUD9qqmUeweBQpeNsxblb3AVdDwbcx1sE',
  );

  // File Picker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _uploadedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  // // Image Picker
  // Future<void> _pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.camera);

  //   if (image != null) {
  //     setState(() {
  //       _uploadedFile = File(image.path);
  //       _fileName = "Captured Image";
  //     });
  //   }
  // }

  // Stop AI Response
  void _stopAIResponse() {
    setState(() {
      _stopResponse = true;
      _isProcessing = false;
    });
  }

  // Copy AI Response to Clipboard
  void _copyResponse(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied to clipboard!")),
    );
  }

  Future<void> _sendMessageToGemini() async {
    if (_messageController.text.isEmpty && _uploadedFile == null) return;

    final message = _messageController.text;
    _stopResponse = false;

    // Store chat message with file (if any)
    Map<String, dynamic> userMessage = {
      "text": message,
      "isUser": true,
      "isFile": _uploadedFile != null,
      "file": _uploadedFile,
      "fileName": _fileName
    };

    setState(() {
      _chatMessages.add(userMessage);
      _messageController.clear();
      _uploadedFile = null;
      _fileName = null;
      _isProcessing = true;
      _typingText = "";
    });

    try {
      final List<Content> inputs = [Content.text(message)];

      if (userMessage["isFile"] && userMessage["file"] != null) {
        final file = userMessage["file"] as File;
        final Uint8List fileBytes = await file.readAsBytes(); // Get raw bytes

        // **Pass the raw fileBytes instead of Base64**
        inputs.add(Content.data('application/pdf', fileBytes));
      }

      final response = await _geminiModel.generateContent(inputs);

      if (_stopResponse) return;

      final reply = response.text ?? "No response from AI.";
      _displayTypingEffect(reply);
    } catch (e) {
      setState(() {
        _chatMessages
            .add({"text": "Error: $e", "isUser": false, "isFile": false});
        _isProcessing = false;
      });
    }
  }

  // Typing Effect for AI Response
  Future<void> _displayTypingEffect(String fullText) async {
    setState(() {
      _isProcessing = false;
      _typingText = "";
    });

    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(Duration(milliseconds: 30));
      if (_stopResponse) return;
      setState(() {
        _typingText = fullText.substring(0, i + 1);
      });
    }

    if (_stopResponse) return;

    setState(() {
      _chatMessages
          .add({"text": _typingText, "isUser": false, "isFile": false});
      _typingText = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: "Gemini AI Chat"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatMessages.length +
                  (_typingText.isNotEmpty ? 1 : 0) +
                  (_isProcessing ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _chatMessages.length && _typingText.isNotEmpty) {
                  return _buildTypingIndicator();
                }
                if (index == _chatMessages.length && _isProcessing) {
                  return _buildLoadingIndicator();
                }
                final chat = _chatMessages[index];
                return _buildChatBubble(chat);
              },
            ),
          ),

          // Uploaded File Preview
          if (_uploadedFile != null) _buildFilePreview(),

          // Message Input Field
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Typing Indicator
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(_typingText, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  // Loading Indicator
  Widget _buildLoadingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 15, bottom: 10),
        child: Row(
          children: [
            JumpingDots(color: Colors.blue, radius: 5, numberOfDots: 3),
            SizedBox(width: 10),
            Text('AI is typing...'),
          ],
        ),
      ),
    );
  }

  // File Preview Above Input
  Widget _buildFilePreview() {
    return Container(
      margin: EdgeInsets.all(16).copyWith(bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedFile01,
            color: ColorConstants.primaryColor,
          ),
          SizedBox(width: 8),
          Expanded(child: Text(_fileName ?? "Selected File")),
          IconButton(
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedMultiplicationSignCircle,
                color: Colors.red),
            onPressed: () {
              setState(() {
                _uploadedFile = null;
                _fileName = null;
              });
            },
          )
        ],
      ),
    );
  }

  // Chat Bubble
  Widget _buildChatBubble(Map<String, dynamic> chat) {
    final isUser = chat["isUser"];
    final isFile = chat["isFile"];

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? ColorConstants.primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isFile)
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: ColorConstants.secondaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedFile01,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(chat["fileName"] ?? "Uploaded File",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            Text(chat["text"] ?? "",
                style: TextStyle(color: isUser ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }

  // Message Input Field
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: ColorConstants.secondaryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            IconButton(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedAttachment01,
                  color: ColorConstants.primaryColor,
                ),
                onPressed: _pickFile),
            // IconButton(
            //     icon: Icon(Icons.camera_alt, color: Colors.green),
            //     onPressed: _pickImage),
            Expanded(
                child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: GoogleFonts.inter(),
                      border: InputBorder.none,
                    ))),
            _isProcessing
                ? IconButton(
                    icon: Icon(Icons.pause, color: Colors.red),
                    onPressed: _stopAIResponse)
                : IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSent,
                      color: ColorConstants.primaryColor,
                    ),
                    onPressed: _sendMessageToGemini),
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:jumping_dot/jumping_dot.dart';
// import 'package:studylink/constants/color_constants.dart';

// import '../widgets/custom_appbar.dart';

// class GeminiChatScreen extends StatefulWidget {
//   @override
//   _GeminiChatScreenState createState() => _GeminiChatScreenState();
// }

// class _GeminiChatScreenState extends State<GeminiChatScreen> {
//   File? _pdfFile;
//   String _pdfText = "";
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, dynamic>> _chatMessages = [];
//   bool _isLoading = false;
//   String _typingText = "";

//   final GenerativeModel _geminiModel = GenerativeModel(
//     model: 'gemini-2.0-flash-exp',
//     apiKey:
//         'AIzaSyCUD9qqmUeweBQpeNsxblb3AVdDwbcx1sE', // Replace with actual API key
//   );

//   // Pick PDF File
//   Future<void> _pickPdfFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'jpg', 'png'],
//     );

//     if (result != null) {
//       setState(() {
//         _pdfFile = File(result.files.single.path!);
//       });

//       _extractTextFromPdf();
//     }
//   }

//   // Dummy PDF Text Extraction
//   Future<void> _extractTextFromPdf() async {
//     if (_pdfFile == null) return;
//     setState(() => _pdfText = "Extracting text...");

//     try {
//       final pdfBytes = await _pdfFile!.readAsBytes();
//       final pdfText = pdfBytes.toString(); // Dummy text extraction

//       setState(() {
//         _pdfText = pdfText.isNotEmpty ? pdfText : "Failed to extract text.";
//       });
//     } catch (e) {
//       setState(() {
//         _pdfText = "Error extracting text: $e";
//       });
//     }
//   }

//   // Send Message to Gemini AI
//   Future<void> _sendMessageToGemini() async {
//     if (_messageController.text.isEmpty) return;

//     final message = _messageController.text;
//     setState(() {
//       _chatMessages.add({"text": message, "isUser": true});
//       _messageController.clear();
//       _isLoading = true;
//       _typingText = "";
//     });

//     final inputText = _pdfText.isNotEmpty ? "$_pdfText\n$message" : message;

//     try {
//       final response =
//           await _geminiModel.generateContent([Content.text(inputText)]);
//       final reply = response.text ?? "No response from Gemini.";

//       _displayTypingEffect(reply);
//     } catch (e) {
//       setState(() {
//         _chatMessages.add({"text": "Error: $e", "isUser": false});
//         _isLoading = false;
//       });
//     }
//   }

//   // Show AI text one by one (Typing Effect)
//   Future<void> _displayTypingEffect(String fullText) async {
//     setState(() {
//       _isLoading = false;
//       _typingText = "";
//     });

//     for (int i = 0; i < fullText.length; i++) {
//       await Future.delayed(Duration(milliseconds: 30)); // Typing speed
//       setState(() {
//         _typingText = fullText.substring(0, i + 1);
//       });
//     }

//     setState(() {
//       _chatMessages.add({"text": _typingText, "isUser": false});
//       _typingText = "";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppbar(title: "Gemini AI Chat"),
//       body: Column(
//         children: [
//           // Show PDF Name Above Input Field

//           Expanded(
//             child: ListView.builder(
//               itemCount: _chatMessages.length +
//                   (_typingText.isNotEmpty ? 1 : 0) +
//                   (_isLoading ? 1 : 0),
//               itemBuilder: (context, index) {
//                 // Typing Effect
//                 if (index == _chatMessages.length && _typingText.isNotEmpty) {
//                   return Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Text(
//                         _typingText,
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   );
//                 }

//                 // Loading Indicator
//                 if (index == _chatMessages.length && _isLoading) {
//                   return Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 15, bottom: 10),
//                         child: Row(
//                           children: [
//                             JumpingDots(
//                               color: ColorConstants.primaryColor,
//                               radius: 5,
//                               numberOfDots: 3,
//                             ),
//                             SizedBox(width: 10),
//                             Text('AI is typing...'),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }

//                 final chat = _chatMessages[index];
//                 final isUser = chat["isUser"];

//                 return Align(
//                   alignment:
//                       isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isUser
//                           ? ColorConstants.primaryColor
//                           : Colors.grey[300],
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(15),
//                         topRight: Radius.circular(15),
//                         bottomLeft: isUser ? Radius.circular(15) : Radius.zero,
//                         bottomRight: isUser ? Radius.zero : Radius.circular(15),
//                       ),
//                     ),
//                     child: Text(
//                       chat["text"],
//                       style: TextStyle(
//                           color: isUser ? Colors.white : Colors.black),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Message Input Field with PDF Upload Icon
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: ColorConstants.secondaryColor.withOpacity(0.4),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 children: [
//                   if (_pdfFile != null)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                       child: Row(
//                         children: [
//                           Icon(Icons.picture_as_pdf, color: Colors.red),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               _pdfFile!.path.split('/').last,
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.close, color: Colors.grey),
//                             onPressed: () {
//                               setState(() {
//                                 _pdfFile = null;
//                                 _pdfText = "";
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   Row(
//                     children: [
//                       // Message Text Field
//                       Expanded(
//                         child: TextField(
//                           controller: _messageController,
//                           decoration: InputDecoration(
//                             hintText: 'Type a message...',
//                             hintStyle: GoogleFonts.inter(
//                               fontWeight: FontWeight.w600,
//                               color: ColorConstants.primaryColor,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // PDF Upload Icon
//                       IconButton(
//                         icon: HugeIcon(
//                           icon: HugeIcons.strokeRoundedAttachment,
//                           color: ColorConstants.primaryColor,
//                         ),
//                         onPressed: _pickPdfFile,
//                       ),

//                       // Send Message Icon
//                       IconButton(
//                         icon: HugeIcon(
//                           icon: HugeIcons.strokeRoundedSent,
//                           color: ColorConstants.primaryColor,
//                         ),
//                         onPressed: _sendMessageToGemini,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
