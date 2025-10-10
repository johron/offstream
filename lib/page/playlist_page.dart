import 'package:flutter/material.dart';
import 'package:offstream/view/sidebar.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Song Title',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'Artist Name',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]
      ),
    );
  }
}

