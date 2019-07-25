library json_to_form;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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

        case "ListNumber":
          listWidget.add(_buildTitle(item['title']));
          listWidget.addAll(_buildEditList<num>(item));
          break;

        case "DropdownString":
        case "LookupString":
          listWidget.add(_buildTitle(item['title']));
          listWidget.add(_buildDropdownButtom<String>(item));
          break;

        case "DropdownNumber":
        case "LookupNumber":
          listWidget.add(_buildTitle(item['title']));
          listWidget.add(_buildDropdownButtom<num>(item));
          break;

        case "DatePicker":
        case "DateTimePicker":
        case "TimePicker":
          listWidget.add(_buildTitle(item['title']));
          listWidget.add(_buildDateTimePicker(item));
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
        this.setState(() {
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
        });
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
                  this.setState(() {
                    textEditingController.clear();
                  });
                }
              }
            },
            keyboardType: _keyboardType(item['type']),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              if (form_values[item['name']] == null) {
                form_values[item['name']] = List<T>();
              }

              var value = textEditingController.text;

              if (value != null) {
                if (item['type'] != "ListNumber") {
                  form_values[item['name']].add(value);
                } else if (isNumber(value)) {
                  form_values[item['name']].add(num.tryParse(value));
                }
              }

              textEditingController.clear();

              _handleChanged();
            });
          },
        ),
      ]),
    );

    List<Widget> listRows = List<Widget>();

    if (form_values[item['name']] != null) {
      for (int i = 0; i < form_values[item['name']].length; i++) {
        listRows.add(Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Slidable.builder(
            actionPane: SlidableDrawerActionPane(),
            secondaryActionDelegate: new SlideActionBuilderDelegate(
                actionCount: 1,
                builder: (context, index, animation, renderingMode) {
                  return IconSlideAction(
                    caption: 'Delete',
                    closeOnTap: true,
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => _buildConfirmationDialog(
                        context, i, animation, renderingMode, item),
                  );
                }),
            key: Key(form_values[item['name']][i].toString()),
            child: ListTile(
              title: Text(form_values[item['name']][i].toString()),
//          onTap: () => print(value),
//              onTap: () => crudBloc.dispatch(EditCrudEvent(value)),
            ),
          ),
        )
//            Dismissible(
//          key: Key(form_values[item['name']][i]),
//          child: ListTile(title: Text(form_values[item['name']][i])),
//          onDismissed: (dismisDirection) {
//            _handleChanged();
//          },
//        )
            );
      }
    }

    if (listRows.length == 0) {
      print("0");
      //listRows.add(ListTile(title: Text("")));
    }

    print("listRows: $listRows");

    editList.add(SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            //padding: const EdgeInsets.only(top: 20.0),
            children: listRows,
          )
        ],
      ),
    ));

    return editList;
  }

  _buildConfirmationDialog(
      BuildContext context,
      int index,
      Animation<double> animation,
      SlidableRenderingMode renderingMode,
      Map item) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Value will be deleted'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
//                print(
//                    'value ${form_values[item['name']][index]} on $index has removed');
                setState(() {
                  form_values[item['name']].removeAt(index);

                  _handleChanged();
                });

                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateTimePicker(Map item) {
    DateFormat dateFormat =
        DateFormat(item['format'] ?? _defaultDateTimeFormat(item['type']));
//    var value;
//
//    if (form_values[item['name']] != null) {
//      value = dateFormat.format(form_values[item['name']]);
//    } else {
//      value = null;
//    }
//
//    TextEditingController dateTimeEditingController = TextEditingController(
//      text: value,
//    );
    print("item: $item");
    print("item['type']: ${item['type']}");
    return DateTimeField(
      format: dateFormat,
      onShowPicker: (context, currentValue) async {
        return await _showDatePicker(context, currentValue, item['type']);
      },
      readOnly: false,
//      resetIcon: Icon(Icons.delete),
//      controller: dateTimeEditingController,
      initialValue: form_values[item['name']],
      autovalidate: true,
      validator: (date) => date == null ? "Invalid date" : null,
      decoration: InputDecoration(
          hintText: item['placeholder'] ?? "", hasFloatingPlaceholder: false),
      onChanged: (DateTime value) {
        this.setState(() {
          form_values[item['name']] = value;

          _handleChanged();
        });
      },
    );
  }

  Future<DateTime> _showDatePicker(
      BuildContext context, DateTime currentValue, String type) async {
    var date;
    var time;

    print("type: $type");

    if (type == "DateTimePicker" || type == "DatePicker") {
      date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: currentValue ?? DateTime.now(),
        lastDate: DateTime(2100),
      );
    }

    if (type == "TimePicker" || (type == "DateTimePicker" && date != null)) {
      time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
      );
    }

    switch (type) {
      case "DateTimePicker":
        return date != null ? DateTimeField.combine(date, time) : currentValue;
        break;

      case "DatePicker":
        return date ?? currentValue;
        break;

      case "TimePicker":
        return time != null ? DateTimeField.convert(time) : currentValue;
        break;
    }

    return currentValue;
  }

  String _defaultDateTimeFormat(String type) {
    const String DEFAULT_DATE_FORMAT = "dd/MM/yyyy";
    const String DEFAULT_TIME_FORMAT = "HH:mm";

    switch (type) {
      case "DateTimePicker":
        return "$DEFAULT_DATE_FORMAT $DEFAULT_TIME_FORMAT";
        break;

      case "DatePicker":
        return DEFAULT_DATE_FORMAT;
        break;

      case "TimePicker":
        return DEFAULT_TIME_FORMAT;
        break;
    }

    throw "Não implementado";
  }
}
