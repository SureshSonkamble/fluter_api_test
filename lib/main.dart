import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
//import package file manually

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData(
          primarySwatch:Colors.red, //primary color for theme
        ),
        home: WriteSQLdata() //set the class here
    );
  }
}

class WriteSQLdata extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return WriteSQLdataState();
  }
}

class WriteSQLdataState extends State<WriteSQLdata>{

  late bool error, sending, success;
  late String msg;

  String addurl = "https://vsproi.com/WS_API/select_test.php?";

  // do not use http://localhost/ for your local
  // machine, Android emulation do not recognize localhost
  // insted use your local ip address or your live URL
  // hit "ipconfig" on Windows or  "ip a" on Linux to get IP Address

  @override
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";
    super.initState();
  }

  Future<void> sendData() async {
    print("In process");
    var res = await http.post(Uri.parse(addurl), body: {

      // "rollno": rollnoctl.text,
    }); //sending post request with header data

    if (res.statusCode == 200) {
     // print(res.body); //print raw response on console
      var data = json.decode(res.body); //decoding json to array
     // print(data);
      print(data["posts"]["status"]);
      if(data["posts"]["status"]=="200"){
        print(data["posts"]["post"][0]);
       print(data["posts"]["post"][0]["Name"]);
        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });

      }else{
        setState(() { //refresh the UI when error is recieved from server
          sending = false;
          error = true;
          // msg = data["message"]; //error message from server
        });

      }

    }else{
      //there is error
      setState(() {
        error = true;
        msg = "Error during sendign data.";
        sending = false;
        //mark error and refresh UI with setState
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("API Data PHP & MySQL"),
          backgroundColor:Colors.redAccent

      ), //appbar

      body: SingleChildScrollView( //enable scrolling, when keyboard appears,
        // hight becomes small, so prevent overflow
          child:Container(
              padding: EdgeInsets.all(20),
              child: Column(children: <Widget>[
 //text input for name
                Container(
                    margin: EdgeInsets.only(top:20),
                    child:SizedBox(
                        width: double.infinity,
                        child:RaisedButton(
                          onPressed:(){ //if button is pressed, setstate sending = true, so that we can show "sending..."
                            setState(() {
                              sending = true;
                            });
                            sendData();
                          },
                          child: Text(
                            sending?"Sending...":"GET DATA",
                            //if sending == true then show "Sending" else show "SEND DATA";
                          ),
                          color: Colors.redAccent,
                          colorBrightness: Brightness.dark,
                          //background of button is darker color, so set brightness to dark

                        )

                    )
                )


              ],)
          )

      ),
    );
    
  }
}