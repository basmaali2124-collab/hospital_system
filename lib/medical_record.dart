import 'package:hospital_system/prescription.dart';
import 'package:hospital_system/staff/doctor.dart';

class MedicalRecord {
 final DateTime _date;
 final Doctor _doctor;
 final String  _diagnosis;
  Prescription _prescription;
  
  MedicalRecord({required DateTime date,required String diagnosis,required Prescription prescription,required Doctor doctor,})
  :_date=date,
   _doctor=doctor,
   _diagnosis=diagnosis,
   _prescription=prescription;
   
   Doctor get doctor => _doctor;
   DateTime get date=>_date;
   String get diagnosis=>_diagnosis;
   Prescription get prescription=>_prescription;
  
  
     @override
   String toString() =>
       'MedicalRecord(date: $_date, doctor: ${_doctor.name}, '
       'diagnosis: $_diagnosis, prescription: $_prescription)';
}