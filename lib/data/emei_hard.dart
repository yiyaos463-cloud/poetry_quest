import 'package:poetry_quest/models/game_level.dart';

final emeiHardLevel = GameLevel(
  poetName: '李白',
  poemTitle: '峨眉山月歌',
  coverDescription: '困难·走进诗仙内心，读懂万里远游的序章',
  dapanStage: '蜀地试翼',
  lifeStage: '少年离蜀，初游四方',
  emotionTheme: '眷恋与憧憬',
  difficulty: '困难',
  layers: [
    LayerData(
      type: LayerType.sensory,
      title: '声韵触境',
      description: '秋夜，孤舟，半轮山月，破碎的月影，猿啼，江风……你感受到的意境是“凄凉”还是“清冷而开阔”？',
      sensoryCues: ['🌙 半轮秋月', '💧 江水映月', '🌬️ 微凉江风', '🐒 远处猿啼'],
      promptQuestion: '李白不是被流放，而是主动出发，因此意境是怎样的？',
      options: [
        Option(text: '凄凉悲伤', isCorrect: false, feedback: '李白并非被贬，而是主动仗剑去国。'),
        Option(text: '清冷中带着壮阔', isCorrect: true),
        Option(text: '热闹欢快', isCorrect: false, feedback: '独行江上，何来热闹？'),
      ],
      correctExplanation: '李白主动离乡追寻理想，意境是清旷的——清冷中带着壮阔。',
    ),
    LayerData(
      type: LayerType.context,
      title: '境遇共情',
      description: '李白一生漂泊，这首诗是他万里远游的起点。他从此再也没有回过四川。',
      contextInfo: '后来他写下《静夜思》的“举头望明月”，《渡荆门送别》的“仍怜故乡水”，其实望的都是当年峨眉山上那半轮秋月。',
      promptQuestion: '如果李白知道这一走就再也回不去了，他还会出发吗？',
      options: [
        Option(text: '会，好男儿志在四方', isCorrect: true),
        Option(text: '不会，他会多留几年', isCorrect: false),
        Option(text: '他不知道，但这就是命运', isCorrect: true),
      ],
    ),
    // 第3层占位，实际由未来自定义组件渲染
    LayerData(
      type: LayerType.wrongInt,
      title: '意象解码',
      description: '“思君不见”的“君”究竟是谁？',
      options: [],
    ),
    LayerData(
      type: LayerType.empathy,
      title: '风骨抉择',
      description: '李白一生都在“出发”，他的诗歌里永远有“故乡”和“远方”的拉扯。',
      promptQuestion: '你觉得这种拉扯是痛苦还是伟大？',
      options: [
        Option(text: '痛苦，因为永远回不去', isCorrect: false),
        Option(text: '伟大，因为他在不断追寻', isCorrect: true),
        Option(text: '两者都有', isCorrect: true),
      ],
    ),
    LayerData(
      type: LayerType.reveal,
      title: '生命联结',
      description: '李白将这首诗送给你。',
      poemLines: '峨眉山月半轮秋，影入平羌江水流。\n夜发清溪向三峡，思君不见下渝州。',
      fullInterpretation: '这是李白万里远游的起点，也是他一生漂泊的序章。',
    ),
  ],
);