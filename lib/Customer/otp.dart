import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:tankcarecustomer/main.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/otp.dart';
import 'package:tankcarecustomer/main.dart';

import '../string_values.dart';

class OTPPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OTPPages(),
    );
  }
}

class OTPPages extends StatefulWidget {
  @override
  OTPPagesState createState() => OTPPagesState();
}

class OTPPagesState extends State<OTPPages> {
  bool _isHidden = true;

  String errortextotp;
  bool validateOTP = false;

  bool loading = false;

  Otp li;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  TextEditingController otpController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    void _showScaffold(String message) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(days: 365),
        action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white, // or some operation you would like
            onPressed: () {
              _scaffoldKey.currentState.removeCurrentSnackBar();
              // this block runs when label is pressed
            }),
      ));
    }

    Future<bool> check() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        return true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        return true;
      }
      return false;
    }

    Future<http.Response> postRequest() async {
      setState(() {
        loading = true;
      });
      var url = String_values.base_url + 'cusreg/otp/verify';
      Map data = {
        "cus_id": RegisterPagesState.cus_id,
        "otp": otpController.text
      };
      print("data: ${data}");
      print(String_values.base_url);
      //encode Map to JSON
      var body = json.encode(data);
      print("response: ${body}");
      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            //   'Authorization':
            //       'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIxIiwidXR5cGUiOiJFTVAifQ.AhfTPvo5C_rCMIexbUd1u6SEoHkQCjt3I7DVDLwrzUs'
            //
          },
          body: body);
      if (response.statusCode == 200) {
        li = Otp.fromJson(json.decode(response.body));
        setState(() {
          loading = false;
        });
        if (!li.status)
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(li.alert),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        else
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(li.alert),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home(firsttime:false)),
                      );
                    },
                  ),
                ],
              );
            },
          );
      } else {
        setState(() {
          loading = false;
        });

        print("Retry");
      }
      print("response: ${response.statusCode}");
      print("response: ${response.body}");
      return response;
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return new Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: height / 3,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Enter OTP send to your Mobile Number",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height / 60,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  obscureText: true,
                  controller: otpController,
                  onTap: () {
                    setState(() {
                      errortextotp = "";
                    });
                  },
                  decoration: InputDecoration(
                    errorText: validateOTP ? errortextotp : null,
                    hintText: 'Enter OTP',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height / 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 40,
                  child: FlatButton(
                    child: Text('Submit'),
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      setState(() {
                        if (otpController.text.isEmpty ||
                            otpController.text.trim().length < 6) {
                          if (otpController.text.isEmpty)
                            errortextotp = "OTP cannot be empty";
                          else
                            errortextotp =
                                "OTP should be minimum of 6 characters";
                          validateOTP = true;
                        } else
                          validateOTP = false;
                      });

                      if (validateOTP == false)
                        check().then((value) {
                          if (value)
                            postRequest();
                          else
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("No Internet Connection"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                        });
                      //  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute extends StatelessWidget());
                    },
                  )),
            ]),
      ),
    ));
  }
}
