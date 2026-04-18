import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poetry_quest/models/poet.dart';
import 'package:poetry_quest/models/poem.dart';
import 'package:poetry_quest/models/user_progress.dart';
import 'package:poetry_quest/models/writing.dart';
import 'package:poetry_quest/services/storage_service.dart';

class GameProvider extends ChangeNotifier {
  String? _currentUsername;
  UserProgress? _userProgress;
  Poet? _selectedPoet;
  Poem? _selectedPoem;
  int _currentLevelIndex = 0;
  int _currentLayerIndex = 0;
  List<String> _unlockedOutfits = [];
  List<String> _unlockedOutfitPaths = [];
  List<Map<String, String>> _collectedPoems = [];
  int _totalScore = 0;

  int _appTabIndex = 0;
  final List<WritingEntry> _pendingGuestWritings = [];

  String? get currentUsername => _currentUsername;
  UserProgress? get userProgress => _userProgress;
  Poet? get selectedPoet => _selectedPoet;
  Poem? get selectedPoem => _selectedPoem;
  int get currentLevelIndex => _currentLevelIndex;
  int get currentLayerIndex => _currentLayerIndex;
  List<String> get unlockedOutfits => _unlockedOutfits;
  List<String> get unlockedOutfitPaths => _unlockedOutfitPaths;
  List<Map<String, String>> get collectedPoems => _collectedPoems;
  int get appTabIndex => _appTabIndex;
  List<WritingEntry> get pendingGuestWritings => _pendingGuestWritings;
  int get totalScore => _totalScore;

  bool get isLoggedIn => _currentUsername != null;
  bool get isGuest => _currentUsername == null;

  static const List<Map<String, dynamic>> _allOutfits = [
    {
      'name': '蜀地青衫',
      'path': 'assets/images/outfits/outfit_libai_shudi_qingshan.png',
      'score': 0,
    },
    {
      'name': '庐山云鹤袍',
      'path': 'assets/images/outfits/outfit_libai_lushan_yunhe.png',
      'score': 30,
    },
    {
      'name': '静夜思·月白衫',
      'path': 'assets/images/outfits/outfit_libai_jingyesi_yuebai.png',
      'score': 60,
    },
    {
      'name': '行路难·长风袍',
      'path': 'assets/images/outfits/outfit_libai_xinglunan_changfeng.png',
      'score': 100,
    },
    {
      'name': '将进酒·金樽裳',
      'path': 'assets/images/outfits/outfit_libai_qiangjinjiu_jinzun.png',
      'score': 150,
    },
    {
      'name': '白帝轻舟氅',
      'path': 'assets/images/outfits/outfit_libai_baidi_qingzhou.png',
      'score': 210,
    },
    {
      'name': '大鹏垂天翼',
      'path': 'assets/images/outfits/outfit_libai_dapeng_chuitian.png',
      'score': 280,
    },
  ];

  List<Map<String, dynamic>> get allOutfits => _allOutfits;

  Future<void> initialize() async {
    try {
      final username = await StorageService.getCurrentUser();
      if (username != null) {
        _currentUsername = username;
        _userProgress = await StorageService.loadProgress(username);
        _userProgress ??= UserProgress(userId: username, poemProgress: {});
        await _loadCollectedPoems();
        await _loadScoreAndOutfits();
      } else {
        _currentUsername = null;
        _userProgress = null;
        _unlockedOutfitPaths = [_allOutfits[0]['path'] as String];
        _unlockedOutfits = [_allOutfits[0]['name'] as String];
        await _loadCollectedPoems();
        await _loadScoreAndOutfits();
      }
      notifyListeners();
    } catch (e) {
      print('初始化GameProvider时出错: $e');
    }
  }

  Future<void> _loadScoreAndOutfits() async {
    final p = await StorageService.prefs;
    final userKey = _currentUsername ?? "guest";
    _totalScore = p.getInt('total_score_$userKey') ?? 0;
    _unlockedOutfitPaths = p.getStringList('unlocked_outfits_$userKey') ?? [];
    final defaultPath = _allOutfits[0]['path'] as String;
    final defaultName = _allOutfits[0]['name'] as String;
    if (!_unlockedOutfitPaths.contains(defaultPath)) {
      _unlockedOutfitPaths.add(defaultPath);
    }
    _unlockedOutfits = _allOutfits
        .where((o) => _unlockedOutfitPaths.contains(o['path']))
        .map((o) => o['name'] as String)
        .toList();
  }

