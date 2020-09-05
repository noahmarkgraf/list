class MyDateTime {

  String convertString(DateTime date) {
    // return '${date.day}:${date.month}:${date.year} - ${date.hour}:${date.minute}';
    return '${date.day}.${date.month}.${date.year} - ${date.hour}:${(date.minute < 10 ? '0' + date.minute.toString() : date.minute)}';
  }

}