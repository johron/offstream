// Page Enum
import 'package:peik/type/playlist_data.dart';

enum Pages {
  library,
  search,
  settings,
  playlist,
}

class OPage {
  final Pages page;
  final String? uuid; // Git repository path, not applicable for other pages

  const OPage(this.page, this.uuid);
}