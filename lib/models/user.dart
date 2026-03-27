enum UserRole {
  master,
  admin,
}

class AppUser {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? phoneNumber;
  final DateTime? createdAt;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == map['role'],
        orElse: () => UserRole.master,
      ),
      phoneNumber: map['phoneNumber'],
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : null,
    );
  }
}
