import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/model/ticketmodel.dart';

import '../apiendpoint.dart';

class ClTicket {
  Future<List<TicketModel>> loadTickets(context, companyId) async {
    String apiUrl = apiBase + '/apitickets/loadTicketList';

    List<TicketModel> tickets = [];
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiUrl, {
      'company_id': companyId,
    }).then((v) => {results = v});

    for (var item in results['tickets']) {
      tickets.add(TicketModel.fromJson(item));
    }

    return tickets;
  }

  Future<TicketModel?> loadTicket(context, id) async {
    Map<dynamic, dynamic> results = {};
    String apiUrl = apiBase + '/apitickets/loadTicket';
    await Webservice()
        .loadHttp(context, apiUrl, {'id': id}).then((v) => results = v);
    if (results['isLoad']) {
      return TicketModel.fromJson(results['ticket']);
    } else {
      return null;
    }
  }
}
