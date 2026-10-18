import 'package:hospital_system/bill.dart';
import 'package:hospital_system/enums.dart';
import 'package:hospital_system/medical_record.dart';
import 'package:hospital_system/person.dart';
import 'package:hospital_system/prescription.dart';
import 'package:hospital_system/staff/doctor.dart';

abstract class Patient {
  final Person person; // composition
  final BloodType bloodType;
  final List<MedicalRecord> medicalHistory;
  final List<Bill> bills;

  Patient({required this.person, required this.bloodType})
      : medicalHistory = [],
        bills = [];
  String get id => person.id;
  String get name => person.name;
  String get phone => person.phone;
  Gender get gender => person.gender;
  int get age => person.age;

  bool get skipsQueue => false;

  double calculateBill({DateTime? date});

  void displayInfo();

  void addBill(Bill b) => bills.add(b);

  void addRecord({
    required Doctor doctor,
    required String diagnosis,
    required List<Medicine> medicines,
    required String note,
    DateTime? date,
  }) {
    final prescription = Prescription(medicines: medicines, note: note);
    final record = MedicalRecord(
      doctor: doctor,
      date: date ?? DateTime.now(),
      diagnosis: diagnosis,
      prescription: prescription,
    );
    medicalHistory.add(record);
  }

  @override
  String toString() {
    return 'Patient(name: $name, phone: $phone, bloodType: ${bloodType.name}, '
        'records: ${medicalHistory.length})';
  }

  void viewHistory() {
    if (medicalHistory.isEmpty) {
      print('No medical records for $name.');
    } else {
      print('Medical history for $name:');
      for (var i = 0; i < medicalHistory.length; i++) {
        print('${i + 1}. ${medicalHistory[i]}');
      }
    }
  }
}