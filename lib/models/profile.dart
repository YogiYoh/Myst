// lib/models/profile.dart
import 'skills.dart';

class Skills {
  final Skill taming;
  final Skill farming;
  final Skill mining; 
  final Skill combat; 
  final Skill foraging; 
  final Skill fishing; 
  final Skill enchanting; 
  final Skill alchemy; 
  final Skill carpentry; 
  final Skill runecrafting; 
  // Add other skills here as needed

  Skills({
    required this.taming,
    required this.farming,
    required this.mining,
    required this.combat,
    required this.foraging,
    required this.fishing,
    required this.enchanting, 
    required this.alchemy,
    required this.carpentry, 
    required this.runecrafting,
    // Add other skills here as required
  });

  factory Skills.fromJson(Map<String, dynamic> json) {
    return Skills(
      taming: Skill.fromJson(json['taming'] ?? {}),
      farming: Skill.fromJson(json['farming'] ?? {}),
      mining: Skill.fromJson(json['mining'] ?? {}),
      combat: Skill.fromJson(json['combat'] ?? {}), 
      foraging: Skill.fromJson(json['foraging'] ?? {}), 
      fishing: Skill.fromJson(json['fishing'] ?? {}), 
      enchanting: Skill.fromJson(json['enchanting'] ?? {}), 
      alchemy: Skill.fromJson(json['alchemy'] ?? {}), 
      carpentry: Skill.fromJson(json['carpentry'] ?? {}), 
      runecrafting: Skill.fromJson(json['runecrafting'] ?? {}), 
      // Add other skills here as required
    );
  }
}
class Level{
  final int level;
  final int xpCurrent; 
  final int xpForNext;

Level({
    required this.level, 
    required this.xpCurrent,
    required this.xpForNext,
});



factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      level: json['level'] ?? 0, 
      xpCurrent: json['xpCurrent'] ?? 0, 
      xpForNext: json['xpForNext'] ?? 0, 
    );
  }
}


class username{
  final String name; 

  username({
    required this.name,
  });


  factory username.fromJson(Map<String, dynamic> json) {
    return username(
      name: json['display_name'] ?? '', 
    );
  }
}



class Profile {
  final String profileId;
  final String cuteName;
  final String gameMode;
  final bool current;
  final Skills skills;
  final Level levels;
  final username name; 

  Profile({
    required this.profileId,
    required this.cuteName,
    required this.gameMode,
    required this.current,
    required this.skills,
    required this.levels,
    required this.name,
  });

  // Factory method to convert JSON into a Profile object
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileId: json['profile_id'] ?? '', // ?? ' ' Use an empty string if 'profile_id' is null
      cuteName: json['cute_name'] ?? '',
      gameMode: json['game_mode'] ?? '',
      current: json['current'] ?? false,
      levels: Level.fromJson(json['data']['skyblock_level'] ?? {}),
      skills: Skills.fromJson(json['data']['skills']['skills'] ?? {}) ,  
      name: username.fromJson(json['data'] ?? {}),
    );
  }
}