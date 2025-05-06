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
    this.id,
    this.name,
    this.email,
    this.avatarUrl,
    this.password,
    this.lastSeen,
    this.isOnline,
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
