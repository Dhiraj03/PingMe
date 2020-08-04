String formatDate(DateTime date) {
  String month;
  switch (date.month) {
    case 1:
      month = 'Jan';
      break;
    case 2:
      month = 'Feb';
      break;
    case 3:
      month = 'Mar';
      break;
    case 4:
      month = 'Apr';
      break;
    case 5:
      month = 'May';
      break;
    case 6:
      month = 'Jun';
      break;
    case 7:
      month = 'Jul';
      break;
    case 8:
      month = 'Aug';
      break;
    case 9:
      month = 'Sep';
      break;
    case 10:
      month = 'Oct';
      break;
    case 11:
      month = 'Nov';
      break;
    case 12:
      month = 'Dec';
      break;
    default:
  }
  String hour =
      date.hour > 12 ? (date.hour - 12).toString() : '0' + date.hour.toString();
  String min =
      date.minute < 9 ? '0' + (date.minute).toString() : date.minute.toString();
  String res = date.day.toString() +
      ' ' +
      month +
      ' ' +
      date.year.toString() +
      ' - ' +
      hour +
      ':' +
      min;
  return res;
}
