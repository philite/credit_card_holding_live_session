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
