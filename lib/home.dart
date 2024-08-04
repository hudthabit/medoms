import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'activities.dart';
import 'add_member.dart';
import 'members.dart';

class UserData{
  final String name;
  final int group;

  UserData({required this.name, required this.group});
}

class Dashboards{
  int members,activities;

  Dashboards({required this.members, required this.activities});
}


class Home extends StatefulWidget{
  final username, group,gname,user_id,phone;
  const Home({super.key, this.username, this.group, this.gname, this.user_id, required this.phone});

  @override
  _HomeState createState()=>_HomeState();
}

class _HomeState extends State<Home>{
  late List<Dashboards> dashbordz;

  Future<List<Dashboards>> getDashboard() async {
    final response = await http.post(Uri.parse("https://flutter.smartpro.co.tz/dashboard.php?gr_id=${Uri.encodeComponent(widget.group)}"));
    // print(response.body);
    final responseData = json.decode(response.body);

    //print(responseData);

    dashbordz = [];

    for(var ds in responseData){
      //print('Group: $gm');
      Dashboards dash  = Dashboards(
        members:     ds['members'],
        activities:    ds['activities'],
      );
      dashbordz.add(dash);
    }
    return dashbordz;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gname,style: const TextStyle(fontWeight: FontWeight.w800,color: Colors.white),),
        backgroundColor: Colors.blue,
        elevation: 0.5,
        toolbarHeight: 80.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)
          )
        ),
        //leading: const Icon(Icons.menu,size: 30,),
        actions: <Widget>[
          IconButton(
              onPressed: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body:Container(
          padding: const EdgeInsets.all(5),
          child:  FutureBuilder(future: getDashboard(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) return const Center( child:CircularProgressIndicator() ,);
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    var data = snapshot.data[index];
                    return Column(
                      children: [
                         Container(
                           alignment: Alignment.topLeft,
                           height: 40,
                          padding: EdgeInsets.all(10),
                          child: const Text('Dashboard',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800,color: Colors.blue),),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //Right Button
                            GestureDetector(
                              onTap: (){
                                print(widget.username);
                              },
                              child:Card(
                                elevation: 8,
                                child:  Container(
                                width: 200,
                                height: 100,
                                padding: const EdgeInsets.all(16),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    //border: Border.all(color: Colors.black,width: 1),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.groups),
                                    Text(data.members.toString()),
                                    const Text('Members')
                                  ],
                                ),
                              ),)
                            ),

                            //Left Button
                           GestureDetector(
                                child: Card(
                                  elevation: 8,
                                    child:   Container(
                                      //color: Colors.red,
                                      width: 200,
                                      height: 100,
                                      padding: const EdgeInsets.all(16),
                                      alignment: Alignment.center,
                                      //decoration: BoxDecoration(
                                       // border: Border.all(color: Colors.black,width: 1),
                                        //borderRadius: BorderRadius.circular(15)
                                      //),
                                      child: Column(
                                        children: [
                                          const Icon(Icons.business_center_rounded),
                                          Text(data.activities.toString()),
                                          const Text('Activities'),
                                        ],
                                      ),
                                  ),
                                )
                           )
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        //Second Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //Right Button
                            GestureDetector(
                                onTap: (){
                                  print(widget.username);
                                },
                                child:Card(
                                  elevation: 8,
                                  child:  Container(
                                    width: 200,
                                    height: 100,
                                    padding: const EdgeInsets.all(16),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      //border: Border.all(color: Colors.black,width: 1),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.groups),
                                        Text(data.members.toString()),
                                        const Text('Members')
                                      ],
                                    ),
                                  ),)
                            ),

                            //Left Button
                            GestureDetector(
                                child: Card(
                                  elevation: 8,
                                  child:   Container(
                                    //color: Colors.red,
                                    width: 200,
                                    height: 100,
                                    padding: const EdgeInsets.all(16),
                                    alignment: Alignment.center,
                                    //decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.black,width: 1),
                                    //borderRadius: BorderRadius.circular(15)
                                    //),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.business_center_rounded),
                                        Text(data.activities.toString()),
                                        const Text('Activities'),
                                      ],
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                        //Third Row Header
                        Container(
                          alignment: Alignment.topLeft,
                          height: 40,
                          padding: const EdgeInsets.all(10),
                          child: const Text('Financial Summary',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800,color: Colors.blue),),
                        ),
                        //Third Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //Right Button
                            GestureDetector(
                                onTap: (){
                                  print(widget.username);
                                },
                                child:Card(
                                  elevation: 8,
                                  child:  Container(
                                    width: 200,
                                    height: 100,
                                    padding: const EdgeInsets.all(16),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      //border: Border.all(color: Colors.black,width: 1),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.groups),
                                        Text(data.members.toString()),
                                        const Text('Hisa')
                                      ],
                                    ),
                                  ),)
                            ),

                            //Left Button
                            GestureDetector(
                                child: Card(
                                  elevation: 8,
                                  child:   Container(
                                    //color: Colors.red,
                                    width: 200,
                                    height: 100,
                                    padding: const EdgeInsets.all(16),
                                    alignment: Alignment.center,
                                    //decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.black,width: 1),
                                    //borderRadius: BorderRadius.circular(15)
                                    //),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.business_center_rounded),
                                        Text(data.activities.toString()),
                                        const Text('Savings'),
                                      ],
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                      ],
                    );

                  });

            },

        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: Colors.blueAccent,
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>const add_member()));
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top,bottom: 24),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 52,
                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNtaWx5JTIwZmFjZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'),
                        ),
                        const SizedBox(height: 12,),
                        Text(widget.gname,style: const TextStyle(fontSize: 28,color: Colors.white),),
                        const Text('info@smartpro.co.tz',style: TextStyle(fontSize: 14,color: Colors.white),)
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.groups),
                    title: const Text('Members'),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>Members(username: widget.username,gname: widget.gname,group: widget.group,)));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: const Text('Activities'),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=> activities(group: widget.group,gname: widget.gname,username: widget.username,user_id: widget.user_id,phone:widget.phone)));
                    },
                  ),
                  const Divider(color: Colors.black45,),
                  ListTile(
                    leading: const Icon(Icons.money),
                    title: const Text('Payments'),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>const Members()));
                    },
                  )
                ],
              )
            ],
          ),

        )
      ),
    );
  }
}