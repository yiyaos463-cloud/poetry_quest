import 'package:poetry_quest/models/game_level.dart';

final xinglunanLevel = GameLevel(
  poetName: '李白',
  poemTitle: '峨眉山月歌',
  coverDescription:
      '唐·开元十二年，24岁的李白“仗剑去国，辞亲远游”。这是他初离蜀地时的作品，意境清朗，既有对故乡的眷恋，亦有对未来的憧憬。',
  dapanStage: '蜀地试翼',
  lifeStage: '少年离蜀，初游四方',
  emotionTheme: '眷恋与憧憬',
  difficulty: '简单',
  layers: [
    // 第1层：声韵触境
    LayerData(
      type: LayerType.sensory,
      title: '声韵触境',
      description: '秋夜，你乘一叶小舟行驶在平羌江上。半轮秋月悬于峨眉山巅，月影随波流淌。江风微凉，远处传来隐约的猿啼与橹声。',
      sensoryCues: [
        '👀 视觉：半轮秋月、江面摇曳的月影',
        '👂 听觉：江水拍打船舷、远处猿啼、摇橹声',
        '🌬️ 触觉：微凉的江风',
      ],
      promptQuestion: '根据这些感官线索，青年李白此刻的心情是怎样的？',
      options: [
        Option(text: '悠闲平静，欣赏夜景', isCorrect: false, feedback: '表面平静，内心实则暗流涌动。'),
        Option(text: '眷恋与憧憬交织，微带离愁', isCorrect: true),
        Option(
          text: '恐惧不安，害怕远行',
          isCorrect: false,
          feedback: '李白是主动仗剑去国，并非恐惧。',
        ),
      ],
      correctExplanation: '你感受到了青年李白初次离乡时，那丝微凉的不舍与期盼。',
    ),
    // 第2层：境遇共情
    LayerData(
      type: LayerType.context,
      title: '境遇共情',
      description: '你决定与这位24岁的李白交谈。他正望着月亮出神。',
      contextInfo:
          '开元十二年（724年），24岁的李白“仗剑去国，辞亲远游”。他并非被贬，而是主动离开蜀地，去追寻建功立业的机会。然而故乡的山水与亲友仍让他深深眷恋。',
      promptQuestion: '你会对李白说什么？',
      options: [
        Option(
          text: '递上一杯酒：“太白兄，此去长安，定当大展宏图！”',
          isCorrect: true,
          feedback: '李白大笑：“借你吉言！我本楚狂人，长风破浪会有时！”',
        ),
        Option(
          text: '轻声问：“三峡路远，你无惧吗？”',
          isCorrect: true,
          feedback: '李白望月轻叹：“蜀江水碧蜀山青，若非心向沧海，谁愿轻离故土？”',
        ),
        Option(
          text: '默默陪他站在船头',
          isCorrect: true,
          feedback: '李白看着江水说：“你也不舍这蜀地的月色吗？”',
        ),
      ],
    ),
    // 第3层：意象解码
    LayerData(
      type: LayerType.wrongInt,
      title: '意象解码',
      description: 'AI 学徒看了这首诗，自信地分析道：“这首诗就是李白在记流水账，把五个地名罗列了一遍，没什么深意。”',
      wrongInterpretation:
          '"‘峨眉山月半轮秋，影入平羌江水流。夜发清溪向三峡，思君不见下渝州。’——这不就是写他从峨眉山出发，经过平羌江、清溪、三峡，最后到渝州吗？一篇游记而已。”',
      options: [
        Option(text: '忽略了地名快速转换所体现的“船行轻快、心情急切”', isCorrect: true),
        Option(text: '忽略了李白其实不喜欢旅游', isCorrect: false, feedback: '李白一生好入名山游。'),
        Option(
          text: 'AI 说得对，确实只是记行程',
          isCorrect: false,
          feedback: '再读读“思君不见”四个字。',
        ),
      ],
      correctExplanation:
          '五个地名连续出现，并非凑字数。它们快速转换，不仅交代了行程，更突出了船行之快、水势之急，体现了诗人出蜀时轻快而急切的心情。同时，地名的不断延伸，也暗含着离故乡越来越远的眷恋。',
    ),
    // 第4层：风骨抉择
    LayerData(
      type: LayerType.empathy,
      title: '风骨抉择',
      description: '船行至清溪，即将进入三峡。李白回头望向峨眉山的方向，沉默不语。他面临着一个抉择：是再回望一眼故乡，还是毅然顺江东下？',
      promptQuestion: '如果你是李白，此刻你会如何选择？',
      options: [
        Option(
          text: '回望故乡（情感羁绊）',
          isCorrect: false,
          feedback: '船速变缓，月亮定格在峨眉山顶。李白低叹：“也罢，且让我再看一眼蜀地月色。”',
        ),
        Option(
          text: '顺江东下（少年壮志）',
          isCorrect: true,
          feedback: '小船冲破峡口，江面豁然开朗，月光洒满前方。李白迎风挺立：“前路漫漫，唯有前行！”',
        ),
      ],
    ),
    // 第5层：生命联结
    LayerData(
      type: LayerType.reveal,
      title: '生命联结',
      description: '李白将这首诗题于船舷，赠予了你。他笑道：“他日你若也离开故土，便会懂我今夜的心情。”',
      poemLines: '峨眉山月半轮秋，影入平羌江水流。\n夜发清溪向三峡，思君不见下渝州。',
      fullInterpretation:
          '这首诗写于李白24岁初离蜀地时。全诗意境清朗，五个地名连用，不仅写出了一路行程，更写出了诗人初出茅庐的轻快与对故乡的眷恋。',
    ),
  ],
);
