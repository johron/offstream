import 'package:flutter/material.dart';

class IndexAndPlay extends StatefulWidget {
  final int index;
  final VoidCallback onPlay;

  const IndexAndPlay({super.key, required this.index, required this.onPlay});

  @override
  State<IndexAndPlay> createState() => _IndexAndPlayState();
}

class _IndexAndPlayState extends State<IndexAndPlay> {
  late int index;

  bool isHovering = false;

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: isHovering
        ? IconButton(
          icon: Icon(Icons.play_arrow_rounded),
          onPressed: () {
            widget.onPlay();
          },
          iconSize: 20,
        )
        : Text('${index + 1}', style: TextStyle(color: Colors.white70)),
    );
  }
}