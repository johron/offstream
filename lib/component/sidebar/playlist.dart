import 'package:flutter/material.dart';

import '../../type/playlist_data.dart';
import '../rounded.dart';

class Playlist extends StatefulWidget {
  final PlaylistData data;
  final ValueChanged<bool> onSelected;
  final bool selected;

  const Playlist({
    super.key,
    required this.data,
    required this.onSelected,
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
    widget.onSelected(selected);
  }

  @override
  Widget build(BuildContext context) {
    var iconPath = data.iconPath;
    if (iconPath == null || iconPath.isEmpty) {
      iconPath = 'https://community.spotify.com/t5/image/serverpage/image-id/55829iC2AD64ADB887E2A5/image-size/large?v=v2&px=999';
    }

    return ListTile(
      leading: Rounded(child: Image.network(iconPath, scale: 5)),
      title: Text(data.title),
      selected: selected,
      onTap: () => _toggleSelected(),
    );
  }
}