import 'package:flutter/material.dart';

// Add BoxContent model class
class BoxContent {
  final String bodyText;
  final String iconUrl;
  final String title;
  final String subtitle;

  BoxContent({
    required this.bodyText,
    required this.iconUrl,
    required this.title,
    required this.subtitle,
  });
}

// Update OrangeBoxWithText
class OrangeBoxWithText extends StatelessWidget {
  final BoxContent content;

  const OrangeBoxWithText({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.8 * MediaQuery.of(context).size.width,
      height: 0.15 * MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              height: 80.0,
              width: 80.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(content.iconUrl),
                ),
              ),
            ),
            title: Text(
              content.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              content.subtitle,
              style: const TextStyle(
                color: Colors.white,
              )
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                content.bodyText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
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

// Update SwipeableBoxes
class SwipeableBoxes extends StatefulWidget {
  final List<BoxContent> boxContents;

  const SwipeableBoxes({Key? key, required this.boxContents}) : super(key: key);

  @override
  State<SwipeableBoxes> createState() => _SwipeableBoxesState();
}

class _SwipeableBoxesState extends State<SwipeableBoxes> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 0.4 * MediaQuery.of(context).size.height,
          width: 0.8 * MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.boxContents.length,
            itemBuilder: (context, index) {
              return OrangeBoxWithText(content: widget.boxContents[index]);
            },
          ),
        ),
        const SizedBox(height: 8), // Spacing between PageView and dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.boxContents.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index 
                    ? Colors.orange 
                    : Colors.orange.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}