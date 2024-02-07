import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt/config/ColorPalette.dart';
import 'package:chat_gpt/screens/HomeScreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatScreen extends StatefulWidget {
  final String userMessage;

  const ChatScreen({Key? key, required this.userMessage}) : super(key: key);

  // const ChatScreen({super.key, required this.userMessage});
  @override
  State<StatefulWidget> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> chatMessages = [];
  late http.Client httpClient; // Declare the client
  bool isUser = true;
  bool isCopying = false;
  bool isLoading = false;
  bool gptResponseAdded = false;
  bool isFromHomeScreen = false;
  bool isInternetConnected = true;
  // final ScrollController _scrollController = ScrollController();

  _ChatScreen() {
    httpClient = http.Client(); // Initialize the client in the constructor
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    httpClient.close(); // Close the client when the widget is disposed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    // Add the initial user message to chatMessages
    if (widget.userMessage.isNotEmpty && !gptResponseAdded) {
      isFromHomeScreen = true;
      chatMessages.add({
        'icon': 'assets/images/img_1.png',
        'name': 'You',
        'command': widget.userMessage,
        'isUser': true,
      });
      // Trigger GPT response
      sendRequestToGPT(widget.userMessage);
    }
    if (widget.userMessage.isEmpty) {
      gptResponseAdded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorPalette.bgColor,
      appBar: AppBar(
        backgroundColor: ColorPalette.bgColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "ImpChat",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              width: 15,
            ),
            Icon(
              Icons.network_check_sharp,
              // size: 20,
              color: isInternetConnected ? Colors.lightGreenAccent : Colors.red,
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              // controller: _scrollController,
              child: Column(
                children: chatMessages.map((message) {
                  return buildChatContainer(
                    message['icon'],
                    message['name'],
                    message['command'],
                    message['isUser'],
                    isLoading,
                  );
                }).toList(),
              ),
            ),
          ),
          loadingAction(),
          buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget buildChatContainer(dynamic iconOrImage, String name, String command,
      bool isUser, bool isLoading) {
    return Container(
      // color: ColorPalette.bgColor,
      margin: const EdgeInsets.only(left: 10, bottom: 12, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  // Check if it's an icon or image
                  iconOrImage is IconData
                      ? Container(
                          decoration: BoxDecoration(
                            color: ColorPalette.sendCommand,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            iconOrImage,
                            size: 25,
                            color: Colors.white,
                          ),
                        )
                      : iconOrImage is String
                          // Assuming it's an image path or URL
                          ? CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage(
                                  iconOrImage), // or NetworkImage(iconOrImage) for URL
                            )
                          : Container(), // Placeholder for other types or null
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 35),
            child: isUser
                ? Text(
                    command,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : isCodeResponse(command)
                    ? HighlightView(
                        getCodeContent(command),
                        language: 'dart',
                        // You can set the language based on your use case
                        theme: githubTheme,
                        textStyle: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'monospace',
                        ),
                      )
                    : AnimatedTextKit(
                        isRepeatingAnimation: false,
                        repeatForever: false,
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            command,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                            speed: const Duration(
                                milliseconds: 10), // Adjust the typing speed
                          ),
                        ],
                      ),
          ),
          !isUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    IconButton(
                      onPressed: () {
                        // Implement the copy to clipboard functionality here
                        // You can use the Flutter Clipboard package
                        // For example:
                        Clipboard.setData(ClipboardData(text: command));

                        // Update the state to show the success icon
                        setState(() {
                          isCopying = true;
                        });
                        // Timer to reset the icon after 2 seconds
                        Timer(const Duration(seconds: 2), () {
                          setState(() {
                            isCopying = false;
                          });
                        });
                      },
                      icon: isCopying
                          ? const Icon(
                              Icons.check, // or any success icon
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.content_copy,
                              size: 20,
                              color: Colors.grey,
                            ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget buildBottomNavBar() {
    return Container(
      color: ColorPalette.cardContainer,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Message ChatGPT...',
                contentPadding: const EdgeInsets.only(left: 20),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mic,
                    color: Colors.white54,
                  ),
                ),
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              // Disable the TextField if the user is not connected to the internet
              enabled: isInternetConnected,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: ColorPalette.sendCommand,
              borderRadius: BorderRadius.circular(14),
            ),
            // You can replace the Icon widget with your desired icon.
            child: IconButton(
              onPressed: () async {
                checkInternetConnection();
                String userMessage = messageController.text;
                if (isInternetConnected && userMessage.isNotEmpty) {
                  chatMessages.add({
                    'icon': 'assets/images/img_1.png',
                    'name': 'You',
                    'command': userMessage,
                    'isUser': true,
                  });
                  setState(() {});
                  messageController.clear();
                  await Future.delayed(const Duration(milliseconds: 10));
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    String gptResponse = await sendRequestToGPT(userMessage);
                    chatMessages.add({
                      'icon': 'assets/images/chatgpt.png',
                      'name': 'ChatGPT',
                      'command': gptResponse,
                      'isUser': false,
                    });
                    setState(() {});
                    // if (!gptResponseAdded) {
                    //   // Only trigger GPT request when userMessage comes from the home screen
                    //   await sendRequestToGPT(userMessage);
                    //
                    //   // Display the loading indicator until GPT fetches the data
                    //   while (isLoading) {
                    //     await Future.delayed(const Duration(milliseconds: 100));
                    //   }
                    // }

                    // _scrollController.animateTo(
                    //   _scrollController.position.maxScrollExtent,
                    //   duration: const Duration(milliseconds: 10),
                    //   curve: Curves.easeOut,
                    // );
                  } catch (e) {
                    // Handle the exception
                    if (kDebugMode) {
                      print('Error fetching response from GPT: $e');
                    }
                  } finally {
                    setState(() {
                      isLoading = false; // Hide loading indicator
                    });
                  }
                }
              },
              icon: isLoading
                  ? Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                        size: 20,
                        color: Colors.black,
                      ),
                    )
                  : isInternetConnected? const Icon(
                      FontAwesomeIcons.locationArrow,
                      color: Colors.black,
                    ) : const Icon(
                FontAwesomeIcons.arrowsRotate,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> sendRequestToGPT(String userMessage) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer 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',
      };

      var apiUrl = Uri.parse('https://api.openai.com/v1/chat/completions');

      var requestBody = {
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content":
                "You are ChatGPT, a helpful assistant. Provide information and answer user queries."
          },
          {"role": "user", "content": userMessage}
        ]
      };

      var response = await http.post(
        apiUrl,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      setState(() {
        isLoading = false;
        // _scrollController.animateTo(
        //   _scrollController.position.maxScrollExtent,
        //   duration: const Duration(milliseconds: 300),
        //   curve: Curves.easeOut,
        // );
        // _scrollController.addListener(() {
        //   if (_scrollController.offset >=
        //           _scrollController.position.maxScrollExtent &&
        //       !_scrollController.position.outOfRange) {
        //     // Text has reached the bottom, perform autoscrolling logic here
        //     // For example, you can scroll to the top or trigger additional content loading
        //     _scrollController.animateTo(0.0,
        //         duration: const Duration(milliseconds: 20),
        //         curve: Curves.easeInOutQuart);
        //     // Or fetch more data and update the UI
        //     // fetchMoreData();
        //     setState(() {});
        //   }
        // });
      });
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var content = jsonResponse['choices'][0]['message']['content'];
        if (userMessage.isNotEmpty && !gptResponseAdded) {
          setState(() {
            isFromHomeScreen = false;
            chatMessages.add({
              'icon': 'assets/images/chatgpt.png',
              'name': 'ChatGPT',
              'command': content,
              'isUser': false,
            });
            // Set the flag to true after adding the response
            gptResponseAdded = true;
          });
        }
        return content;
      } else {
        throw Exception(
            'Failed to fetch response from GPT API. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching response from GPT: $e');
      }
      rethrow; // Rethrow the exception to propagate it further
    }
  }

  bool isCodeResponse(String response) {
    // Check if the response starts and ends with the pattern '''
    return response.trim().startsWith("'''") && response.trim().endsWith("'''");
  }

  String getCodeContent(String response) {
    // Extract the content between the ''' and ''' for code highlighting
    return response.trim().substring(3, response.length - 3);
  }

  loadingAction() {
    return isFromHomeScreen
        ? SizedBox(
            height: 200,
            child: LoadingAnimationWidget.fourRotatingDots(
              size: 50,
              // leftDotColor: Colors.white, rightDotColor: Colors.yellow,
              color: Colors.white,
            ),
          )
        : const SizedBox.shrink();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isInternetConnected = connectivityResult != ConnectivityResult.none;
    });
  }
}
