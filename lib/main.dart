import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';

import 'package:offstream/view/multimedia.dart';
import 'package:offstream/view/playlist.dart';
import 'package:offstream/view/sidebar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 700),
    minimumSize: Size(1000, 600),
    center: true,
    title: "Offstream",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const OffstreamApp());
}

class OffstreamApp extends StatefulWidget {
  const OffstreamApp({super.key});

  @override
  State<OffstreamApp> createState() => _OffstreamAppState();
}

class _OffstreamAppState extends State<OffstreamApp> {
  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Offstream';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: Flex(
          direction: Axis.horizontal,
          children: [
            Sidebar(),
            Playlist(),
          ],
        ),
        bottomNavigationBar: Multimedia()
      ),
    );
  }
}