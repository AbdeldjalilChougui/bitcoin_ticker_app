import 'package:bitcoin_ticker/models/coin_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinData {
  static const apiKey = "E2583C82-C95E-4679-975B-32B1AF8275CD";
  static const url = "https://rest.coinapi.io/v1/exchangerate";

  Future getCoinData (String currency) async {
    Map<String,String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      http.Response response = await http.get(
          "$url/$crypto/$currency?apikey=$apiKey");
      if (response.statusCode == 200) {
        double price = jsonDecode(response.body)["rate"];
        cryptoPrices[crypto] = price.toStringAsFixed(1);
      }
    }
    return cryptoPrices;
  }
}
