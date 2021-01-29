import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:tankcarecustomer/CustomerModels/State.dart';
import 'package:tankcarecustomer/main.dart';

import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tankcarecustomer/Customer/login.dart';
import 'package:tankcarecustomer/Customer/otp.dart';
import 'package:tankcarecustomer/CustomerModels/districtlist.dart';
import 'package:tankcarecustomer/CustomerModels/register.dart';

import '../string_values.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterPages(),
    );
  }
}

class RegisterPages extends StatefulWidget {
  @override
  RegisterPagesState createState() => RegisterPagesState();
}

class RegisterPagesState extends State<RegisterPages> {

  static String token = "";
  static String cus_id = "";
  bool _isHidden = true;
  String dropdownValue1 = '-- Select State --';

  States li12;

  DistrictListings li13;

  String dropdownValue3 ="-- Address Type --";

  var validateAd=false;

  var errortextaddr;

  bool validatePC=false;

  String errortextpin;
  Future<http.Response> stateRequest() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'state';
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      li12 = States.fromJson(json.decode(response.body));

      stringlist.clear();
      stringlist.add('-- Select State --');
      for (int i = 0; i < li12.items.length; i++)
        stringlist.add(li12.items[i].stateName);
      //dropdownValue1=stringlist[0];

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

  Future<http.Response> districtRequest(stateid) async {
    var url = String_values.base_url + 'district/' + stateid;
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        li13 = DistrictListings.fromJson(json.decode(response.body));
        stringlist1.clear();

        stringlist1.add('-- Select District --');
        for (int i = 0; i < li13.items.length; i++)
          stringlist1.add(li13.items[i].districtName);
      });

      //dropdownValue1=stringlist[0];

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
  int statetype = 1;
  int districttype = 1;
  List<String> stringlist = [
    '-- Select State --',
    "Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor"
  ];
  List<String> stringlist1 = [
    '-- Select District --',
    "Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor"
  ];
  String dropdownValue2 = '-- Select District --';
  String errortextname;
  bool validateN = false;
  String errortextmobile;
  bool validateM = false;
  String errortextemail;
  bool validateE = false;
  String errortextpass;
  bool validateP = false;
  String errortextcpass;
  bool validateCP = false;

  bool loading = false;

  Register li;

  var ref = false;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController refcodeController = new TextEditingController();
  TextEditingController confirmpasswordController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController PincodeController = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    Future<bool> check() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        return true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        return true;
      }
      return false;
    }

    Future<http.Response> postRequest(addrtype) async {
      setState(() {
        loading = true;
      });
      var url = String_values.base_url + 'cusreg';
      Map data;
      if (ref)
        data = {
          "name": nameController.text,
          "phone": mobileController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "ref_code": refcodeController.text,
          "cus_address": addressController.text,

          "cus_address_type": addrtype,
          "cus_district": districttype,
          "cus_pincode": PincodeController.text,
          "cus_state": statetype,
          // email: "dfsg@gmail.com"
          // name: "srfg"
          // password: "123123"
          // phone: "5445445454"
          // ref_code: ""
        };
      else
        data = {
          "name": nameController.text,
          "phone": mobileController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "cus_address": addressController.text,
          "cus_address_type": addrtype,
          "cus_district": districttype,
          "cus_pincode": PincodeController.text,
          "cus_state": statetype,
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
        li = Register.fromJson(json.decode(response.body));
        token = li.token;
        cus_id = li.uid;
        setState(() {
          loading = false;
        });

        if (li.status) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OTPPage()),
          );
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

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return loading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // new Container(
                  //   child: Image.asset('logo.png'),
                  //   width: 100,
                  //   height: 100,
                  // ),
                  SizedBox(
                    height: height / 10,
                  ),
                  Container(
                    // color: Colors.white,
                    width: width,
                    child: new Container(
                      child: Image.asset('logo.png'),
                      width: 100,
                      height: 100,
                    ),
                  ),

                  Container(
                    color: Colors.white,
                    child: SizedBox(
                      height: height / 20,
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5.0),
                  //     color: Colors.white,
                  //
                  //   ),
                  //   // color: Colors.white,
                  //   child: Center(
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(16.0),
                  //       child: new Text(
                  //         "Registration",
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.red,
                  //             fontSize: 17),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 20,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      onTap: () {
                        setState(() {
                          errortextname = null;
                        });
                      },
                      decoration: InputDecoration(
                        errorText: validateN ? errortextname : null,
                        labelText: 'Name',
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
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onTap: () {
                        setState(() {
                          errortextemail = null;
                        });
                      },
                      decoration: InputDecoration(
                        errorText: validateE ? errortextemail : null,
                        labelText: 'Email',
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
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: TextField(
                      controller: mobileController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      onTap: () {
                        setState(() {
                          errortextmobile = null;
                        });
                      },
                      decoration: InputDecoration(
                        errorText: validateM ? errortextmobile : null,
                        counterText: "",
                        labelText: 'Mobile number',
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
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      onTap: () {
                        setState(() {
                          errortextpass = null;
                        });
                      },
                      decoration: InputDecoration(
                        errorText: validateP ? errortextpass : null,
                        labelText: 'Password',
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
                    height: height / 50,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: TextField(
                      obscureText: true,
                      controller: confirmpasswordController,
                      onTap: () {
                        setState(() {
                          errortextcpass = null;
                        });
                      },
                      decoration: InputDecoration(
                        errorText: validateCP ? errortextcpass : null,
                        labelText: 'Confirm Password',
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
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Container(
                      child: new TextField(
                        minLines: 3,
                        maxLines: 15,
                        controller: addressController,
                        decoration: InputDecoration(
                          errorText: validateAd ?  errortextaddr : null,
                          labelText: 'Address',
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
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        border: new Border.all(color: Colors.black38)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue3,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue3 = newValue;

                          });
                        },
                        items:<String>["-- Address Type --", "Residential", "Commercial"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        border: new Border.all(color: Colors.black38)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue1,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue1 = newValue;
                            dropdownValue2 = '-- Select District --';
                            statetype = stringlist.indexOf(newValue);
                            for (int i = 0; i < li12.items.length; i++)
                              if (li12.items[i].stateName == newValue) {
                                statetype = int.parse(li12.items[i].stateId);

                                districtRequest(li12.items[i].stateId);
                              }
                          });
                        },
                        items: stringlist
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        border: new Border.all(color: Colors.black38)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue2,
                        onChanged: (String newValue) {
                          setState(() {
                            for (int i = 0; i < li13.items.length; i++)
                              if (li13.items[i].districtName == newValue) {
                                districttype =
                                    int.parse(li13.items[i].districtId);
                              }
                            dropdownValue2 = newValue;
                          });
                        },
                        items: stringlist1
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Container(
                      child: new TextField(
                        controller: PincodeController,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          errorText: validatePC ? errortextpin : null,
                          labelText: 'Pincode',
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
                  ),
                  SizedBox(
                    height: height / 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Checkbox(
                            value: ref,
                            activeColor: Colors.red,
                            onChanged: (bool value) {
                              setState(() {
                                ref = value;
                              });
                            }),
                        Text("Having Referal Code ")
                      ],
                    ),
                  ),

                  Visibility(
                    visible: ref,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: TextField(
                        controller: refcodeController,
                        decoration: InputDecoration(
                          labelText: 'Referal Code',
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
                  ),
                  SizedBox(
                    height: height / 30,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 40,
                      child: FlatButton(
                        child: Text('Sign Up'),
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () {
                          setState(() {
                            LoginPagesState.emailController.text =
                                emailController.text.trim();
                            final bool isValid = EmailValidator.validate(
                                emailController.text.trim());
                            if (emailController.text.trim().isNotEmpty) {
                              if (!isValid) {
                                validateE = true;
                                errortextemail = "Enter proper email";
                              } else
                                validateE = false;
                            } else {
                              validateE = true;
                              errortextemail = "Email cannot be empty";
                            }
                            if (nameController.text.trim().isEmpty) {
                              if (nameController.text.trim().isEmpty)
                                errortextname = "Name cannot be empty";
                              validateN = true;
                            } else
                              validateN = false;

                            String pattern = r'(^([0-9]{10})$)';
                            RegExp regExp = new RegExp(pattern);

                            if (mobileController.text.length != 10 ||
                                !regExp.hasMatch(mobileController.text)) {
                              if (mobileController.text.isEmpty)
                                errortextmobile =
                                    "Mobile Number cannot be empty";
                              else if (mobileController.text.length != 10)
                                errortextmobile =
                                    "Mobile Number must contains 10 digits";
                              else
                                errortextmobile =
                                    "Mobile Number must only contains numeric digits";
                              validateM = true;
                            } else
                              validateM = false;
                            if (passwordController.text.isEmpty ||
                                passwordController.text.trim().length < 6) {
                              if (passwordController.text.isEmpty)
                                errortextpass = "Password cannot be empty";
                              else
                                errortextpass =
                                    "Password should be minimum of 6 characters";
                              validateP = true;
                            } else
                              validateP = false;

                            if (confirmpasswordController.text.isEmpty ||
                                passwordController.text !=
                                    confirmpasswordController.text) {
                              if (confirmpasswordController.text.isEmpty)
                                errortextcpass =
                                    "Confirm Password cannot be empty";
                              else
                                errortextcpass =
                                    "Password and Confirm password should be same";
                              validateCP = true;
                            } else
                              validateCP = false;

                            if (addressController.text.isEmpty ) {
                              if (confirmpasswordController.text.isEmpty)
                                errortextaddr =
                                "Address cannot be empty";

                              validateAd = true;
                            } else
                              validateAd = false;
                            if (PincodeController.text.length!=6 ) {
                              if (PincodeController.text.length!=6)
                                errortextpin =
                                "Pincode should be 6 digits";

                              validatePC= true;
                            } else
                              validatePC = false;
                          });

                          if (validateCP == false &&
                              validateE == false &&
                              validateM == false &&
                              validateN == false &&
                              validateP == false &&
                              validateAd == false &&
                              validatePC== false && dropdownValue1!='-- Select State --'&&dropdownValue2!='-- Select District --'&&dropdownValue3!="-- Address Type --")
    {check().then((value) {
    if (value)
    {
    if(dropdownValue3=="Residential")
    postRequest("RES");
    else if(dropdownValue3=="Commercial")
    postRequest("COM");
    }
    else
    showDialog<void>(
    context: context,
    barrierDismissible:
    false, // user must tap button!
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
    }
    else if (dropdownValue1 == '-- Select State --')
    showDialog<void>(
    context: context,
    barrierDismissible: false,
    // user must tap button!
    builder: (BuildContext context) {
    return AlertDialog(
    title: Text("Please Choose State"),
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
    else if (dropdownValue2 ==
    '-- Select District --')
    showDialog<void>(
    context: context,
    barrierDismissible: false,
    // user must tap button!
    builder: (BuildContext context) {
    return AlertDialog(
    title: Text("Please Choose District"),
    actions: <Widget>[
    TextButton(
    child: Text('OK'),
    onPressed: () {
    Navigator.of(context).pop();
    },
    ),
    ],
    );});
                          else if (dropdownValue3 ==
                              "-- Address Type --")
                            showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Please Address Type"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );});

                          //  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute extends StatelessWidget());
                        },
                      )),
                  // buildButtonContainer(),

                  SizedBox(
                    height: height / 40,
                  ),
                  SizedBox(
                    height: height / 40,
                  ),
                  Container(
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Already have an Account?",
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
  void initState() {
  stateRequest(); super.initState();
  }
  Widget buildTextField(String labelText) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        prefixIcon: labelText == "Email" ? Icon(Icons.email) : Icon(Icons.lock),
        suffixIcon: labelText == "Password"
            ? IconButton(
                onPressed: _toggleVisibility,
                icon: _isHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )
            : null,
      ),
      obscureText: labelText == "Password" ? _isHidden : false,
    );
  }

  Widget ButtonContainer() {
    return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: 40,
        child: FlatButton(
          child: Text('Sign Up'),
          color: Colors.redAccent,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () {
            print(emailController.text);

            //  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute extends StatelessWidget());
          },
        ));
  }
}
