import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:web_scraper/web_scraper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loaded = false;
  String temperature;
  String description;
  String rainFall;
  String location;
  String siteUrl = 'https://weather.naver.com/';

  @override
  void initState() {
    super.initState();
    getData();
    HomeWidget.setAppGroupId('group.com.swfact.home');
  }

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
        HomeWidget.getWidgetData<String>('temperature',
            defaultValue: 'Default temperature')
            .then((value) =>
            setState(() {
              temperature = value;
            })),
        HomeWidget.getWidgetData<String>('description',
            defaultValue: 'Default description')
            .then((value) =>
            setState(() {
              description = value;
            })),
        HomeWidget.getWidgetData<String>('rainFall',
            defaultValue: 'Default rainFall')
            .then((value) =>
            setState(() {
              rainFall = value;
            })),
        HomeWidget.getWidgetData<String>('location',
            defaultValue: 'Default location')
            .then((value) =>
            setState(() {
              location = value;
            })),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Getting Data. $exception');
    }
  }

  Future<void> _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeWidget Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (loaded)
                ? Column(
              children: [
                Text(temperature),
                Text(description),
                Text(rainFall),
                Text(location),
              ],
            )
                : CircularProgressIndicator(),
            ElevatedButton(
              onPressed: _sendAndUpdate,
              child: Text('위젯에 날씨 적용하기'),
            ),
            ElevatedButton(
              onPressed: _loadData,
              child: Text('위젯에 있는 날씨 불러오기'),
            ),
            ElevatedButton(
              onPressed: getData,
              child: Text('날씨 불러오기'),
            ),
          ],
        ),
      ),
    );
  }

  void getData() async {
    final webScraper = WebScraper(siteUrl);
    if (await webScraper.loadWebPage("")) {
      var _temperature =
      webScraper.getElement('div.weather_area > strong.current', ['title']);
      var _description = webScraper.getElement(
          'div.weather_area > p.summary > span.weather.before_slash',
          ['innerHtml']);
      var _rainFall = webScraper.getElement(
          'div.weather_area > dl.summary_list > dd.desc', ['innerHtml']);
      var _location = webScraper.getElement(
          'div.location_area > strong.location_name', ['innerHtml']);

      setState(() {
        temperature = _temperature[0]['title'].replaceAll(RegExp(r'현재 온도'), '');
        description = _description[0]['title'];
        rainFall = _rainFall[0]['title'];
        location = _location[0]['title'];
        loaded = true;
      });
    }
  }
}
