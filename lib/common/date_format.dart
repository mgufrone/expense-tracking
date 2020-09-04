const DAYS = ['Mo.', 'Tue.', 'Wed.', 'Thu.', 'Fr.', 'Sat.', 'Sun.'];
String formatDate(DateTime date) {
  return '${date.year}-${date.month > 9 ? date.month : '0${date.month}'}-${date.day > 9 ? date.day : '0${date.day}'}';
}

String dateMonth(DateTime date) {
  return '${date.month}.${date.day}';
}

String dayOnly(DateTime date) {
  return DAYS[date.weekday - 1];
}
