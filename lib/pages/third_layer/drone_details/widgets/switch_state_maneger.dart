import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:flutter/material.dart';
import 'issues.dart';
import 'flight_records.dart';
import 'maintnance_records.dart';

class SwitchCaseStateManager extends StatefulWidget {
  final String groupID;
  final Drone drone;
  final String privileges;
  final int index;
  const SwitchCaseStateManager({
    Key? key,
    required this.groupID,
    required this.drone,
    required this.index,
    required this.privileges,
  }) : super(key: key);

  @override
  State<SwitchCaseStateManager> createState() => _SwitchCaseStateManagerState();
}

class _SwitchCaseStateManagerState extends State<SwitchCaseStateManager> {
  @override
  Widget build(BuildContext context) {
    switch (widget.index) {
      case 0:
        return DroneMaintenance(drone: widget.drone, groupID: widget.groupID, privileges: widget.privileges);

      case 1:
        return DroneIssues(drone: widget.drone, groupID: widget.groupID);

      case 2:
        return DroneFlightRecords(drone: widget.drone, groupID: widget.groupID, privileges: widget.privileges);
    }
    return Container();
  }
}
