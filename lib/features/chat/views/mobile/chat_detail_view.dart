import 'package:chat_app/features/chat/widgets/message_bubble.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/dummy_data.dart'; // Import to access addMessage and addConversation
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final User user;
  final List<Message> messages;
  final Function(Conversation) onAdd;
  final Function(Conversation) onUpdate;

  const ChatDetailScreen(
      {super.key,
      required this.user,
      required this.messages,
      required this.onAdd,
      required this.onUpdate});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final User currentUser = DummyData.instance.currentUser;
  List<Message> _messages = []; // Local state for messages

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.messages); // Initialize with passed messages
    _messageController.addListener(() {
      setState(() {}); // Update UI when text changes to show/hide send button
    });
    // Scroll to bottom initially if there are messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_messages.isNotEmpty) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    // Generate unique ID for the message
    final messageId = DateTime.now().microsecondsSinceEpoch.toString();

    // Create new message
    final newMessage = Message(
      id: messageId,
      sendTo: User(id: widget.user.id!),
      sendFrom: User(id: currentUser.id!),
      content: _messageController.text.trim(),
      type: MessageType.text,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
      seenBy: [],
    );

    // Add message to dummyMessages
    DummyData.instance.addMessage(newMessage);

    // Check if conversation exists, if not create a new one
    debugPrint("====> Send message: ${currentUser.id} - ${widget.user.id}");
    for (var e in DummyData.instance.dummyConversations) {
      debugPrint("===> Conv: ${e.id} - ${e.members}");
    }
    final existingConversation =
        DummyData.instance.dummyConversations.firstWhere(
      (conv) =>
          conv.members!.contains(currentUser.id) &&
          conv.members!.contains(widget.user.id),
      orElse: () => Conversation(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        members: [User(id: currentUser.id!), User(id: widget.user.id!)],
        lastMessage: null,
        messages: [
          Message(
            id: messageId,
            sendTo: User(id: widget.user.id!),
            sendFrom: User(id: currentUser.id!),
            content: _messageController.text.trim(),
            type: MessageType.text,
            timestamp: DateTime.now(),
            status: MessageStatus.sent,
            seenBy: [],
          )
        ],
      ),
    );

    debugPrint("====> ExisConv: ${existingConversation.id}");

    if (!DummyData.instance.dummyConversations.contains(existingConversation)) {
      // New conversation
      DummyData.instance.addConversation(existingConversation);
      widget.onAdd(existingConversation);
    } else {
      // Update existing conversation
      final updatedConversation = Conversation(
        id: existingConversation.id,
        members: existingConversation.members,
        lastMessage: null,
        messages: [...existingConversation.messages!],
      );
      // DummyData.instance.dummyConversations.remove(existingConversation);
      // DummyData.instance.addConversation(updatedConversation);
      debugPrint("====> Update ok?");
      DummyData.instance.updateConversation(updatedConversation);
      widget.onUpdate(updatedConversation);
    }

    // Update local messages state
    setState(() {
      _messages.add(newMessage);
    });

    // Clear text field
    _messageController.clear();

    // Scroll to bottom
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E88E5)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.user.avatarUrl!),
              radius: 16,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.user.isOnline!
                      ? 'Đang hoạt động'
                      : 'Hoạt động ${_getLastSeenTime(widget.user.lastSeen)}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Color(0xFF1E88E5)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Color(0xFF1E88E5)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.sendFrom == currentUser.id;

                // Group messages by date
                final showDate = index == 0 ||
                    !_isSameDay(
                      _messages[index].timestamp!,
                      _messages[index - 1].timestamp!,
                    );

                return Column(
                  children: [
                    if (showDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          _formatMessageDate(message.timestamp!),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    MessageBubble(
                      message: message,
                      isMe: isMe,
                      user: isMe ? currentUser : widget.user,
                    ),
                  ],
                );
              },
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.photo, color: Colors.grey),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Aa',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) =>
                          _sendMessage(), // Send on keyboard submit
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.emoji_emotions, color: Colors.grey),
                  onPressed: () {},
                ),
                _messageController.text.trim().isEmpty
                    ? IconButton(
                        icon: const Icon(Icons.thumb_up, color: Colors.grey),
                        onPressed: () {},
                      )
                    : IconButton(
                        icon: const Icon(Icons.send, color: Color(0xFF1E88E5)),
                        onPressed: _sendMessage,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLastSeenTime(DateTime? lastSeen) {
    if (lastSeen == null) return '';

    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else {
      return '${difference.inDays} ngày trước';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Hôm nay';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Hôm qua';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
