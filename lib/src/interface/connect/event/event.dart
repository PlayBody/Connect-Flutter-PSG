import 'package:connect/src/common/bussiness/event.dart';
import 'package:connect/src/common/bussiness/organs.dart';
import 'package:connect/src/common/const.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/interface/component/dropdown/dropdownmodel.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/model/organmodel.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ConnectEvent extends StatefulWidget {
  const ConnectEvent({Key? key}) : super(key: key);

  @override
  _ConnectEvent createState() => _ConnectEvent();
}

class _ConnectEvent extends State<ConnectEvent> {
  late Future<List> loadData;

  DateTime selectedDate = DateTime.now();
  String _fromDate = DateFormat('yyyy-MM-dd').format(
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)));
  String _toDate = DateFormat('yyyy-MM-dd').format(DateTime.now()
      .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)));

  List<Appointment> appointments = <Appointment>[];

  List<OrganModel> organs = [];

  String? organId;

  @override
  void initState() {
    super.initState();
    loadData = loadEventData();
  }

  Future<List> loadEventData() async {
    organs = await ClOrgan().loadOrganList(context, APPCOMANYID);
    if (organId == null) organId = organs.first.organId;
    String vFromDateTime = _fromDate + ' 00:00:00';
    String vToDateTime = _toDate + ' 23:59:59';

    appointments = [];
    appointments = await ClEvent().loadEvents(context, {
      'company_id': APPCOMANYID,
      'from_time': vFromDateTime,
      'to_time': vToDateTime,
      'organ_id': organId
    });

    appointments.addAll(await ClEvent().loadEvents(context, {
      'company_id': APPCOMANYID,
      'from_time': vFromDateTime,
      'to_time': vToDateTime,
      'is_all_organ': '1'
    }));

    setState(() {});
    return [];
  }

  Future<void> changeViewCalander(DateTime _date) async {
    if (_fromDate ==
        DateFormat('yyyy-MM-dd')
            .format(_date.subtract(Duration(days: _date.weekday - 1)))) return;
    _fromDate = DateFormat('yyyy-MM-dd')
        .format(_date.subtract(Duration(days: _date.weekday - 1)));
    _toDate = DateFormat('yyyy-MM-dd').format(
        _date.add(Duration(days: DateTime.daysPerWeek - _date.weekday)));

    Dialogs().loaderDialogNormal(context);
    await loadEventData();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: 'イベントカレンダー',
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: [
                  _getTopButtons(),
                  // _getOrganDropDown(),
                  Expanded(child: _getCalendar()),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _getTopButtons() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(children: [
          Container(child: Text('店名'), width: 80),
          Flexible(
              child: DropDownModelSelect(
                  value: organId,
                  items: [
                    ...organs.map((e) => DropdownMenuItem(
                          child: Text(e.organName),
                          value: e.organId,
                        ))
                  ],
                  tapFunc: (v) async {
                    organId = v;
                    Dialogs().loaderDialogNormal(context);
                    await loadEventData();
                    Navigator.pop(context);
                  }))
        ]));
  }

  Widget _getCalendar() {
    return SfCalendar(
      view: CalendarView.week,
      firstDayOfWeek: 1,
      headerHeight: 0,
      // cellBorderColor: timeSlotCellBorderColor,
      // selectionDecoration: timeSlotSelectDecoration,
      timeSlotViewSettings: TimeSlotViewSettings(
          // startHour: viewFromHour.toDouble(),
          // endHour: viewToHour.toDouble(),
          timeIntervalHeight: 30,
          dayFormat: 'E',
          timeInterval: Duration(minutes: 30),
          timeFormat: 'H:mm',
          timeTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Colors.black.withOpacity(0.5),
          )),
      appointmentTextStyle: TextStyle(
          fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
      timeRegionBuilder:
          (BuildContext context, TimeRegionDetails timeRegionDetails) {
        return Container(
          padding: EdgeInsets.only(top: 5),
          color: timeRegionDetails.region.color,
          alignment: Alignment.topCenter,
          child: Text(
            timeRegionDetails.region.text.toString(),
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
        );
      },
      // viewNavigationMode: ViewNavigationMode.none,
      // specialRegions: regions,
      dataSource: _AppointmentDataSource(appointments),
      // onTap: (d) => selectedDate = d.date!,
      // onLongPress: (d) => calendarTapped(d),
      onViewChanged: (d) => changeViewCalander(d.visibleDates[1]),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
