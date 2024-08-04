import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class Users{
  final int id;
  final String name;
  final String mobile;
  final String email;

  Users({required this.name, required this.mobile, required this.email, required this.id});
}

class Details extends StatefulWidget{
  const Details({super.key, required this.user});

  final Users user;

  @override
  _DetailsState  createState()=> _DetailsState();
}

class _DetailsState extends State<Details>{

  Future<void> DeleteData() async{
    final response = await http.post(Uri.parse("https://flutter.smartpro.co.tz/delete_user.php"),
        headers: <String,String> {'Content-Type': 'application/json', 'Charset': 'utf-8'},
        body: json.encode(<String,String>{
          "id": widget.user.id.toString(),
        }));

    if(response.statusCode==200){
      //print("Succes");
      showDialog(context: context,
        builder: (context)=> AlertDialog(
          title:  Text(widget.user.name),
          content: const Text("Deleted successfully"),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            },
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(14),
                child: const Text('Ok'),
              ),
            ),
          ],
        ),
      );
    }else{
      print("Some issue");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Details'),
      ),
      body: Container(
        height: 270,
        padding: const EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.user.name,style: const TextStyle(fontSize: 20),),
            Text(widget.user.mobile,style: const TextStyle(fontSize: 20),),
            Text(widget.user.email,style: const TextStyle(fontSize: 20),),
            Text(widget.user.id.toString(),style: const TextStyle(fontSize: 20),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DeleteData();
        },
        child: const Icon(Icons.delete),

      ),

    );
  }
}