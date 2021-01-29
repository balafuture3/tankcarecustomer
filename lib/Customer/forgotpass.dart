import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:tankcarecustomer/main.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tankcarecustomer/Customer/otp.dart';
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/login.dart';
import 'package:tankcarecustomer/main.dart';
import 'package:tankcarecustomer/string_values.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForgotPasswordPages(),
    );
  }
}

class ForgotPasswordPages extends StatefulWidget {
  @override
  ForgotPasswordPagesState createState() => ForgotPasswordPagesState();
}

class ForgotPasswordPagesState extends State<ForgotPasswordPages> {
  bool _isHidden = true;

  bool loading = false;

  Login li;

  String errortextemail;
  String errortextpass;

  bool validateE = false;

  bool validateP = false;

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
        RegisterPagesState.cus_id = li.uid;
        RegisterPagesState.token = li.token;
        if (li.accVerify == "N")
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OTPPage()),
          );
        else
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(firsttime:false)),
          );
      }

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

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: height / 10,
                  ),
                  new Container(
                    child: Image.asset('logo.png'),
                    width: 180,
                    height: 180,
                  ),

                  SizedBox(
                    height: height / 30,
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

                  buildTextField("Email"),
                  SizedBox(
                    height: height / 10,
                  ),

                  ButtonContainer(),
                  // buildButtonContainer(),

                  SizedBox(
                    height: height / 30,
                  ),
                  SizedBox(
                    height: height / 30,
                  ),
                  // Container(
                  //   child: Center(
                  //     child: InkWell(
                  //       onTap: (){
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>RegisterPage()),
                  //         );
                  //       },
                  //       child: Container(
                  //         child: Text("Create an Account",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600),),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        prefixIcon: hintText == "Email" ? Icon(Icons.email) : Icon(Icons.lock),
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

              if (validateE == false && validateP == false) postRequest();
            });

            //  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute extends StatelessWidget());
          },
        ));
  }
}