  Future<void> _saveScoreAndOutfits() async {
    final p = await StorageService.prefs;
    final userKey = _currentUsername ?? "guest";
    await p.setInt('total_score_$userKey', _totalScore);
    await p.setStringList('unlocked_outfits_$userKey', _unlockedOutfitPaths);
  }

  Future<void> _loadCollectedPoems() async {
    try {
      final p = await StorageService.prefs;
      final key = 'collected_poems_${_currentUsername ?? "guest"}';
      final list = p.getStringList(key) ?? [];
      _collectedPoems = list
          .map((e) => Map<String, String>.from(jsonDecode(e)))
          .toList();
    } catch (e) {
      _collectedPoems = [];
    }
  }

  Future<void> addCollectedPoem({
    required String title,
    required String lines,
    required String summary,
    required String difficulty,
  }) async {
    final exists = _collectedPoems.any(
      (poem) => poem['title'] == title && poem['difficulty'] == difficulty,
    );
    if (exists) return;

    final poem = {
      'title': title,
      'lines': lines,
      'summary': summary,
      'difficulty': difficulty,
    };
    _collectedPoems.add(poem);
    final p = await StorageService.prefs;
    final key = 'collected_poems_${_currentUsername ?? "guest"}';
    final list = _collectedPoems.map((e) => jsonEncode(e)).toList();
    await p.setStringList(key, list);
    notifyListeners();
  }

  Future<String?> login(String username, String password) async {
    final isValid = await StorageService.validateUser(username, password);
    if (!isValid) return '账号或密码错误';
    _currentUsername = username;
    await StorageService.setCurrentUser(username);
    _userProgress = await StorageService.loadProgress(username);
    _userProgress ??= UserProgress(userId: username, poemProgress: {});
    await _loadCollectedPoems();
    await _loadScoreAndOutfits();
    notifyListeners();
    return null;
  }

  Future<String?> register(String username, String password) async {
    if (password.length < 4) return '密码至少4位';
    final exists = await StorageService.userExists(username);
    if (exists) return '账号已存在';
    await StorageService.saveUser(username, password);
    return await login(username, password);
  }

  Future<void> logout() async {
    _currentUsername = null;
    _userProgress = null;
    _selectedPoet = null;
    _selectedPoem = null;
    _collectedPoems.clear();
    _pendingGuestWritings.clear();
    _totalScore = 0;
    _unlockedOutfits.clear();
    _unlockedOutfitPaths.clear();
    await StorageService.logout();
    notifyListeners();
  }

  void selectPoet(Poet poet) {
    _selectedPoet = poet;
    notifyListeners();
  }

  void selectPoem(Poem poem) {
    _selectedPoem = poem;
    if (_userProgress != null &&
        !_userProgress!.poemProgress.containsKey(poem.id)) {
      _userProgress!.poemProgress[poem.id] = PoemProgress.initial(
        poem.levelCount,
      );
      _saveProgress();
    }
    _currentLevelIndex = 0;
    _currentLayerIndex = 0;
    notifyListeners();
  }

  PoemProgress? get currentPoemProgress {
    if (_selectedPoem == null || _userProgress == null) return null;
    return _userProgress!.poemProgress[_selectedPoem!.id];
  }

  bool isLevelUnlocked(int levelIndex) {
    final progress = currentPoemProgress;
    if (progress == null) return levelIndex == 0;
    return progress.isLevelUnlocked(levelIndex);
  }

  void startLevel(int levelIndex) {
    _currentLevelIndex = levelIndex;
    _currentLayerIndex = 0;
    notifyListeners();
  }

  void nextLayer() {
    _currentLayerIndex++;
    notifyListeners();
  }

  void resetLayers() {
    _currentLayerIndex = 0;
    notifyListeners();
  }

