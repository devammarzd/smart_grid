import 'package:flutter/material.dart';
import 'package:smart_grid/CustomWidgets/CustomScaffold.dart';
import 'package:smart_grid/Global.dart';
import 'package:smart_grid/Screens/Appliances.dart';

class Home extends StatefulWidget {
  final int noOfRooms;
  Home({this.noOfRooms, Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int noOfRooms;
  int noOfRoomsAdd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.noOfRooms != null) {
      setState(() {
        noOfRooms = widget.noOfRooms;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      index: 0,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: noOfRooms,
          itemBuilder: (BuildContext context, int index) {
            int rooms = index + 1;
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Applainces();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 7,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Room Number $rooms',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 40,
                            color: primaryColorLight,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Enter the amount of rooms'),
                content: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {
                      noOfRoomsAdd = int.parse(val);
                    });
                  },
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          noOfRooms = noOfRooms + noOfRoomsAdd;
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Add'))
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
