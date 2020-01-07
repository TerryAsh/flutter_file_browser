import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:file_browser/file_browser.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FileBrowser.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: GestureDetector(
          child: Text('Running on: $_platformVersion\n'),
          onTap: _pickDocument,
        ),
      ),
    );
  }

  _pickDocument() async {
    String result;
    try {
      FileBrowserPickerParams params = FileBrowserPickerParams(
        allowedFileExtensions: null,
        allowedUtiTypes: null,
        allowedMimeTypes: null,
      );

      FileBrowser.openDocument(this.context);
      print("result" + result);
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      setState(() {});
    }

    setState(() {});
  }
}
