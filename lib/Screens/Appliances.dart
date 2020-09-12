import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_grid/CustomWidgets/CustomScaffold.dart';
import 'package:smart_grid/Global.dart';
import 'package:smart_grid/Screens/Login.dart';

class Applainces extends StatefulWidget {
  final int roomNum;
  Applainces({@required this.roomNum,Key key}):super(key:key);
  @override
  _ApplaincesState createState() => _ApplaincesState();
}

class _ApplaincesState extends State<Applainces> {
  int noOfApp;
  String appname;
  List<String> roomapp = [];
  List<String> roomappPower = [];
  bool recordAC = false;
  bool recordApp2 = false;
  double limitUnitsAC = 0;
  double limitUnitsApp2 = 0;
  Timer _timerAC;
  Timer _timerApp2;
  double totalpowerAC = 0;
  double totalpowerApp2 = 0;
  double unitsConsumedAC = 0;
  double unitsConsumedApp2 = 0;
  double totalroomUnits = 0;
  double roomLimit=0;
  bool limitExceedAC = false;
  bool limitExceedApp2 = false;
  int minsApp2 = 0;
  int minsAC = 0;
  int hrsApp2 = 0;
  int hrsAC = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  void _starttimer(double power) {
    int count = 0;
    double n = 0;
    double powerperMin;
    _timerAC = Timer.periodic(Duration(seconds: 5), (timer) {
      powerperMin = (power / 1000) / 60;
      n = (totalpowerAC + powerperMin);

      if (this.mounted) {
        if (minsAC == 59) {
          setState(() {
            minsAC = 0;
            hrsAC = hrsAC + 1;
          });
        } else {
          setState(() {
            totalpowerAC = num.parse(n.toStringAsFixed(4));
            unitsConsumedAC = num.parse((totalpowerAC).toStringAsFixed(2));
            // totalroomUnits =
            //     num.parse((totalroomUnits + powerperMin).toStringAsFixed(2));
            minsAC = minsAC + 1;
          });
          
          if (unitsConsumedAC >= limitUnitsAC) {
            count++;
            print(
                'Units Consumed : $unitsConsumedAC is greater than limit: $limitUnitsAC');
            setState(() {
              limitExceedAC = true;
            });
            count == 1 ? showNotification('AC 2-Ton') : null;
          } else {
            setState(() {
              limitExceedAC = false;
            });
          }
        }
      }
    });
  }

  void _starttimerWM(double power) {
    int count = 0;
    double n = 0;
    double powerperMin;
    _timerApp2 = Timer.periodic(Duration(seconds: 5), (timer) {
      powerperMin = (power / 1000) / 60;
      n = (totalpowerApp2 + powerperMin);

      if (this.mounted) {
        if (minsApp2 == 59) {
          setState(() {
            minsApp2 = 0;
            hrsApp2 = hrsApp2 + 1;
          });
        } else {
          setState(() {
            totalpowerApp2 = num.parse(n.toStringAsFixed(4));
            unitsConsumedApp2 = num.parse((totalpowerApp2).toStringAsFixed(2));
            // totalroomUnits =
            //     num.parse((totalroomUnits + powerperMin).toStringAsFixed(2));
            minsApp2 = minsApp2 + 1;
          });
        
          if (unitsConsumedApp2 >= limitUnitsApp2) {
            count++;
            print(
                'Units Consumed : $unitsConsumedApp2 is greater than limit: $limitUnitsApp2');
            setState(() {
              limitExceedApp2 = true;
            });
            count == 1 ? showNotification('Telivision') : null;
          } else {
            setState(() {
              limitExceedApp2 = false;
            });
          }
        }
      }
    });
  }
   void _starttimerRoom() {
  int count=0;
    _timerAC = Timer.periodic(Duration(seconds: 5), (timer) {
        if (this.mounted) {
      print('total room units : $totalroomUnits');
    setState(() {
      totalroomUnits=num.parse((unitsConsumedAC+unitsConsumedApp2).toStringAsFixed(2));
    });
    if(totalroomUnits>roomLimit&&(recordAC==true||recordApp2==true)){
    count++;
    }
    if(count==1)
    feedbackdialog();
        }
    });
  }
feedbackdialog(){
  return showDialog(context: context,
  builder: (context) {
    return AlertDialog(
title: Row(
  children: [
    Icon(Icons.info,color: Colors.yellow[800],),
    SizedBox(width:5,),
    Text('Feedback')
  ],
),
content: Text('Your AC is consuming more units $unitsConsumedAC Units as compared to a usual 2 Ton AC in $hrsAC hrs and $minsAC mins'),
    );
  },
  );
}

