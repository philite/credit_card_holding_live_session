import 'package:credit_card_holding2/database.dart';

import 'card_type.dart';

class CreditCard {
  int id;
  String cardNumber;
  DateTime expireDate;
  CardType cardType;

  CreditCard({
    this.id = 0,
    required this.cardNumber,
    required this.expireDate,
    required this.cardType
  });

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'expireDate': expireDate.toString(),
      'type': cardType.name
    };
  }

  static CreditCard fromMap(Map map) {
    // เรื่อง JSON / Python Dictionary
    // Map<String, String> หมายถึง Map<key, value>
    // map[key] = value
    // id = map[columnId] ซึ่ง columnId คือ key จะได้ value ออกมาเป็น id

    return CreditCard(
      id: map[SqlDatabase.columnId],
      cardNumber: map[SqlDatabase.columnCardNumber],
      expireDate: DateTime.parse(map[SqlDatabase.columnExpireDate]),
      cardType: cardTypeFromString(map[SqlDatabase.columnCardType])
    );
  }

  @override
  String toString() {
    return 'CreditCard{id: $id, cardNumber: $cardNumber, expireDate: $expireDate, cardType: $cardType}';
  }
}
