import 'dart:convert';
import 'dart:math';

import 'package:documents_picker/documents_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankcarecustomer/Customer/CustomerGroupList.dart';
import 'package:tankcarecustomer/Customer/GroupList.dart';
import 'package:tankcarecustomer/Customer/PlanList.dart';
import 'package:tankcarecustomer/Customer/PropertyList.dart';
import 'package:tankcarecustomer/Customer/ReferalList.dart';
import 'package:tankcarecustomer/Customer/ServiceList.dart';
import 'package:tankcarecustomer/Customer/billlist.dart';
import 'package:tankcarecustomer/Customer/checkoutlist.dart';
import 'package:tankcarecustomer/Customer/login.dart';
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/profile.dart';
import 'package:tankcarecustomer/string_values.dart';

import 'CustomerModels/MenuModel.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static bool _seen = false;
  Map<int, Color> color =
  {
    50:Color.fromRGBO(229,115,115, .1),
    100:Color.fromRGBO(229,115,115, .2),
    200:Color.fromRGBO(229,115,115, .3),
    300:Color.fromRGBO(229,115,115, .4),
    400:Color.fromRGBO(229,115,115, .5),
    500:Color.fromRGBO(229,115,115, .6),
    600:Color.fromRGBO(229,115,115, .7),
    700:Color.fromRGBO(229,115,115, .8),
    800:Color.fromRGBO(229,115,115, .9),
    900:Color.fromRGBO(229,115,115, 1),
  };

  static String role;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    MaterialColor colorCustom = MaterialColor(0xFFFF7373, color);
    Future<bool> checkFirstSeen() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _seen = (prefs.getBool('seen') ?? false);
      if (_seen) {
        RegisterPagesState.cus_id = prefs.getString("userid");
        RegisterPagesState.token = prefs.getString("token");
        LoginPagesState.emailController.text = prefs.getString("email");
        role = prefs.getString("role");
        print('Open sequence: Not First Time');
        print(RegisterPagesState.cus_id);
        print(RegisterPagesState.token);
      } else {
        // Set the flag to true at the end of onboarding screen if everything is successfull and so I am commenting it out
        // await prefs.setBool('seen', true);
        print('Open sequence: First Time');
      }
      return _seen;
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: checkFirstSeen(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            print(role);

             return snapshot.data ? Home() : LoginPage();
            //    return MyHomePage();
          }
          return Container(); // noop, this builder is called again when the future completes
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.firsttime});

  bool firsttime;
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Profile li;
  static String refcode;
  static String username = "  ";

  MenuList li3;

  RandomColor _randomColor = RandomColor();
  Future<http.Response> details() async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'menu-list';
    print(url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      li3 = MenuList.fromJson(jsonDecode(response.body));
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
  bool loading = false;

  Future<http.Response> postRequest() async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'my-profile';
    print(String_values.base_url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      li = Profile.fromJson(json.decode(response.body));
      if (li.status) refcode = li.data.ucode;
      setState(() {
        username = li.data.uname;
      });
      setState(() {
        loading = false;
      });
    }

    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  void initState() {
    details().then((value) => postRequest().then((value) => widget.firsttime?showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0),
          title: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    "logo.png",
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Welcomes You",
                  style: TextStyle(color: Colors.amber, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  li.data.uname.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),

          // actions: <Widget>[
          //   TextButton(
          //     child: Text('OK'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    ):Container()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> share() async {
      await Share.share('Join on Tank Care by clicking https://www.minmegam.com, a secure app for tank,sump,car and bike services. Enter my code "${refcode}" to earn rewards! ',

      );
    }

    // Future<void> shareFile() async {
    //   List<dynamic> docs = await DocumentsPicker.pickDocuments;
    //   if (docs == null || docs.isEmpty) return null;
    //
    //   await FlutterShare.shareFile(
    //     title: 'Example share',
    //     text: 'Example share text',
    //     filePath: docs[0] as String,
    //   );
    // }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      //backgroundColor: Colors.redAccent[100],
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              // color: Colors.white,
              margin: EdgeInsets.all(3.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Text(
                    "Dashboard",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 17),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: Container(
                  height: height/1.3,
                  width: width,
                  color: Colors.red.withOpacity(0),
                  padding: EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: <Widget>[
                      for (int i = 0; i < li3.list.length; i++)
                        if (li3.list[i].title != "Home")
                          Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                            color: RandomHexColor.colorRandom(),
                            // color: _randomColor.randomColor(
                            //   colorHue: ColorHue.multiple(colorHues: [ ColorHue.red,ColorHue.green,ColorHue.blue,ColorHue.yellow,ColorHue.orange,]),
                            //
                            //   colorBrightness: ColorBrightness.veryLight,
                            //   colorSaturation: ColorSaturation.highSaturation,
                            // ),
                            child: InkWell(
                              onTap: () {
                                pageswitch(li3.list[i].title, li3.list[i].children);
                              },
                              splashColor: Colors.redAccent,
                              borderRadius: BorderRadius.circular(20),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(

                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                          color: Colors.white.withOpacity(0.5)),
                                      padding: EdgeInsets.all(10),
                                      child: li3.list[i].icon!=null?Image.network(li3.list[i].icon,
                                        height: 35,width: 35,):Container(),
                                    ),
                                    SizedBox(height: height / 80),
                                    Container(
                                      child: Text(
                                        li3.list[i].title,
                                        style: new TextStyle(

                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
          /*
      Container(
              padding: EdgeInsets.all(18),
              child: GridView.count(
                crossAxisCount: 3,
                children: <Widget>[
                  Card(
                    elevation: 5.0,
                    // color: Colors.redAccent[100],
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerGroupList()));
                      },
                      splashColor: Colors.redAccent,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.border_color,
                              size: 25.0,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Group",
                              style: new TextStyle(fontSize: 10.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5.0,
                    child: InkWell(
                      splashColor: Colors.redAccent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PropertyList()));
                      },
                      //  splashColor: Colors.redAccent[100],
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.build,
                              size: 25.0,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Property",
                              style: new TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5.0,
                    child: InkWell(
                      splashColor: Colors.redAccent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlanList()));
                      },
                      //  splashColor: Colors.redAccent[100],
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.assignment,
                              size: 25.0,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Plan",
                              style: new TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ServiceList()));
                      },
                      splashColor: Colors.redAccent,
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.attach_money,
                              size: 25.0,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Service",
                              style: new TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BillList()));
                      },
                      splashColor: Colors.redAccent,
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.feedback,
                              size: 25.0,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Bill List",
                              style: new TextStyle(fontSize: 11.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckOutList()));
                      },
                      splashColor: Colors.redAccent,
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.mode_comment,
                              size: 25.0,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Checkout",
                              style: new TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5.0,
                    child: InkWell(
                      splashColor: Colors.redAccent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReferalList()));
                      },
                      //  splashColor: Colors.redAccent[100],
                      borderRadius: BorderRadius.circular(15),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.share,
                              size: 25.0,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Referrals",
                              style: new TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
*/
        appBar: AppBar(
        title: Image.asset('logotitle.png',height: 40),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  share();
                }),
          )
        ],
      ),

      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Welcome"),
              accountEmail: Text(username),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  username.substring(0, 1),
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            // ListTile(
            //   title: Text("Group"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => GroupList()),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: Text("Bill List"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => BillList()),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: Text("Checkout"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => CheckOutList()),
            //     );
            //   },
            // ),
            ListTile(
              title: Text("Logout"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('seen', false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPages()),
                );
              },
            ),
            // ListTile(
            //   title: Text("Plan"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => PlanList()),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: Text("Property"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => PropertyList()),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: Text("Offer"),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => OfferList())
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
  void pageswitch(String title, List<Children> children) {
    print(title);
    switch (title) {
      case "Property":

        if (children.toString() == "null") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PropertyList()));
        }
        else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Plan":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlanList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;
      case "Services":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ServiceList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;

      case "My Bill":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BillList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;

      case "Referral":
        print(children.toString());
        if (children.toString() == "null") {
          print("inside");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ReferalList()));
        } else {
          print("outside");
          showchildren(title, children);
        }
        break;

    }
  }

  void childrenwitch(String title) {
    print(title);
    switch (title) {
      case "Group":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => GroupList()));

        break;
      case "Property":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PropertyList()));
        break;

      case "Checkout":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CheckOutList()));
        break;
      case "Bill List":
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BillList()));
        break;
    }
  }

  void showchildren(title, children) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.8),
              title: Container(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              content: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: GridView.count(crossAxisCount: 3, children: <Widget>[
                  for (int i = 0; i < children.length; i++)
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      color: RandomHexColor.colorRandom(),
                      // color: _randomColor.randomColor(
                      //   colorHue: ColorHue.multiple(colorHues: [ ColorHue.red,ColorHue.green,ColorHue.blue,ColorHue.yellow,ColorHue.orange,]),
                      //   colorBrightness: ColorBrightness.veryLight,
                      //   colorSaturation: ColorSaturation.highSaturation,
                      // ),
                      elevation: 5.0,

                      child: InkWell(
                        splashColor: Colors.redAccent,
                        onTap: () {
                          childrenwitch(children[i].title);
                        },
                        borderRadius: BorderRadius.circular(25),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(

                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                    color: Colors.white.withOpacity(0.5)),
                                padding: EdgeInsets.all(5),
                                child:children[i].icon!=null? Image.network(
                                  children[i].icon,
                                  height: 25,
                                  width: 25,
                                ):Container(),
                              ),
                              SizedBox(height: 5),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    children[i].title,
                                    style: new TextStyle(
                                        fontSize: 12.0, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                ]),
              ));
        });
  }


}
class RandomHexColor {
  static const Color one = Color(0xffF4A460);
  static const Color two = Color(0xff78AB46);
  static const Color three = Color(0xff2BCAFF);
  static const Color four = Color(0xff838EDE);
  static const Color five = Color(0xffFFDE2B);
  static List<Color> hexColor = [one, two, three,four,five];

  static final _random = Random();

  static Color colorRandom() {
    return hexColor[_random.nextInt(5)];
  }
}