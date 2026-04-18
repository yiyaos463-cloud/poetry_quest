// 五层类型枚举
enum LayerType {
  sensory, // 感官入境
  context, // 背景透视
  wrongInt, // 错解挑战
  empathy, // 情感投射
  reveal, // 正解揭示
}

// 选项模型
class Option {
  final String text;
  final bool isCorrect;
  final String? feedback;

  Option({required this.text, required this.isCorrect, this.feedback});
}

// 单层数据
class LayerData {
  final LayerType type;
  final String title;
  final String description;
  final List<String>? sensoryCues;
  final String? contextInfo;
  final String? wrongInterpretation;
  final List<Option>? options;
  final String? correctExplanation;
  final String? promptQuestion;
  final String? poemLines;
  final String? fullInterpretation;

  LayerData({
    required this.type,
    required this.title,
    required this.description,
    this.sensoryCues,
    this.contextInfo,
    this.wrongInterpretation,
    this.options,
    this.correctExplanation,
    this.promptQuestion,
    this.poemLines,
    this.fullInterpretation,
  });
}

// 整关数据（一个诗人、一首诗）
class GameLevel {
  final String poetName;
  final String poemTitle;
  final String coverDescription;
  final String dapanStage;
  final String lifeStage;
  final String emotionTheme;
  final String difficulty;   // 新增：简单 / 一般 / 困难
  final List<LayerData> layers;

  GameLevel({
    required this.poetName,
    required this.poemTitle,
    required this.coverDescription,
    required this.dapanStage,
    required this.lifeStage,
    required this.emotionTheme,
    required this.difficulty,
    required this.layers,
  });
}