class LocalStore {
  final String loggedInUser;

  LocalStore({
    required this.loggedInUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'loggedInUser': loggedInUser,
    };
  }

  factory LocalStore.fromJson(Map<String, dynamic> json) {
    return LocalStore(
      loggedInUser: json['loggedInUser'],
    );
  }
}