import 'package:flutter/material.dart';
import 'package:offstream/component/dialog/user_pin_dialog.dart';
import 'package:offstream/controller/auth_controller.dart';
import 'package:offstream/controller/playback_controller.dart';
import 'package:offstream/controller/storage_controller.dart';
import 'package:offstream/controller/user_controller.dart';
import 'package:offstream/page/library_page.dart';
import 'package:offstream/page/settings_page.dart';
import 'package:offstream/type/page.dart';
import 'package:offstream/type/stream_data.dart';
import 'package:offstream/util/util.dart';

import 'package:offstream/view/multimedia.dart';
import 'package:offstream/page/playlist_page.dart';
import 'package:offstream/view/sidebar.dart';

import 'package:just_audio_media_kit/just_audio_media_kit.dart';

import 'component/pin.dart';

void main() async {
  JustAudioMediaKit.ensureInitialized();

  //await StorageController().saveStream(getSampleStreamData());
  await StorageController().init();

  await AuthController().init();
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

  final UserController userController = UserController();

  @override
  void initState() {
    userController.onUserDeletedPlaylist.listen((_) {
      if (_selectedPage.page == Pages.playlist) {
        _selectedPage = OPage(Pages.library, null);
        setState(() {});
      }
    });

    userController.onUserSelectedPage.listen((page) {
      _selectedPage = page;
      updateState();
    });

    super.initState();
  }

  void updateState() {
    setState(() {});
  }

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
            Pin(),
            Sidebar(
              initialPage: _selectedPage,
              onPageSelected: (page) {
                _selectedPage = page;
                updateState();
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
        return LibraryPage();
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