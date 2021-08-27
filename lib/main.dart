
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_config/flutter_config.dart';
import 'map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  // await dotenv.load(fileName: "assets/.env");
  // print(dotenv.get("API_KEY"));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    
    // if (Platform.isIOS) {
    //   return CupertinoApp(
    //     home: CupertinoPageScaffold(
    //       navigationBar: CupertinoNavigationBar(
    //         backgroundColor: Colors.green[700],
    //         middle: Text('Maps Sample App'),
    //         trailing: Text("zoom: $currentZoomLevel"),
    //       ),
    //       child: SafeArea(
    //         child: Text("Maps"),
    //         //MainMap(),
    //       ),
    //     ),
    //   );
    // } else {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mappy'),
          backgroundColor: Colors.green[700],
          actions: [
            IconButton(onPressed: gotoSearch, icon: Icon(Icons.search))
          ],
        ),
        body: MainMap(),
        ),
    );
    // }
  }
  void gotoSearch() {
    // navigato
  }
  
}
