import 'package:flutter/material.dart';
import 'package:theme_flutter/theme/theme_reader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: JsonTheme(
          key: Key("Outer"),
          child: MyHomePage(title: 'Flutter Demo Home Page'),
          json: """
{
  "colors": {
    "primaryColor": "main",
    "main": "#ff00ff",
    "secondary": "#fbfbfb",
    "mainText": "#ffbbff00",
    "secondaryText": "main"
  }
}
"""),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return JsonTheme(
      key: Key("Inner"),
      json: """{
      "colors":{
          "primaryColor":"secondary",
          "mainText": "mainText"
        }
      }""",
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style:
                  TextStyle(color: JsonTheme.of(context).getColor("mainText")),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
