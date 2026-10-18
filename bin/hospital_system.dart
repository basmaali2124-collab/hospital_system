import 'package:hospital_system/enums.dart';
import 'package:hospital_system/hospital.dart';
import 'package:hospital_system/loggable.dart';
import 'package:hospital_system/patient/emergency_patient.dart';
import 'package:hospital_system/patient/in_patient.dart';
import 'package:hospital_system/patient/out_patient.dart';
import 'package:hospital_system/patient/patient.dart';
import 'package:hospital_system/prescription.dart';
import 'package:hospital_system/room.dart';
import 'package:hospital_system/staff/doctor.dart';
import 'package:hospital_system/staff/nurse.dart';
import 'package:hospital_system/staff/staff.dart';
import 'package:hospital_system/person.dart';

class Demo with Loggable {
  void step(String title) => log('=== $title');

  void expectError(String label, void Function() action) {
    try {
      action();
      log('!! $label: no error was thrown (unexpected)');
    } catch (e) {
      log('X  $label -> $e');
    }
  }
}

DateTime nextWeekday(int weekday, {int hour = 10}) {
  var d = DateTime.now().add(const Duration(days: 1));
  while (d.weekday != weekday) {
    d = d.add(const Duration(days: 1));
  }
  return DateTime(d.year, d.month, d.day, hour);
}

