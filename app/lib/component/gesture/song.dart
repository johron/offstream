import 'package:flutter/material.dart';
import 'package:peik/component/snackbar.dart';
import 'package:peik/controller/storage_controller.dart';
import 'package:peik/type/song_data.dart';

class Song extends StatelessWidget {
  final SongData song;
  final Widget widget;
  final bool disableContextMenu;

  const Song({
    required this.song,
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
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        );
        if (selected == 'delete') {
          StorageController().removeSong(song.uuid).then((success) {
            if (!success) {
              OSnackBar(message: "Failed to delete song '${song.title}'").show(context);
            }
          });
        }
      },
      child: widget,
    );
  }
}