import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'my_home_page.dart';
import 'yandex_initializer.dart'; // Import the initializer

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async operations before runApp

  final initializer = YandexInitializer();
  final sdkStatus = await initializer.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(sdkStatus: sdkStatus), // Pass status to AppState
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
