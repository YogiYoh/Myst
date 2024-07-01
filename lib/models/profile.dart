// lib/models/profile.dart
import 'skills.dart';

class Skills {
  final Skill taming;
  final Skill farming;
  // Add other skills here as needed

  Skills({
    required this.taming,
    required this.farming,
    // Add other skills here as required
  });

  factory Skills.fromJson(Map<String, dynamic> json) {
    return Skills(
      taming: Skill.fromJson(json['taming'] ?? {}),
      farming: Skill.fromJson(json['farming'] ?? {}),
      // Add other skills here as required
    );
  }
}

class Profile {
  final String profileId;
  final String cuteName;
  final String gameMode;
  final bool current;
  final Skills skills;

  Profile({
    required this.profileId,
    required this.cuteName,
    required this.gameMode,
    required this.current,
    required this.skills,
  });

  // Factory method to convert JSON into a Profile object
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileId: json['profile_id'] ?? '', // ?? ' ' Use an empty string if 'profile_id' is null
      cuteName: json['cute_name'] ?? '',
      gameMode: json['game_mode'] ?? '',
      current: json['current'] ?? false,
      skills: Skills.fromJson(json['data']['skills']['skills'] ?? {}) ,  
    );
  }
}