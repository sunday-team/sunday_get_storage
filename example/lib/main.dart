import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sunday_get_storage/sunday_get_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final box = GetStorage("main");
  box.init();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var isDarkMode = false;
  final box = GetStorage("main");

  @override
  void initState() {
    super.initState();
    box.listenKey('darkmode', (newValue) {
      setState(() {
        isDarkMode = newValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode
          ? ThemeData.dark()
          : ThemeData.from(colorScheme: ColorScheme.light()),
      home: Scaffold(
        appBar: AppBar(title: Text("Get Storage")),
        body: Center(
          child: SwitchListTile(
            title: Text("Touch to change ThemeMode"),
            value: isDarkMode,
            onChanged: (bool value) {
              box.write('darkmode', value);
              setState(() {
                isDarkMode = value;
              });
              if (kDebugMode) {
                print(box.read("darkmode"));
              }
            },
          ),
        ),
      ),
    );
  }
}
