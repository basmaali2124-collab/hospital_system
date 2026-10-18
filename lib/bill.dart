import 'package:hospital_system/billable.dart';
import 'package:hospital_system/enums.dart';
import 'package:hospital_system/exceptions.dart';
import 'package:hospital_system/patient/patient.dart';
import 'package:hospital_system/validation_helper.dart';

class Bill implements Billable {
static int _counter=0;

 final int _id;
 final Patient _patient;
 final List<Item> _items;
  double _paidAmount;
  PaymentStatus _status;

  Bill({
    required Patient patient,
    required List<Item> items,
  })  : _id = ++_counter,
        _patient = patient,
        _items = List.of(items),
        _paidAmount = 0,
        _status = PaymentStatus.unPaid;//status;

  int get id => _id;
  Patient get patient => _patient;
  List<Item> get items => List.unmodifiable(_items);
  double get paidAmount => _paidAmount;
  PaymentStatus get status => _status;

  void addItem(Item item){
    if(status==PaymentStatus.paid)
    {throw Exception("cannot add items in paid bill ");}
    _items.add(item);
  }
 double get remainingAmount => total - _paidAmount;
  
  double _insuranceDiscount = 0;

void applyInsurance(int coveragePercent) {
  if(coveragePercent>=80) throw Exception("coverage Pesent cannot be gretter than 80%");
  if (_paidAmount > 0) throw InvalidPaymentException();
  final subtotal = _items.fold(0.0, (s, i) => s + i.fee);
  _insuranceDiscount = subtotal * coveragePercent / 100;
}

@override
double get total =>
    _items.fold(0.0, (s, i) => s + i.fee) - _insuranceDiscount;

  @override
  void pay(double amount) {
  if( amount<=0 || amount>remainingAmount ){
   throw InvalidPaymentException();
   }
   _paidAmount+=amount;
   _status = remainingAmount <= 0
      ? PaymentStatus.paid
      : PaymentStatus.partiallyPaid;
  } 
}

class Item {
 final String _description;
 final double _fee;

  Item({
    required String description,
    required double fee,
  })  : _description = description,
        _fee = fee{ ValidationHelper.positiveValidation(fee, 'fee');}

  String get description => _description;
  double get fee => _fee;

}