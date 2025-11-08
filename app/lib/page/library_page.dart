import 'package:flutter/material.dart';
import 'package:offstream/component/playlist.dart';
import 'package:offstream/controller/user_controller.dart';
import 'package:offstream/util/util.dart';

import '../component/rounded.dart';
import '../controller/auth_controller.dart';
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

  void updateState() {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Playlist>>(
        future: _buildPlaylistCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
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
    );
  }

  Future<List<Playlist>> _buildPlaylistCards() async {
    List<Playlist> cards = [];

    var playlists = await userController.user;

    for  (var playlist in playlists.playlists) {
      cards.add(
        Playlist(
          playlist: playlist,
          widget: Card(
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              onTap: () {
                var page = OPage(Pages.playlist, playlist);
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
                      maxLines: 2,
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