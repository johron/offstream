import 'package:flutter/material.dart';

class Playlist extends StatelessWidget {
  final String title;
  final IconData icon;
  final String repo;

  const Playlist({super.key, required this.title, required this.icon, required this.repo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(repo),
      onTap: () {},
    );
  }
}