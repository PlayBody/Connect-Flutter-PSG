import 'package:intl/intl.dart';

class DateTimes {
  String convertTimeFromDouble(v) {
    return (v.toInt() < 10
            ? '0' + v.toInt().toString()
            : v.toInt().toString()) +
        ':' +
        (((v - v.toInt()) * 60).toInt() < 10
            ? '0' + ((v - v.toInt()) * 60).toInt().toString()
            : ((v - v.toInt()) * 60).toInt().toString()) +
        ':00';
  }

  String convertTimeFromDateTime(v) {
    return (v.hour < 10 ? '0' + v.hour.toString() : v.hour.toString()) +
        ":" +
        (v.minute < 10 ? '0' + v.minute.toString() : v.toString()) +
        ':00';
  }

  String convertTimeFromDateTimeAddHour(v, h) {
    return ((v.hour + h) < 10
            ? '0' + (v.hour + h).toString()
            : (v.hour + h).toString()) +
        ":" +
        (v.minute < 10 ? '0' + v.minute.toString() : v.minute.toString()) +
        ':00';
  }

  String convertTimeFromString(String v) {
    return DateFormat('HH:mm:ss').format(DateTime.parse(v));
  }

  String convertJPYMFromDateTime(DateTime v) {
    return v.year.toString() + '年' + v.month.toString() + '月';
  }
}
