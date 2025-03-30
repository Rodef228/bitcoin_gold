import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget buildPicker() {
    return DropdownButton<String>(
      value: selectedCurrency,
      dropdownColor: Colors.lightBlue[100],
      style: TextStyle(color: Colors.blue[900], fontSize: 18),
      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
      iconSize: 30,
      underline: Container(height: 2, color: Colors.white),
      items:
          currenciesList.map((currency) {
            return DropdownMenuItem(value: currency, child: Text(currency));
          }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

  void getData() async {
    setState(() {
      isWaiting = true;
    });
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      setState(() {
        coinValues = data;
        isWaiting = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isWaiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CryptoCard(
                cryptoCurrency: 'BTC',
                value: (isWaiting ? '?' : coinValues['BTC']).toString(),
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                cryptoCurrency: 'ETH',
                value: (isWaiting ? '?' : coinValues['ETH']).toString(),
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                cryptoCurrency: 'LTC',
                value: (isWaiting ? '?' : coinValues['LTC']).toString(),
                selectedCurrency: selectedCurrency,
              ),
            ],
          ),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            color: Colors.lightBlue,
            child: buildPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.value = "BTC",
    this.selectedCurrency = "AUD",
    this.cryptoCurrency = "BTC",
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
