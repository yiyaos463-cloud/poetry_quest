class Poem {
  final String id;
  final String title;
  final String poetId;
  final String content;
  final String difficulty;
  final int levelCount;
  final String? description;

  Poem({
    required this.id,
    required this.title,
    required this.poetId,
    required this.content,
    required this.difficulty,
    required this.levelCount,
    this.description,
  });
}

final List<Poem> poemsData = [
  // 李白 - 简单 (峨眉山月歌)
  Poem(
    id: 'emeishanyuege_simple',
    title: '峨眉山月歌',
    poetId: 'libai',
    content: '峨眉山月半轮秋，影入平羌江水流。\n夜发清溪向三峡，思君不见下渝州。',
    difficulty: '简单',
    levelCount: 5,
    description: '离蜀远游，不舍与憧憬',
  ),
  Poem(
    id: 'wangluanshan',
    title: '望庐山瀑布',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '简单',
    levelCount: 0,
    description: '敬请期待',
  ),
  Poem(
    id: 'jinyesi',
    title: '静夜思',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '简单',
    levelCount: 0,
    description: '敬请期待',
  ),
  Poem(
    id: 'qingpingdiao',
    title: '清平调·其一',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '简单',
    levelCount: 0,
    description: '敬请期待',
  ),
  Poem(
    id: 'xinglunan',
    title: '行路难·其一',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '简单',
    levelCount: 0,
    description: '敬请期待',
  ),

  // 李白 - 中等 (峨眉山月歌 - 一般难度)
  Poem(
    id: 'emeishanyuege_general',
    title: '峨眉山月歌',
    poetId: 'libai',
    content: '峨眉山月半轮秋，影入平羌江水流。\n夜发清溪向三峡，思君不见下渝州。',
    difficulty: '中等',
    levelCount: 5,
    description: '地名里的秘密 - 手绘地图 + 时间轴拖拽',
  ),
  Poem(
    id: 'wangluanshan_medium',
    title: '望庐山瀑布',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '中等',
    levelCount: 0,
    description: '敬请期待',
  ),
  Poem(
    id: 'jinyesi_medium',
    title: '静夜思',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '中等',
    levelCount: 0,
    description: '敬请期待',
  ),
  Poem(
    id: 'qingpingdiao_medium',
    title: '清平调·其一',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '中等',
    levelCount: 0,
    description: '敬请期待',
  ),
  Poem(
    id: 'xinglunan_medium',
    title: '行路难·其一',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '中等',
    levelCount: 0,
    description: '敬请期待',
  ),

  // 李白 - 困难 (峨眉山月歌 - 困难难度)
  Poem(
    id: 'emeishanyuege_hard',
    title: '峨眉山月歌',
    poetId: 'libai',
    content: '峨眉山月半轮秋，影入平羌江水流。\n夜发清溪向三峡，思君不见下渝州。',
    difficulty: '困难',
    levelCount: 5,
    description: '万里远游的序章 - 意象解谜 + 星空共鸣',
  ),
  Poem(
    id: 'jiangjinjiu',
    title: '将进酒',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '困难',
    levelCount: 0,
    description: '敬请期待',
  ),
  Poem(
    id: 'wangluanshan_hard',
    title: '望庐山瀑布',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '困难',
    levelCount: 0,
    description: '敬请期待',
  ),
  Poem(
    id: 'jinyesi_hard',
    title: '静夜思',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '困难',
    levelCount: 0,
    description: '敬请期待',
  ),
  Poem(
    id: 'qingpingdiao_hard',
    title: '清平调·其一',
    poetId: 'libai',
    content: '敬请期待',
    difficulty: '困难',
    levelCount: 0,
    description: '敬请期待',
  ),
];