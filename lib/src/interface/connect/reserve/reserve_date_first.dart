import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/common/bussiness/reserve.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/component/text/label_text.dart';
import 'package:connect/src/interface/connect/reserve/reserve_date_second.dart';
import 'package:connect/src/model/reservemodel.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../common/globals.dart' as globals;

class ReserveDateFirst extends StatefulWidget {
  final String organId;
  final String? staffId;
  const ReserveDateFirst({required this.organId, this.staffId, Key? key})
      : super(key: key);

  @override
  _ReserveDateFirst createState() => _ReserveDateFirst();
}

class _ReserveDateFirst extends State<ReserveDateFirst> {
  late Future<List> loadData;

  DateTime selectedDate = DateTime.now();

  List<TimeRegion> regions = <TimeRegion>[];
  List<Appointment> appointments = <Appointment>[];
  String _fromDate = '';
  String _toDate = '';
  String showFromDate = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(Duration(days: DateTime.now().weekday)));
  String organFromTime = "00:00:00";
  String organToTime = "23:59:59";
  double sfCalanderHeight = 0;

  bool initLoad = true;

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<List> loadInitData() async {
    _fromDate = DateFormat('yyyy-MM-dd 00:00:00').format(getDate(
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1))));
    _toDate = DateFormat('yyyy-MM-dd 23:59:59').format(selectedDate
        .add(Duration(days: DateTime.daysPerWeek - selectedDate.weekday)));

    var organTime =
        await ClOrgan().loadOrganBussinessTime(context, widget.organId);
    if (organTime['from_time'] != null) organFromTime = organTime['from_time'];
    if (organTime['to_time'] != null) organToTime = organTime['to_time'];

    regions = await ClReserve().loadReserveConditions(
        context, widget.organId, widget.staffId, _fromDate, _toDate, '60');

    sfCalanderHeight = 30 *
            (int.parse(organToTime.split(':')[0]) -
                int.parse(organFromTime.split(':')[0])) +
        70;

    List<ReserveModel> reserves = await ClReserve().loadUserReserveList(
        context, globals.userId, widget.organId, _fromDate, _toDate);
    appointments = [];
    reserves.forEach((element) {
      var _color = Colors.yellow;
      String _subject = '指名予約申請';
      if (element.reserveStatus == '2') {
        _color = Colors.blue;
        _subject = '予約済み';
      }
      if (element.reserveStatus == '3') {
        _color = Colors.red;
        _subject = '拒否';
      }

      appointments.add(Appointment(
        startTime: DateTime.parse(element.reserveTime),
        endTime: DateTime.parse(element.reserveExitTime),
        color: _color,
        subject: _subject,
        startTimeZone: '',
        endTimeZone: '',
      ));
    });

    setState(() {});
    return [];
  }

  Future<void> changeViewCalander(_date) async {
    String _cFromDate = DateFormat('yyyy-MM-dd')
        .format(getDate(_date.subtract(Duration(days: _date.weekday))));
    if (_cFromDate == showFromDate && initLoad) return;
    initLoad = false;
    selectedDate = _date;
    Dialogs().loaderDialogNormal(context);
    await loadInitData();
    Navigator.pop(context);
  }

  Future<void> setReserveTime(CalendarTapDetails _cell) async {
    if (_cell.date == null) return;

    String? selText =
        regions.firstWhere((element) => element.startTime == _cell.date).text;
    // if (selText == null || selText == '' || selText == 'x') return;

    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ReserveDateSecond(
        organId: widget.organId,
        staffId: widget.staffId,
        selTime: _cell.date!,
      );
    }));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: '予約',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                  _getComments(),
                  _getReserveComment(),
                  _getDateView(),
                  SizedBox(height: 8),
                  _getCalandarContent()
                ])));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _getComments() {
    return Container(
        padding: EdgeInsets.only(left: 30, top: 20),
        child: LeftSectionTitleText(label: '予約日と時間帯を選んでください'));
  }

  Widget _getDateView() {
    return Container(
      padding: EdgeInsets.only(left: 40),
      child: LeftSectionTitleText(
          label: DateFormat('y年M月').format(DateTime.parse(_fromDate))),
    );
  }

  Widget _getReserveComment() {
    var commentStyle = TextStyle(fontSize: 12);
    return Container(
      padding: EdgeInsets.only(left: 40),
      child: Column(
        children: [
          Row(
            children: [
              Text('◎', style: TextStyle(color: Colors.red)),
              SizedBox(width: 4),
              Text('指名スタッフの予約可能時間', style: commentStyle)
            ],
          ),
          Row(
            children: [
              Text('〇', style: TextStyle(color: Colors.red)),
              SizedBox(width: 4),
              Text('指名スタッフ以外で予約できる時間', style: commentStyle)
            ],
          ),
          Row(
            children: [
              Text('□', style: TextStyle(color: Colors.green)),
              SizedBox(width: 4),
              Text('指名スタッフへのリクエスト予約。', style: commentStyle)
            ],
          ),
          Row(
            children: [
              SizedBox(width: 20),
              Text('（指名スタッフの承認後に予約確定となります。）', style: commentStyle)
            ],
          ),
          Row(
            children: [
              Text('×', style: TextStyle(color: Colors.grey)),
              SizedBox(width: 4),
              Text('予約できません。')
            ],
          )
        ],
      ),
    );
  }

  Widget _getCalandarContent() {
    return Container(
      height: sfCalanderHeight,
      child: Stack(
        children: [
          SafeArea(
            child: SfCalendar(
              headerHeight: 0,
              firstDayOfWeek: 1,
              view: CalendarView.week,
              todayHighlightColor: Colors.black,
              cellBorderColor: Color(0xffcccccc),
              timeSlotViewSettings: TimeSlotViewSettings(
                  dayFormat: '(E)',
                  timeInterval: Duration(hours: 1),
                  timeIntervalHeight: -1,
                  timeFormat: 'H:mm',
                  startHour: double.parse(organFromTime.split(':')[0]),
                  endHour: double.parse(organToTime.split(':')[0]) +
                      (int.parse(organToTime.split(':')[1]) > 0 ? 1 : 0),
                  timeTextStyle: TextStyle(fontSize: 15, color: Colors.grey)),
              specialRegions: regions,
              dataSource: _AppointmentDataSource(appointments),
              appointmentTextStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              timeRegionBuilder:
                  (BuildContext context, TimeRegionDetails timeRegionDetails) =>
                      timeRegionBuilder(timeRegionDetails),
              onTap: (d) => setReserveTime(d),
              onViewChanged: (d) => changeViewCalander(d.visibleDates[2]),
            ),
          ),
          Positioned(
              top: 55,
              left: 6,
              child: Container(
                child: Text(organFromTime.substring(0, 5),
                    style: TextStyle(
                        fontSize: 14.5,
                        color: Colors.grey,
                        letterSpacing: 0.5)),
              )),
        ],
      ),
    );
  }

  Widget timeRegionBuilder(timeRegionDetails) {
    return Container(
      height: 30,
      color: timeRegionDetails.region.color,
      alignment: Alignment.center,
      child: Text(
        timeRegionDetails.region.text.toString(),
        style: timeRegionDetails.region.textStyle,
      ),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
