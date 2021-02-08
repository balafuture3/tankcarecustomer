import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:tankcarecustomer/main.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankcarecustomer/Customer/forgotpass.dart';
import 'package:tankcarecustomer/Customer/otp.dart';
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/login.dart';
import 'package:tankcarecustomer/main.dart';
import 'package:tankcarecustomer/string_values.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPages(),
    );
  }
}

class LoginPages extends StatefulWidget {
  @override
  LoginPagesState createState() => LoginPagesState();
}

class LoginPagesState extends State<LoginPages> {
  bool _isHidden = true;

  bool loading = false;

  Login li;

  String errortextemail;
  String errortextpass;

  bool validateE = false;

  bool validateP = false;

  Future<bool> setRegistered(userid, token, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userid', userid);
    await prefs.setString('token', token);
    await prefs.setString('email', email);
    await prefs.setBool('seen', true);
    return true;
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
    var url = String_values.base_url + 'cuslogin';
    Map data = {
      "uname": emailController.text,
      "password": passwordController.text
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
      li = Login.fromJson(json.decode(response.body));
      setState(() {
        loading = false;
      });

      if (li.status) {
        if (li.accVerify == "N") {
          RegisterPagesState.cus_id = li.uid;
          RegisterPagesState.token = li.token;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OTPPage()),
          );
        } else {
          setRegistered(li.uid, li.token, emailController.text);
          RegisterPagesState.cus_id = li.uid;
          RegisterPagesState.token = li.token;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(firsttime:true)),
          );
        }
      } else
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                content: li.messages.length != 0
                    ? Text(li.messages[0])
                    : Text(li.alert),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });

      // showDialog(
      //     context: context,
      //     builder:(_) =>AlertDialog(
      //       title: Text(
      //         li.alert,
      //         style: TextStyle(color: Colors.red),
      //
      //       ),
      //       content:Text(
      //           li.alert,
      //           style: TextStyle(color: Colors.red),)
      //     ));

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

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  static TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    width: width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height / 6,
                        ),
                        new Container(
                          child: Image.asset('logo.png'),
                          width: 150,
                          height: 150,
                        ),
                        SizedBox(
                          height: height / 15,
                        ),
                      ],
                    ),
                  ),


                  /*
            Text(
              "TANK CARE SOLUTIONS",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),*/
                  SizedBox(
                    height: height / 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: buildTextField("Email or Mobile Number"),
                  ),
                  SizedBox(
                    height: height / 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextField(
                      obscureText: _isHidden,
                      controller: passwordController,
                      onTap: () {
                        setState(() {
                          errortextpass = null;
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: _toggleVisibility,
                          icon: _isHidden
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        errorText: validateP ? errortextpass : null,
                        labelText: 'Password',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: InkWell(
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                child: Text("Forgot Password?"),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 15,
                  ),


                  ButtonContainer(),
                  // buildButtonContainer(),

                  SizedBox(
                    height: height / 30,
                  ),

                  Container(
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Create an Account",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildTextField(String hintText) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        setState(() {
          errortextemail = null;
        });
      },
      decoration: InputDecoration(
        errorText: validateE ? errortextemail : null,
        prefixIcon: Icon(Icons.phonelink_sharp),
        labelText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        suffixIcon: hintText == "Password"
            ? IconButton(
          onPressed: _toggleVisibility,
          icon: _isHidden
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        )
            : null,
      ),
      obscureText: hintText == "Password" ? _isHidden : false,
    );
  }

  Widget ButtonContainer() {
    return Container(
        width: MediaQuery.of(context).size.width / 1.8,
        height: 50,
        child: FlatButton(
          child: Text('Login'),
          color: Colors.red,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          onPressed: () {
            setState(() {
              if (emailController.text.trim().isNotEmpty) {
                validateE = false;
              } else {
                validateE = true;
                errortextemail = "Email cannot be empty";
              }
              if (passwordController.text.isEmpty ||
                  passwordController.text.trim().length < 6) {
                if (passwordController.text.isEmpty)
                  errortextpass = "Password cannot be empty";
                else
                  errortextpass = "Password should be minimum of 6 characters";
                validateP = true;
              } else
                validateP = false;

              if (validateE == false && validateP == false)
                check().then((value) {
                  if (value)
                    postRequest();
                  else
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
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
            });

            //  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute extends StatelessWidget());
          },
        ));
  }
}
