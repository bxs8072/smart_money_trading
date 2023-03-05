import 'package:smart_money_trading/models/ticker.dart';

List<String> optyionTypeList = [
  "butterfly",
  "call spread",
  "condor",
  "iron butterfly",
  "iron condor",
  "put spread",
];

List<Ticker> stockTickerList = [
  Ticker(
      "SPDR® S&P 500",
      "The S&P 500 (Standard & Poor's 500) is a stock market index that measures the performance of 500 of the largest publicly traded companies in the United States",
      "assets/logos/snp500.png"),
  Ticker(
      "Nasdaq",
      "The NASDAQ (National Association of Securities Dealers Automated Quotations) is an electronic stock exchange that primarily trades technology and internet-related stocks",
      "assets/logos/nasdaq2.png"),
  Ticker(
      "Russell 3000",
      "The Russell 3000 Index is a market capitalization-weighted stock market index that measures the performance of the 3000 largest publicly traded companies in the United States",
      "assets/logos/russl300.png"),
];
