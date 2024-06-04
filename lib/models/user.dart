class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String profileUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profileUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profileUrl: json['profile_url'],
    );
  }
}
