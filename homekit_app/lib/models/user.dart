import 'dart:convert';

class User {
  final String token;
  final String id;
  final String username;
  final String email;
  late final String password;
  final dynamic device;

  User({
    required this.token,
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.device,
  });

  Map<String, dynamic> toMap() {
    return {
      'accessToken': token,
      '_id': id,
      'username': username,
      'email': email,
      'password': password,
      'device': device?.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      token: map['accessToken'] ?? '',
      id: map['_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      device: map['device'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? token,
    String? id,
    String? username,
    String? email,
    String? password,
    dynamic device,
  }) {
    return User(
      token: token ?? this.token,
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      device: device ?? this.device,
    );
  }
}
