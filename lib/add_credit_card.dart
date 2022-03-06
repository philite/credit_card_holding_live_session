import 'package:credit_card_holding2/credit_card.dart';
import 'package:credit_card_holding2/main.dart';
import 'package:credit_card_holding2/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'card_type.dart';

class AddCreditCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddCreditCardState();
}

class AddCreditCardState extends State<AddCreditCard> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  String _selectedType = CardType.masterCard.name;
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Credit Card"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 60),
                child: Text("Type"),
              ),
              DropdownButton(
                items: ["masterCard", "visa", "amex"].map((value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue as String;
                  });
                },
                value: _selectedType,
              )
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(60, 0, 60, 20),
            child: Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(label: Text("Card Number")),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CharacterSpacingInputFormatter()
                ],
                validator: (String? value) {
                  // Elvis operator (short-handed if-else)
                  return (value != null && value.length == 19) ? null : 'Invalid card';
                },
                controller: controller,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Expire Date"),
                Text(formatDate(_dateTime))
              ],
            ),
          ),
          Container(
            child: ElevatedButton(
              child: Text("Pick expire date"),
              onPressed: () {
                showMonthPicker(context: context, initialDate: _dateTime)
                    .then((newDate) =>
                {
                  if (newDate != null) {
                    setState(() {
                      _dateTime = newDate;
                    })
                  }
                });
              },
            ),
          ),
          Padding(padding: EdgeInsets.all(20)),
          Center(
            child: ElevatedButton(
              child: Text("Add"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  MyApp.database.then((db) =>
                  {
                    db.addCard(CreditCard(
                        cardNumber:controller.text,
                        expireDate: _dateTime,
                        cardType: cardTypeFromString(_selectedType)
                    )).then((value) => {
                      Navigator.pop(context)
                    })
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Adding Card"))
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CharacterSpacingInputFormatter extends TextInputFormatter {
  int separateEvery = 4;
  String separateBy = " ";

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % separateEvery == 0 && nonZeroIndex != text.length) {
        buffer.write(separateBy);
      }
    }

    var newString = buffer.toString();
    return newValue.copyWith(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length)
    );
  }
}
