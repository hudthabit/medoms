import 'dart:convert';

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:medoms/register.dart';

import 'group_add.dart';
import 'home.dart';
import 'main.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState()=> _LoginState(); 
}

class _LoginState extends State<Login>{
  final _formKyey = GlobalKey<FormState>();

  TextEditingController emailController    = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String loginurl = "https://flutter.smartpro.co.tz/login.php";

  String msgError = "";
  String name = "";

  getApi(String username, String password) async{
      final res = await http.post(Uri.parse("$loginurl?username=${Uri.encodeComponent(username)}&password=${Uri.encodeComponent(password)}"));
      final data = jsonDecode(res.body.toString());
      //print(data);
      String name; String gr_id,gname;String UID;String phone;
      if (data[0]['level'] == "admin") {
        name = data[0]['username'];gr_id = data[0]['gr_id'];gname = data[0]['gname'];UID=data[0]['id'].toString();
        Navigator.of(context).push(MaterialPageRoute(builder: (c) => HomeScreen(username: name, group: gr_id, user_id: UID,)));
        emailController.clear();
        passwordController.clear();
        setState(() {
          msgError = "User not found";
        });
      } else if (data[0]['level'] == "user") {
        name = data[0]['username'];gr_id = data[0]['gr_id'];gname = data[0]['gname'];UID=data[0]['id'].toString();phone=data[0]['phone'];
        Navigator.of(context).push(MaterialPageRoute(builder: (c) => Home(username: name,group:gr_id,gname:gname,user_id: UID,phone:phone)));
        emailController.clear();
        passwordController.clear();
        setState(() {
          msgError = "User not found";
        });
      } else {
        setState(() {
          msgError = "Username not found";
        });
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: <Widget>[
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>group_add()));
          },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Form(
        key: _formKyey,
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Email'),
                    ),
                  validator: (value){
                    if(value== null || value.isEmpty){
                        return 'Please enter your email';
                    }
                    return null;
                  },
                  ),
                ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Password')
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if(_formKyey.currentState!.validate()){
                        //getUser();
                        //print(passwordController.text);
                        getApi(emailController.text, passwordController.text);
                        //print(name);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill inputs')));
                      }
                    },
                    child: const Text('Submit'),

                  ),),
              ),
              SizedBox(
                height: 15.0,
                child: Center(
                  child: Text(msgError, style: const TextStyle(color: Colors.red),),
                )
              )
            ],
          ),

        ),
        
      ),
    );
  }
  
}

