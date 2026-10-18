import 'package:hospital_system/bill.dart';
import 'package:hospital_system/enums.dart';
import 'package:hospital_system/medical_record.dart';
import 'package:hospital_system/person.dart';
import 'package:hospital_system/prescription.dart';
import 'package:hospital_system/staff/doctor.dart';



abstract class Patient extends Person{
final BloodType _bloodType;
final List <MedicalRecord> _medicalHistory;
final List<Bill> _bills;

Patient({required BloodType bloodType, required super.name, required super.phone, required super.gender, required super.birthDate,})
  :_bloodType=bloodType,
   _medicalHistory=[],
   _bills=[];

 BloodType get bloodType =>_bloodType;
 List <MedicalRecord> get  medicalHistory =>List.unmodifiable(_medicalHistory);
 List <Bill> get bills =>List.unmodifiable(_bills);
 bool get skipsQueue => false;
 
double calculateBill({DateTime? date});

void addBill(Bill b) => _bills.add(b);

void addRecord({
    required Doctor doctor,
    required String diagnosis,
    required List<Medicine> medicines,
    required String note,
    DateTime? date
  }) {
    final prescription = Prescription(medicines: medicines, note: note);
    final record = MedicalRecord(
      doctor:doctor,
      date:date?? DateTime.now(),
      diagnosis: diagnosis,
      prescription: prescription,
    );
    _medicalHistory.add(record);
  }
  
 @override
String toString() {
  return 'Patient(name: $name, phone: $phone, bloodType: ${_bloodType.name}, '
      'records: ${_medicalHistory.length})';
}
 
 void viewHistory(){
  if (_medicalHistory.isEmpty) {
    print('No medical records for $name.');
  }
 else { print('Medical history for $name:');
  for (var i = 0; i < _medicalHistory.length; i++) {
    print('${i + 1}. ${_medicalHistory[i]}');
  }
 } }
}