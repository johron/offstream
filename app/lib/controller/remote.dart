class RemoteController {
  RemoteController._internal();

  static final RemoteController _instance = RemoteController._internal();

  factory RemoteController() => _instance;

  String _stream = "";

  void init() {
  }

  void set(String stream) {
    _stream = stream;
  }
}