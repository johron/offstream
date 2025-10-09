import 'package:flutter/material.dart';
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
        bottomNavigationBar: BottomAppBar(
          height: 100,
          color: Colors.grey[900],
          child: Row(children: [
            Column(children: [Text("test")]),
            Column(children: [
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {},
              ),
            ]),
            Column(children: [Text("test")]),
          ])
        )
      ),
    );
  }
}