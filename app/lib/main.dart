import 'package:flutter/material.dart';
import 'package:offstream/controller/auth.dart';
import 'package:offstream/controller/playback.dart';
import 'package:offstream/controller/storage.dart';
import 'package:offstream/page/settings_page.dart';
import 'package:offstream/type/page.dart';
import 'package:offstream/type/stream_data.dart';
import 'package:offstream/util/util.dart';

import 'package:offstream/view/multimedia.dart';
import 'package:offstream/page/playlist_page.dart';
import 'package:offstream/view/sidebar.dart';

import 'package:just_audio_media_kit/just_audio_media_kit.dart';

void main() async {
  JustAudioMediaKit.ensureInitialized();

  //await StorageController().saveStream(getSampleStreamData());
  await StorageController().init();

  AuthController().init();
  PlaybackController().init();

  runApp(const OffstreamApp());
}

class OffstreamApp extends StatefulWidget {
  const OffstreamApp({super.key});

  @override
  State<OffstreamApp> createState() => _OffstreamAppState();
}

class _OffstreamAppState extends State<OffstreamApp> {
  OPage _selectedPage = OPage(Pages.library, null);

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
            Sidebar(
              initialPage: _selectedPage,
              onPageSelected: (page) {
                setState(() {
                  _selectedPage = page;
                });
              },
            ),
            Expanded(child: Container(
              child: _buildPageContent(),
            )),
          ],
        ),
        bottomNavigationBar: Multimedia()
      ),
    );
  }

  Widget _buildPageContent() {
    // Return different widgets based on selected page
    switch (_selectedPage.page) {
      case Pages.library:
        return Text('Library Content');
      case Pages.search:
        return Text('Search Content');
      case Pages.settings:
        return SettingsPage();
      case Pages.playlist:
        if (_selectedPage.playlist == null) {
          return Text('No playlist selected');
        }

        var auth = AuthController();
        if (auth.loggedInUser == null) {
          return Text('User not logged in');
        }

        return PlaylistPage(
          playlist: _selectedPage.playlist!,
        );
    }
  }
}