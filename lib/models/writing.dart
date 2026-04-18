class WritingEntry {
  final String id;
  final String poemId; // 可选：与哪首诗关联
  final String title;
  final String content;
  final int timestamp;

  WritingEntry({
    required this.id,
    required this.poemId,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory WritingEntry.fromJson(Map<String, dynamic> json) {
    return WritingEntry(
      id: json['id'],
      poemId: json['poemId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'poemId': poemId,
    'title': title,
    'content': content,
    'timestamp': timestamp,
  };

  WritingEntry copyWith({
    String? id,
    String? poemId,
    String? title,
    String? content,
    int? timestamp,
  }) {
    return WritingEntry(
      id: id ?? this.id,
      poemId: poemId ?? this.poemId,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
