import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'group.dart';


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
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}


class activity_add extends StatefulWidget{
  final username, group,gname;
  const activity_add({super.key, this.username, this.group, this.gname});

  @override
  activity_addState createState() => activity_addState();
}

class activity_addState extends State<activity_add> {

  final _formKey  = GlobalKey<FormState>();

  TextEditingController activity = TextEditingController();
  TextEditingController budget = TextEditingController();

  Future<String> SendData() async {
    final response = await http.post(Uri.parse('https://flutter.smartpro.co.tz/activity_add.php'),
        headers: <String, String> {'Content-Type':'application/json','Charset':'utf-8'},
        body: json.encode(<String, String>{
          "name": activity.text,
          "budget": budget.text,
          "group": widget.group,
        }));

    if(response.statusCode==200){
      final body = json.decode(response.body);
      if(body['status']){
        //print('Success Feedback:${body['message']}');
        final snackBar = SnackBar(
          content: const Text('Group Added Successfully'),
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>const Groups()));
            },),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else{
        //print('Failed to save group');
      }
    }else{
      throw Exception('Failed to Send Data');
    }
    return '';
  }

  String _activity = '';
  String _budget = '';

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
        title: const Text('Add Activity'),
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
                    controller: activity,
                    decoration:  const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.group_add_outlined),
                        hintText: 'Enter Activity',
                        label: Text('Activity')
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter Activity';
                      }else{
                        return null;
                      }
                    },
                    onSaved: (value){
                      _activity = value!;
                    },
                  ),
                ),

                TextFormField(
                  controller: budget,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.person),
                      hintText: 'Enter Budget',
                      label: Text('Budget')
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Budget';
                    }else{
                      return null;
                    }
                  },
                  onSaved: (value){
                    _budget = value!;
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