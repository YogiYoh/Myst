class Profile {
  final String uuid;
  final String username;
  final String rank;
  final String level;

  Profile({
    required this.uuid,
    required this.username,
    required this.rank,
    required this.level,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      uuid: json['uuid'],
      username: json['username'],
      rank: json['rank'],
      level: json['level'].toString(),
    );
  }
}
