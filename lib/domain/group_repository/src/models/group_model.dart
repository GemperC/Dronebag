class Group {
  String id;
  final String name;
  String key;
  List<dynamic> users;

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
        'users': users,
      };

  static Group fromJson(Map<String, dynamic> json) => Group(
        id: json['id'],
        name: json['Group_Name'],
        key: json['Group_Key'],
        users: json['users'] as List<dynamic>,
      );

}
