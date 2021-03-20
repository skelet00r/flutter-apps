import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bin-to-dec',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'bin-to-dec'),
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
  String output = "0";

  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String bin2Dec(String value) {
    if (value == null) return "0";
    if (value.length != 8) return "0";
    return int.parse(value, radix: 2).toString();
  }

  void onChanged (value) {
    setState(() {
      output = bin2Dec(textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter the binary code to convert to decimal',
            ),
            TextField(
              controller: textController,
              maxLength: 8,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
              autofocus: true,
              keyboardType: TextInputType.phone,
              inputFormatters: [ 
                FilteringTextInputFormatter.allow(RegExp('[0-1]')) 
              ],
              onChanged: onChanged,
            ),
            Text(output, style: Theme.of(context).textTheme.headline1),
          ],
        ),
      ),
    );
  }
}
