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
