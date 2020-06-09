import 'package:flutter/material.dart';

import 'networking.dart';

//Both API keys works.
const kCoinApiKey = 'AB930A98-4F09-4973-A49E-727C1F5C65C9';
//const kCoinApiKey = '45542D14-4EDF-4335-99A0-8CA44F1F2AFE';

const kCoinApiURL = 'https://rest.coinapi.io/v1/exchangerate';
//BTC/USD?apiKey=API

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const Map<String, String> supportedCurrencies = {
  'AUD': 'Australian Dollar',
  'BRL': 'Brazilian Real',
  'CAD': 'Canadian Dollar',
  'CNY': 'Yuan Renminbi (China)',
  'COP': 'Colombian Peso',
  'EUR': 'Euro (Europe)',
  'GBP': 'Pound Sterling (UK and others)',
  'HKD': 'Hong Kong Dollar',
  'IDR': 'Rupiah (Indonesia)',
  'ILS': 'New Israel Sheqel',
  'INR': 'Rupee (India)',
  'JPY': 'Yen (Japan)',
  'MXN': 'Mexican Peso',
  'NOK': 'Norwegian Krone',
  'NZD': 'New Zealand Dollar',
  'PLN': 'Zloty	(Poland)',
  'RON': 'Romanian Leu',
  'RUB': 'Russian Ruble',
  'SEK': 'Swedish Krona',
  'SGD': 'Singapore Dollar',
  'USD': 'US Dollar',
  'ZAR': 'Rand (South Africa)',
};

class CoinData {
  Map currenciesExchange = Map();

  Future<dynamic> getCoinData(String cryptoCurrency, String currency) async {
    String key = cryptoCurrency + currency;
    try {
      if (currenciesExchange[key] == null) {
        print('Network');
        NetworkHelper networkHelper = NetworkHelper(
            '$kCoinApiURL/$cryptoCurrency/$currency?apiKey=$kCoinApiKey');

        var data = await networkHelper.getData();

        currenciesExchange[key] = data;

        return currenciesExchange[key];
      } else {
        print('Cache');
        return currenciesExchange[key];
      }
    } catch (e) {
      throw e;
    }
  }

  void clearCache() {
    currenciesExchange.clear();
  }
}
