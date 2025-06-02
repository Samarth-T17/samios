import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const platform = MethodChannel('coreml_channel');

  Future<void> _runModels() async {
    try {
      final result = await platform.invokeMethod('runModels');
      print('Inference Result: $result');
    } on PlatformException catch (e) {
      print("Failed: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("CoreML Test")),
        body: Center(
          child: ElevatedButton(
            onPressed: _runModels,
            child: Text("Run Models"),
          ),
        ),
      ),
    );
  }
}

