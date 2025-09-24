import 'package:flutter/material.dart';

class CalendarInfo extends StatelessWidget {
  const CalendarInfo({
    required this.onSwipeUpClose,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
    super.key,
  });
  final VoidCallback onSwipeUpClose;
  final ValueChanged<double> onVerticalDragUpdate;
  final ValueChanged<double> onVerticalDragEnd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (d) => onVerticalDragUpdate(d.delta.dy),
        onVerticalDragEnd: (d) => onVerticalDragEnd(d.primaryVelocity ?? 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 192, 207, 255),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(102, 26, 49, 123), // колір тіні
                    spreadRadius: 2, // наскільки "розповзається"
                    blurRadius: 8, // ступінь розмиття
                    offset: const Offset(0, 4), // зміщення (x, y)
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(child: Center(child: Text('some data'))),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
