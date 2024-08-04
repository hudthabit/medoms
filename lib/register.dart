import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class RegisterPage extends StatefulWidget{
  @override
  _RegisterPageState createState()=>_RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{

  static const items = <String>["admin","user"];
  final List<DropdownMenuItem<String>> _myitems = items
      .map((e)=>DropdownMenuItem(
        value: e,
          child: Text(e),
  )).toList();

  String valueItem = "admin";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10.0),
                decoration:  BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.amber,Colors.pink]),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Username',
                    hintText: 'Username'
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration:  BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.amber,Colors.pink]),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Password',
                    hintText: 'Password'
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Material(
                borderRadius: BorderRadius.circular(20.0),
                elevation: 10.0,
                color: Colors.pink,
                child: MaterialButton(
                  onPressed: () {
                   // insertApi();
                  },
                  color: Colors.pink,
                  child: const Text("REGISTER"),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  
}