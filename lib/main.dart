import 'package:flutter/material.dart';
import 'package:offstream/view/multimedia.dart';
import 'package:offstream/view/playlists.dart';
import 'package:offstream/view/variable.dart';

void main() {
  runApp(const OffstreamApp());
}

class OffstreamApp extends StatelessWidget {
  const OffstreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Offstream';
    final Variable mainView = Variable(content: const Playlists());

    return MaterialApp(
      title: appTitle,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: Column(
          children: [
            mainView,
          ],
        ),
        bottomNavigationBar: Multimedia()
      ),
    );
  }
}