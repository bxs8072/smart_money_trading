import 'dart:convert';

import 'package:http/http.dart';

class BenzingaApi {
  String benzingaApiKey = '868d643270d9482491b8f97fc40595d2';
  Client client = Client();

  Future<List<Map<String, dynamic>>> getNews() async {
    Uri uri = Uri.parse(
        'https://api.benzinga.com/api/v2/news?pageSize=3&displayOutput=headline&sort=created%3Adesc&topics=apple%2Ccrypto%2Cstock%2Ctech&token=${benzingaApiKey}');

    Response response =
        await client.get(uri, headers: {"accept": "application/json"});

    List<Map<String, dynamic>> results =
        List<Map<String, dynamic>>.from(json.decode(response.body));

    print(results);
    return results;
  }
}
