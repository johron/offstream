// Page Enum
import 'package:offstream/type/playlist_data.dart';

enum Pages {
  library,
  search,
  settings,
  playlist,
}

class OPage {
  final Pages page;
  final PlaylistData? playlist; // Git repository path, not applicable for other pages

  const OPage(this.page, this.playlist);
}