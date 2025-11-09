import 'package:flutter/material.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:peik/controller/auth_controller.dart';
import 'package:peik/controller/playback_controller.dart';
import 'package:peik/controller/storage_controller.dart';
import 'package:peik/controller/user_controller.dart';
import 'package:peik/page/library_page.dart';
import 'package:peik/page/playlist_page.dart';
import 'package:peik/page/settings_page.dart';
import 'package:peik/type/page.dart';
import 'package:peik/view/multimedia.dart';
import 'package:peik/view/sidebar.dart';

import 'component/pin.dart';

void main() async {
  JustAudioMediaKit.ensureInitialized();

  //await StorageController().saveStream(getSampleStreamData());
  await StorageController().init();

  await AuthController().init();
  PlaybackController().init();

  runApp(const PeikApp());
}

class PeikApp extends StatefulWidget {
  const PeikApp({super.key});

  @override
  State<PeikApp> createState() => _PeikAppState();
}

class _PeikAppState extends State<PeikApp> {
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
    const String appTitle = 'Peik';

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
          uuid: _selectedPage.playlist!.uuid,
        );
    }
  }
}