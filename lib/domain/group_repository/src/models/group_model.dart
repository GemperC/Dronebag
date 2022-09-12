import 'dart:convert';

class Group {
  String id;
  final String name;
  String key;
  Map<String, dynamic> users;

  Group({
    this.id = '',
    required this.name,
    this.key = '',
    required this.users,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Group_Name': name,
        'Group_Key': key,
        'Group_Users': users,
      };

  static Group fromJson(Map<String, dynamic> json) => Group(
        id: json['id'],
        name: json['Group_Name'],
        key: json['Group_Key'],
        users: json['Group_Users'],
      );

}
