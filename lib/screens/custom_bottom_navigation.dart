import 'package:chat_gpt/config/ColorPalette.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: ColorPalette.cardContainer, // Set your desired background color
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Message ChatGPT...',
                contentPadding: const EdgeInsets.only(left: 20),
                suffixIcon: const Icon(Icons.mic,color: Colors.white,),
                hintStyle: const TextStyle(color: Colors.white54,),
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
              onPressed: () {  },
              icon: const Icon(
                Icons.send,
                color: Colors.black,
              ),),
          ),
        ],
      ),
    );
  }
}
