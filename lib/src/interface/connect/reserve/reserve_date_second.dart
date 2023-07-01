import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/common/bussiness/reserve.dart';
import 'package:connect/src/interface/component/button/default_buttons.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/component/text/label_text.dart';
import 'package:connect/src/interface/connect/reserve/connect_reserve_confirm.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../common/dialogs.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../model/stafflistmodel.dart';

class ReserveDateSecond extends StatefulWidget {
  final String organId;
  final String? staffId;
  final DateTime selTime;
  const ReserveDateSecond(
      {required this.organId, this.staffId, required this.selTime, Key? key})
      : super(key: key);

  @override
  _ReserveDateSecond createState() => _ReserveDateSecond();
}

class _ReserveDateSecond extends State<ReserveDateSecond> {
  late Future<List> loadData;

  List<StaffListModel> staffs = [];

  String _fromDate = '';
  String _toDate = '';
  int reserveStatus = 3;

  DateTime? reserveTime;
  // List<Appointment> appointments = <Appointment>[];

  List<TimeRegion> regions = <TimeRegion>[];
  String organFromTime = "00:00:00";
  String organToTime = "23:59:59";
  double sfCalanderHeight = 0;

  var selRegion;

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<List> loadInitData() async {
    _fromDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.selTime);
    _toDate = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(widget.selTime.add(Duration(minutes: 60)));

    var organTime =
        await ClOrgan().loadOrganBussinessTime(context, widget.organId);
    if (organTime['from_time'] != null) organFromTime = organTime['from_time'];
    if (organTime['to_time'] != null) organToTime = organTime['to_time'];

    regions = await ClReserve().loadReserveConditions(
        context, widget.organId, widget.staffId, _fromDate, _toDate, '5');

    sfCalanderHeight = 30 *
            (int.parse(organToTime.split(':')[0]) -
                int.parse(organFromTime.split(':')[0])) +
        70;

    setState(() {});
    return [];
  }

  Future<void> setReserveTime(CalendarTapDetails _cell) async {
    if (_cell.date == null) return;
    reserveTime = null;
    reserveStatus = 3;
    String? selText =
        regions.firstWhere((element) => element.startTime == _cell.date).text;
    // if (selText == null || selText == '' || selText == 'x') return;
    if (selText == '○' || selText == '◎') reserveStatus = 1;
    if (selText == '□') reserveStatus = 2;
    reserveTime = _cell.date!;
  }

  Future<void> pushReserveConfirm() async {
    if (reserveTime == null) {
      Dialogs().infoDialog(context, '予約可能な時間帯を選択してください。');
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ConnectReserveConfirm(
          reserveStatus: reserveStatus,
          reserveOrganId: widget.organId,
          reserveStaffId: widget.staffId,
          reserveStartTime: reserveTime!);
    }));
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
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  _getComments(),
                  SizedBox(height: 8),
                  Expanded(child: _getCalandarContent()),
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                      child: PrimaryButton(
                          label: '確認', tapFunc: () => pushReserveConfirm()))
                ]));
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
        child: LeftSectionTitleText(label: '詳しい予約時間を選んでください'));
  }

  Widget _getCalandarContent() {
    return Container(
      child: Stack(
        children: [
          SafeArea(
            child: SfCalendar(
              initialDisplayDate: widget.selTime,
              headerHeight: 0,
              // firstDayOfWeek: 1,
              viewNavigationMode: ViewNavigationMode.none,
              view: CalendarView.day,
              todayHighlightColor: Colors.black,
              cellBorderColor: Color(0xffcccccc),
              timeSlotViewSettings: TimeSlotViewSettings(
                  timeInterval: Duration(minutes: 5),
                  timeIntervalHeight: -1,
                  timeFormat: 'H:mm',
                  startHour: widget.selTime.hour.toDouble(),
                  endHour: widget.selTime.hour.toDouble() + 1,
                  timeTextStyle: TextStyle(fontSize: 15, color: Colors.grey)),
              specialRegions: regions,
              // dataSource: _AppointmentDataSource(appointments),
              timeRegionBuilder:
                  (BuildContext context, TimeRegionDetails timeRegionDetails) =>
                      timeRegionBuilder(timeRegionDetails),
              onTap: (d) => setReserveTime(d),
            ),
          ),
          Positioned(
              top: 55,
              left: 6,
              child: Container(
                child: Text(DateFormat('HH:mm').format(widget.selTime),
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
      padding: EdgeInsets.only(left: 20, top: 5),
      height: 30,
      color: timeRegionDetails.region.color,
      child: Text(
        timeRegionDetails.region.text.toString(),
        style: timeRegionDetails.region.textStyle,
      ),
    );
  }
}
