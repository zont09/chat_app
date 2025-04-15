enum MessageType { text, image, video }

enum MessageStatus { sending, sent, delivered, seen }

class Message {
  final String id;
  final String sendTo;
  final String sendFrom;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final String? replyTo;
  final String? reactions;
  final MessageStatus status;
  final List<String> seenBy;
  final bool isEdited;
  final List<String> oldContent;
  final bool isDeletedForEveryone;
  final List<String> deleteFor;

  Message({
    required this.id,
    required this.sendTo,
    required this.sendFrom,
    required this.content,
    required this.type,
    required this.timestamp,
    this.replyTo,
    this.reactions,
    required this.status,
    required this.seenBy,
    this.isEdited = false,
    this.oldContent = const [],
    this.isDeletedForEveryone = false,
    this.deleteFor = const [],
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      sendTo: json['sendTo'],
      sendFrom: json['sendFrom'],
      content: json['content'],
      type: MessageType.values.byName(json['type']),
      timestamp: DateTime.parse(json['timestamp']),
      replyTo: json['replyTo'],
      reactions: json['reactions'],
      status: MessageStatus.values.byName(json['status']),
      seenBy: List<String>.from(json['seenBy']),
      isEdited: json['isEdited'] ?? false,
      oldContent: json['oldContent'] != null
          ? List<String>.from(json['oldContent'])
          : [],
      isDeletedForEveryone: json['isDeletedForEveryone'] ?? false,
      deleteFor: json['deleteFor'] != null
          ? List<String>.from(json['deleteFor'])
          : [],
    );
  }
}
