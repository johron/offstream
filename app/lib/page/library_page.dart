import 'package:flutter/material.dart';
import 'package:peik/component/gesture/playlist.dart';
import 'package:peik/component/snackbar.dart';
import 'package:peik/controller/user_controller.dart';
import 'package:peik/util/util.dart';

import '../component/dialog/playlist_create_dialog.dart';
import '../component/dialog/song_import_dialog.dart';
import '../component/rounded.dart';
import '../controller/auth_controller.dart';
import '../controller/storage_controller.dart';
import '../type/page.dart';
import '../util/color.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final AuthController authController = AuthController();
  final UserController userController = UserController();
  final StorageController storageController = StorageController();

  void updateState() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    authController.onAuthenticatedStream.listen((event) {
      updateState();
    });
    
    userController.onUserUpdated.listen((event) {
      updateState();
    });

    super.initState();
  }

  // TODO: Remake this: on the top before the grid, three buttons "Import Song(s)", "Create Playlist", "All Songs",
  // TODO: rectangular buttons with icons, kind of like the current import song button but wider and shorter on the top

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Flex(
        direction: Axis.vertical,
        children: [
          SizedBox(height: 125, child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.7,
            ),
            children: [
              staticCard("Import Song", Icons.add_rounded, () {
                carefulShowDialog(context: context, builder: (context) {
                  return SongImportDialog();
                });
              }),
              staticCard("Create Playlist", Icons.playlist_add_rounded, () {
                carefulShowDialog(context: context, builder: (context) {
                  return PlaylistCreateDialog();
                });
              }),
              staticCard("All Songs", Icons.music_note_rounded, () {
                var page = OPage(Pages.playlist, "all_songs");
                userController.userSelectedPageController.add(page);
              })
            ],
          )),
          Expanded(child: FutureBuilder<List<Widget>>(
            future: _buildPlaylistCards(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                if (snapshot.error.toString() == "Exception: No user is logged in") {
                  var page = OPage(Pages.settings, null);
                  userController.userSelectedPageController.add(page);
                  return Center(child: Text('Please log in to view your library.'));
                }
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final cards = snapshot.data ?? <Card>[];
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                children: cards,
              );
            },
          )
        )],
      ),
    );
  }

  Widget staticCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
        child: InkWell(
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: getToggledColor()),
                SizedBox(height: 6),
                Text(title, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        )
    );
  }

  Future<List<Widget>> _buildPlaylistCards() async {
    List<Widget> cards = [];

    var user = await userController.user;
    var playlists = user.playlists;

    for (var playlist in playlists) {
      cards.add(
        Playlist(
          disableContextMenu: playlist.title == "All Songs",
          playlist: playlist,
          widget: Card(
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              onTap: () {
                var page = OPage(Pages.playlist, playlist.uuid);
                userController.userSelectedPageController.add(page);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Rounded(radius: 8, child: Image.network(getMissingAlbumArtPath(), fit: BoxFit.cover))
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: Material(
                            color: getToggledColor(),
                            shape: const CircleBorder(),
                            child: IconButton(
                              icon: const Icon(Icons.play_arrow_rounded, color: Colors.black),
                              onPressed: () {
                                print("Play playlist ${playlist.title}");
                              },
                              splashRadius: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      playlist.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return cards;
  }
}