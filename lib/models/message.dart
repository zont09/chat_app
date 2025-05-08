import 'package:chat_app/models/user.dart';

enum MessageStatus { sending, sent, delivered, seen, error }
enum MessageType { text, image, video, file }

class Message {
  final String? id;
  final User? sendTo;
  final User? sendFrom;
  final String? content;
  final MessageType? type;
  final DateTime? timestamp;
  final Message? replyTo; // MessageId
  final Map<String, List<String>>? reactions; // { "👍": [UserId], "❤️": [UserId] }
  final MessageStatus? status;
  final List<User>? seenBy;
  final bool? isEdited;
  final List<String>? oldContent;
  final bool? isDeletedForEveryone;
  final List<String>? deleteFor;
  final User? forwardedFrom; // { "messageId": ObjectId, "senderId": ObjectId }

  Message({
    this.id,
    this.sendTo,
    this.sendFrom,
    this.content,
    this.type,
    this.timestamp,
    this.replyTo,
    this.reactions,
    this.status,
    this.seenBy,
    this.isEdited,
    this.oldContent,
    this.isDeletedForEveryone,
    this.deleteFor,
    this.forwardedFrom,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      sendTo: User.fromJson(json['sendTo']),
      sendFrom: User.fromJson(json['sendFrom']),
      content: json['content'],
      type: MessageType.values.firstWhere(
          (e) => e.toString() == '${json['type']}',
          orElse: () => MessageType.text),
      timestamp: DateTime.parse(json['timestamp']),
      replyTo: json['replyTo'] != null ? Message.fromJson(json['replyTo']) : null,
      reactions: Map<String, List<String>>.from(json['reactions']),
      status: MessageStatus.values.firstWhere(
          (e) => e.toString() == '${json['status']}',
          orElse: () => MessageStatus.sending),
      seenBy: (json['seenBy'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e))
          .toList(),
      isEdited: json['isEdited'],
      oldContent: List<String>.from(json['oldContent'] ?? []),
      isDeletedForEveryone: json['isDeletedForEveryone'],
      deleteFor: List<String>.from(json['deleteFor']),
      forwardedFrom:
          User.fromJson(json['forwardedFrom']), // Chưa có định nghĩa
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sendTo': sendTo?.toJson(),
      'sendFrom': sendFrom?.toJson(),
      'content': content,
      'type': type.toString().split('.').last,
      'timestamp': timestamp?.toIso8601String(),
      'replyTo': replyTo?.toJson(),
      'reactions': reactions,
      'status': status.toString().split('.').last,
      'seenBy': seenBy?.map((user) => user.toJson()).toList(),
      'isEdited': isEdited,
      'oldContent': oldContent,
      'isDeletedForEveryone': isDeletedForEveryone,
      'deleteFor': deleteFor,
      'forwardedFrom': forwardedFrom?.toJson(), // Chưa có định nghĩa
    };
  }
}
