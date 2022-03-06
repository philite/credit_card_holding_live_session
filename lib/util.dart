import 'package:logger/logger.dart';

String formatDate(DateTime date) {
  String month; // 01
  String year; // 2022 -> 22, 2023 -> 23

  if ("${date.month}".length < 2) {
    month = "0${date.month}";
  } else {
    month = "${date.month}";
  }
  year = date.year.toString().replaceRange(0, 2, "");
  return "$month/$year";
}

String formatCardNumber(String cardNumber) {
  // 0000 0000 0000 0000
  // **** **** **** 0000
  String result = "";
  List<String> subString = cardNumber.split(" ");
  for (int i = 0; i < subString.length - 1; i++) {
    subString[i] = subString[i].replaceRange(0, subString[i].length, "**** ");
    result += subString[i];
  }
  result += subString[subString.length - 1];
  return result;
}

String formatCardNumberRegex(String cardNumber){
  // "0000 "
  final regex = RegExp("\b[0-9]{4}\s{1}\b");
  return cardNumber.replaceAll(regex, "**** ");
}
