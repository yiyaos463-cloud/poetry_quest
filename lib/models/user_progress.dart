class UserProgress {
  final String userId;
  final Map<String, PoemProgress> poemProgress;

  UserProgress({required this.userId, required this.poemProgress});

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    final progressMap = <String, PoemProgress>{};
    final map = json['poemProgress'] as Map<String, dynamic>? ?? {};
    map.forEach((key, value) {
      progressMap[key] = PoemProgress.fromJson(value);
    });
    return UserProgress(userId: json['userId'], poemProgress: progressMap);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['poemProgress'] = poemProgress.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    return map;
  }
}

class PoemProgress {
  int highestUnlockedLevel;
  List<bool> completedLevels;

  PoemProgress({
    required this.highestUnlockedLevel,
    required this.completedLevels,
  });

  factory PoemProgress.initial(int levelCount) {
    return PoemProgress(
      highestUnlockedLevel: 1,
      completedLevels: List.filled(levelCount, false),
    );
  }

  factory PoemProgress.fromJson(Map<String, dynamic> json) {
    return PoemProgress(
      highestUnlockedLevel: json['highestUnlockedLevel'],
      completedLevels: List<bool>.from(json['completedLevels']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'highestUnlockedLevel': highestUnlockedLevel,
      'completedLevels': completedLevels,
    };
  }

  bool isLevelUnlocked(int levelIndex) {
    return levelIndex < highestUnlockedLevel;
  }

  void completeLevel(int levelIndex) {
    if (levelIndex < completedLevels.length) {
      completedLevels[levelIndex] = true;
      if (levelIndex + 1 > highestUnlockedLevel &&
          levelIndex + 1 <= completedLevels.length) {
        highestUnlockedLevel = levelIndex + 1;
      }
    }
  }
}
