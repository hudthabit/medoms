import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'activity_add.dart';
import 'add_member.dart';
import 'edit_group.dart';
import 'edit_member.dart';
import 'group_add.dart';

class Activities{
  final  	int id;
  final String name ;
  final String 	budget ;
  final String gname;
  final String	group;
  final pledges;
  final payments;

  Activities({required this.name, required this.group,required this.id,required this.budget, required this.gname,required this.pledges,required this.payments,});
}

class Pledges{
  final  	int id;
  final String amount,control_no;
  Pledges({required this.id, required this.control_no, required this.amount});
}

class activities extends StatefulWidget{
  final username, group,gname,user_id,phone;
  const activities({super.key, this.username, this.group, this.gname, this.user_id,this.phone});


  @override
  _activitiesState createState() => _activitiesState();
}

class _activitiesState extends State<activities>{
  late List<Activities> activitiez;
  late List<Pledges> pledges;

  Future<List<Activities>> getGroups() async {
    final response = await http.post(Uri.parse("https://flutter.smartpro.co.tz/activities.php?gr_id=${Uri.encodeComponent(widget.group)}"));
   // print(response.body);
    final responseData = json.decode(response.body);

    print(responseData);

    activitiez = [];

    for(var gm in responseData){
      //print('Group: $gm');
      Activities group  = Activities(
        name:     gm['name'],
        group:    gm['group'],
        id:       gm['id'],
        budget:   gm['budget'],
        gname: '',
        pledges: gm['pledges'],
        payments: gm['payments'],
      );
      activitiez.add(group);
    }
    return activitiez;
  }

  String purl = "https://flutter.smartpro.co.tz/get_pamount.php";



  final _formKey  = GlobalKey<FormState>();
  String _activity = '';
  TextEditingController plamount = TextEditingController();
  TextEditingController pyamount = TextEditingController();

  void _submitForm(id){

    print(id);
    //if(_formKey.currentState!.validate()){
      //_formKey.currentState!.save();
      print('hood');
      SendData(id);

      setState(() {
        getGroups();
      });
    //}
  }

