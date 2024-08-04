import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'add_member.dart';
import 'edit_group.dart';
import 'edit_member.dart';
import 'group_add.dart';

class Memberz{
  final  	int id;
  final String name ;
  final String 	phone ;
  final String email;
  final String	rdate;
  final String group;
  final String 	status;

  Memberz({required this.name, required this.group,required this.phone,required this.email,required this.rdate,required this.status,required this.id});
}

class Members extends StatefulWidget{
  final username, group,gname;
  const Members({super.key, this.username, this.group, this.gname});


  @override
  _MemberState createState() => _MemberState();
}

class _MemberState extends State<Members>{


  late List<Memberz> groups;

  Future<List<Memberz>> getGroups() async {
    final response = await http.post(Uri.parse("https://flutter.smartpro.co.tz/members.php?gr_id=${Uri.encodeComponent(widget.group)}"));
    //print(response.body);
    final responseData = json.decode(response.body);

    //print(responseData);

    groups = [];

    for(var gm in responseData){
      //print('Group: $gm');
      Memberz group  = Memberz(
        name:     gm['name'],
        group:    gm['group'],
        phone:    gm['phone'],
        email:    gm['email'],
        rdate:    gm['rdate'],
        status:    gm['status'],
        id:       gm['id'],
      );
      groups.add(group);
    }
    return groups;
  }

  Future<void> DeleteData(int id,String name) async{
    final response = await http.post(Uri.parse("https://flutter.smartpro.co.tz/group_delete.php"),
        headers: <String,String> {'Content-Type': 'application/json', 'Charset': 'utf-8'},
        body: json.encode(<String,String>{
          "id": id.toString(),
        }));

    if(response.statusCode==200){
      //print("Succes");
      showDialog(context: context,
        builder: (context)=> AlertDialog(
          title:  Text(name),
          content: const Text("Deleted successfully"),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>const Groups()));
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
        title:  Text(widget.gname,style: const TextStyle(fontSize: 20,color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
              future: getGroups(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(!snapshot.hasData) return const Center( child:CircularProgressIndicator() ,);
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      var data = snapshot.data[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: const Icon(Icons.group),
                            title: Text(data.name,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.orangeAccent),),
                            subtitle: Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  textDirection: TextDirection.ltr,
                                  children: [
                                    Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(data.name)
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(data.phone),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(data.email),
                                    ),
                                  ],
                                )
                            ) ,
                            trailing: SizedBox(
                              width: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: IconButton(
                                        onPressed: () {  }, icon: const Icon(Icons.view_list),
                                      )
                                  ),
                                  Expanded(child: IconButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  edit_member(member: data,)));
                                    }, icon: const Icon(Icons.edit),
                                  )),
                                  Expanded(child: IconButton(
                                    onPressed: () {
                                      DeleteData(data.id,data.name);
                                    }, icon: const Icon(Icons.delete),
                                  )
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ),
                      );
                    }
                );
              }
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> add_member(group: widget.group,gname: widget.gname,)));
        },

        child: const Icon(Icons.add),

      ),
    );
  }

}