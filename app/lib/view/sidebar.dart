import 'package:flutter/material.dart';

import 'package:offstream/type/page.dart';
import 'package:offstream/util/util.dart';

import '../component/rounded.dart';
import '../controller/auth.dart';
import '../type/playlist_data.dart';

class Sidebar extends StatefulWidget {
  final ValueChanged<OPage>? onPageSelected;
  final OPage initialPage;

  const Sidebar({
    super.key,
    this.onPageSelected,
    this.initialPage = const OPage(Pages.library, null),
  });

  @override
  State<Sidebar> createState() => _SidebarState();

}

class _SidebarState extends State<Sidebar> {
  late OPage selectedPage;

  @override
  void initState() {
    super.initState();
    selectedPage = widget.initialPage;

    AuthController().onLoginStateChanged.listen((event) {
      updateState();
    });
  }

  void updateState() {
    setState(() {});
  }

  void _changePage(OPage page) {
    setState(() {
      selectedPage = page;
    });
    widget.onPageSelected?.call(selectedPage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Color(0x0AFFFFFF),
      padding: const EdgeInsets.only(left: 5, top: 10, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.library_music),
            title: Text('Library'),
            selected: selectedPage.page == Pages.library,
            onTap: () => _changePage(OPage(Pages.library, null)),
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            selected: selectedPage.page == Pages.search,
            onTap: () => _changePage(OPage(Pages.search, null)),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            selected: selectedPage.page == Pages.settings,
            onTap: () => _changePage(OPage(Pages.settings, null)),
          ),
          Divider(color: Colors.grey[700]),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: getPlaylists(),
            ),
          ),
        ],
      ),
    );
  }

  List<ListTile> getPlaylists() {
    var auth = AuthController();
    if (auth.loggedInUser == null) {
      return [];
    }

    List<ListTile> playlists = [];

    for (var playlist in auth.loggedInUser!.playlists) {
      playlists.add(
        ListTile(
            leading: Rounded(child: Image.network(getMissingAlbumArtPath(), scale: 5)),
            title: Text(playlist.title),
            selected: selectedPage.page == Pages.playlist && selectedPage.playlist == playlist,
            onTap: () => _changePage(OPage(Pages.playlist, playlist)
        )),
      );
    }

    return playlists;
  }
}