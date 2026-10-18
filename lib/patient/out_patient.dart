import 'package:hospital_system/patient/patient.dart';
import 'package:hospital_system/staff/doctor.dart';

class OutPatient extends Patient {
  int visitCount;
  Doctor? _doctor;

  OutPatient({
    this.visitCount = 0,
    required super.person,
    required super.bloodType,
  });

  void registerVisit(Doctor doctor) {
    _doctor = doctor;
    visitCount++;
  }

  @override
  double calculateBill({DateTime? date}) {
    if (_doctor == null) return 0;
    return _doctor!.consultationFee;
  }

  @override
  void displayInfo() {
    print('--- Outpatient ---');
    print('ID: $id\nName: $name\nAge: $age\nPhone: $phone\n'
        'Blood type: ${bloodType.name}\nVisits: $visitCount');
  }
}