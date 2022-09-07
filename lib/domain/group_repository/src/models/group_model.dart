class Group {
  String id;
  final String groupName;
  String groupKey;
  List<String> group_users;
  List<String> group_admins;

  Group({
    this.id = '',
    required this.groupName,
    this.groupKey = '',
    required this.group_admins,
    required this.group_users,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Group_Name': groupName,
        'Group_Key': groupKey,
        'Group_Users': group_users,
        'Group_Admins': group_admins,
      };

  static Group fromJson(Map<String, dynamic> json) => Group(
        groupName: json['Group_Name'],
        groupKey: json['Group_key'],
        group_users: json['Group_Admins'],
        group_admins: json['Group_Users'],
      );
}
