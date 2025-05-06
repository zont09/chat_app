import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

class StoryCircle extends StatelessWidget {
  final User user;

  const StoryCircle({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: user.isOnline! ? Colors.green : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(user.avatarUrl!.isNotEmpty
                      ? user.avatarUrl!
                      : 'assets/images/default_avatar.png'),
                  radius: 28,
                ),
              ),
              if (user.isOnline!)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            user.name!.split(' ').last,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
