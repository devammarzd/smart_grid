import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_grid/Global.dart';
import 'package:smart_grid/Screens/RoomsInput.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height:  MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                ),

                Container(
                  padding: EdgeInsets.all(10),
                 decoration:BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular( 500),
               border: Border.all(
                 color: primaryColor,
                 width: 3
               )
                 ),
                  child:Image.asset('assets/logo.png',
                        width:MediaQuery.of(context).size.height/14,
                        height: MediaQuery.of(context).size.height/14,
                        fit: BoxFit.fill,
                        )
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height /
                      35, //equal to height=15
                ),
                Text(
                  'Smart Grid',
                  style: TextStyle(
                    fontSize: 26,
                    color: primaryColor,
                    fontWeight: FontWeight.bold
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 20,
                // ),
                // Text(
                //   'Login',
                //   style: TextStyle(
                //       fontSize: 28,
                //       color: primaryColor,
                    
                //       fontWeight: FontWeight.bold),
                // ),
               
                SizedBox(
                  height: MediaQuery.of(context).size.height / 9,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        cursorColor: commonTextColor,
                      
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColorLight)),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter email";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            35, //equal to height=15
                      ),
                      TextFormField(
                        cursorColor: commonTextColor,
                  
                        obscureText: true,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColorLight)),
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                      Icons.visibility_off,
                                    ),
                              onPressed: () {
                            
                              },
                            )),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter password";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                  color: primaryColor, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 14),
                      Column(
                        children: <Widget>[
                          Builder(
                            builder: (BuildContext context) {
                              return RaisedButton(
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height:
                                        MediaQuery.of(context).size.height /
                                            20,
                                    alignment: Alignment.center,
                                    child: Text("Login")),
                                color: Colors.green,
                                textColor: Colors.white,
                                onPressed: (){
                                     Navigator.pushReplacement (context,
                                          MaterialPageRoute(builder:
                                              (BuildContext context) {
                                        return RoomsInput();
                                      }));
                                    
                                  
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                  ),
                                  children: [
                                TextSpan(text: 'New to Smart Grid? '),
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder:
                                      //         (BuildContext context) {
                                      //   return CreateAccountScreen();
                                      // }));
                                    },
                                    child: Text(
                                      'Register here',
                                      style: TextStyle(
                                          color: primaryColor,
                                          decoration:
                                              TextDecoration.underline,
                                          fontSize: 14),
                                    ),
                                  ),
                                )
                              ]))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}