import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/globals.dart' as globals;

class Funcs {
  Future<void> logout(BuildContext context) async {
    globals.userId = '';
    globals.userName = '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('is_rirakukan_login_id', '');

    Navigator.pushNamed(context, '/Home');
  }

  // bool orderInputListAdd(BuildContext context, MenuReserveModel item) {
  //   if (globals.orderReserveMenus.length >= 10) {
  //     Dialogs().infoDialog(context, warningOrderReserveMenuMax);
  //     return false;
  //   }
  //   if (item.menuId == null) {
  //     globals.orderReserveMenus.add(item);
  //   } else {
  //     List<MenuReserveModel> reserveList = [];
  //     bool isExist = false;
  //     globals.orderReserveMenus.forEach((element) {
  //       if (element.menuId == item.menuId &&
  //           element.variationId == item.variationId) {
  //         reserveList.add(MenuReserveModel(
  //             menuTitle: item.menuTitle,
  //             quantity: (int.parse(element.quantity) + int.parse(item.quantity))
  //                 .toString(),
  //             menuPrice: item.menuPrice,
  //             menuId: item.menuId,
  //             variationId: item.variationId));
  //         isExist = true;
  //       } else {
  //         reserveList.add(element);
  //       }
  //     });
  //     if (!isExist) {
  //       reserveList.add(item);
  //     }
  //     globals.orderReserveMenus = reserveList;
  //   }
  //   return true;
  // }

  String getTimeFormatHHMM(DateTime? _time) {
    if (_time == null) return '設定なし';

    String hour =
        _time.hour < 10 ? '0' + _time.hour.toString() : _time.hour.toString();
    String min = _time.minute < 10
        ? '0' + _time.minute.toString()
        : _time.minute.toString();

    return hour + ':' + min;
  }

  String getTimeFormatHMM00(DateTime? _time) {
    if (_time == null) return '設定なし';

    String hour = _time.hour.toString();
    String min = _time.minute < 10
        ? '0' + _time.minute.toString()
        : _time.minute.toString();

    return hour + ':' + min + ':00';
  }

  bool isNumeric(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

  String dateFormatJP1(String? dateString) {
    if (dateString == null) return '';
    DateTime _date = DateTime.parse(dateString);
    return _date.year.toString() +
        '年' +
        _date.month.toString() +
        '月' +
        _date.day.toString() +
        '日';
  }

  String dateFormatHHMMJP(String? dateString) {
    if (dateString == null) return '';
    DateTime _date = DateTime.parse(dateString);
    return _date.hour.toString() + '時' + _date.minute.toString() + '分';
  }

  String dateTimeFormatJP1(String? dateString) {
    if (dateString == null) return '';
    DateTime _date = DateTime.parse(dateString);
    return _date.month.toString() +
        '月' +
        _date.day.toString() +
        '日' +
        _date.hour.toString() +
        '時' +
        _date.minute.toString() +
        '分';
  }

  String dateTimeFormatJP2(String? dateString) {
    if (dateString == null) return '';
    return int.parse(dateString.split(":")[0]).toString() +
        '時間' +
        int.parse(dateString.split(":")[1]).toString() +
        '分';
  }

  List<String> getYearSelectList(String min, String max) {
    List<String> results = [];

    for (int i = int.parse(min); i <= int.parse(max); i++) {
      results.add(i.toString());
    }
    return results;
  }

  List<String> getMonthSelectList() {
    List<String> results = [];

    for (int i = 1; i <= 12; i++) {
      results.add(i.toString());
    }
    return results;
  }

  List<String> getDaySelectList(String? year, String? month) {
    List<String> results = [];
    int maxDay = 31;

    if (year != null && month != null) {
      if (month == '12') {
        year = (int.parse(year) + 1).toString();
        month = '01';
      } else {
        month = (int.parse(month) + 1).toString();
        if (int.parse(month) < 10) month = '0' + month;
      }
      DateTime nextMonthFirstDate = DateTime.parse(year + '-' + month + '-01');
      DateTime monthLastDate = nextMonthFirstDate.subtract(Duration(days: 1));
      maxDay = monthLastDate.day;
    }
    for (int i = 1; i <= maxDay; i++) {
      results.add(i.toString());
    }
    return results;
  }

  int getMaxDays(String? year, String? month) {
    int maxDay = 31;

    if (year != null && month != null) {
      if (month == '12') {
        year = (int.parse(year) + 1).toString();
        month = '01';
      } else {
        month = (int.parse(month) + 1).toString();
        if (int.parse(month) < 10) month = '0' + month;
      }
      DateTime nextMonthFirstDate = DateTime.parse(year + '-' + month + '-01');
      DateTime monthLastDate = nextMonthFirstDate.subtract(Duration(days: 1));
      maxDay = monthLastDate.day;
    }
    return maxDay;
  }

  List<String> getMiniuteSelectList(
      String? min, String? max, String? dur, bool isEmpty) {
    List<String> results = [];
    if (isEmpty) results.add('');
    int fromT = min == null ? 0 : int.parse(min);
    int toT = max == null ? 90 : int.parse(max);
    int stepT = dur == null ? 5 : int.parse(dur);

    for (int i = fromT; i <= toT; i = i + stepT) {
      results.add(i.toString());
    }
    return results;
  }

  String currencyFormat(String value) {
    bool isMinus = false;
    //print(int.parse(value));
    if (int.parse(value) < 0) isMinus = true;
    String param = value.replaceAll('-', '');

    String result = '';

    int _length = param.length;
    if (_length < 4) return isMinus ? ('-' + param) : param;

    int commaCount = _length ~/ 3;
    int mod = _length % 3;

    if (mod == 0) {
      commaCount--;
      mod = 3;
    }
    for (var i = 0; i <= commaCount; i++) {
      if (i == 0)
        result = param.substring(0, mod);
      else
        result = result + ',' + param.substring((i - 1) * 3 + mod, i * 3 + mod);
    }

    //print(isMinus);
    return isMinus ? ('-' + result) : result;
  }
}
