import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class HourCubit extends Cubit<int> {
  HourCubit() : super(DateTime.now().hour) {
    _startTimer();
  }
  Timer? _timer;

  void _startTimer() {
    var lastHour = state;
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = DateTime.now().hour;
      if (now != lastHour) {
        lastHour = now;
        emit(now);
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
