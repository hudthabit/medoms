import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:decorated_dropdownbutton/decorated_dropdownbutton.dart';
import 'package:medoms/members.dart';

import 'main.dart';

class add_member extends StatefulWidget{
  final group,gname;
  const add_member({super.key, this.group, this.gname});

  @override
  add_memberstate  createState() => add_memberstate();

}

class add_memberstate extends State<add_member> {
  final _formKey  = GlobalKey<FormState>();



  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController username = TextEditingController();

  Future<String> SendData() async {
    final response = await http.post(Uri.parse('https://flutter.smartpro.co.tz/member_add.php'),
    headers: <String, String> {'Content-Type':'application/json','Charset':'utf-8'},
        body: json.encode(<String, String>{
          "name"      : name.text,
          "mobile"    : mobile.text,
          "email"     : email.text,
          "group"     : widget.group,
          "gname"     : widget.gname,
          "username"  : username.text
        }));

   print(response.body);

    if(response.statusCode==200){
      final body = json.decode(response.body);
      if(body['status']){
        //print('Success Feedback:${body['message']}');
        final snackBar = SnackBar(
            content: Text('Success Feedback:${body['message']}'),
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Members(gname:widget.gname ,group: widget.group,)));
            },),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else{
        print('Failed Feedback:${body['error']}');
      }
    }else{
      throw Exception('Failed to Send Data');
    }
    return '';
  }
  var newData ;

  String _name   = '';
  String _mobile = '';
  String _email  = '';
  String _username  = '';

  void _submitForm(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      //print(newData);
      SendData();
     Navigator.pop(context, MaterialPageRoute(builder: (context)=> Members(gname:widget.gname ,group: widget.group,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.gname),
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
                      return 'Enter Group Name';
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
                const SizedBox(height: 10,),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child:TextFormField(
                      controller: username,
                      maxLength: 9,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Your username',
                          icon: Icon(Icons.supervised_user_circle)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Username';
                        }else{
                          return null;
                        }
                      },
                      onSaved: (value){
                        _username = value!;
                      },
                    )),

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
