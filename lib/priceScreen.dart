import 'package:bitcoin_ticker/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'coinData.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
//  String btc = '1 BTC = ';
//  String eth = '1 ETH = ';
//  String ltc = '1 LTC = ';
  CoinData coinData = CoinData();
  Map<String, String> currencyExchange = Map();
  SizeConfig sizeConfig = SizeConfig();
  bool isWaiting = false;

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> items = [];
    for (String currency in supportedCurrencies.keys) {
      items.add(DropdownMenuItem(
        value: currency,
        child: Text(
          currency,
        ),
      ));
    }

    return DropdownButton<String>(
      dropdownColor: Colors.lightBlue[900],
      underline: Container(
        height: 2,
        color: Colors.lightBlue[900],
      ),
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          print(selectedCurrency);
          getCoinData(selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> items = [];
    for (String currency in supportedCurrencies.keys) {
      items.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: SizeConfig.safeBlockHorizontal * 7,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = items[selectedIndex].data;
        getCoinData(selectedCurrency);
      },
      children: items,
    );
  }

  void showColoredToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.lightBlue[900],
      textColor: Colors.white,
    );
  }

  void getCoinData(String currency) async {
    isWaiting = true;
    try {
      for (String crypto in cryptoList) {
        var data = await coinData.getCoinData(crypto, currency);

        isWaiting = false;

        if (data != null) {
          var rate = data['rate'];
          int roundedRate = rate.toInt();

          setState(() {
            currencyExchange[crypto] = roundedRate.toString();
          });
        } else {
          setState(() {
            currencyExchange[crypto] = 'not found';
          });
        }
      }

      print(currencyExchange);
    } catch (e) {
      showColoredToast('Error ' + e.errorCode.toString() + ' - ' + e.errorMsg);
    }
  }

  void refresh() {
    coinData.clearCache();
    getCoinData(selectedCurrency);
  }

  @override
  void initState() {
    super.initState();
    getCoinData(selectedCurrency);
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : currencyExchange[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: SizeConfig.safeBlockHorizontal * 15,
                alignment: Alignment.center,
                //padding: EdgeInsets.only(bottom: 30.0),
                margin: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2.5),
                //color: Colors.lightBlue,
                child: Text(
                  supportedCurrencies[selectedCurrency],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: SizeConfig.safeBlockHorizontal * 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              makeCards(),
            ],
          ),
          Container(
            height: SizeConfig.safeBlockHorizontal * 25,
            alignment: Alignment.center,
            //padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        tooltip: 'Refresh',
        backgroundColor: Colors.lightBlue[900],
        foregroundColor: Colors.white,
        onPressed: () {
          refresh();
        },
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({this.value, this.selectedCurrency, this.cryptoCurrency});

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          SizeConfig.safeBlockHorizontal * 4,
          SizeConfig.safeBlockHorizontal * 4,
          SizeConfig.safeBlockHorizontal * 4,
          0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.safeBlockHorizontal * 3,
              horizontal: SizeConfig.safeBlockHorizontal * 7),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 4.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
