
import 'package:flutter/material.dart';
import 'package:offstream/type/page.dart';
import 'package:offstream/util/util.dart';

import 'package:offstream/view/multimedia.dart';
import 'package:offstream/page/playlist_page.dart';
import 'package:offstream/view/sidebar.dart';

void main() async {
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
        return Text('Settings Content');
      case Pages.playlist:
        if (_selectedPage.playlistPath == null) {
          return Text('No playlist selected');
        }

        return PlaylistPage(
          playlist: getSamplePlaylist(),
        );
    }
  }
}