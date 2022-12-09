

class GroupMember {
  final String role;
  final String email;

  GroupMember({
    required this.role,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'role': role,
        'email': email,
      };

  GroupMember.fromMap(Map<String, dynamic> Function() map)
      : assert(map()['role'] != null),
        assert(map()['email'] != null),
        role = map()['role'],
        email = map()['email'];

  static GroupMember fromJson(Map<String, dynamic> json) => GroupMember(
        role: json['role'],
        email: json['email'],
      );
}