  Future<void> completeCurrentLevel({required String difficulty}) async {
    if (_selectedPoem == null) return;

    if (_userProgress != null) {
      final progress = _userProgress!.poemProgress[_selectedPoem!.id];
      if (progress != null) {
        if (_currentLevelIndex < progress.completedLevels.length) {
          progress.completeLevel(_currentLevelIndex);
          _saveProgress();
        }
      }
    }

    // 根据难度生成知识点总结
    String summary;
    switch (difficulty) {
      case '简单':
        summary = '知识点：①李白24岁离蜀远游；②“峨眉山月”象征故乡；③地名连用体现船行轻快。';
        break;
      case '中等':
        summary = '知识点：①五个地名依次为峨眉山→平羌江→清溪→三峡→渝州；②“君”既指月、也指故乡亲友；③虚实结合的手法。';
        break;
      case '困难':
        summary = '知识点：①意境“清旷”——清冷中带着壮阔；②“君”的多重象征（月/故乡/亲友）；③《峨眉山月歌》是李白万里远游的序章。';
        break;
      default:
        summary = '完成《峨眉山月歌》关卡获得的纪念';
    }

    await addCollectedPoem(
      title: _selectedPoem!.title,
      lines: _selectedPoem!.content,
      summary: summary,
      difficulty: difficulty,
    );

    int scoreToAdd = 0;
    switch (difficulty) {
      case '简单':
        scoreToAdd = 10;
        break;
      case '中等':
        scoreToAdd = 20;
        break;
      case '困难':
        scoreToAdd = 30;
        break;
      default:
        scoreToAdd = 10;
    }
    addScore(scoreToAdd);

    notifyListeners();
  }

  Future<void> _saveProgress() async {
    if (_currentUsername != null && _userProgress != null) {
      await StorageService.saveProgress(_currentUsername!, _userProgress!);
    }
  }

  int get totalCompletedLevels {
    if (_userProgress == null) return 0;
    int total = 0;
    _userProgress!.poemProgress.forEach((_, progress) {
      total += progress.completedLevels.where((c) => c).length;
    });
    return total;
  }

  int get totalPoemsStarted {
    if (_userProgress == null) return 0;
    return _userProgress!.poemProgress.keys.length;
  }

  void setAppTab(int index) {
    _appTabIndex = index;
    notifyListeners();
  }

  void addScore(int points) {
    _totalScore += points;
    _checkEquipmentUnlock();
    _saveScoreAndOutfits();
    notifyListeners();
  }

  void _checkEquipmentUnlock() {
    bool updated = false;
    for (var outfit in _allOutfits) {
      final requiredScore = outfit['score'] as int;
      final path = outfit['path'] as String;
      final name = outfit['name'] as String;
      if (_totalScore >= requiredScore &&
          !_unlockedOutfitPaths.contains(path)) {
        _unlockedOutfitPaths.add(path);
        if (!_unlockedOutfits.contains(name)) {
          _unlockedOutfits.add(name);
        }
        updated = true;
      }
    }
    if (updated) {
      _saveScoreAndOutfits();
    }
  }

  void addGuestWriting(WritingEntry writing) {
    _pendingGuestWritings.add(writing);
    notifyListeners();
  }

  Future<void> mergeGuestWritings() async {
    if (_pendingGuestWritings.isEmpty) return;
    for (final writing in _pendingGuestWritings) {
      await addWriting(writing);
    }
    _pendingGuestWritings.clear();
    notifyListeners();
  }

  Future<void> addWriting(WritingEntry writing) async {
    final p = await StorageService.prefs;
    final key = 'writings_${_currentUsername ?? "guest"}';
    final list = p.getStringList(key) ?? [];
    list.add(jsonEncode(writing.toJson()));
    await p.setStringList(key, list);
    notifyListeners();
  }

  Future<List<WritingEntry>> getWritings() async {
    final p = await StorageService.prefs;
    final key = 'writings_${_currentUsername ?? "guest"}';
    final list = p.getStringList(key) ?? [];
    return list.map((e) => WritingEntry.fromJson(jsonDecode(e))).toList();
  }

  Future<void> deleteWriting(String id) async {
    final p = await StorageService.prefs;
    final key = 'writings_${_currentUsername ?? "guest"}';
    final list = p.getStringList(key) ?? [];
    final writings = list
        .map((e) => WritingEntry.fromJson(jsonDecode(e)))
        .toList();
    writings.removeWhere((w) => w.id == id);
    final updated = writings.map((w) => jsonEncode(w.toJson())).toList();
    await p.setStringList(key, updated);
    notifyListeners();
  }

  Future<void> updateWriting(WritingEntry writing) async {
    final p = await StorageService.prefs;
    final key = 'writings_${_currentUsername ?? "guest"}';
    final list = p.getStringList(key) ?? [];
    final writings = list
        .map((e) => WritingEntry.fromJson(jsonDecode(e)))
        .toList();
    final index = writings.indexWhere((w) => w.id == writing.id);
    if (index != -1) {
      writings[index] = writing;
      final updated = writings.map((w) => jsonEncode(w.toJson())).toList();
      await p.setStringList(key, updated);
    }
    notifyListeners();
  }
}