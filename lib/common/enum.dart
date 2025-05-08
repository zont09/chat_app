enum NotificationType {
  newFriendRequest,
  unknown
}

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.newFriendRequest:
        return 'newFriendRequest';
      case NotificationType.unknown:
        return 'unknown';
    }
  }
}
