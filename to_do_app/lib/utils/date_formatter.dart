

class DateFormatter {
  static const List<String> _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
  ];
  
  static const List<String> _weekdays = [
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'
  ];

  static String formatHeaderDate(DateTime date) {
    return '${_weekdays[date.weekday - 1]}, ${_months[date.month - 1]} ${date.day}';
  }

  static List<DateTime> getCurrentWeek(DateTime date) {
    int weekday = date.weekday;
    DateTime monday = date.subtract(Duration(days: weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }
}
