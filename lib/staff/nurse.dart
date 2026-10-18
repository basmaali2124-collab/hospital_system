import 'package:hospital_system/enums.dart';
import 'package:hospital_system/room.dart';
import 'package:hospital_system/staff/staff.dart';

class Nurse extends Staff{
  Shift shift;
  List<Room>  assignedRooms;

  Nurse({required this.shift,required this.assignedRooms, required super.baseSalary, required super.workingDays, required super.department, required super.name, required super.phone, required super.gender, required super.birthDate});

  @override
  double calculateSalary() {
   if(shift==Shift.night)
   {
    return baseSalary+((baseSalary*20)/100);
   }
   else 
   return baseSalary;
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