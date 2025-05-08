class Theme {
  final String? id;
  final String? backgroundImage; // URL
  final String? dominantColor; // mã màu
  final String? emoji; // biểu tượng cảm xúc

  Theme({
    this.id,
    this.backgroundImage,
    this.dominantColor,
    this.emoji,
  });

  factory Theme.fromJson(Map<String, dynamic> json) {
    return Theme(
      id: json['_id'],
      backgroundImage: json['backgroundImage'],
      dominantColor: json['dominantColor'],
      emoji: json['emoji'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'backgroundImage': backgroundImage,
      'dominantColor': dominantColor,
      'emoji': emoji,
    };
  }
}