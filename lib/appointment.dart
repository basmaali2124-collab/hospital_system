import 'package:hospital_system/enums.dart';
import 'package:hospital_system/patient/patient.dart';
import 'package:hospital_system/staff/doctor.dart';
import 'package:hospital_system/validation_helper.dart';

class Appointment {
  static int _counter = 0;

  final int _id;
  final Patient _patient;
  final Doctor _doctor;
  DateTime _dateTime;
  AppointmentStatus _status;

  Appointment({
    required Patient patient,
    required Doctor doctor,
    required DateTime dateTime,
  })  : _id = ++_counter,
        _patient = patient,
        _doctor = doctor,
        _dateTime = dateTime,
        _status = AppointmentStatus.scheduled {
    ValidationHelper.pastDateValidation(dateTime);
  }

  int get id => _id;
  Patient get patient => _patient;
  Doctor get doctor => _doctor;
  DateTime get dateTime => _dateTime;
  AppointmentStatus get status => _status;
   set status(AppointmentStatus status) => _status=status;

    bool get _isClosed =>
      _status == AppointmentStatus.cancelled ||
      _status == AppointmentStatus.completed;

  void complete() {
    if (_isClosed) {
      throw Exception('Cannot complete a cancelled or completed appointment.');
    }
    _status = AppointmentStatus.completed;
  }

  void cancel() {
    if (_isClosed) {
      throw Exception('Cannot cancel a cancelled or completed appointment.');
    }
    _status = AppointmentStatus.cancelled;
  }

  void reschedule(DateTime date) {
    if (_isClosed) {
      throw Exception('Cannot reschedule a cancelled or completed appointment.');
    }
    ValidationHelper.pastDateValidation(date);
    doctor.isAvailableAt(date, ignoreAppointment: this);
    _dateTime = date;
    _status = AppointmentStatus.rescheduled;
  }
}