import 'package:hospital_system/appointment.dart';
import 'package:hospital_system/bill.dart';
import 'package:hospital_system/enums.dart';
import 'package:hospital_system/exceptions.dart';
import 'package:hospital_system/patient/emergency_patient.dart';
import 'package:hospital_system/patient/in_patient.dart';
import 'package:hospital_system/patient/patient.dart';
import 'package:hospital_system/room.dart';
import 'package:hospital_system/staff/doctor.dart';
import 'package:hospital_system/staff/staff.dart';

class Hospital {
  String name;
  List<Patient> patients;
  List<Staff> staff;
  List<Room> rooms;
  List<Appointment> appointments;
  List<Bill> bills;

  Hospital({required this.name,
  }):patients=[],
     staff=[],
     rooms=[],
     appointments=[],
     bills=[];

  void registerPatient(Patient patient){
   for(Patient p in patients )
   {if(p.id==patient.id|| p.phone==patient.phone){
    throw Exception("this patient is already exit");
   }}
    patients.add(patient);
  }
  void addStaff(Staff hospitalStaff){
    for(Staff s in staff )
   {if(s.id==hospitalStaff.id|| s.phone==hospitalStaff.phone){
    throw Exception("this doctor is already exit");
   }}
   if(staff.contains(hospitalStaff))
   {throw Exception("this Staff is already exit");}
    staff.add(hospitalStaff);
  }
  Patient findPatient(Patient patient){
    if(patients.contains(patient)){
      return patient;
    }
    else
    {throw Exception("this patient not found");}
  }
  List<Doctor> findDoctorsBySpecialization(Specialization specialization) {
  final result = <Doctor>[];
  for (final s in staff) {
    if (s is Doctor && s.specialization == specialization) {
      result.add(s);
    }
  }
  return result;
}

void bookAppointment({
  required Patient patient,
  required Doctor doctor,
  required DateTime dateTime,
}) {
  if (!patient.skipsQueue) {
    doctor.isAvailableAt(dateTime);
  }
  final appointment = Appointment(patient: patient, doctor: doctor, dateTime: dateTime);
  doctor.addAppointment(appointment);
  appointments.add(appointment);
}
void cancelAppointment(Appointment appointment){
  if(appointments.contains(appointment)){
    appointment.cancel();
  }
  else
  {throw Exception('Appointment not found');}
}

void admitPatient(Patient patient, Room room, {required DateTime date}) {
  if (room.type == RoomType.icu) {
    if (patient is! EmergencyPatient || !patient.canUseICU) {
      throw ValidationException('ICU is only for emergency patients with severity 4 or 5');
    }
  }
  if (patient is InPatient) {
    patient.admit(room, date);
  } else {
    room.occupy(patient);
  }
}
void dischargePatient(Patient patient, {required DateTime date}) {
  if (patient is! InPatient || !patient.isAdmitted) {
    throw PatientNotAdmittedException();
  }
  final hasUnpaid = patient.bills.any((b) => b.status != PaymentStatus.paid);
  final insured = patient.coveragePercent > 0;
  if (hasUnpaid && !insured) throw UnpaidBillException();
  patient.discharge(date);
}

Bill generateBill(Patient patient, {DateTime? date}) {
  final amount = patient.calculateBill(date: date);
  final bill = Bill(
    patient: patient,
    items: [Item(description: 'Hospital charges', fee: amount)],
  );
if (patient is InPatient) bill.applyInsurance(patient.coveragePercent);
patient.addBill(bill);
  bills.add(bill);
  return bill;
}

void displayReport({DateTime? date}) {
  final today = date ?? DateTime.now();
  final doctors = staff.whereType<Doctor>().toList();
  final occupiedRooms = rooms.where((r) => r.isOccupied).toList();

  final todayAppointments = appointments
      .where((a) =>
          a.status != AppointmentStatus.cancelled &&
          a.dateTime.year == today.year &&
          a.dateTime.month == today.month &&
          a.dateTime.day == today.day)
      .toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  final unpaidBills =
      bills.where((b) => b.status != PaymentStatus.paid).toList();
  final totalUnpaid = unpaidBills.fold(0.0, (sum, b) => sum + b.remainingAmount);

  print('--- Hospital Report: $name ---');

  print('Doctors (${doctors.length}):');
  for (final d in doctors) {
    print('  - ${d.name} | ${d.specialization.name} | ${d.consultationFee} EGP');
  }

  print('Occupied rooms (${occupiedRooms.length}/${rooms.length}):');
  for (final r in occupiedRooms) {
    print('  - Room #${r.number} (${r.type.name}) | Patient: ${r.patient!.name}');
  }

  print("Today's appointments (${todayAppointments.length}):");
  for (final a in todayAppointments) {
    print('  - ${a.dateTime.hour}:${a.dateTime.minute.toString().padLeft(2, '0')}'
        ' | ${a.patient.name} with Dr. ${a.doctor.name} | ${a.status.name}');
  }

  print('Unpaid bills (${unpaidBills.length}) | Total remaining: $totalUnpaid EGP:');
  for (final b in unpaidBills) {
    print('  - Bill #${b.id} | ${b.patient.name} | Remaining: ${b.remainingAmount} EGP');
  }
}

}