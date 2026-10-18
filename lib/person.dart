import 'package:hospital_system/enums.dart';
import 'package:hospital_system/validation_helper.dart';
import 'package:uuid/uuid.dart';

class Person {
  final String _id;
  final String name;
  final String phone;
  final Gender gender;
  final DateTime _birthDate;

  Person({
    required this.name,
    required this.phone,
    required this.gender,
    required DateTime birthDate,
  })  : _id = Uuid().v4(),
        _birthDate = birthDate {
    ValidationHelper.phoneVlidation(phone);
    ValidationHelper.futureDateValidation(birthDate);
  }

  String get id => _id;

  int get age {
    final today = DateTime.now();
    int result = today.year - _birthDate.year;
    if (today.month < _birthDate.month ||
        (today.month == _birthDate.month && today.day < _birthDate.day)) {
      result--;
    }
    return result;
  }
}