import 'package:flutter/material.dart';
import 'package:offstream/view/sidebar.dart';

class Variable extends StatelessWidget {
  StatelessWidget content;

  Variable({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Row(
        children: [
          Sidebar(),
          Expanded(
            child: content
          )
        ]
      )
    );
  }
}