  void _canceltimerWM() {
    _timerApp2.cancel();
  }

  void _canceltimer() {
    _timerAC.cancel();
  }

  addAppplaince(String applianceName, String appliancePower) {
    roomapp.add('$applianceName');
    roomappPower.add(appliancePower);
  }

  void showNotification(String appname) async {
    await demoNotification(appname);
  }

  Future<void> demoNotification(String appname) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channelId',
      'channelName',
      'channelDescription',
      importance: Importance.High,
      priority: Priority.High,
      ticker: 'test ticker',
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('piece_of_cake'),
    );
    var iOSchannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSchannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Warning!',
      '$appname units limit has exceeded',
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _starttimerRoom();
    initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification Payload : $payload');
    }
    // await Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Login()));
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Applainces()));
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Appliances',
          style: TextStyle(color: primaryColor),
        ),
        iconTheme: IconThemeData(color: primaryColor),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(
                  Icons.add,
                  size: 27,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Enter the Name of appliance'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              // width: 30,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  hintText: 'Select',
                                  // value: typeAnimal,
                                  // suffix:appname != null? Text('Power'):null
                                ),
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 20,
                                elevation: 26,
                                style: TextStyle(
                                  color: Colors.black,
                                  // fontSize: 20,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    appname = value;
                                  });
                                },
                                items: appliancesAll
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        // TextField(
                        //   onChanged: (val) {
                        //     setState(() {
                        //       appname = val;
                        //     });
                        //   },
                        // ),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                if (appname != null) {
                                  int i = appliancesAll.indexOf(appname);
                                  String appliancePower =
                                      appliancesAllPower.elementAt(i);
                                  addAppplaince(appname, appliancePower);
                                  print('${roomapp[0]}');
                                  setState(() {
                                    appname = null;
                                  });
                                }
                                Navigator.pop(context);
                              },
                              child: Text('Add'))
                        ],
                      );
                    },
                  );
                }),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(    height: 60,),
                widget.roomNum==1?  Card(
                    color: limitExceedAC ? Colors.red[100] : Colors.white,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height / 3,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8, 5, 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'AC 2-Ton',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.indigoAccent),
                                        ),
                                        Switch(
                                          value: recordAC,
                                          onChanged: limitUnitsAC == 0
                                              ? null
                                              : (bool value) {
                                                  setState(() {
                                                    recordAC = !recordAC;
                                                  });
                                                  if (recordAC == true) {
                                                    _starttimer(2500);
                                                  } else if (recordAC ==
                                                      false) {
                                                    _canceltimer();
                                                  }
                                                },
                                        ),
                                      ],
                                    ),
                                    Text('Power: 2500 W',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Limit (Units) : $limitUnitsAC Units',
                                                  style: TextStyle(),
                                                ),
                                              ),
                                              RaisedButton.icon(
                                                  color: Colors.blueAccent,
                                                  disabledColor: Colors.grey,
                                                  onPressed: recordAC == false
                                                      ? () {
                                                          enterlimit();
                                                        }
                                                      : null,
                                                  icon: Icon(
                                                    Icons.edit,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text(
                                                    'Set limit',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Total Units Consumed : $unitsConsumedAC Units',
                                            style: TextStyle(
                                                color: limitExceedAC
                                                    ? Colors.redAccent
                                                    : Colors.green[700],
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Total Power Consumed : $totalpowerAC kWH',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Duration : $hrsAC Hrs $minsAC Minutes',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              limitExceedAC
                                                  ? Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                      size: 20,
                                                    )
                                                  : Container(),
                                              limitExceedAC
                                                  ? Text(
                                                      'LIMIT EXCEEDED!',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ):Container(),
//Appliance 2
             widget.roomNum==1?     Card(
                    color: limitExceedApp2 ? Colors.red[100] : Colors.white,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height / 3,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8, 5, 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Telivision',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.indigoAccent),
                                        ),
                                        Switch(
                                          value: recordApp2,
                                          onChanged: limitUnitsApp2 == 0
                                              ? null
                                              : (bool value) {
                                                  setState(() {
                                                    recordApp2 = !recordApp2;
                                                  });
                                                  if (recordApp2 == true) {
                                                    _starttimerWM(900);
                                                  } else if (recordApp2 ==
                                                      false) {
                                                    _canceltimerWM();
                                                  }
                                                },
                                        ),
                                      ],
                                    ),
                                    Text('Power: 200 W',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Limit (Units) : $limitUnitsApp2 Units',
                                                  style: TextStyle(),
                                                ),
                                              ),
                                              RaisedButton.icon(
                                                  color: Colors.blueAccent,
                                                  disabledColor: Colors.grey,
                                                  onPressed: recordApp2 == false
                                                      ? () {
                                                          enterlimitWashMachine();
                                                        }
                                                      : null,
                                                  icon: Icon(
                                                    Icons.edit,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text(
                                                    'Set limit',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Total Units Consumed : $unitsConsumedApp2 Units',
                                            style: TextStyle(
                                                color: limitExceedAC
                                                    ? Colors.redAccent
                                                    : Colors.green[700],
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Total Power Consumed : $totalpowerApp2 kWH',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Duration : $hrsApp2 Hrs $minsApp2 Minutes',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              limitExceedApp2
                                                  ? Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                      size: 20,
                                                    )
                                                  : Container(),
                                              limitExceedApp2
                                                  ? Text(
                                                      'LIMIT EXCEEDED!',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ):Container(),
               addApplianceWidget(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // width: MediaQuery.of(context).size.width/1.7,
                alignment: Alignment.center,
                height: 60,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blueAccent),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Room Consumption:',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' $totalroomUnits Units',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
             Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                // width: MediaQuery.of(context).size.width/1.7,
                alignment: Alignment.center,
                height: 60,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blueGrey),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Room Limit: ${roomLimit.toString()} Units',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    RaisedButton(onPressed: (){
                      enterlimitForRoom();
                    },child: Text('Set limit'),)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  enterlimitWashMachine() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter a limit for the appliance'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffix: Text('Units'),
            ),
            onChanged: (val) {
              setState(() {
                limitUnitsApp2 = double.parse(val);
              });
            },
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  setState(() {
                    // noOfRooms = noOfRooms + noOfRoomsAdd;
                  });
                  Navigator.pop(context);
                },
                child: Text('Set'))
          ],
        );
      },
    );
  }

  enterlimit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter a limit for the appliance'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffix: Text('Units'),
            ),
            onChanged: (val) {
              setState(() {
                limitUnitsAC = double.parse(val);
              });
            },
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  setState(() {
                    // noOfRooms = noOfRooms + noOfRoomsAdd;
                  });
                  Navigator.pop(context);
                },
                child: Text('Set'))
          ],
        );
      },
    );
  }
    enterlimitForRoom() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter a limit for Room'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffix: Text('Units'),
            ),
            onChanged: (val) {
              setState(() {
                roomLimit = double.parse(val);
              });
            },
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  setState(() {
                    // noOfRooms = noOfRooms + noOfRoomsAdd;
                  });
                  Navigator.pop(context);
                },
                child: Text('Set'))
          ],
        );
      },
    );
  }
  Widget addApplianceWidget(){
    return    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: roomapp.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              // height: MediaQuery.of(context).size.height / 3,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 8, 5, 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${roomapp[index]}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.indigoAccent),
                                              ),
                                              Switch(
                                                  value: false,
                                                  onChanged: null),
                                            ],
                                          ),
                                          Text(
                                              'Power: ${roomappPower[index]} W',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Limit (Units) : 0.0 Units',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                    RaisedButton.icon(
                                                        color:
                                                            Colors.blueAccent,
                                                        disabledColor:
                                                            Colors.grey,
                                                        onPressed: () {
                                                          // enterlimit();
                                                        },
                                                        icon: Icon(
                                                          Icons.edit,
                                                          size: 15,
                                                          color: Colors.white,
                                                        ),
                                                        label: Text(
                                                          'Set limit',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        )),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Total Units Consumed : 0.0 Units',
                                                  style: TextStyle(
                                                      color: Colors.green[700],
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Total Power Consumed : 0.0 kWH',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 13),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Duration : 0 Hrs 0 Minutes',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    // limitExceedAC
                                                    //     ? Icon(
                                                    //         Icons.error,
                                                    //         color: Colors.red,
                                                    //         size: 20,
                                                    //       )
                                                    //     : Container(),
                                                    // limitExceedAC
                                                    //     ? Text(
                                                    //         'LIMIT EXCEEDED!',
                                                    //         style: TextStyle(
                                                    //             color: Colors.red),
                                                    //       )
                                                    //     : Container()
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      });
  }
}
