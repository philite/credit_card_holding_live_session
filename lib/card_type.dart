import 'dart:ui';

enum CardType { masterCard, visa, amex }

// "masterCard" => CardType.masterCard

// CardType.values เท่ากับ masterCard, visa, amex
// firstWhere คือดึงตัวแรกที่เท่ากับบรรทัดข้างล่าง
// (element) => // หมายถึง element แต่ละตัวใน CardType
// masterCard => masterCard.name => "masterCard" == "masterCard"
// ถ้าเท่ากัน จะคืนค่า CardType.masterCard
// ถ้าไม่เท่ากัน ก็จะลูปตัวต่อไป visa
// (element) => visa.name => "visa" == "masterCard"

CardType cardTypeFromString(String type) {
  return CardType.values.firstWhere((element) => element.name == type);
}

List<Color> getColorGradientsByCardType(CardType type) {
  switch (type) {
    case CardType.masterCard:
      return [
        const Color(0xff6a31d5),
        const Color(0xff6b38d8),
        const Color(0xff6c48e1),
        const Color(0xff6d56e8),
        const Color(0xff6f66f0),
        const Color(0xff7173f6)
      ];
    case CardType.visa:
      return [
        const Color(0xff637ae3),
        const Color(0xff5e8ce0),
        const Color(0xff5ca3de),
        const Color(0xff5fbfda),
        const Color(0xff65d5d8),
        const Color(0xff6ce6d9)
      ];
    case CardType.amex:
      return [
        const Color(0xffe35da0),
        const Color(0xffe46099),
        const Color(0xffe66692),
        const Color(0xffe97185),
        const Color(0xffec7681),
        const Color(0xffef7e7a),
      ];
  }
}
