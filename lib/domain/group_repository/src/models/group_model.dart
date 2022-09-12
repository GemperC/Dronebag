class Group {
  String id;
  final String name;
  String key;
  List<dynamic> users;
  List<dynamic> admins;

  Group({
    this.id = '',
    required this.name,
    this.key = '',
    required this.users,
    required this.admins,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Group_Name': name,
        'Group_Key': key,
        'Group_Users': users,
        'Group_Admins': admins,
      };

  static Group fromJson(Map<String, dynamic> json) => Group(
        id: json['id'],
        name: json['Group_Name'],
        key: json['Group_Key'],
        users: json['Group_Users'] as List<dynamic>,
        admins: json['Group_Admins'] as List<dynamic>,
      );

}
