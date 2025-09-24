import 'package:flutter/material.dart';
import 'package:remedi/features/home/presentation/ui/widgets/calendar_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double reveal = 0.0;
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final paddingTopH = MediaQuery.of(context).padding.top + 56;
    final overlayTop = screenH * (reveal - 1);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 212, 222, 255),
      appBar: _appBar(screenH),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: paddingTopH),
                Padding(padding: const EdgeInsets.all(8), child: Text(':)')),
              ],
            ),
          ),
          _calendarInfoAnimatedCard(overlayTop, screenH),
        ],
      ),
    );
  }

  AnimatedPositioned _calendarInfoAnimatedCard(
    double overlayTop,
    double screenH,
  ) {
    return AnimatedPositioned(
      duration: dragging ? Duration.zero : const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      top: overlayTop,
      left: 0,
      right: 0,
      height: screenH,
      child: CalendarInfo(
        onSwipeUpClose: () {
          setState(() => reveal = 0.0);
        },
        onVerticalDragUpdate: (dy) {
          setState(() {
            reveal = (reveal + dy / screenH).clamp(0.0, 1.0);
          });
        },
        onVerticalDragEnd: (vy) {
          final shouldClose = vy < -700 || reveal < 0.7;
          setState(() => reveal = shouldClose ? 0.0 : 1.0);
        },
      ),
    );
  }

  PreferredSize _appBar(double screenH) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 56),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (_) => setState(() => dragging = true),
        onVerticalDragUpdate: (details) {
          setState(() {
            reveal = (reveal + details.delta.dy / screenH).clamp(0.0, 1.0);
          });
        },
        onVerticalDragEnd: (details) {
          final vy = details.primaryVelocity ?? 0;
          final shouldOpen = vy > 700 || reveal > 0.3;
          setState(() {
            dragging = false;
            reveal = shouldOpen ? 1.0 : 0.0;
          });
        },
        child: AppBar(
          title: const Text('AppBar'),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 192, 207, 255),
        ),
      ),
    );
  }
}
