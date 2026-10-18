import 'package:hospital_system/bill.dart';
import 'package:hospital_system/exceptions.dart';
import 'package:hospital_system/insureable.dart';
import 'package:hospital_system/patient/patient.dart';
import 'package:hospital_system/room.dart';

class InPatient extends Patient with Insurable {
  Room? _room;
  DateTime? _admissionDate;
  DateTime? _dischargeDate;
  final List<Item> _services = [];

  InPatient({
    required super.bloodType,
    required super.name,
    required super.phone,
    required super.gender,
    required super.birthDate,
  });

  Room? get room => _room;
  DateTime? get admissionDate => _admissionDate;
  DateTime? get dischargeDate => _dischargeDate;
  bool get isAdmitted => _room != null && _dischargeDate == null;
  List<Item> get services => List.unmodifiable(_services);

  void addService(Item service) => _services.add(service);

  void admit(Room room, DateTime date) {
    room.occupy(this); 
    _room = room;
    _admissionDate = date;
    _dischargeDate = null;
  }

  void discharge(DateTime date) {
    if (!isAdmitted) throw PatientNotAdmittedException();
    _dischargeDate = date;
    _room!.release();
  }

  @override
  double calculateBill({DateTime? date}) {
    if (_room == null || _admissionDate == null) return 0;
    final end = date ?? _dischargeDate ?? DateTime.now();
    final start = DateTime(_admissionDate!.year, _admissionDate!.month, _admissionDate!.day);
    final last = DateTime(end.year, end.month, end.day);
    final days = last.difference(start).inDays;
    final billableDays = days < 1 ? 1 : days;
    final servicesCost = _services.fold(0.0, (s, i) => s + i.fee);
    return billableDays * _room!.pricePerDay + servicesCost;
  }

  @override
  void displayInfo() {
    print('--- Inpatient ---');
    print('ID: $id\nName: $name\nAge: $age\nPhone: $phone\n'
        'Blood type: ${bloodType.name}\n'
        'Room: ${_room?.number ?? "-"}\n'
        'Admission date: ${_admissionDate ?? "-"}\n'
        'Insurance: $insuranceCompany ($coveragePercent%)');
  }
}