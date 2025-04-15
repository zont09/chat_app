class Conversation {
  final String id;
  final List<String> members;
  final String lastMessage;
  final List<String> messages;

  Conversation({
    required this.id,
    required this.members,
    required this.lastMessage,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'],
      members: List<String>.from(json['members']),
      lastMessage: json['lastMessage'],
      messages: List<String>.from(json['messages']),
    );
  }
}
