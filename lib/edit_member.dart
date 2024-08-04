import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:decorated_dropdownbutton/decorated_dropdownbutton.dart';
import 'package:medoms/members.dart';

import 'main.dart';


class CityOne{
  String  name, admin;
  int id;

  CityOne({required this.id, required this.name, required this.admin});

  factory CityOne.fromJSON(Map<String, dynamic> json){
    return CityOne(
      id: json["id"],
      name: json["name"],
      admin: json["admin"],
    );
  }
}

class PostsModel {
  //int? userId;
  int? id;
  String? name;
  String? phone;
  String? email;

  PostsModel({this.id, this.name, this.phone, this.email});

  PostsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['userId'] = this.userId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }
}

class edit_member extends StatefulWidget{
  const edit_member({super.key,  required this.member});

  final Memberz member;

  @override
  edit_memberState  createState() => edit_memberState();

}

class edit_memberState extends State<edit_member> {
  final _formKey  = GlobalKey<FormState>();

  var newData ;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();

  @override
  void initState(){
    super.initState();

    name     = TextEditingController(text: widget.member.name);
    mobile   = TextEditingController(text: widget.member.phone);
    email    = TextEditingController(text: widget.member.email);
    newData  = widget.member.group;
  }

  Future<List<PostsModel>> getPostApi ()async{
    try {
      final response = await http.get(Uri.parse('https://flutter.smartpro.co.tz/groups.php')) ;
      final body = json.decode(response.body) as List;

      if(response.statusCode == 200) {

        return  body.map((dynamic json) {
          final map = json as Map<String, dynamic>;
          return  PostsModel(
            id: map['id'] as int,
            name: map['name'] as String,
            phone: map['phone'] as String,
          );
        }).toList();
      }
    } on SocketException {
        await Future.delayed(const Duration(milliseconds: 1800));
        throw Exception('No Internet Connection');
    } on TimeoutException {
        throw Exception('');
    }
      throw Exception('error fetching data');
  }

  Future<String> SendData() async {
      final response = await http.post(Uri.parse('https://flutter.smartpro.co.tz/member_edit.php'),
          headers: <String, String> {'Content-Type':'application/json','Charset':'utf-8'},
          body: json.encode(<String, String>{
            "name"   : name.text,
            "mobile" : mobile.text,
            "email"  : email.text,
            "group"  : newData,
            "id"     : widget.member.id.toString()
          }));

      if(response.statusCode==200){
        final body = json.decode(response.body);
        if(body['status']){
          final snackBar = SnackBar(
            content: Text('Success Feedback:${body['message']}'),
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Members()));
              },),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }else{
          //print('Failed Feedback:${body['error']}');
        }
      }else{
        throw Exception('Failed to Send Data');
      }
      return '';
  }

  String _name   = '';
  String _mobile = '';
  String _email  = '';

  void _submitForm(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      SendData();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const Members()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Member'),
        ),body:Container(

        padding: const EdgeInsets.all(10),
        child:Form(
          key: _formKey ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: name,
                    decoration: const InputDecoration(
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
                      _name = value!;
                    },
                  )
              ),

              Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child:TextFormField(
                    controller: mobile,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Phone',
                        icon: Icon((Icons.phone))
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter phone #';
                      }else{
                        return null;
                      }
                    },
                    onSaved: (value){
                      _mobile = value!;
                    },
                  )),

              Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child:TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Email',
                        icon: Icon(Icons.email)
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Email';
                      }else{
                        return null;
                      }
                    },
                    onSaved: (value){
                      _email = value!;
                    },
                  )),


              Container(
                padding: const EdgeInsets.only(bottom: 5,top: 5,left: 10,right: 10),
                margin: const EdgeInsets.only(left: 40),
                decoration:  BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(5),

                ),

                child: FutureBuilder(
                    future: getPostApi(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        return DropdownButtonFormField(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent)
                                )
                            ),

                            value: newData,
                            hint: const Text('---Select Group---'),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: snapshot.data!.map((item){
                              return DropdownMenuItem(
                                  value: item.id.toString(),
                                  child: Text(item.name.toString()));
                            }).toList(),
                            onChanged: (value){
                              newData = value ;
                              //print(newData = value);
                              setState(() {

                              });
                            }
                        );
                      }else{
                        return const Center(child:CircularProgressIndicator() ,) ;
                      }
                    }
                ),
              ),

              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10 ,0 ,10 ,0),
                margin: const EdgeInsets.only(top: 10,left: 40),
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: (){
                    _submitForm();
                  },child: const Text('Add User'),
                ),
              ),
            ],),
        )
    )
    );
  }
}