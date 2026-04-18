import 'package:poetry_quest/models/game_level.dart';

final emeiGeneralLevel = GameLevel(
  poetName: '李白',
  poemTitle: '峨眉山月歌',
  coverDescription: '中等·地名里的秘密 - 手绘地图 + 时间轴拖拽 + 光影粒子',
  dapanStage: '蜀地试翼',
  lifeStage: '少年离蜀，初游四方',
  emotionTheme: '眷恋与憧憬',
  difficulty: '中等',
  layers: [
    // 第1层：声韵触境（图文穿插 + 环境音效 + 轻舟动画）
    LayerData(
      type: LayerType.sensory,
      title: '声韵触境',
      description: '秋江夜景的静态插画 + 环境音效（水声、猿啼）。文字逐句浮现，配合"轻舟"图标在地图上快速移动的动画，让学生直观感受"船行轻快"。',
      sensoryCues: [
        '🎨 视觉：秋江夜景插画，半轮秋月悬于峨眉山巅',
        '🎵 听觉：江水声、远处猿啼、摇橹声',
        '⚡ 动态：轻舟图标在地图上快速移动',
      ],
      promptQuestion: '根据动画效果，李白此刻的船行速度是怎样的？',
      options: [
        Option(text: '缓慢悠闲，欣赏风景', isCorrect: false, feedback: '注意轻舟的移动速度！'),
        Option(text: '快速轻快，心情急切', isCorrect: true),
        Option(text: '走走停停，犹豫不决', isCorrect: false, feedback: '李白是主动出发，并非犹豫。'),
      ],
      correctExplanation: '轻舟快速移动的动画，直观展现了李白出蜀时的轻快与急切。',
    ),
    // 第2层：境遇共情（对话气泡 + 微动画）
    LayerData(
      type: LayerType.context,
      title: '境遇共情',
      description: '李白立绘出现在地图旁，通过对话气泡讲述离乡心情。点击不同选项，李白表情和气泡文字变化。',
      contextInfo: '24岁的李白"仗剑去国，辞亲远游"。他主动离开蜀地，去追寻建功立业的机会，但故乡的山水与亲友仍让他深深眷恋。',
      promptQuestion: '点击与李白对话，了解他的心情：',
      options: [
        Option(
          text: '"太白兄，离乡远游，可有不舍？"',
          isCorrect: true,
          feedback: '李白望月："蜀江水碧蜀山青，若非心向沧海，谁愿轻离故土？"',
        ),
        Option(
          text: '"前方三峡险峻，可需缓行？"',
          isCorrect: true,
          feedback: '李白笑道："大鹏一日同风起，扶摇直上九万里！"',
        ),
        Option(
          text: '"今夜月色真美，且饮一杯？"',
          isCorrect: true,
          feedback: '李白举杯："此去经年，应是良辰好景虚设。便纵有千种风情，更与何人说？"',
        ),
      ],
    ),
    // 第3层：意象解码（时间轴拖拽排序 - 由 MapTimelineLayer 渲染）
    LayerData(
      type: LayerType.wrongInt,
      title: '意象解码',
      description: '将地名卡片拖拽到时间轴上的正确位置，理解五个地名连续出现的表达效果。',
      options: [],
    ),
    // 第4层：风骨抉择（双分支动画选择）
    LayerData(
      type: LayerType.empathy,
      title: '风骨抉择',
      description: '画面出现两个选项卡片："回望故乡"和"顺江东下"。选择后，地图上的小船会播放不同动画。',
      promptQuestion: '如果你是李白，船行至清溪即将进入三峡，你会如何选择？',
      options: [
        Option(
          text: '回望故乡（情感羁绊）',
          isCorrect: false,
          feedback: '船速变缓，镜头拉近峨眉山，李白低头叹息。选择了情感，但少了前行的勇气。',
        ),
        Option(
          text: '顺江东下（少年壮志）',
          isCorrect: true,
          feedback: '小船加速冲出画面，江面豁然开朗，金光洒落。李白选择了向前，但把眷恋写进了诗里。',
        ),
      ],
    ),
    // 第5层：生命联结（生成专属路线图）
    LayerData(
      type: LayerType.reveal,
      title: '生命联结',
      description: '你可以将自己的一次"出发"经历（如升学、搬家）写在地图上的空白处。生成一张带有自己文字的手绘地图诗卡。',
      poemLines: '峨眉山月半轮秋，影入平羌江水流。\n夜发清溪向三峡，思君不见下渝州。',
      fullInterpretation: '这首诗写于李白24岁初离蜀地时。五个地名连用，不仅写出了一路行程，更写出了诗人初出茅庐的轻快与对故乡的眷恋。地名快速转换，让读者仿佛跟着李白一夜千里。',
    ),
  ],
);