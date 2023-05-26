import 'dart:math';

String generateRandomString() {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  String result = '';

  for (var i = 0; i < 16; i++) {
    result += chars[random.nextInt(chars.length)];
  }

  return result;
}

extension DisplayDate on DateTime {
  String getDisplayDate(){
    List<String> monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    int month = this.month;


    return "${monthNames[month-1]} ${day}, ${year}";
  }
}