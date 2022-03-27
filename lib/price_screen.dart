import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = "USD";

  DropdownButton androidDropDown () {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          this.selectedCurrency = value;
          getData();
        });
      },
    );
  }


  CupertinoPicker iOSPicker () {
    List<Text> cupertinoItems = [];
    for(String currency in currenciesList) {
      cupertinoItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: cupertinoItems,
    );
  }

  Map<String,String> cryptoPrices = {};
  bool isWaiting;

  void getData() async{
    isWaiting = true;
    try {
      var dataPrices = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        cryptoPrices = dataPrices;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<CryptoCard> gett () {
    List<CryptoCard> cards = [];
    for (String crypto in cryptoList)
    {
      cards.add(
        CryptoCard(
          crypto: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? "?" : cryptoPrices[crypto],
        ),
      );
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: gett(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? androidDropDown() : iOSPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    @required this.crypto,
    @required this.selectedCurrency,
    @required this.value,
  });

  final String crypto;
  final String selectedCurrency;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $crypto = $value $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
