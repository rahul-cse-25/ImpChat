import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Constant {
  static final List<CardData> cardsData = [
    CardData(
      icon: FontAwesomeIcons.code,
      title: "Write Code",
      content:
          "Write code of flutter to make a container having border radius 50",
    ),
    CardData(
      icon: FontAwesomeIcons.optinMonster,
      title: "Option Trading",
      content: "How to learn about option trading",
    ),
    CardData(
      icon: FontAwesomeIcons.globe,
      title: "Global warming",
      content: "tell me all about global warming",
    ),
    CardData(
      icon: FontAwesomeIcons.faceLaugh,
      title: "Joke",
      content: "tell me a joke",
    ),
    CardData(
      icon: FontAwesomeIcons.java,
      title: "Java programming",
      content: "what is constructor in java",
    ),
    CardData(
      icon: FontAwesomeIcons.houseMedicalCircleCheck,
      title: "Medicine survey",
      content: "which medicine is used to take care of pain",
    ),
    CardData(
      icon: FontAwesomeIcons.fortyTwoGroup,
      title: "Guides",
      content: "which field have potential growth in future",
    ),
    CardData(
      icon: FontAwesomeIcons.anchor,
      title: "Anchor",
      content: "what is anchor ?",
    ),
    CardData(
      icon: FontAwesomeIcons.boltLightning,
      title: "Electricity",
      content: "what is the formula of Current ?",
    ),
    CardData(
      icon: FontAwesomeIcons.bots,
      title: "Artificial intelligence",
      content: "what is the scope of artificial intelligence",
    ),
    // Add more CardData items as needed
  ];
}

class CardData {
  final IconData icon;
  final String title;
  final String content;

  CardData({required this.icon, required this.title, required this.content});
}
