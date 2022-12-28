import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:flutter/material.dart';
import 'issues.dart';
import 'flight_records.dart';
import 'maintnance_records.dart';
class SwitchCaseStateManager extends StatefulWidget {
    final String groupID;
  final Drone drone;
  final int index;
  const SwitchCaseStateManager({
    Key? key,
        required this.groupID,
    required this.drone,
    required this.index,
  }) : super(key: key);

  @override
  State<SwitchCaseStateManager> createState() => _SwitchCaseStateManagerState();
}

class _SwitchCaseStateManagerState extends State<SwitchCaseStateManager> {
  @override
  Widget build(BuildContext context) {

    switch (widget.index) {
      case 0:
      print('returnning maintnence records');
        return Container();

      case 1:
        print('returnning issues');
        return DroneIssues(drone: widget.drone, groupID: widget.groupID);

      case 2:
            print('returnning flight records');

        return Container();
    }
    return Container();
  }
}