void main() {
  final demo = Demo();
  final birth = DateTime(1990, 5, 1);

  final monday10 = nextWeekday(DateTime.monday);
  final friday10 = DateTime(monday10.year, monday10.month, monday10.day + 4, 10);

  demo.step('1. Create hospital and rooms');
  final hospital = Hospital(name: 'Nile Hospital');
  final general = Room(number: 1, type: RoomType.general, pricePerDay: 500);
  final private = Room(number: 2, type: RoomType.private, pricePerDay: 1200);
  final icu = Room(number: 3, type: RoomType.icu, pricePerDay: 3000);
  hospital.rooms.addAll([general, private, icu]);
  demo.log('${hospital.name} created with ${hospital.rooms.length} rooms');

  demo.step('2. Add doctors and nurse');
  final hassan = Doctor(
    specialization: Specialization.cardiology,
    consultationFee: 400,
    maxDailyAppointments: 10,
    baseSalary: 15000,
    workingDays: [Days.sunday, Days.monday, Days.tuesday, Days.wednesday],
    department: 'Cardiology',
    person: Person(
      name: 'Dr. Hassan',
      phone: '01000001111',
      gender: Gender.male,
      birthDate: birth,
    ),
  );
  final sara = Doctor(
    specialization: Specialization.cardiology,
    consultationFee: 400,
    maxDailyAppointments: 10,
    baseSalary: 15000,
    workingDays: [Days.sunday, Days.monday, Days.tuesday, Days.wednesday],
    department: 'Cardiology',
    person: Person(
      name: 'Dr. Sara',
      phone: '01000000003',
      gender: Gender.female,
      birthDate: birth,
    ),
  );
  final mai = Nurse(
    shift: Shift.night,
    assignedRooms: [private, icu],
    baseSalary: 6000,
    workingDays: [Days.sunday, Days.monday, Days.tuesday],
    department: 'Nursing',
    person: Person(
      name: 'Nurse Mai',
      phone: '01000000005',
      gender: Gender.female,
      birthDate: birth,
    ),
  );
  hospital.addStaff(hassan);
  hospital.addStaff(sara);
  hospital.addStaff(mai);
  demo.log('Staff added: ${hospital.staff.map((s) => s.name).join(', ')}');

  demo.step('3. Register patients');
  final ahmed = OutPatient(
    bloodType: BloodType.aPositive,
    person: Person(
      name: 'Ahmed',
      phone: '01000000101',
      gender: Gender.male,
      birthDate: birth,
    ),
  );
  final mohamed = InPatient(
    bloodType: BloodType.oPositive,
    person: Person(
      name: 'Mohamed',
      phone: '01000000002',
      gender: Gender.male,
      birthDate: birth,
    ),
  )
    ..insuranceCompany = 'Misr Insurance'
    ..coveragePercent = 60;
  final khaled = EmergencyPatient(
    severityLevel: SeverityLevel.level5,
    doctor: hassan,
    bloodType: BloodType.bNegative,
    person: Person(
      name: 'Khaled',
      phone: '01000000091',
      gender: Gender.male,
      birthDate: birth,
    ),
  );

  final omar = OutPatient(
    bloodType: BloodType.abPositive,
    person: Person(
      name: 'Omar',
      phone: '01100000004',
      gender: Gender.male,
      birthDate: birth,
    ),
  );
  for (final p in [ahmed, mohamed, khaled, omar]) {
    hospital.registerPatient(p);
  }
  demo.log('Registered: ${hospital.patients.map((p) => p.name).join(', ')}');

  demo.step('4. Ahmed books Dr. Hassan on Monday 10:00');
  hospital.bookAppointment(patient: ahmed, doctor: hassan, dateTime: monday10);
  final ahmedAppointment = hospital.appointments.last;
  demo.log('Booked: $monday10');

  demo.step('5. Another patient books the same slot');
  demo.expectError(
    'Omar -> Dr. Hassan Monday 10:00',
    () => hospital.bookAppointment(
        patient: omar, doctor: hassan, dateTime: monday10),
  );

  demo.step('6. Ahmed books Dr. Sara on Friday');
  demo.expectError(
    'Ahmed -> Dr. Sara Friday',
    () => hospital.bookAppointment(
        patient: ahmed, doctor: sara, dateTime: friday10),
  );

  demo.step('7. Dr. Hassan completes the visit');
  ahmedAppointment.complete();
  ahmed.registerVisit(hassan);
  ahmed.addRecord(
    doctor: hassan,
    diagnosis: 'Mild hypertension',
    medicines: [Medicine(name: 'Amlodipine', dose: '5mg', days: 30)],
    note: 'Reduce salt, follow up in 2 weeks',
    date: monday10,
  );
  demo.log('Visit completed, record added');

  demo.step('8. Admit Mohamed to Private, then Khaled to the same room');
  final admitDate = DateTime.now();
  hospital.admitPatient(mohamed, private, date: admitDate);
  demo.log('Mohamed admitted to room #${private.number}');
  demo.expectError(
    'Khaled -> Private room',
    () => hospital.admitPatient(khaled, private, date: admitDate),
  );

  demo.step('9. Admit Khaled to ICU');
  hospital.admitPatient(khaled, icu, date: admitDate);
  demo.log('Khaled admitted to ICU (room #${icu.number})');

  demo.step('10. Mohamed: bill, insurance, payment, discharge');
  final dischargeDate = admitDate.add(const Duration(days: 3));
  final bill = hospital.generateBill(mohamed, date: dischargeDate);
  demo.log('Bill #${bill.id}: total after 60% insurance = ${bill.total} EGP');
  demo.expectError('Pay more than remaining', () => bill.pay(bill.total + 1));
  demo.expectError('Pay 0', () => bill.pay(0));
  bill.pay(500);
  demo.log('Paid 500 -> status: ${bill.status.name}, remaining: ${bill.remainingAmount}');
  bill.pay(bill.remainingAmount);
  demo.log('Paid the rest -> status: ${bill.status.name}');
  hospital.dischargePatient(mohamed, date: dischargeDate);
  demo.log('Mohamed discharged');

  demo.step('11. Discharge Ahmed');
  demo.expectError(
    'Discharge Ahmed',
    () => hospital.dischargePatient(ahmed, date: dischargeDate),
  );

  demo.step('12. Salaries');
  for (final Staff s in hospital.staff) {
    final salary =
        s is Doctor ? s.calculateSalary(date: monday10) : s.calculateSalary();
    demo.log('${s.name} (${s.runtimeType}): $salary EGP');
  }

  demo.step('13. Cardiology doctors');
  for (final d in hospital.findDoctorsBySpecialization(Specialization.cardiology)) {
    demo.log(d.name);
  }

  demo.step('Polymorphism: calculateBill() on every patient type');
  final List<Patient> all = [ahmed, mohamed, khaled];
  for (final p in all) {
    demo.log('${p.name} (${p.runtimeType}): ${p.calculateBill(date: dischargeDate)} EGP');
  }

  hospital.generateBill(ahmed);
  hospital.generateBill(khaled);

  demo.step("14. Ahmed's medical history");
  ahmed.viewHistory();

  demo.step('14. Hospital report');
  hospital.displayReport(date: monday10);
}