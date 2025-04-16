enum WsEvent {
  userOnline,
  userOffline,
  message,
  messageStatus,
  forwardMessage,
  newMessage,
  messageReceived,
  markAsSeen,
  conversationSeen,
  deleteMessage,
  messageDeleted,
  editMessage,
  messageUpdated,
  addReaction,
  reactionAdded,
  typing,
  groupCreated,
  memberAdded,
  memberRemoved,
  memberLeft,
  groupNameUpdated,
  groupAvatarUpdated,
  nicknameUpdated,
  roleUpdated,
  quickEmojisUpdated,
  themeUpdated,
  conversationDeleted,
  userProfileUpdated,
  userStatusUpdated,
  userStatusRemoved,
  friendRequestAccepted,
  unknown,
}

// Extension to convert enum to string
extension WsEventString on WsEvent {
  String get name {
    switch (this) {
      case WsEvent.userOnline:
        return 'userOnline';
      case WsEvent.userOffline:
        return 'userOffline';
      case WsEvent.message:
        return 'message';
      default:
        return 'unknown';
    }
  }
}

// Extension to convert string to enum
extension WsEventFromString on String {
  WsEvent toWsEvent() {
    switch (this) {
      case 'userOnline':
        return WsEvent.userOnline;
      case 'userOffline':
        return WsEvent.userOffline;
      case 'message':
        return WsEvent.message;
      default:
        return WsEvent.unknown;
    }
  }
}