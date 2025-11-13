// Page Enum

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