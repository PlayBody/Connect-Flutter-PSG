import 'dart:convert';

import 'package:connect/src/http/webservice.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../apiendpoint.dart';

class ClEvent {
  Future<List<Appointment>> loadEvents(context, dynamic param) async {
    List<Appointment> appointments = [];

    String apiUrl = apiBase + '/apievents/loadEvents';
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl,
        {'condition': jsonEncode(param)}).then((value) => results = value);
    for (var item in results['events']) {
      appointments.add(Appointment(
          startTime: DateTime.parse(item['from_time']),
          endTime: DateTime.parse(item['to_time']),
          subject: item['comment'],
          color: item['organ_id'].toString() == '0'
              ? Colors.green.withOpacity(0.5)
              : Colors.blue.withOpacity(0.5),
          startTimeZone: '',
          endTimeZone: '',
          notes: item['id'].toString()));
    }

    appointments.sort((a, b) => a.startTime.compareTo(b.startTime));
    return appointments;
  }
}
