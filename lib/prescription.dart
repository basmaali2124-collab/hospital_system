class Prescription {
   List<Medicine> _medicines;
   String _note;

  Prescription({required List<Medicine> medicines, required String note})
      : _medicines = List.of(medicines), // نسخة، عشان محدش يعدل من بره
        _note = note;
   
   
  List<Medicine> get medicines => List.unmodifiable(_medicines);
  String get note => _note;
 @override
  String toString() => 'Medicines: ${_medicines.join(', ')} | Note: $_note';

}
class Medicine {
  final String _name;
  final String _dose;
  final int _days;

  Medicine({
    required String name,
    required String dose,
    required int days,
  }):_name=name,
     _dose=dose,
     _days=days;

  @override
  String toString() => '$_name ($_dose for $_days days)';

}