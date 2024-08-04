import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'group.dart';
import 'login.dart';


class PostsModel {
  int? userId;
  int? id;
  String? title;
  String? body;

  PostsModel({this.userId, this.id, this.title, this.body});

  PostsModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}


class group_add extends StatefulWidget{
  @override
  group_addState createState() => group_addState();
}

class group_addState extends State<group_add> {

  final _formKey  = GlobalKey<FormState>();

  TextEditingController gname = TextEditingController();
  TextEditingController gadmin = TextEditingController();
  TextEditingController gphone = TextEditingController();
  TextEditingController gemail = TextEditingController();

  Future<String> SendData() async {
    final response = await http.post(Uri.parse('https://flutter.smartpro.co.tz/group_add.php'),
        headers: <String, String> {'Content-Type':'application/json','Charset':'utf-8'},
        body: json.encode(<String, String>{
          "name": gname.text,
          "admin": gadmin.text,
          "phone": gphone.text,
          "email": gemail.text
        }));

    if(response.statusCode==200){
      final body = json.decode(response.body);
      if(body['status']){
        Navigator.pop(context, MaterialPageRoute(builder: (context)=>Login()));
      }else{
        //print('Failed to save group');
        final snackBar = SnackBar(
          content: const Text('Failed to save group'),
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {  },),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }else{
      throw Exception('Failed to Send Data');
    }
    return '';
  }

  String _gname = '';
  String _gadmin = '';
  String _gphone = '';
  String _gemail = '';

  void _submitForm(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      SendData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Group'),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child:  Form(
          key: _formKey ,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child:TextFormField(
                  maxLength: 11,
                  controller: gname,
                  decoration:  const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.group_add_outlined),
                      hintText: 'Enter Group Name',
                      label: Text('Name')
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Group Name';
                    }else{
                      return null;
                    }
                  },
                  onSaved: (value){
                    _gname = value!;
                  },
                ),
              ),

              TextFormField(
                controller: gadmin,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                  hintText: 'Enter Admin Name',
                  label: Text('Admin')
                ),
                validator: (value){
                    if(value!.isEmpty){
                      return 'Enter group admin';
                    }else{
                      return null;
                    }
                },
                onSaved: (value){
                    _gadmin = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: gphone,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.phone),
                  hintText: 'Enter Phone',
                  label: Text('Phone')
                  ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Enter phone numbe';
                  }else{
                    return null;
                  }
                },
                onSaved: (value){
                  _gphone = value!;
                },
              ),
              TextFormField(
                controller: gemail,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.email),
                    hintText: 'Enter Email',
                    label: Text('Email')
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Enter Email';
                  }else{
                    return null;
                  }
                },
                onSaved: (value){
                  _gemail = value!;
                },
              ),

              Container(
                padding: const EdgeInsets.only(left: 150,top: 40),
                child: TextButton(
                onPressed: () {
                  _submitForm();
                },
                 child: const Text('Save Record'),
      
              ),
            ),
          ],
        )
          ),),);
  }

}