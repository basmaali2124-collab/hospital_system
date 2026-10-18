import 'package:hospital_system/appointment.dart';
import 'package:hospital_system/enums.dart';
import 'package:hospital_system/exceptions.dart';
import 'package:hospital_system/schedulable.dart';
import 'package:hospital_system/staff/staff.dart';
import 'package:hospital_system/validation_helper.dart';

class Doctor extends Staff implements Schedulable {
  final Specialization _specialization;
  double _consultationFee;
  List<Appointment> _appointments;
  int _maxDailyAppointments;

  Doctor({
    required Specialization specialization,
    required double consultationFee,
    required int maxDailyAppointments,
    required super.person,
    required super.baseSalary,
    required super.workingDays,
    required super.department,
  })  : _consultationFee = consultationFee,
        _specialization = specialization,
        _maxDailyAppointments = maxDailyAppointments,
        _appointments = [] {
    ValidationHelper.positiveValidation(consultationFee, "consultationFee");
    ValidationHelper.positiveValidation(maxDailyAppointments, "maxDailyAppointments");
  }

  Specialization get specialization => _specialization;
  double get consultationFee => _consultationFee;
  int get maxDailyAppointments => _maxDailyAppointments;
  List<Appointment> get appointments => List.unmodifiable(_appointments);

  @override
  double calculateSalary({DateTime? date}) {
    final d = date ?? DateTime.now();
    int count = appointments
        .where((a) =>
            a.status == AppointmentStatus.completed &&
            a.dateTime.year == d.year &&
            a.dateTime.month == d.month &&
            a.dateTime.day == d.day)
        .length;
    double finalSalary = baseSalary + ((count * consultationFee * 10) / 100);
    return finalSalary;
  }

  void addAppointment(Appointment a) => _appointments.add(a);

  @override
  void displayInfo() {
    print('--- Doctor ---');
    print(
      'ID: $id\n'
      'Name: $name\n'
      'Age: $age\n'
      'Phone: $phone\n'
      'Specialization: ${specialization.name}\n'
      'Department: $department\n'
      'Consultation fee: $consultationFee EGP\n'
      'Working days: ${workingDays.map((d) => d.name).join(', ')}\n'
      'Max daily appointments: $maxDailyAppointments',
    );
  }

  @override
  bool isAvailableAt(DateTime time, {Appointment? ignoreAppointment}) {
    if (!workingDays.contains(Days.values[time.weekday - 1])) {
      throw DoctorNotAvailableException();
    }
    final active = appointments.where(
        (a) => a != ignoreAppointment && a.status != AppointmentStatus.cancelled);
    final countThatDay = active
        .where((a) =>
            a.dateTime.year == time.year &&
            a.dateTime.month == time.month &&
            a.dateTime.day == time.day)
        .length;
    if (active.any((a) => a.dateTime == time)) {
      throw SlotTakenException();
    }
    if (countThatDay >= _maxDailyAppointments) {
      throw DoctorNotAvailableException();
    }
    return true;
  }
}