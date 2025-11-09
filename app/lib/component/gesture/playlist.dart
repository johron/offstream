import 'package:flutter/material.dart';
import 'package:peik/component/snackbar.dart';
import 'package:peik/type/playlist_data.dart';

import '../../controller/user_controller.dart';

class Playlist extends StatelessWidget {
  final PlaylistData playlist;
  final Widget widget;
  final bool disableContextMenu;

  const Playlist({
    required this.playlist,
    required this.widget,
    this.disableContextMenu = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) async {
        if (disableContextMenu) return;
        final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
        final selected = await showMenu<String>(
          context: context,
          position: RelativeRect.fromRect(
            details.globalPosition & const Size(1, 1),
            Offset.zero & overlay.size,
          ),
          items: const [
            PopupMenuItem(value: 'rename', child: Text('Rename')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        );
        if (selected == 'rename') {
          print('Rename playlist: ${playlist.title}');
        } else if (selected == 'delete') {
          UserController().deletePlaylist(playlist.uuid).then((success) {
            if (!success) {
              OSnackBar(message: "Failed to delete playlist '${playlist.title}'").show(context);
            }
          });
        }
      },
      child: widget,
    );
  }
}