import 'package:smart_money_trading/models/ticker.dart';

List<String> optyionTypeList = [
  "butterfly",
  "call spread",
  "condor",
  "iron butterfly",
  "iron condor",
  "outright call",
  "outright put",
  "put spread",
];

List<Ticker> stockTickerList = [
  Ticker("spy", "SPDR® S&P 500 ETF Trust, NYSEARCA", "assets/logos/tesla.png"),
  Ticker("qqq", "Invesco QQQ Trust, NASDAQ", "assets/logos/tesla.png"),
  Ticker(
      "tsla",
      "Tesla, Inc. designs, develops, manufactures, sells and leases fully electric vehicles and energy generation and storage systems, and offer services related to its products. The Company's automotive segment includes the design, development, manufacturing, sales, and leasing of electric vehicles as well as sales of automotive regulatory credits. Additionally, the automotive segment is also comprised of services and other, which includes non-warranty after-sales vehicle services, sales of used vehicles, retail merchandise, sales by its acquired subsidiaries to third party customers, and vehicle insurance. Its energy generation and storage segment includes the design, manufacture, installation, sales and leasing of solar energy generation and energy storage products and related services and sales of solar energy systems incentives. Its automotive products include Model 3, Model Y, Model S and Model X. Powerwall and Megapack are its lithium-ion battery energy storage products.",
      "assets/logos/tesla.png"),
  Ticker(
      "aapl",
      "Apple Inc. (Apple) designs, manufactures and markets smartphones, personal computers, tablets, wearables and accessories and sells a range of related services. The Company’s products include iPhone, Mac, iPad, AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch and accessories. The Company operates various platforms, including the App Store, which allows customers to discover and download applications and digital content, such as books, music, video, games and podcasts. Apple offers digital content through subscription-based services, including Apple Arcade, Apple Music, Apple News+, Apple TV+ and Apple Fitness+. Apple also offers a range of other services, such as AppleCare, iCloud, Apple Card and Apple Pay. Apple sells its products and resells third-party products in a range of markets, including directly to consumers, small and mid-sized businesses, and education, enterprise and government customers through its retail and online stores and its direct sales force.",
      "assets/logos/apple.png"),
  Ticker(
      "msft",
      "Microsoft Corporation is a technology company. The Company develops and supports software, services, devices, and solutions. Its segments include Productivity and Business Processes, Intelligent Cloud, and More Personal Computing. The Productivity and Business Processes segment consists of products and services in its portfolio of productivity, communication, and information services, spanning a variety of devices and platforms. This segment includes Office Consumer, LinkedIn, dynamics business solutions, and Office Commercial. The Intelligent Cloud segment consists of public, private, and hybrid server products and cloud services that can power modern businesses and developers. This segment includes server products and cloud services, and enterprise services. The More Personal Computing segment consists of products and services that put customers at the centre of the experience with its technology. This segment includes Windows, devices, gaming, and search and news advertising.",
      "assets/logos/microsoft.png"),
  Ticker(
      "amzn",
      "Amazon.com, Inc. provides a range of products and services to customers. The products offered through its stores include merchandise and content that it purchased for resale and products offered by third-party sellers. It manufactures and sells electronic devices, including Kindle, Fire tablet, Fire TV, Echo, and Ring, and it develops and produces media content. It also offers subscription services such as Amazon Prime, a membership program. Its segments include North America, International and Amazon Web Services (AWS). The AWS segment consists of global sales of compute, storage, database, and other services for start-ups, enterprises, government agencies, and academic institutions. It provides advertising services to sellers, vendors, publishers, authors, and others, through programs, such as sponsored advertisements, display, and video advertising. Customers access its offerings through websites, mobile applications, Alexa, devices, streaming, and physically visiting its stores.",
      "assets/logos/amazon.jpeg"),
  Ticker(
      "goog",
      "Alphabet Inc. is a holding company. The Company's segments include Google Services, Google Cloud, and Other Bets. The Google Services segment includes products and services such as ads, Android, Chrome, hardware, Google Maps, Google Play, Search, and YouTube. The Google Cloud segment includes Google's infrastructure and platform services, collaboration tools, and other services for enterprise customers. The Other Bets segment includes earlier stage technologies that are further afield from its core Google business, and it includes the sale of health technology and Internet services. Its Google Cloud provides enterprise-ready cloud services, including Google Cloud Platform and Google Workspace. Google Cloud Platform enables developers to build, test, and deploy applications on its infrastructure. The Company's Google Workspace collaboration tools include applications, such as Gmail, Docs, Drive, Calendar, Meet, and various others. The Company also has various hardware products.",
      "assets/logos/google.png"),
];
