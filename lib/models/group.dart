class Group {
  String id;
  final String groupName;

  Group({
    this.id = '',
    required this.groupName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Group Name': groupName,
      };
}