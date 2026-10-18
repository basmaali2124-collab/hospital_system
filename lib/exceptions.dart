class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
  @override
  String toString() => message;
}

class DoctorNotAvailableException implements Exception {
  @override
  String toString() =>
      "The doctor is not available at the requested time. Please choose another time or another doctor.";
}

class SlotTakenException implements Exception {
  @override
  String toString() =>
      "This time slot is already booked. Please choose a different slot.";
}

class RoomOccupiedException implements Exception {
  @override
  String toString() =>
      "This room is currently occupied. Please choose another room or try again later.";
}

class PatientNotAdmittedException implements Exception {
  @override
  String toString() =>
      "This patient is not admitted to the hospital. Please admit the patient first.";
}

class UnpaidBillException implements Exception {
  @override
  String toString() =>
      "There is an unpaid bill on this account. Please pay it before continuing.";
}

class InvalidPaymentException implements Exception {
  @override
  String toString() =>
      "The payment is invalid. Please check the amount and try again.";
}