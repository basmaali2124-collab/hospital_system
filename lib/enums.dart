enum Gender{male,female}

enum BloodType {aPositive, aNegative, bPositive, bNegative, abPositive, abNegative, oPositive, oNegative,}

enum Specialization {cardiology, pediatrics, neurology,}

enum AppointmentStatus { scheduled, rescheduled, completed, cancelled }

enum RoomType {general,private,icu}

enum PaymentStatus {unPaid, partiallyPaid,paid}

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum SeverityLevel { level1(1), level2(2), level3(3), level4(4), level5(5);

  final int value;
  const SeverityLevel(this.value);
  bool get allowsICU => value >= 4;
}

enum Shift { morning , night }
