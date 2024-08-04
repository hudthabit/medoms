import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'group.dart';


class edit_group extends StatefulWidget{
  const edit_group({super.key, required this.group});

  final Groupz group;

  @override
  group_editState createState() => group_editState();
}

class group_editState extends State<edit_group> {

  final _formKey  = GlobalKey<FormState>();

  //var hood = widget.group.email;

  TextEditingController gname = TextEditingController();
  TextEditingController gadmin = TextEditingController();
  TextEditingController gphone = TextEditingController();
  TextEditingController gemail = TextEditingController();

  @override
  void initState(){
    super.initState();

    gname = TextEditingController(text: widget.group.name);
    gadmin = TextEditingController(text: widget.group.admin);
    gphone = TextEditingController(text: widget.group.phone);
    gemail = TextEditingController(text: widget.group.email);
  }

  Future<String> SendData() async {
    final response = await http.post(Uri.parse('https://flutter.smartpro.co.tz/group_edit.php'),
        headers: <String, String> {'Content-Type':'application/json','Charset':'utf-8'},
        body: json.encode(<String, String>{
          "name": gname.text,
          "admin": gadmin.text,
          "phone": gphone.text,
          "email": gemail.text,
          "id": widget.group.id.toString()
        }));

    if(response.statusCode==200){
      final body = json.decode(response.body);
      if(body['status']){
        //print('Success Feedback:${body['message']}');
        final snackBar = SnackBar(
          content: const Text('Record Updated Successfully'),
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const Groups()));
            },),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        padding: const EdgeInsets.all(50),
        child:  Form(
            key: _formKey ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: gname,
                  decoration: const InputDecoration(
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
                TextFormField(
                  controller: gadmin,
                  decoration: const InputDecoration(
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
                  controller: gphone,
                  decoration: const InputDecoration(
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
                    child: const Text('Update Record'),

                  ),
                )
              ],
            )
        ),),);
  }

}