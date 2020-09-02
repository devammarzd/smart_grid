import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_grid/Global.dart';
import 'package:smart_grid/Screens/Home.dart';

class RoomsInput extends StatefulWidget {
  @override
  _RoomsInputState createState() => _RoomsInputState();
}

class _RoomsInputState extends State<RoomsInput> {
  int noOfRooms;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                       begin:  FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                     
              colors: [   primaryColor,      Colors.lightGreen[300]],
            )),
            
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: 
                        Image.asset('assets/logo.png',
                        width: MediaQuery.of(context).size.width/5,
                        height: MediaQuery.of(context).size.height/14,
                        fit: BoxFit.fill,
                        )
                      //   Icon(
                      //  MdiIcons.flash,
                      //     color: logoColor,
                      //     size: 50,
                      //   ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Smart Grid',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                        
                      ),
                        SizedBox(
                        height: 20,
                      ),
                       Container(
                         alignment: Alignment.center,
                     
                         width: MediaQuery.of(context).size.width/1.2,
                         
                         child: Text(
                          'Sustain, for a better tomorrow',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
      
                          ),
                          
                      ),
                       ),
                    ],
                  ),
                ),
              ),
            
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
     
                      // Padding(padding: EdgeInsets.only(top: 20)),
                      Text(
                        "Enter the number of rooms:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height:10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0,5,15,5),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                         decoration: InputDecoration(
                          hintText: 'No. of Rooms',
                           fillColor:Colors.white,
                           filled: true,
                           
                         ),
                         onChanged: (val){
                           setState(() {
                             noOfRooms=int.parse(val);
                           });
                         }, 
                        ),
                      )
                    ],
                  )),
                  //  Expanded(
                  //    flex: 2,
                  //    child: SizedBox(child: Text(''),)),
            ],
          ),
         
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                onPressed: (){
                  if(noOfRooms!=null){
                   Navigator.pushReplacement (context,
                                          MaterialPageRoute(builder:
                                              (BuildContext context) {
                                        return Home(noOfRooms: noOfRooms,);
                                      }));
                  }
                },
                color: Colors.white,
                child: Text('Next', style: TextStyle(
                  color:primaryColor
                ),)),
            ),
          )
        ],
      ),
    );
  }
}
