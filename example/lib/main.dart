import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';

// /// Used for Background Updates using Workmanager Plugin
// void callbackDispatcher() {
//   Workmanager.executeTask((taskName, inputData) {
//     final now = DateTime.now();
//     return Future.wait<bool>([
//       HomeWidget.saveWidgetData(
//         'title',
//         'Updated from Background',
//       ),
//       HomeWidget.saveWidgetData(
//         'message',
//         '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
//       ),
//       HomeWidget.updateWidget(
//         name: 'HomeWidgetExampleProvider',
//         iOSName: 'HomeWidgetExample',
//       ),
//     ]).then((value) {
//       return !value.contains(false);
//     });
//   });
// }

/// Called when Doing Background Work initiated from Widget
// void backgroundCallback(Uri data) async {
//   print(data);
//
//   if (data.host == 'titleclicked') {
//     final greetings = [
//       'Hello',
//       'Hallo',
//       'Bonjour',
//       'Hola',
//       'Ciao',
//       '哈洛',
//       '안녕하세요',
//       'xin chào'
//     ];
//     final selectedGreeting = greetings[Random().nextInt(greetings.length)];
//
//     await HomeWidget.saveWidgetData<String>('title', selectedGreeting);
//     await HomeWidget.updateWidget(
//         name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
//   }
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Workmanager.initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String temperature = '32';
  String description = '구름많음';
  String rainFall = '30';
  String location = '중구 을지로1가';

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId('group.com.swfact.home');
    // HomeWidget.registerBackgroundCallback(backgroundCallback);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  // @override
  // void dispose() {
  //   _titleController.dispose();
  //   _messageController.dispose();
  //   super.dispose();
  // }

  Future<void> _sendData() async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('temperature', temperature),
        HomeWidget.saveWidgetData<String>('description', description),
        HomeWidget.saveWidgetData<String>('rainFall', rainFall),
        HomeWidget.saveWidgetData<String>('location', location),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future<void> _updateWidget() async {
    try {
      return HomeWidget.updateWidget(
          name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  Future<void> _loadData() async {
    try {
      return Future.wait([
        HomeWidget.getWidgetData<String>('temperature', defaultValue: 'Default temperature')
            .then((value) => temperature = value),
        HomeWidget.getWidgetData<String>('description', defaultValue: 'Default description')
            .then((value) => description = value),
        HomeWidget.getWidgetData<String>('rainFall', defaultValue: 'Default rainFall')
            .then((value) => rainFall = value),
        HomeWidget.getWidgetData<String>('location',
                defaultValue: 'Default location')
            .then((value) => location = value),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Getting Data. $exception');
    }
  }

  Future<void> _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri uri) {
    if (uri != null) {
      showDialog(
          context: context,
          builder: (buildContext) => AlertDialog(
                title: Text('App started from HomeScreenWidget'),
                content: Text('Here is the URI: $uri'),
              ));
    }
  }

  // void _startBackgroundUpdate() {
  //   Workmanager.registerPeriodicTask('1', 'widgetBackgroundUpdate',
  //       frequency: Duration(minutes: 15));
  // }
  //
  // void _stopBackgroundUpdate() {
  //   Workmanager.cancelByUniqueName('1');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeWidget Example'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(temperature),
            Text(description),
            Text(rainFall),
            Text(location),
            ElevatedButton(
              onPressed: _sendAndUpdate,
              child: Text('Send Data to Widget'),
            ),
            ElevatedButton(
              onPressed: _loadData,
              child: Text('Load Data'),
            ),
            ElevatedButton(
              onPressed: _checkForWidgetLaunch,
              child: Text('Check For Widget Launch'),
            ),
            // if (Platform.isAndroid)
            //   ElevatedButton(
            //     onPressed: _startBackgroundUpdate,
            //     child: Text('Update in background'),
            //   ),
            // if (Platform.isAndroid)
            //   ElevatedButton(
            //     onPressed: _stopBackgroundUpdate,
            //     child: Text('Stop updating in background'),
            //   )
          ],
        ),
      ),
    );
  }
}
