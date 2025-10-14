import 'package:flutter/material.dart';
import 'package:offstream/util/util.dart';

import '../../type/playlist_data.dart';
import '../rounded.dart';

class Playlist extends StatefulWidget {
  final PlaylistData data;
  final ValueChanged<bool> onTap;
  final bool selected;

  const Playlist({
    super.key,
    required this.data,
    required this.onTap,
    this.selected = false,
  });

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  late PlaylistData data;
  late bool selected;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    selected = widget.selected;
  }

  void _toggleSelected() {
    setState(() {
      selected = true;
    });
    widget.onTap(selected);
  }

  @override
  Widget build(BuildContext context) {
      var iconPath = data.iconPath;
      if (iconPath == null || iconPath.isEmpty) {
        iconPath = getMissingAlbumArtPath();
      }

      return ListTile(
        leading: Rounded(child: Image.network(iconPath, scale: 5)),
        title: Text(data.title),
        selected: selected,
        onTap: () => _toggleSelected(),
      );
  }
}