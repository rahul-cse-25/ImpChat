import 'dart:math';

import 'package:chat_gpt/config/ColorPalette.dart';
import 'package:chat_gpt/screens/ChatScreen.dart';

// import 'package:chat_gpt/screens/FeedBack.dart';
// import 'package:chat_gpt/screens/HelpCenter.dart';
import 'package:chat_gpt/screens/RecentHistory.dart';

// import 'package:chat_gpt/screens/Setting.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/Constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<String> recentHistory = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool openDrawer = false;
  bool message = true;
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    fetchRecentHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorPalette.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          // This is for drawer to open when user swipe left to right
          onHorizontalDragUpdate: (details) {
            if (details.primaryDelta! > 0) {
              setState(() {
                openDrawer = true;
              });
              _scaffoldKey.currentState?.openDrawer();
              Scaffold.of(context).openDrawer();
            }
          },
          child: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
              // Open drawer directly from the AppBar
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 2),
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Use BoxShape.circle to create a circular container
              color: Colors.lightGreenAccent,
            ),
            child: const ClipOval(
              child: Image(
                image: AssetImage('assets/images/img_1.png'),
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
      ),
      drawer: buildDrawer(),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: buildHomeScreenCenter(),
          )),
          buildBottomNavBar(),
        ],
      ),
    );
  }

  buildHomeScreenCenter() {
    return Column(
      children: [
        // AdsCard
        Container(
          width: double.infinity,
          height: 180,
          margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: const DecorationImage(
                image: AssetImage('assets/images/SingleBot2.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.srgbToLinearGamma(),
                opacity: 0.6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ChatGPT-4",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Our smartest and most capable model.\nInclude DALL-E, browsing and more.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontSize: 18.0, // Font size
                        fontWeight: FontWeight.bold, // Font weight
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors
                          .white, // Background color when the button is in its default state
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(
                      ColorPalette.sendCommand,
                      // Background color when the button is pressed
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(12.0), // Padding around the text
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(50), // Border radius
                      ),
                    ),
                  ),
                  child: const Text(
                    '  Get Plus  ',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Default Search Cards
        buildDefaultSearchCard(),
        // Recent History title
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Recent history",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecentHistory(),
                        ));
                  },
                  child: const Text(
                    "See all",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  )),
            ],
          ),
        ),
        // History List
        Container(
          margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
          // height: 120,
          child: Column(
            children: [
              buildHistoryCard("How to learn Flutter app development ?"),
              buildHistoryCard("What is the scope of flutter development ?"),
              buildHistoryCard(
                  "How to become a cross platform developer and what are the required skill needed"),
              buildHistoryCard(
                  "How to create a good pathway for computer engineering student so that he can achieve all needed skillsHow to create a good pathway for computer engineering student so that he can achieve all needed skills"),
            ],
            // children: recentHistory.map((historyTitle) => buildHistoryCard(historyTitle))
            //     .toList(),
          ),
        ),
      ],
    );
  }

  buildBottomNavBar() {
    return Container(
      height: 70,
      color: Colors.transparent, // Set your desired background color
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
              onPressed: () {
                if (messageController.text.isNotEmpty) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          userMessage: messageController.text,
                        ),
                      ));
                  // messageController.clear();
                }
              },
              icon: const Icon(
                FontAwesomeIcons.locationArrow,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildDefaultSearchCard() {
    final random = Random();
    final firstRandomIndex = random.nextInt(Constant.cardsData.length);

    int secondRandomIndex;
    int thirdRandomIndex;
    int forthRandomIndex;
    do {
      secondRandomIndex = random.nextInt(Constant.cardsData.length);
      thirdRandomIndex = random.nextInt(Constant.cardsData.length);
      forthRandomIndex = random.nextInt(Constant.cardsData.length);
    } while (secondRandomIndex == firstRandomIndex ||
        thirdRandomIndex == firstRandomIndex ||
        thirdRandomIndex == secondRandomIndex ||
        forthRandomIndex == firstRandomIndex ||
        forthRandomIndex == secondRandomIndex ||
        forthRandomIndex == thirdRandomIndex);

    final firstCardData = Constant.cardsData[firstRandomIndex];
    final secondCardData = Constant.cardsData[secondRandomIndex];
    final thirdCardData = Constant.cardsData[thirdRandomIndex];
    final forthCardData = Constant.cardsData[forthRandomIndex];

    return Container(
      // width: double.infinity,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        children: [
          buildCard(firstCardData),
          const SizedBox(
            width: 10,
          ),
          buildCard(secondCardData),
          if (MediaQuery.of(context).size.width > 600) // Check for desktop
            ...[
            const SizedBox(width: 10),
            buildCard(thirdCardData),
            const SizedBox(width: 10),
            buildCard(forthCardData),
          ],
        ],
      ),
    );
  }

  buildDrawer() {
    return Drawer(
      backgroundColor: ColorPalette.bgColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
            // color: ColorPalette.sendCommand,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ColorPalette.sendCommand,
                    ),
                    child: const Icon(
                      EvaIcons.person,
                      color: Colors.white,
                      size: 30,
                    )),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rahul Prajapati",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    Text(
                      "rahul.coder.25@gmail.com",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorPalette.drawerAdColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Image.asset('assets/images/star.png'),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Get Plus",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Enjoy the advance AI \nmodels",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 20,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(
                        userMessage: '',
                      ),
                    ));
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Row(
                  children: [
                    Icon(
                      EvaIcons.plus,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "New Chat",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const RecentHistory(),
                //     ));
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.clockRotateLeft,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Recent History",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              )),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 35, right: 35),
            height: 1.5,
            width: double.infinity,
            color: Colors.grey.shade600,
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const Setting(),
                //     ));
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Row(
                  children: [
                    Icon(EvaIcons.settings, color: Colors.white),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const HelpCenter(),
                //     ));
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Row(
                  children: [
                    Icon(EvaIcons.questionMarkCircleOutline,
                        color: Colors.white),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Help Center",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const FeedBack(),
                //     ));
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Row(
                  children: [
                    Icon(EvaIcons.messageCircle, color: Colors.white),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Send Us FeedBack",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  buildHistoryCard(String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10, left: 20),
      // width: double.infinity,
      decoration: BoxDecoration(
          color: ColorPalette.cardContainer,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(userMessage: content),
                    ));
              },
              child: Text(
                content,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                deleteHistoryItem(content);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white54,
              )),
        ],
      ),
    );
  }

  Future<void> fetchRecentHistory() async {
    // Fetch recent history titles from the database
    // Update the state to trigger a rebuild of the UI
    setState(() {
      recentHistory = [
        "How to learn flutter for app development?",
        "Check",
        "third",
        "Forth",
      ];
    });
  }

  void deleteHistoryItem(String item) {
    // Delete the history item from the database or any storage mechanism
    // Update the state to trigger a rebuild of the UI
    setState(() {
      recentHistory.remove(item);
    });
  }

  buildCard(CardData cardFulData) {
    return Expanded(
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          width: double.infinity,
          height: min(230, 250),
          decoration: BoxDecoration(
            color: ColorPalette.cardContainer,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15, top: 15),
                decoration: BoxDecoration(
                    color: ColorPalette.chatScreenIcons,
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      cardFulData.icon,
                      color: Colors.white,
                      size: 20,
                    )),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cardFulData.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      cardFulData.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatScreen(userMessage: cardFulData.content),
                          ));
                    },
                    icon: const Icon(
                      EvaIcons.arrowForward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
