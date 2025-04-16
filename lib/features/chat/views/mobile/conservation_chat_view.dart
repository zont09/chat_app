import 'package:chat_app/configs/color_configs.dart';
import 'package:chat_app/features/chat/bloc/conversation_cubit.dart';
import 'package:chat_app/features/chat/views/mobile/chat_detail_view.dart';
import 'package:chat_app/features/chat/widgets/conservation_list_item.dart';
import 'package:chat_app/features/chat/widgets/story_circle.dart';
import 'package:chat_app/models/dummy_data.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  int _selectedIndex = 0;
  final User currentUser = DummyData.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = DummyData.instance.dummyUsers
          .where((user) => user.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _cancelSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filteredUsers = [];
    });
  }

  void _showNewChatOptions() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tin nhắn mới',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E88E5),
                ),
              ),
              const SizedBox(height: 16),
              // Group chat option
              ListTile(
                leading: const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF1E88E5),
                  child: Icon(Icons.groups, color: Colors.white),
                ),
                title: const Text(
                  'Tạo nhóm mới',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Placeholder for group chat creation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Tính năng tạo nhóm đang phát triển!')),
                  );
                },
              ),
              const Divider(height: 1),
              // List of friends
              Expanded(
                child: ListView.builder(
                  itemCount: DummyData.instance.dummyUsers.length,
                  itemBuilder: (context, index) {
                    final user = DummyData.instance.dummyUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(user.avatar),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(
                              user: user,
                              messages: DummyData.instance.dummyMessages
                                  .where((m) =>
                                      DummyData.instance.dummyConversations
                                          .firstWhere(
                                            (c) => c.members.contains(user.id),
                                            orElse: () => DummyData
                                                .instance.dummyConversations[0],
                                          )
                                          .messages
                                          .contains(m.id))
                                  .toList(),
                              onAdd: (v) {},
                              onUpdate: (v) {},
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ConversationCubit()..initData(DummyData.instance.dummyConversations),
      child: BlocBuilder<ConversationCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<ConversationCubit>(c);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: !_isSearching
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(currentUser.avatar),
                          radius: 18,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Đoạn Chat',
                          style: TextStyle(
                            color: ColorConfig.primary3, fontSize: 25, fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(width: 12),
                        const SizedBox.shrink(),
                      ],
                    )
                  : TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
              actions: [
                if (_isSearching)
                  TextButton(
                    onPressed: _cancelSearch,
                    child: const Text(
                      'Hủy',
                      style: TextStyle(color: Color(0xFF1E88E5), fontSize: 16),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: InkWell(
                      onTap: _showNewChatOptions,
                      child: Image.asset('assets/images/icons/ic_new_conversation.png', height: 40,),
                    ),
                  )
                  // IconButton(
                  //   icon:
                  //       const Icon(Icons.edit_square, color: Color(0xFF1E88E5)),
                  //   onPressed: _showNewChatOptions,
                  // ),
              ],
            ),
            body: Column(
              children: [
                if (!_isSearching)
                  // Search bar
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GestureDetector(
                      onTap: _startSearch,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 12, right: 8),
                              child: Icon(Icons.search, color: Colors.grey),
                            ),
                            Text(
                              'Tìm kiếm',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (!_isSearching)
                  // Story circles
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      children: [
                        // Your story
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.add,
                                    color: Colors.white, size: 30),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tin của bạn',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        // Friends' stories
                        ...DummyData.instance.dummyUsers
                            .map((user) => StoryCircle(user: user)),
                      ],
                    ),
                  ),
                if (!_isSearching)
                  // Divider
                  const Divider(height: 1),
                // Search results or conversation list
                Expanded(
                  child: _isSearching
                      ? ListView.builder(
                          itemCount: _filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = _filteredUsers[index];

                            final message =
                                DummyData.instance.dummyMessages.firstWhere(
                              (m) =>
                                  m.id ==
                                  cubit.conversations
                                      .firstWhere(
                                        (c) => c.members.contains(user.id),
                                        orElse: () => DummyData
                                            .instance.dummyConversations[0],
                                      )
                                      .lastMessage,
                              orElse: () => DummyData.instance.dummyMessages[0],
                            );

                            return ConversationListItem(
                              user: user,
                              message: message,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatDetailScreen(
                                      user: user,
                                      messages: DummyData.instance.dummyMessages
                                          .where((m) => cubit.conversations
                                              .firstWhere(
                                                (c) =>
                                                    c.members.contains(user.id),
                                                orElse: () => DummyData.instance
                                                    .dummyConversations[0],
                                              )
                                              .messages
                                              .contains(m.id))
                                          .toList(),
                                      onAdd: (v) {
                                        cubit.addConversation(v);
                                      },
                                      onUpdate: (v) {
                                        cubit.updateConversation(v);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount:
                          cubit.conversations.length,
                          itemBuilder: (context, index) {
                            final conversation =
                            cubit.conversations[index];
                            final user =
                                DummyData.instance.dummyUsers.firstWhere(
                              (u) => u.id == conversation.members[1],
                              orElse: () => DummyData.instance.dummyUsers[0],
                            );
                            final message =
                                DummyData.instance.dummyMessages.firstWhere(
                              (m) => m.id == conversation.lastMessage,
                              orElse: () => DummyData.instance.dummyMessages[0],
                            );

                            return ConversationListItem(
                              user: user,
                              message: message,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatDetailScreen(
                                      user: user,
                                      messages: DummyData.instance.dummyMessages
                                          .where((m) => conversation.messages
                                              .contains(m.id))
                                          .toList(),
                                      onAdd: (v) {
                                        cubit.addConversation(v);
                                      },
                                      onUpdate: (v) {
                                        cubit.updateConversation(v);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 2,
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedItemColor: ColorConfig.primary3,
              unselectedItemColor: Colors.grey,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble),
                  label: 'Đoạn chat',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      const Icon(Icons.people),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: const Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  label: 'Bạn bè',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.groups),
                  label: 'Nhóm',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
