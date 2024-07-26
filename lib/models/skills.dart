class Skill {
  final int xp;
  final int level;
  final int maxLevel;
  final int xpCurrent;
  final int xpForNext;
  final double progress;
  final int levelCap;
  final int uncappedLevel;
  final double levelWithProgress;
  final double unlockableLevelWithProgress;
  final int rank;

  Skill({
    required this.xp,
    required this.level,
    required this.maxLevel,
    required this.xpCurrent,
    required this.xpForNext,
    required this.progress,
    required this.levelCap,
    required this.uncappedLevel,
    required this.levelWithProgress,
    required this.unlockableLevelWithProgress,
    required this.rank,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      xp: (json['xp'] ?? 0.0).toInt(), // Convert xp to integer
      level: json['level'] ?? 0,
      maxLevel: json['maxLevel'] ?? 0,
      xpCurrent: (json['xpCurrent'] ?? 0.0).toInt(), // Convert xpCurrent to integer
      xpForNext: (json['xpForNext'] ?? 0.0).toInt(), // Convert xpForNext to integer
      progress: json['progress'] ?? 0.0,
      levelCap: json['levelCap'] ?? 0,
      uncappedLevel: json['uncappedLevel'] ?? 0,
      levelWithProgress: json['levelWithProgress'] ?? 0.0,
      unlockableLevelWithProgress: json['unlockableLevelWithProgress'] ?? 0.0,
      rank: json['rank'] ?? 0,
    );
  }
}
