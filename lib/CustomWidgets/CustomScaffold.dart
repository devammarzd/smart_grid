import 'package:flutter/material.dart';
import 'package:smart_grid/Constants.dart';

class CustomScaffold extends StatefulWidget {
  final int index;
  final Widget body;
  final FloatingActionButton floatingActionButton;
  CustomScaffold({@required this.index,@required this.body,@required this.floatingActionButton , Key key}) : super(key:key);
  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  void choiceAction(String choice){
    print('Working');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
appBar: AppBar(
  title: Text('Smart Grid',style: TextStyle(color:Colors.white),),
iconTheme: IconThemeData(

  color: Colors.white
),
  actions: [
    PopupMenuButton<String>(
    onSelected: choiceAction,
  itemBuilder: (context){
    return Constants.choices.map((String choice){
      return PopupMenuItem<String>(
      value: choice,
      child: Text(choice));
    }).toList();
  },
    )
  ],
),

drawer: Drawer(
child: ListView(
  children: [
  UserAccountsDrawerHeader(accountName: Text('Guest User'), accountEmail: Text('xyz@gmail.com')),
  ListTile(title: Text('Profile'),),
  ListTile(title: Text('Theme'),),
  ListTile(title: Text('Settings'),),
  ListTile(title: Text('Logout'),),

  ],
),
),
body: widget.body,
floatingActionButton:widget.floatingActionButton,
    );
  }
}