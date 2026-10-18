
import 'exceptions.dart';

class ValidationHelper {
  static void positiveValidation(var value, String msg) {
    if (value <= 0) {
      throw ValidationException(
        "$msg must be greater than zero",
      );
    }
  }
  static void notNegativeValidation(var value, String msg) {
    if (value < 0) {
      throw ValidationException(
        "$msg cannot be negative",
      );
    }
  }

  static void pastDateValidation(DateTime date) {
    if (date.isBefore(DateTime.now())) {
      throw ValidationException(
        "The date cannot be in the past, Please choose a future date",
      );
    }
  }

  static void phoneVlidation(String value) {
    if (value.length != 11 ||
        !RegExp(r'^\d+$').hasMatch(value)) {
      throw ValidationException(
        "Phone must be 11 digits only",
      );
    }
  }

  
   static void futureDateValidation(DateTime birthDate) {
    if (birthDate.isAfter(DateTime.now())) {
      throw ValidationException(
        "This date hasn't come yet",
      );
    }
  }
}


