import 'package:connect/src/http/webservice.dart';
import 'package:connect/src/model/company_site_model.dart';
import 'package:connect/src/model/companymodel.dart';

import '../apiendpoint.dart';

class ClCompany {
  Future<CompanyModel> loadCompanyInfo(context, String companyId) async {
    Map<dynamic, dynamic> results = {};
    String apiUrl = apiBase + '/apicompanies/loadCompanyInfo';
    await Webservice().loadHttp(
        context, apiUrl, {'company_id': companyId}).then((v) => {results = v});

    return CompanyModel.fromJson(results['company']);
  }

  Future<List<CompanySiteModel>> loadCompanySites(
      context, String companyId) async {
    List<CompanySiteModel> sites = [];

    String apiUrl = apiBase + '/apicompanies/getCompanySites';
    await Webservice()
        .loadHttp(context, apiUrl, {'company_id': companyId}).then(
            (results) => {
                  for (var item in results['sites'])
                    {sites.add(CompanySiteModel.fromJson(item))}
                });

    return sites;
  }
}
