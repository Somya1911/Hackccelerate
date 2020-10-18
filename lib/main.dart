import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Health Assistant'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int calorieBase;
  int calorieAvecActivite;
  int radioSelectionnee;
  double poids;
  double age;
  bool genre = false;
  double taille = 170.0;
  Map mapActivite = {
    0: "Low",
    1: "Moderate",
    2: "High"
  };

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          backgroundColor: setColor(),
        ),
        body: new SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              padding(),
              texteAvecStyle("Fill in all the fields to get your daily calorie requirement."),
              padding(),
              new Card(
                elevation: 10.0,
                child: new Column(
                  children: <Widget>[
                    padding(),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        texteAvecStyle("Female", color: Colors.pink),
                        new Switch(
                            value: genre,
                            inactiveTrackColor: Colors.pink,
                            activeTrackColor: Colors.blue,
                            onChanged: (bool b) {
                              setState(() {
                                genre = b;
                              });
                            }),
                        texteAvecStyle("Male", color: Colors.blue)
                      ],
                    ),
                    padding(),
                    new RaisedButton(
                      color: setColor(),
                      child: texteAvecStyle((age == null)? "Press to enter your age": "Your age is: ${age.toInt()}",
                        color: Colors.white
                      ),
                        onPressed: (() => montrerPicker())
                    ),
                    padding(),
                    texteAvecStyle("Your height is: ${taille.toInt()} cm.", color: setColor()),
                    padding(),
                    new Slider(
                        value: taille,
                        activeColor: setColor(),
                        onChanged: (double d) {
                          setState(() {
                            taille = d;
                          });
                        },
                      max: 215.0,
                      min: 100.0,
                    ),
                    padding(),
                    new TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (String string) {
                        setState(() {
                          poids = double.tryParse(string);
                        });
                      },
                      decoration: new InputDecoration(
                        labelText: "Enter your weight in kilograms."
                      ),
                    ),
                    padding(),
                    texteAvecStyle("What is your sporting activity?", color: setColor()),
                    padding(),
                    rowRadio(),
                    padding()
                  ],
                ),
              ),
              padding(),
              new RaisedButton(
                color: setColor(),
                child: texteAvecStyle("Calculate", color: Colors.white),
                  onPressed: calculerNombreDeCalories,
              )
            ],
          ),
        ),
      ),
    );


  }


  Padding padding() {
    return new Padding(padding: EdgeInsets.only(top: 20.0));
  }

  Future<Null> montrerPicker() async {
    DateTime choix = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now(),
      initialDatePickerMode: DatePickerMode.year
    );
    if (choix != null) {
      var difference = new DateTime.now().difference(choix);
      var jours = difference.inDays;
      var ans = (jours / 365);
      setState(() {
        age = ans;
      });
    }
  }


  Color setColor() {
    if (genre) {
      return Colors.blue;
    } else {
      return Colors.pink;
    }
  }
  
  Text texteAvecStyle(String data, {color: Colors.black, fontSize: 15.0}) {
    return new Text(
      data,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color: color,
        fontSize: fontSize
      )
    );
  }
  
  Row rowRadio() {
    List<Widget> l = [];
    mapActivite.forEach((key, value) {
      Column colonne = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
            activeColor: setColor(),
              value: key,
              groupValue: radioSelectionnee, 
              onChanged: (Object i) {
              setState(() {
                radioSelectionnee = i;

              });
              }),
          texteAvecStyle(value, color: setColor())
        ],
      );
      l.add(colonne);
    });
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }

  void calculerNombreDeCalories() {
    if (age != null && poids != null && radioSelectionnee != null) {
      //Calculer
      if (genre) {
        calorieBase = (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age)).toInt();
      } else {
        calorieBase = (655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age)).toInt();
      }
      switch(radioSelectionnee) {
        case 0:
          calorieAvecActivite = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieAvecActivite = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieAvecActivite = (calorieBase * 1.8).toInt();
          break;
        default:
          calorieAvecActivite = calorieBase;
          break;
      }

      setState(() {
        dialogue();
      });

    } else {
      alerte();
    }
  }

  Future<Null> dialogue() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return SimpleDialog(
            title: texteAvecStyle("Your calorie requirement", color: setColor()),
            contentPadding: EdgeInsets.all(15.0),
            children: <Widget>[
              padding(),
              texteAvecStyle("Your basic need is to: $calorieBase"),
              padding(),
              texteAvecStyle("Your need with sports activity is : $calorieAvecActivite"),
              new RaisedButton(onPressed: () {
                Navigator.pop(buildContext);
              },
              child: texteAvecStyle("OK", color: Colors.white),
                color: setColor(),
              )
            ],
          );
        }
    );
  }

  Future<Null> alerte() async {
    return showDialog(
        context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
          return new AlertDialog(
            title: texteAvecStyle("Error"),
            content: texteAvecStyle("All fields are not filled"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  child: texteAvecStyle("OK", color: Colors.red))
            ],
          );
      }
    );
  }
}
