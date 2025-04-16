import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/theme.dart';
import 'package:chat_app/models/user.dart';

enum ConversationType { private, group }

class Conversations {
  final String? id;
  final List<User>? members; // List of User objects
  final String? lastMessage;
  final List<Message>? messages;
  final ConversationType? type; // "private", "group"
  final String? name;
  final String? avatarUrl;
  final String? quickEmojis; // optional
  final Theme? theme; // optional
  final User? creator;

  Conversations({
    this.id,
    this.members,
    this.lastMessage,
    this.messages,
    this.type,
    this.name,
    this.avatarUrl,
    this.quickEmojis,
    this.theme,
    this.creator,
  });

  factory Conversations.fromJson(Map<String, dynamic> json) {
    return Conversations(
      id: json['_id'],
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e))
          .toList(),
      lastMessage: json['lastMessage'],
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e))
          .toList(),
      type: ConversationType.values.firstWhere(
          (e) => e.toString() == '${json['type']}',
          orElse: () => ConversationType.private),
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      quickEmojis: json['quickEmojis'],
      theme: json['theme'] != null ? Theme.fromJson(json['theme']) : null,
      creator: User.fromJson(json['creator']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'members': members?.map((e) => e.toJson()).toList(),
      'lastMessage': lastMessage,
      'messages': messages?.map((e) => e.toJson()).toList(),
      'type': type.toString(),
      'name': name,
      'avatarUrl': avatarUrl,
      'quickEmojis': quickEmojis,
      'theme': theme?.toJson(), // Updated to call toJson() on theme
      'creator': creator?.toJson(),
    };
  }
}
