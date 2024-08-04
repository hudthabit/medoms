import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medoms/members.dart';
import 'package:medoms/trial_one.dart';

import 'activity_add.dart';
//import 'add_member.dart';
//import 'dropdown.dart';
//import 'edit_member.dart';
//import 'group.dart';
import 'group_add.dart';
import 'login.dart';
//import 'm_details.dart';


class UserData{
  final String name;
  final int group;

  UserData({required this.name, required this.group});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeDOMS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home:  const MyHomePage(title: 'MeDOMS'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;


  @override
  SplashScreenState  createState() => SplashScreenState ();
}

class SplashScreenState extends State<MyHomePage>{

  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 5),
            //()=> Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> const HomeScreen()))
              ()=> Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>  Login()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return   Container(
      color: Colors.white,
      child:  const CircleAvatar(
        backgroundColor: Colors.black,
        radius: 120,
        child: CircleAvatar(
          radius: 215,
          backgroundImage: AssetImage('assets/Logo.jpg',),),
       )
    );
  }
}

class HomeScreen extends StatefulWidget{
  final String username,group,user_id;
  const HomeScreen({super.key, required this.username, required this.group, required this.user_id});

  @override
  _HomeScreenState createState()=> _HomeScreenState();
}

class _HomeScreenState  extends State<HomeScreen>{
   int _selectedIndex = 0;
  static  final List<Widget> _widgetOptions = <Widget>[
    const test(),
    const gComunity(),
    const gComunity(),
  ];

  void _onItemTapped(index){
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:  Image.asset('assets/logo.png',),//const Text('MeDOMS'),
        centerTitle: true,
        toolbarHeight: 75.2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>group_add()));
          },
            icon: const Icon(Icons.group),
          ),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const gComunity()));
          },
            icon: const Icon(Icons.settings),
          ),
        ],
        leading: IconButton(
          onPressed: () {  },
          icon: const Icon(Icons.menu),
        ),leadingWidth: 40,
      ),
      body:  Center(
        child: _widgetOptions.elementAt(_selectedIndex)//Text(widget.username),//
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem> [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.lightBlue
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Activities',
              backgroundColor: Colors.lightBlue
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.money),
              label: 'Donation',
              backgroundColor: Colors.lightBlue
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,

      ),
    );
  }
}





