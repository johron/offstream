import 'package:flutter/material.dart';
import 'package:offstream/component/rounded.dart';

class Song extends StatelessWidget {
  final String title;
  final String artist;
  final String albumArtUrl;

  const Song({super.key, required this.title, required this.artist, required this.albumArtUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Rounded(child: Image.network(albumArtUrl)),
      title: Text(title),
      subtitle: Text(artist),
    );
  }
}