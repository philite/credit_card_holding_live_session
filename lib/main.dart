import 'package:carousel_slider/carousel_slider.dart';
import 'package:credit_card_holding2/add_credit_card.dart';
import 'package:credit_card_holding2/card_type.dart';
import 'package:credit_card_holding2/credit_card.dart';
import 'package:credit_card_holding2/database.dart';
import 'package:credit_card_holding2/edit_credit_card.dart';
import 'package:credit_card_holding2/util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'list_type.dart';

void main() {
  var logger = Logger();
  logger.d(formatCardNumberRegex("0000 0000 0000 0000"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static Future<SqlDatabase> database = SqlDatabase.createInstance();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<CreditCard> allList;
  late List<CreditCard> masterCardList;
  late List<CreditCard> visaList;
  late List<CreditCard> amexList;
  bool isLoading = true;

  @override
  void initState() {
    refreshCards();
    super.initState();
  }

  void refreshCards() {
    setState(() {
      isLoading = true;
    });

    MyApp.database.then((db) => {
          db.getAllCards().then((aList) => {allList = aList}).then((value) => {
                db.getCardsByType(CardType.masterCard)
                    .then((mList) => masterCardList = mList)
                    .then((value) => db
                        .getCardsByType(CardType.visa)
                        .then((vList) => visaList = vList))
                    .then((value) => db
                        .getCardsByType(CardType.amex)
                        .then((amList) => amexList = amList))
                    .then((value) => setState(() {
                          isLoading = false;
                        }))
              })
        });

    // var database = await App.database;
    // allList = await database.getAllCards();
    // masterList = await database.getCardsByType(CardType.masterCard);
    // visaList = await database.getCardsByType(CardType.visa);
    // amexList = await database.getCardsByType(CardType.amex);
  }

  void toAddCreditCard() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddCreditCard()))
        .then((value) => {refreshCards()});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            bottom: TabBar(
              tabs: [
                Tab(text: "All"),
                Tab(text: "Master Card"),
                Tab(text: "Visa"),
                Tab(text: "Amex")
              ],
            ),
          ),
          body: buildBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: toAddCreditCard,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  Widget buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return TabBarView(children: [
      buildListView(ListType.all),
      buildListView(ListType.masterCard),
      buildListView(ListType.visa),
      buildListView(ListType.amex),
    ]);
  }

  Widget buildListView(ListType type) {
    List<CreditCard> items;

    switch (type) {
      case ListType.all:
        items = allList;
        break;
      case ListType.masterCard:
        items = masterCardList;
        break;
      case ListType.visa:
        items = visaList;
        break;
      case ListType.amex:
        items = amexList;
        break;
    }

    if (items.isEmpty) {
      return const Center(
        child: Text("Credit card empty! Add some cards"),
      );
    }

    return Scrollbar(
        child: CarouselSlider.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int itemIndex,
                    int pageViewIndex) =>
                InkWell(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 30),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: getColorGradientsByCardType(
                                  items[itemIndex].cardType))),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.all(100)),
                            SizedBox(
                              width: 225,
                              child: Text(
                                "CARD NUMBER",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              child: SizedBox(
                                width: 225,
                                child: Text(
                                  formatCardNumber(items[itemIndex].cardNumber),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      wordSpacing: 8),
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            SizedBox(
                              width: 225,
                              child: Text(
                                "EXPIRE DATE",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            SizedBox(
                              width: 225,
                              child: Text(
                                formatDate(items[itemIndex].expireDate),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // edit
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UpdateCreditCard(id: items[itemIndex].id)))
                        .then((value) => {refreshCards()});
                  },

                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Delete this card?"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      MyApp.database.then((db) => {
                                            db
                                                .deleteCard(items[itemIndex].id)
                                                .then((value) => {
                                                      refreshCards(),
                                                      Navigator.pop(context)
                                                    })
                                          });
                                    },
                                    child: Text("Delete")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"))
                              ],
                            ));
                  },
                ),
            options:
                CarouselOptions(enableInfiniteScroll: false, height: 450)));
  }
}
