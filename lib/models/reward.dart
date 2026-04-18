class Outfit {
  final String id;
  final String name;
  final String description;
  final String imageAsset; // 暂未使用，预留

  Outfit({
    required this.id,
    required this.name,
    required this.description,
    this.imageAsset = '',
  });
}
