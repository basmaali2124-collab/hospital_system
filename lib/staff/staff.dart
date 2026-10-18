import 'package:hospital_system/enums.dart';
import 'package:hospital_system/person.dart';
import 'package:hospital_system/validation_helper.dart';

abstract class Staff {
  final Person person; 
  double _baseSalary;
  List<Days> _workingDays;
  String _department;

  Staff({
    required this.person,
    required double baseSalary,
    required List<Days> workingDays,
    required String department,
  })  : _baseSalary = baseSalary,
        _department = department,
        _workingDays = List.of(workingDays) {
    ValidationHelper.positiveValidation(baseSalary, "salary");
  }


  String get id => person.id;
  String get name => person.name;
  String get phone => person.phone;
  Gender get gender => person.gender;
  int get age => person.age;

  double get baseSalary => _baseSalary;
  List<Days> get workingDays => List.unmodifiable(_workingDays);
  String get department => _department;

  set baseSalary(double baseSalary) {
    ValidationHelper.positiveValidation(baseSalary, "salary");
    _baseSalary = baseSalary;
  }

  set workingDays(List<Days> workingDays) => _workingDays = workingDays;
  set department(String department) => _department = department;

  double calculateSalary();

  void displayInfo();
}