import 'package:hospital_system/enums.dart';
import 'package:hospital_system/room.dart';
import 'package:hospital_system/staff/staff.dart';

class Nurse extends Staff {
  Shift _shift;
  List<Room> _assignedRooms;

  Nurse({
    required Shift shift,
    required List<Room> assignedRooms,
    required super.person,
    required super.baseSalary,
    required super.workingDays,
    required super.department,
  })  : _shift = shift,
        _assignedRooms = List.from(assignedRooms);

  Shift get shift => _shift;
  set shift(Shift value) => _shift = value;

  List<Room> get assignedRooms => List.unmodifiable(_assignedRooms);
  set assignedRooms(List<Room> value) => _assignedRooms = List.from(value);

  @override
  double calculateSalary() {
    if (shift == Shift.night) {
      return baseSalary + ((baseSalary * 20) / 100);
    } else {
      return baseSalary;
    }
  }

  @override
  void displayInfo() {
    print('--- Nurse ---');
    print('ID: $id\n'
        'Name: $name\n'
        'Age: $age\n'
        'Phone: $phone\n'
        'Department: $department\n'
        'Shift: ${shift.name}\n'
        'Assigned rooms: ${assignedRooms.map((r) => '#${r.number} (${r.type.name})').join(', ')}\n'
        'Working days: ${workingDays.map((d) => d.name).join(', ')}');
  }
}