  Future<String> SendData(id) async {
    final response = await http.post(Uri.parse('https://flutter.smartpro.co.tz/pledges.php'),
        headers: <String, String> {'Content-Type':'application/json','Charset':'utf-8'},
        body: json.encode(<String, String>{
          "activity": id.toString(),
          "group"   : widget.group,
          "member"  : widget.user_id,
          "amount"  : plamount.text,
          "phone"   : widget.phone,
        }));

    print(response.body);

    if(response.statusCode==200){
      final body = json.decode(response.body);
      if(body['status']){
        //print('Success Feedback:${body['message']}');
        final snackBar = SnackBar(
          content: const Text('Pledge added successfully'),
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
             // Navigator.pop(context);
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

  Future<String> SendPayment(id) async {
    final response = await http.post(Uri.parse('https://flutter.smartpro.co.tz/pledge_payment.php'),
        headers: <String, String> {'Content-Type':'application/json','Charset':'utf-8'},
        body: json.encode(<String, String>{
          "activity": id.toString(),
          "group"   : widget.group,
          "member"  : widget.user_id,
          "amount"  : pyamount.text,
          "phone"   : widget.phone,
        }));

    print(response.body);

    if(response.statusCode==200){
      final body = json.decode(response.body);
      if(body['status']){
        //print('Success Feedback:${body['message']}');
        final snackBar = SnackBar(
          content: const Text('Pledge added successfully'),
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              Navigator.pop(context);
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

  String dropdownvalue = 'CASH';
  var items = ["TIGO-PESA","M-PESA","Airtel Monay","Halopesa","AzamPes","CASH"];

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
                            //leading: const Icon(Icons.group),
                            title: Text(data.name,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.orangeAccent),),
                            subtitle: Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  textDirection: TextDirection.ltr,
                                  children: [
                                    Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(data.name),

                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(data.budget),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Text(data.gname),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(onPressed: (){
                                                //print('hood');
                                                showBottomSheet(
                                                    context: context,
                                                    builder: (context)=>Container(
                                                      color: Colors.pink,
                                                      height: 200,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            const Text('This is Bottom Sheet',style: TextStyle(fontSize: 20),),
                                                            TextFormField(
                                                              controller: plamount,
                                                              decoration: const InputDecoration(
                                                                hintText: 'Enter Amount',
                                                              ),
                                                              keyboardType: TextInputType.number,
                                                              validator: (value){
                                                                if(value!.isEmpty){
                                                                  return 'Amount';
                                                                }else{
                                                                  return null;
                                                                }
                                                              },
                                                              onSaved: (value){
                                                                _activity = value!;
                                                              },
                                                            ),
                                                            Row(
                                                              children: [
                                                                ElevatedButton(
                                                                    onPressed: (){
                                                                      //print('hoo');
                                                                      var id = data.id;
                                                                      //print(id);
                                                                      _submitForm(id);
                                                                      plamount.clear();
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: const Text('Save')),
                                                                ElevatedButton(
                                                                    onPressed: (){
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: const Text('Cancel'))
                                                              ],
                                                            ),
                                                          ],

                                                        ),
                                                      ),
                                                    )
                                                );
                                              },
                                                  child: const Text('Pledge')
                                              ),
                                              TextButton(onPressed: (){
                                                showBottomSheet(
                                                    context: context,
                                                    builder: (context)=>Container(
                                                     // padding: const EdgeInsets.all(0),
                                                      color: Colors.blueAccent,
                                                      height: 300,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            const Text('Payment Model',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w800 ),),
                                                            const SizedBox(height: 10,),
                                                            TextFormField(
                                                              controller: pyamount,
                                                              decoration: const InputDecoration(
                                                                hintText: 'Enter Amount',
                                                              ),
                                                              keyboardType: TextInputType.number,
                                                              validator: (value){
                                                                if(value!.isEmpty){
                                                                  return 'Amount';
                                                                }else{
                                                                  return null;
                                                                }
                                                              },
                                                              onSaved: (value){
                                                                _activity = value!;
                                                              },
                                                            ),
                                                            DropdownButton(

                                                              value: dropdownvalue,
                                                                icon: const Icon(Icons.keyboard_arrow_down),
                                                                items: items.map((String items){
                                                                  return DropdownMenuItem(
                                                                    value: items,
                                                                      child: Text(items),
                                                                  );
                                                                }).toList(),
                                                                onChanged: (String ? newValue){
                                                                setState(() {
                                                                  dropdownvalue = newValue!;
                                                                });
                                                                }
                                                            ),
                                                            const SizedBox(height: 20,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                ElevatedButton(
                                                                    onPressed: (){
                                                                      var id = data.id;
                                                                      SendPayment(id);
                                                                      pyamount.clear();
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: const Text('Save Payment')),
                                                                ElevatedButton(
                                                                    onPressed: (){
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: const Text('Cancel'))
                                                              ],
                                                            ),
                                                          ],

                                                        ),
                                                      ),
                                                    )
                                                );
                                              },
                                                  child: const Text('Payment')
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ),
                                  ],
                                )
                            ) ,
                            trailing: SizedBox(
                              width: 70,
                              child: Column(children: [
                                Row(
                                  children: [
                                    Expanded(child: Text(data.pledges.toString(),style: const TextStyle(fontWeight: FontWeight.w800,color: Colors.red),),),
                                    Expanded(child: Text(data.payments.toString(),style: const TextStyle(fontWeight: FontWeight.w800,color: Colors.green),),)
                                  ],
                                ),
                               Expanded(
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
                                         // DeleteData(data.id,data.name);
                                        }, icon: const Icon(Icons.delete),
                                      )
                                      ),
                                     ],
                                   ),
                              ),]
                            )),
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=> activity_add(group: widget.group,gname: widget.gname,)));
        },

        child: const Icon(Icons.add),

      ),
    );
  }

}
