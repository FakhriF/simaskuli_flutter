class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String profileUrl;
  final String birthDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profileUrl,
    required this.birthDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profileUrl: json['profile_url'] ??
          "https://cdn150.picsart.com/upscale-245339439045212.png",
      birthDate: json['birthDate'],
    );
  }
}
