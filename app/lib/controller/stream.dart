class StreamController {
  StreamController._internal();

  static final StreamController _instance = StreamController._internal();

  factory StreamController() => _instance;

  String _stream = "";

  void init() {
  }

  void set(String stream) {
    _stream = stream;
  }
}