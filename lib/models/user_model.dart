class UserModel {
  final String uid;
  final String email;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.createdAt,
  });

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create UserModel from JSON (Firestore)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  // Copy with method
  UserModel copyWith({
    String? uid,
    String? email,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
