import 'package:hospital_system/enums.dart';
import 'package:hospital_system/exceptions.dart';
import 'package:hospital_system/patient/patient.dart';
import 'package:hospital_system/validation_helper.dart';

class Room {
  int _number;
  RoomType _type;
  double _pricePerDay;
  Patient? _patient;

  Room({
    required int number,
    required RoomType type,
    required double pricePerDay,
    Patient? patient,
  })  : _number = number,
        _type = type,
        _pricePerDay = pricePerDay,
        _patient = patient;

  int get number => _number;
  RoomType get type => _type;
  double get pricePerDay => _pricePerDay;
  bool get isOccupied => _patient != null;
  Patient? get patient => _patient;


  set number(int number){
    ValidationHelper.positiveValidation(number,"number");
    _number=number;
  }
  set type(RoomType type)=> _type = type;
  set pricePerDay(double price) {
    ValidationHelper.positiveValidation(price,"price");
    _pricePerDay=price;
  }

  void occupy(Patient p) {
  if (isOccupied) throw RoomOccupiedException();
  _patient = p;
}
void release() => _patient = null;
 }