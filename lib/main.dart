import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_location_test/get_current_location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();

    print("Native called background task: $task");

    if (task == 'get-location') {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        print('User current position in background: $position');
      } catch (e) {
        print('Error fetching location in background: $e');
      }
    }

    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Workmanger'),
        ),
        body: ElevatedButton(
          onPressed: () async {
            Workmanager().registerPeriodicTask(
              "one-time-task",
              "get-location",
              frequency: const Duration(minutes: 15),
            );
          },
          child: const Center(
            child: Text('ADD'),
          ),
        ),
      ),
    );
  }
}
