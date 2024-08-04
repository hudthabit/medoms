import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'edit_group.dart';
import 'group_add.dart';

class Groupz{
  final  	int id;
  final String name ;
  final String admin;
  final String 	phone ;
  final String email;
  final String	reg_date;
  final String ex_date;
  final String 	gname;

  Groupz({required this.name, required this.admin,required this.phone,required this.email,required this.reg_date,required this.ex_date,required this.gname,required this.id});
}

class Groups extends StatefulWidget{
  const Groups({super.key});


  @override
  GroupState createState() => GroupState();
}

class GroupState extends State<Groups>{


late List<Groupz> groups;

  Future<List<Groupz>> getGroups() async {
    final response = await http.post(Uri.parse('https://flutter.smartpro.co.tz/groups.php'));
    //print(response.body);
    final responseData = json.decode(response.body);

    //print(responseData);

    groups = [];

    for(var gm in responseData){
      //print('Group: $gm');
      Groupz group  = Groupz(
          name:     gm['name'],
          admin:    gm['admin'],
          phone:    gm['phone'],
          email:    gm['email'],
          reg_date: gm['reg_date'],
          ex_date:  gm['ex_date'],
          gname:    gm['gname'],
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
        title: const Text('Groups'),
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
                                    child: Text(data.admin)
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>  edit_group(group: data,)));
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=>group_add()));
        },

      ),
    );
  }

}