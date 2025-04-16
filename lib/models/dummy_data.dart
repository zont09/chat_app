// Current user
import 'package:chat_app/models/conservation_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';

 User currentUser = User(
  id: 'user1',
  name: 'Tôi',
  avatar: 'assets/images/avatar_me.png',
  isOnline: true,
);

// Dummy users
 List<User> dummyUsers = [
  User(
    id: 'user2',
    name: 'Trương',
    avatar: 'assets/images/demo/truong_avt.png',
    isOnline: true,
  ),
  User(
    id: 'user3',
    name: 'Thịnh',
    avatar: 'assets/images/demo/z_avatar.png',
    isOnline: true,
  ),
  User(
    id: 'user4',
    name: 'Tuấn',
    avatar: 'assets/images/default_avatar.png',
    isOnline: false,
    lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  User(
    id: 'user5',
    name: 'Tú',
    avatar: 'assets/images/demo/tu_avatar.png',
    isOnline: true,
  ),
  User(
    id: 'user6',
    name: 'Thiên',
    avatar: 'assets/images/default_avatar.png',
    isOnline: false,
    lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
  ),
  User(
    id: 'user7',
    name: 'Ngọc Thịnh',
    avatar: 'assets/images/demo/z_avatar.png',
    isOnline: false,
    lastSeen: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  User(
    id: 'user8',
    name: 'Bone',
    avatar: 'assets/images/demo/truong_avt.png',
    isOnline: true,
  ),
  User(
    id: 'user9',
    name: 'Đình Như Thông',
    avatar: 'assets/images/demo/thong_avt.png',
    isOnline: false,
    lastSeen: DateTime.now().subtract(const Duration(days: 1)),
  ),
  User(
    id: 'user10',
    name: 'Trần Trung Thông',
    avatar: 'assets/images/demo/3T.png',
    isOnline: false,
    lastSeen: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  User(
    id: 'user11',
    name: 'Nguyễn Tú',
    avatar: 'assets/images/demo/tu_avatar.png',
    isOnline: false,
    lastSeen: DateTime.now().subtract(const Duration(minutes: 3)),
  ),
];

// Dummy messages
 List<Message> dummyMessages = [
  Message(
    id: 'msg1',
    sendTo: 'user1',
    sendFrom: 'user6',
    content: 'Đã bày tỏ cảm xúc 😍 về tin nhắn của bạn',
    type: MessageType.text,
    timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 25)),
    status: MessageStatus.seen,
    seenBy: ['user1'],
  ),
  Message(
    id: 'msg2',
    sendTo: 'user1',
    sendFrom: 'user7',
    content: 'Để mai đi :)))',
    type: MessageType.text,
    timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    status: MessageStatus.seen,
    seenBy: ['user1'],
  ),
  Message(
    id: 'msg3',
    sendTo: 'user8',
    sendFrom: 'user1',
    content: 'assets/images/cafe.jpg',
    type: MessageType.image,
    timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    status: MessageStatus.seen,
    seenBy: ['user8'],
  ),
  Message(
    id: 'msg4',
    sendTo: 'user1',
    sendFrom: 'user9',
    content: 'Bạn: Rep tôi cái bạn ơi, sao bạn không trả lời',
    type: MessageType.text,
    timestamp: DateTime.now().subtract(const Duration(days: 4)),
    status: MessageStatus.seen,
    seenBy: ['user1'],
  ),
  Message(
    id: 'msg5',
    sendTo: 'user1',
    sendFrom: 'user10',
    content: 'Bạn: Tài liệu tham khảo cho kỳ thi...',
    type: MessageType.text,
    timestamp: DateTime.now().subtract(const Duration(days: 4)),
    status: MessageStatus.seen,
    seenBy: ['user1'],
  ),
  Message(
    id: 'msg6',
    sendTo: 'user1',
    sendFrom: 'user11',
    content: 'Chào Thông nhá',
    type: MessageType.text,
    timestamp: DateTime.now().subtract(const Duration(hours: 21, minutes: 32)),
    status: MessageStatus.seen,
    seenBy: ['user1'],
  ),
  Message(
    id: 'msg7',
    sendTo: 'user11',
    sendFrom: 'user1',
    content: 'Làm deadline đi nha Thông',
    type: MessageType.text,
    timestamp: DateTime.now().subtract(const Duration(hours: 16, minutes: 44)),
    status: MessageStatus.seen,
    seenBy: ['user11'],
  ),
  Message(
    id: 'msg8',
    sendTo: 'user8',
    sendFrom: 'user1',
    content: 'Làm sai câu 4 rồi kìa, đáng ra phải là AE chứ',
    type: MessageType.text,
    timestamp: DateTime.now().subtract(const Duration(hours: 11, minutes: 40)),
    status: MessageStatus.seen,
    seenBy: ['user8'],
  ),
  Message(
    id: 'msg9',
    sendTo: 'user1',
    sendFrom: 'user8',
    content: 'Quán cafe ở quận 1 này đẹp vãi',
    type: MessageType.text,
    timestamp: DateTime.now().subtract(const Duration(hours: 10, minutes: 34)),
    status: MessageStatus.seen,
    seenBy: ['user1'],
  ),
  Message(
    id: 'msg10',
    sendTo: 'user1',
    sendFrom: 'user8',
    content: 'Nhìn okela không :>',
    type: MessageType.text,
    timestamp: DateTime.now().subtract(const Duration(hours: 10, minutes: 34)),
    status: MessageStatus.seen,
    seenBy: ['user1'],
  ),
  Message(
    id: 'msg11',
    sendTo: 'user1',
    sendFrom: 'user8',
    content: 'assets/images/cafe.jpg',
    type: MessageType.image,
    timestamp: DateTime.now().subtract(const Duration(hours: 10, minutes: 34)),
    status: MessageStatus.seen,
    seenBy: ['user1'],
  ),
  Message(
    id: 'msg12',
    sendTo: 'user8',
    sendFrom: 'user1',
    content: 'Trông ổn á chứ :v',
    type: MessageType.text,
    timestamp: DateTime.now().subtract(const Duration(hours: 10, minutes: 30)),
    status: MessageStatus.seen,
    seenBy: ['user8'],
  ),
  Message(
    id: 'msg13',
    sendTo: 'user11',
    sendFrom: 'user1',
    content: '👋',
    type: MessageType.text,
    timestamp: DateTime.now().subtract(const Duration(hours: 16, minutes: 44)),
    status: MessageStatus.seen,
    seenBy: ['user11'],
  ),
];

// Dummy conversations
 List<Conversation> dummyConversations = [
  Conversation(
    id: 'conv1',
    members: ['user1', 'user6'],
    lastMessage: 'msg1',
    messages: ['msg1'],
  ),
  Conversation(
    id: 'conv2',
    members: ['user1', 'user7'],
    lastMessage: 'msg2',
    messages: ['msg2'],
  ),
  Conversation(
    id: 'conv3',
    members: ['user1', 'user8'],
    lastMessage: 'msg12',
    messages: ['msg3', 'msg8', 'msg9', 'msg10', 'msg11', 'msg12'],
  ),
  Conversation(
    id: 'conv4',
    members: ['user1', 'user9'],
    lastMessage: 'msg4',
    messages: ['msg4'],
  ),
  Conversation(
    id: 'conv5',
    members: ['user1', 'user10'],
    lastMessage: 'msg5',
    messages: ['msg5'],
  ),
  Conversation(
    id: 'conv6',
    members: ['user1', 'user11'],
    lastMessage: 'msg13',
    messages: ['msg6', 'msg7', 'msg13'],
  ),
];

 class DummyAction {
   // Function to add a new user to dummyUsers
   static void addUser(User user) {
     // Check if user with the same ID already exists
     if (dummyUsers.any((u) => u.id == user.id)) {
       print('User with ID ${user.id} already exists.');
       return;
     }

     dummyUsers.add(user);
     print('Added user: ${user.name} (ID: ${user.id})');
   }

// Function to add a new message to dummyMessages
   static void addMessage(Message message) {
     // Check if message with the same ID already exists
     if (dummyMessages.any((m) => m.id == message.id)) {
       print('Message with ID ${message.id} already exists.');
       return;
     }

     dummyMessages.add(message);
     print('Added message: ${message.content} (ID: ${message.id})');
   }

// Function to add a new conversation to dummyConversations
   static void addConversation(Conversation conversation) {
     // Check if conversation with the same ID already exists
     if (dummyConversations.any((c) => c.id == conversation.id)) {
       print('Conversation with ID ${conversation.id} already exists.');
       return;
     }

     // Validate that lastMessage exists in messages list
     if (!conversation.messages.contains(conversation.lastMessage)) {
       print('Last message ID ${conversation.lastMessage} must be in the messages list.');
       return;
     }

     dummyConversations.add(conversation);
     print('Added conversation: ${conversation.id} with members ${conversation.members}');
   }
 }
