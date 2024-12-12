import 'package:flutter/material.dart';

class OrangeBoxWithText extends StatelessWidget {
  final String text;

  const OrangeBoxWithText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.9 * MediaQuery.of(context).size.width, // 90% of screen width
      height: 0.2 * MediaQuery.of(context).size.height, // 20% of screen height
      padding: const EdgeInsets.all(16.0), // Add padding inside the box
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: SingleChildScrollView(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white, // Text color for contrast
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
      ),
    ),

    );
  }
}

class TextRectangleGrid extends StatelessWidget {
  final List<String> texts;

  const TextRectangleGrid({Key? key, required this.texts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8.0, // Horizontal space between rectangles
        runSpacing: 8.0, // Vertical space between rectangles
        children: texts.map((text) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}