class Poet {
  final String id;
  final String name;
  final String subtitle;
  final String description;
  final String imageAsset;
  final String? audioAsset;
  final String? backgroundAsset;
  final List<String> tags;

  Poet({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.imageAsset,
    this.audioAsset,
    this.backgroundAsset,
    required this.tags,
  });
}

final List<Poet> poetsData = [
  Poet(
    id: 'libai',
    name: '李白',
    subtitle: '诗仙',
    description:
        '李白（701年－762年），字太白，号青莲居士。唐代伟大的浪漫主义诗人，被后人誉为"诗仙"。其诗风豪放飘逸，想象丰富，语言流转自然，音律和谐多变。\n\n他一生纵酒高歌，游历名山大川，却始终怀才不遇。"安能摧眉折腰事权贵，使我不得开心颜"正是他性格的真实写照。',
    imageAsset: 'assets/images/libai.png',
    audioAsset: 'assets/audio/libai_intro.mp3',
    backgroundAsset: null,
    tags: ['浪漫主义', '豪放', '诗仙'],
  ),
  Poet(
    id: 'dufu',
    name: '杜甫',
    subtitle: '诗圣',
    description:
        '杜甫（712年－770年），字子美，自号少陵野老。唐代伟大的现实主义诗人，被后人尊为"诗圣"。其诗深刻反映社会现实，风格沉郁顿挫。\n\n他经历了唐朝由盛转衰的历史，晚年流离失所，却始终心系苍生。"朱门酒肉臭，路有冻死骨"表达了他对百姓的深切同情。',
    imageAsset: 'assets/images/dufu.png',
    audioAsset: 'assets/audio/dufu_intro.mp3',
    backgroundAsset: null,
    tags: ['现实主义', '沉郁顿挫', '诗圣'],
  ),
  Poet(
    id: 'sushi',
    name: '苏轼',
    subtitle: '东坡居士',
    description:
        '苏轼（1037年－1101年），字子瞻，号东坡居士。北宋著名文学家、书法家、画家。其诗词题材广阔，清新豪健，善用夸张比喻，独具风格。\n\n他一生几经贬谪，却始终旷达超然。"竹杖芒鞋轻胜马，谁怕？一蓑烟雨任平生"展现了他面对困境的豁达胸襟。',
    imageAsset: 'assets/images/sushi.png',
    audioAsset: 'assets/audio/sushi_intro.mp3',
    backgroundAsset: null,
    tags: ['豪放派', '旷达', '全才'],
  ),
  Poet(
    id: 'liqingzhao',
    name: '李清照',
    subtitle: '易安居士',
    description:
        '李清照（1084年－约1155年），号易安居士。宋代女词人，婉约词派代表。前期多写悠闲生活，后期悲叹身世，语言清丽，自成一格。\n\n她经历了国破家亡的悲凉，词风从清新婉约转为沉痛悲凉。"寻寻觅觅，冷冷清清，凄凄惨惨戚戚"道尽了她晚年的孤独与凄凉。',
    imageAsset: 'assets/images/liqingzhao.png',
    audioAsset: 'assets/audio/liqingzhao_intro.mp3',
    backgroundAsset: null,
    tags: ['婉约派', '易安体', '词宗'],
  ),
];