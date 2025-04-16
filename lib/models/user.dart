class User {
  final String? id;
  final String? name;
  final String? email;
  final String? avatarUrl;
  final String? password;
  final DateTime? lastSeen;
  final bool? isOnline;
  final String? nickname; // optional
  final String? role; // "admin", "member"

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.password,
    required this.lastSeen,
    required this.isOnline,
    this.nickname, // optional
    this.role, // "admin", "member"
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      password: json['password'],
      lastSeen: DateTime.parse(json['lastSeen']),
      isOnline: json['isOnline'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'password': password,
      'lastSeen': lastSeen?.toIso8601String(),
      'isOnline': isOnline,
    };
  }
}
