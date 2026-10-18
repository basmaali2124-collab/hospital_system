import 'package:hospital_system/enums.dart';
import 'package:hospital_system/patient/patient.dart';
import 'package:hospital_system/staff/doctor.dart';

class EmergencyPatient extends Patient {
  final SeverityLevel _severityLevel;
  Doctor _doctor;

  EmergencyPatient({
    required SeverityLevel severityLevel,
    required Doctor doctor,
    required super.bloodType,
    required super.name,
    required super.phone,
    required super.gender,
    required super.birthDate,
  })  : _severityLevel = severityLevel,
        _doctor = doctor;

  SeverityLevel get severityLevel => _severityLevel;
  Doctor get doctor => _doctor;

  bool get canUseICU => _severityLevel.allowsICU;

  @override
  bool get skipsQueue => true;

  void registerVisit(Doctor doctor) => _doctor = doctor;

  @override
  double calculateBill({DateTime? date}) => _doctor.consultationFee * 1.5; // +50%

  @override
  void displayInfo() {
    print('--- Emergency Patient ---');
    print('ID: $id\nName: $name\nAge: $age\nPhone: $phone\n'
        'Blood type: ${bloodType.name}\n'
        'Severity: ${_severityLevel.value}\n'
        'Doctor: ${_doctor.name}');
  }
}