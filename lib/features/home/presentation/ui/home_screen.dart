import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:remedi/features/home/presentation/bloc/hour_cubit.dart';
import 'package:remedi/features/home/presentation/ui/widgets/calendar_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _reveal = 0.0;
  bool _dragging = false;
  late final DateTime _today;
  late DateTime _currentDate;
  final ScrollController _controller = ScrollController();
  late final PageController _pageController;

  final int _initialPage = 10000;
  static const double _hourItemHeight = 56;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _currentDate = _today;
    _pageController = PageController(initialPage: _initialPage);

    final dateInHours = _today.hour;
    final percent = (dateInHours * 3 / 24 - 1).clamp(0.0, 1.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToPercent(percent);
    });
  }

  void scrollToPercent(double percent) {
    final maxScroll = _controller.position.maxScrollExtent;
    final target = maxScroll * percent;
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  String _formatDate(DateTime date) => DateFormat('dd.MM.yyyy').format(date);

  void _goToPage(int offset) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _pageController.page!.toInt() + offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final paddingTopH = MediaQuery.of(context).padding.top + 56;
    final overlayTop = screenH * (_reveal - 1);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 212, 222, 255),
      appBar: _appBar(
        screenH: screenH,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24,
          children: [
            IconButton(
              onPressed: () => _goToPage(-1),
              icon: Icon(Icons.arrow_back),
            ),
            Text(_formatDate(_currentDate)),
            IconButton(
              onPressed: () => _goToPage(1),
              icon: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: paddingTopH),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentDate = _today.add(
                          Duration(days: index - _initialPage),
                        );
                      });
                    },
                    itemBuilder: (context, index) {
                      _today.add(Duration(days: index - _initialPage));
                      return BlocBuilder<HourCubit, int>(
                        builder: (context, state) {
                          return SingleChildScrollView(
                            key: PageStorageKey('sameScrollForAllDays'),
                            controller: _controller,
                            padding: EdgeInsetsGeometry.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(
                                24,
                                (int i) => _buildHourCell(i, state, index),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          _calendarInfoAnimatedCard(overlayTop, screenH),
        ],
      ),
    );
  }

  Widget _buildHourCell(int hour, int currentHour, int pageIndex) {
    final isTodayPage = pageIndex == _initialPage;
    final isCurrentHour = currentHour == hour && isTodayPage;

    return Container(
      height: _hourItemHeight,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isCurrentHour
            ? const Color.fromARGB(100, 126, 154, 255)
            : hour.isEven
            ? const Color.fromARGB(154, 234, 238, 252)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text('${hour.toString().padLeft(2, '0')}:00'),
      ),
    );
  }

  AnimatedPositioned _calendarInfoAnimatedCard(
    double overlayTop,
    double screenH,
  ) {
    return AnimatedPositioned(
      duration: _dragging ? Duration.zero : const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      top: overlayTop,
      left: 0,
      right: 0,
      height: screenH,
      child: CalendarInfo(
        height: screenH - 200,
        onSwipeUpClose: () {
          setState(() => _reveal = 0.0);
        },
        onVerticalDragUpdate: (dy) {
          setState(() {
            _reveal = (_reveal + dy / screenH).clamp(0.0, 1.0);
          });
        },
        onVerticalDragEnd: (vy) {
          final shouldClose = vy < -700 || _reveal < 0.7;
          setState(() => _reveal = shouldClose ? 0.0 : 1.0);
        },
      ),
    );
  }

  PreferredSize _appBar({required double screenH, required Widget title}) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 56),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (_) => setState(() => _dragging = true),
        onVerticalDragUpdate: (details) {
          setState(() {
            _reveal = (_reveal + details.delta.dy / screenH).clamp(0.0, 1.0);
          });
        },
        onVerticalDragEnd: (details) {
          final vy = details.primaryVelocity ?? 0;
          final shouldOpen = vy > 700 || _reveal > 0.3;
          setState(() {
            _dragging = false;
            _reveal = shouldOpen ? 1.0 : 0.0;
          });
        },
        child: AppBar(
          title: title,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 192, 207, 255),
          surfaceTintColor: const Color.fromARGB(255, 192, 207, 255),
        ),
      ),
    );
  }
}
