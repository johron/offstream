import 'package:flutter/material.dart';

class Playlist extends StatefulWidget {
  final String title;
  final IconData icon;
  final String repo;

  final ValueChanged<bool> onSelected;
  final bool selected;

  const Playlist({
    super.key,
    required this.title,
    required this.icon,
    required this.repo,
    required this.onSelected,
    this.selected = false,
  });

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  late String title;
  late IconData icon;
  late String repo;

  late bool selected;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    icon = widget.icon;
    repo = widget.repo;
    selected = widget.selected;
  }

  void _toggleSelected() {
    setState(() {
      selected = !selected;
    });
    widget.onSelected(selected);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(repo),
      onTap: () => _toggleSelected(),
    );
  }
}