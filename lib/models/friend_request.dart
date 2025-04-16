import 'package:chat_app/models/user.dart';

/**
{
  "_id": ObjectId,
  "fromUser": ObjectId, // UserId
  "toUser": ObjectId, // UserId
  "status": String, // "pending", "accepted", "rejected"
  "timestamp": Timestamp
}
 */

enum FriendRequestStatus { pending, accepted, rejected }

class FriendRequest {
  final String? id;
  final User? fromUser; 
  final User? toUser;
  final FriendRequestStatus? status;
  final DateTime? timestamp; 

  FriendRequest({
    this.id,
    this.fromUser,
    this.toUser,
    this.status,
    this.timestamp,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['_id'],
      fromUser: User.fromJson(json['fromUser']),
      toUser: User.fromJson(json['toUser']),
      status: FriendRequestStatus.values.firstWhere(
          (e) => e.toString() == '${json['status']}',
          orElse: () => FriendRequestStatus.pending),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fromUser': fromUser?.toJson(),
      'toUser': toUser?.toJson(),
      'status': status.toString(),
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}