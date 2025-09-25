import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remedi/features/home/presentation/bloc/hour_cubit.dart';
import 'package:remedi/router/app_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => HourCubit())],
      child: MaterialApp.router(routerConfig: router),
    );
  }
}
