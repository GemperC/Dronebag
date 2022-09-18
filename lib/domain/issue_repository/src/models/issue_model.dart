class Issue {
  String id; //id of the drone in the firestore database
  final String name; // name of the drone
  String serial_number; // serial number of the drone in the army
  String flight_time; // hours of active flight
  String hours_till_maintenace; // hours left until maintnence 
  String maintenance; // every 'maintenance' hours the drone need maintenance
  DateTime date_added; // what date the drone was aded to the database
  DateTime date_bought; // when did the drone was bought

  Drone ({
    this.id = '',
    required this.name,
    required this.serial_number,
    required this.maintenance,
    required this.date_added,
    required this.date_bought,
    this.hours_till_maintenace = '',
    required this.flight_time,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'serial_number': serial_number,
        'maintenance': maintenance,
        'date_added': date_added,
        'date_bought': date_bought,
        'hours_till_maintenace': hours_till_maintenace,
        'flight_time': flight_time,
      };

  static Drone fromJson(Map<String, dynamic> json) => Drone(
        id: json['id'],
        name: json['name'],
        serial_number: json['serial_number'],
        maintenance: json['maintenance'],
        date_added: json['date_added'],
        date_bought: json['date_bought'],
        hours_till_maintenace: json['hours_till_maintenace'],
        flight_time: json['flight_time'],
      );
}
