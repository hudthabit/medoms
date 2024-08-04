import 'dart:convert';

import 'package:flutter/material.dart';

import 'activity_add.dart';
import 'group.dart';
import 'members.dart';
import 'package:http/http.dart' as http;

class test extends StatelessWidget{
  const test({super.key});

  @override
  Widget build(BuildContext context) {
    return   Center(
      child: Stack(
        alignment: Alignment.center,
        textDirection: TextDirection.rtl,
        fit: StackFit.loose,
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            height: 300,
            width: 400,
            color: Colors.green,
            child:  Center(
              child:  TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const Groups()));
                  },
                  child: const Text('Groups..11')),
              // Text('Top Widget: Green', style: TextStyle(fontSize: 20),),
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: Container(
              height: 100,
              width: 150,
              color: Colors.blue,
              child:  Center(
                child: TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const Members()));
                    },
                    child: const Text('Members')),//  Text('Midle Widget: Blue',style: TextStyle(fontSize: 20,color: Colors.white),),
              ),
            ),
          ),

          Positioned(
            top: 30,
            left: 20,
            child: Container(
              height: 100,
              width: 150,
              color: Colors.orange,
              child:  Center(
                child: TextButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const activity_add()));
                }, child: const Text('Activity'),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class test2 extends StatelessWidget{
  const test2({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          color: Colors.blue,
          height: 100,
          alignment: Alignment.center,
          child:  const Text('Failed'),
        ),
        Divider(
          thickness: 2.0,
          color: Colors.blue[500],
        ),
        const Text('Under Devider'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Container(
              height: 200,
              color: Colors.green,
              alignment: Alignment.center,
              child: const Text('Left Section'),
            )),

            Expanded(
              child: Container(
                height: 200,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const VerticalDivider(
                  thickness: 2, color: Colors.white,
                ),
              ),
            ),
            Expanded(child: Container(
              height: 200,
              color: Colors.yellow,
              alignment: Alignment.center,
              child: const Text('Rigth Section'),
            )),

          ],
        ),
        const Divider(
          height: 20,
          thickness: 2,
          color: Colors.black,
        ),
        Container(
          height: 100,
          alignment: Alignment.center,
          color: Colors.orange,
          child: const Text('Educative Answer - Section B'),
        )
      ],
    );
  }
}

class gComunity extends StatefulWidget{
  const gComunity({super.key});


  @override
  GroupState createState() => GroupState();
}

class GroupState extends State<gComunity>{

  Future<void>activateGroup(int id,String name,String phone, admin) async{
    final response = await http.post(Uri.parse("https://flutter.smartpro.co.tz/group_activate.php"),
        headers: <String,String> {'Content-Type': 'application/json', 'Charset': 'utf-8'},
        body: json.encode(<String,String>{
          "id"   : id.toString(),
          "name" : name,
          "phone": phone,
          "admin": admin,
        }));

    if(response.statusCode==200){
      //Navigator.pop(context, MaterialPageRoute(builder: (context)=>const gComunity()));
    }else{
      print("Some issue");
    }
  }

  late List<Groupz> groups;

  Future<List<Groupz>> getGroups() async {
    final myres = await http.post(Uri.parse('https://flutter.smartpro.co.tz/groups.php'));
    final myData = json.decode(myres.body);

    groups = [];

    for(var gm in myData){
      //print('singleUser: $gm');
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

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child:  FutureBuilder(
            future: getGroups(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData) return const CircularProgressIndicator();// CircularProgressIndicator();
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
                          subtitle:Container(
                              alignment: Alignment.topLeft,
                              //color: Colors.blue,
                              child:  Column(
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
                              )) ,
                          trailing: Container(
                            width: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: IconButton(
                                      onPressed: () {  }, icon: const Icon(Icons.view_list,size: 30,),
                                    )
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(child: IconButton(
                                  onPressed: () {
                                    activateGroup(data.id,data.name,data.phone,data.admin);
                                  }, icon: const Icon(Icons.recommend,size: 30,color: Colors.blue,),
                                )),
                              ],
                            ),
                          ),
                        ),

                      ),
                    );
                  });
            }));
  }
}


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