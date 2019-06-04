library json_to_form;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class CoreForm extends StatefulWidget {
  const CoreForm({
    @required this.form,
    @required this.onChanged,
    this.padding,
    this.form_map,
    @required this.form_value,
  });

  final String form;
  final dynamic form_map;
  final dynamic form_value;
  final double padding;
  final ValueChanged<dynamic> onChanged;

  @override
  _CoreFormState createState() => _CoreFormState(
        form_items: form_map ?? json.decode(form),
        form_values: form_value ?? {},
      );
}

class _CoreFormState extends State<CoreForm> {
  final dynamic form_items;
  dynamic form_values;

  int radioValue;

  List<Widget> jsonToForm() {
    print('form_values: $form_values');

    List<Widget> listWidget = List<Widget>();

    for (var count = 0; count < form_items.length; count++) {
      Map item = form_items[count];
      String type = item['type'];

      switch (type) {
        case "RadioButton":
          listWidget.add(_buildTitle(item['title']));
          listWidget.addAll(_buildRadioGroup(item));
          break;

        case "Switch":
          listWidget.add(_buildSwitch(item));
          break;

        case "Checkbox":
          listWidget.add(_buildTitle(item['title']));
          listWidget.addAll(_buildCheckbox(item));
          break;

        case "ListString":
          listWidget.add(_buildTitle(item['title']));
          listWidget.addAll(_buildEditList<String>(item));
          break;

        case "ListInteger":
          listWidget.add(_buildTitle(item['title']));
          listWidget.addAll(_buildEditList<int>(item));
          break;

        case "DropdownString":
        case "LookupString":
          listWidget.add(_buildTitle(item['title']));
          listWidget.add(_buildDropdownButtom<String>(item));
          break;

        case "DropdownInteger":
        case "LookupInteger":
          listWidget.add(_buildTitle(item['title']));
          listWidget.add(_buildDropdownButtom<int>(item));
          break;

        case "Input":
        case "Password":
        case "Email":
        case "Number":
        case "Phone":
        case "Url":
        case "TareaText":
        default:
          listWidget.add(_buildTitle(item['title']));
          listWidget.add(_buildTextField(item));
          break;
      }
    }

    return listWidget;
  }

  List<Widget> _buildCheckbox(Map item) {
    List<Widget> listCheckbox = List<Widget>();

    for (var i = 0; i < item['list'].length; i++) {
      listCheckbox.add(Row(children: <Widget>[
        Expanded(child: Text(item['list'][i]['title'])),
        Checkbox(
          value: form_values[item['list'][i]['name']] ?? false,
          onChanged: (bool value) {
            this.setState(() {
              form_values[item['list'][i]['name']] = value;

              _handleChanged();
            });
          },
        )
      ]));
    }

    return listCheckbox;
  }

  Row _buildSwitch(Map item) {
    return Row(children: <Widget>[
      Expanded(child: Text(item['title'])),
      Switch(
        value: form_values[item['name']] ?? false,
        onChanged: (bool value) {
          this.setState(() {
            form_values[item['name']] = value;

            _handleChanged();
          });
        },
      )
    ]);
  }

  List<Widget> _buildRadioGroup(Map item) {
    List<Widget> listRadioGroup = List<Widget>();

    for (var i = 0; i < item['list'].length; i++) {
      listRadioGroup.add(Row(children: <Widget>[
        Expanded(child: Text(item['list'][i]['title'])),
        Radio<int>(
          value: item['list'][i]['value'],
          groupValue: form_values[item['name']] ?? 0,
          onChanged: (int value) {
            this.setState(() {
              form_values[item['name']] = value;

              _handleChanged();
            });
          },
        ),
      ]));
    }

    return listRadioGroup;
  }

  TextField _buildTextField(Map item) {
    var textEditingController = TextEditingController(
      text: item['type'] == "Number"
          ? "${form_values[item['name']]}"
          : form_values[item['name']],
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(hintText: item['placeholder'] ?? ""),
      maxLines: item['type'] == "TareaText" ? 10 : 1,
      onChanged: (String value) {
        if (item['type'] == "Number") {
          if (!isNumber(value)) {
            textEditingController.clear();
          }

          form_values[item['name']] =
              value == null ? null : num.tryParse(value) ?? null;
        } else {
          form_values[item['name']] = value;
        }

        _handleChanged();
      },
      obscureText: item['type'] == "Password" ? true : false,
      keyboardType: _keyboardType(item['type']),
    );
  }

  bool isNumber(String value) {
    if (value == null) {
      return true;
    }

    final n = num.tryParse(value);

    return n != null;
  }

  TextInputType _keyboardType(String type) {
    switch (type) {
      case "Email":
        return TextInputType.emailAddress;
        break;

      case "Number":
      case "ListNumber":
        return TextInputType.number;
        break;

      case "Phone":
        return TextInputType.phone;
        break;

      case "Url":
        return TextInputType.url;
        break;

      case "TareaText":
        return TextInputType.multiline;
        break;

      default:
        return TextInputType.text;
        break;
    }
  }

  Widget _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      ),
    );
  }

  _CoreFormState({@required this.form_items, this.form_values});

  void _handleChanged() {
    widget.onChanged(form_values);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(widget.padding ?? 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: jsonToForm(),
      ),
    );
  }

  Widget _buildDropdownButtom<T>(Map item) {
    List<DropdownMenuItem<T>> dropdownMenuItemList =
        List<DropdownMenuItem<T>>();

    for (var i = 0; i < item['list'].length; i++) {
      dropdownMenuItemList.add(DropdownMenuItem<T>(
        child: Text(item['list'][i]['title']),
        value: item['list'][i]['value'],
      ));
    }

    return DropdownButton<T>(
      items: dropdownMenuItemList,
      value: form_values[item['name']],
      onChanged: (T value) {
        this.setState(() {
          form_values[item['name']] = value;

          _handleChanged();
        });
      },
    );
  }

  List<Widget> _buildEditList<T>(Map item) {
    List<Widget> editList = List<Widget>();

    var textEditingController = TextEditingController();

    editList.add(
      Row(children: <Widget>[
        Expanded(
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(hintText: item['placeholder'] ?? ""),
            maxLines: 1,
            onChanged: (String value) {
              if (item['type'] == "ListNumber") {
                if (!isNumber(value)) {
                  textEditingController.clear();
                }
              }
            },
            keyboardType: _keyboardType(item['type']),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            if (!form_values[item['name']]) {
              form_values[item['name']] = List<T>();
            }

            var value = textEditingController.text;

            if (value != null && item['type'] != "ListNumber" ||
                isNumber(value)) {
              setState(() {
                form_values[item['name']].add(value);
              });
            }

            textEditingController.clear();

            _handleChanged();
          },
        ),
      ]),
    );

    var listRows = form_values[item['name']].reversed.map((data) {
      return Dismissible(
        key: Key(data),
        child: ListTile(title: Text(data)),
        onDismissed: (dismisDirection) {
          _handleChanged();
        },
      );
    }).toList();

    editList.add(ListView(children: listRows));

    return editList;
  }
}
