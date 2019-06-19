import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_to_form/json_to_form.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(title: 'Flutter Json To Form'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  String form_send_email = json.encode([
    {
      'name': "subject",
      'type': 'Input',
      'title': 'Subject',
      'placeholder': "Subject"
    },
    {
      'name': "content",
      'type': 'TareaText',
      'title': 'Message',
      'placeholder': "Content"
    },
  ]);
  String form = json.encode([
    {
      'name': "higroup",
      'type': 'Input',
      'title': 'Hi Group',
      'placeholder': "Hi Group flutter"
    },
    {
      'name': 'password',
      'type': 'Password',
      'title': 'Password',
    },
    {
      'name': 'email',
      'type': 'Email',
      'title': 'Email test',
      'placeholder': "hola a todos"
    },
    {
      'name': 'url',
      'type': 'Url',
      'title': 'URL',
      'placeholder': "hola a todos"
    },
    {
      'name': 'tareatexttest',
      'type': 'TareaText',
      'title': 'TareaText test',
      'placeholder': "hola a todos"
    },
    {
      'name': 'radiobuton1',
      'type': 'RadioButton',
      'title': 'Radio Button test 1',
      'list': [
        {
          'title': "product 1",
          'value': 1,
        },
        {
          'title': "product 2",
          'value': 2,
        },
        {
          'title': "product 3",
          'value': 3,
        }
      ]
    },
    {
      'name': 'radiobuton2',
      'type': 'RadioButton',
      'title': 'Radio Button test 2',
      'list': [
        {
          'title': "product 1",
          'value': 1,
        },
        {
          'title': "product 2",
          'value': 2,
        },
        {
          'title': "product 3",
          'value': 3,
        }
      ]
    },
    {
      'name': 'switch',
      'type': 'Switch',
      'title': 'Switch test',
    },
    {
      'type': 'Checkbox',
      'title': 'Checkbox test',
      'list': [
        {
          'name': 'checkbox1product1',
          'title': "product 1",
        },
        {
          'name': 'checkbox1product2',
          'title': "product 2",
        },
        {
          'name': 'checkbox1product3',
          'title': "product 3",
        }
      ]
    },
    {
      'type': 'Checkbox',
      'title': 'Checkbox test 2',
      'list': [
        {
          'name': 'checkbox2product1',
          'title': "product 1",
        },
        {
          'name': 'checkbox2product2',
          'title': "product 2",
        },
        {
          'name': 'checkbox2product3',
          'title': "product 3",
        }
      ]
    },
    {
      'name': 'dropdownstring',
      'type': 'DropdownString',
      'title': 'DropdownString test',
      'list': [
        {
          'title': "Item 1",
          'value': "item1",
        },
        {
          'title': "Item 2",
          'value': "item2",
        },
        {
          'title': "Item 3",
          'value': "item3",
        }
      ]
    },
    {
      'name': 'dropdownnumber',
      'type': 'DropdownNumber',
      'title': 'DropdownNumber test',
      'list': [
        {
          'title': "Item 1",
          'value': 1,
        },
        {
          'title': "Item 2",
          'value': 2,
        },
        {
          'title': "Item 3",
          'value': 3,
        },
        {
          'title': "Item 3.5",
          'value': 3.5,
        }
      ]
    },
    {
      'name': 'liststring',
      'type': 'ListString',
      'title': 'List String',
      'placeholder': 'Item',
      'list': [
        'Item 1',
        'Item 2',
        'Item 3',
      ]
    },
    {
      'name': 'listnumber',
      'type': 'ListNumber',
      'title': 'List Number',
      'placeholder': '0',
      'list': [
        1,
        2,
        3,
        3.5,
      ]
    },
  ]);
  dynamic response;

  @override
  Widget build(BuildContext context) {
    print(form);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: new Column(children: <Widget>[
            new CoreForm(
              form: form,
              form_value: response,
              onChanged: (dynamic response) {
                this.response = response;
              },
            ),
            new RaisedButton(
                child: new Text('Send'),
                onPressed: () {
                  print(this.response.toString());
                })
          ]),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
