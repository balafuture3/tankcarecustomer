import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:tankcarecustomer/main.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tankcarecustomer/Customer/GroupList.dart';
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/districtlist.dart';
import 'package:tankcarecustomer/CustomerModels/groupview.dart';
import 'package:tankcarecustomer/CustomerModels/statelist.dart';

import '../string_values.dart';

class GroupEdit extends StatefulWidget {
  GroupEdit({Key key, this.groupid});

  String groupid;

  @override
  GroupEditState createState() => GroupEditState();
}

class GroupEditState extends State<GroupEdit> {
  bool loading = false;
  TextEditingController serviceyearcontroller = new TextEditingController();
  TextEditingController PincodeController = new TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController NameController = new TextEditingController();
  TextEditingController GroupContactNameController =
      new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController GroupNumberController = new TextEditingController();
  int statetype = 1;
  int districttype = 1;
  TextEditingController GroupCodeController = new TextEditingController();
  TextEditingController servicetypeController = new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  bool isenable = true;
  bool cameramove = false;
  double latitudecamera, longitudecamera;
  var addressText;
  var first;
  int proprtytype;
  List<String> stringlist1 = [
    '-- Select District --',
    "Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor"
  ];
  GroupView li;
  String dropdownValue1 = '-- Select State --';

  String dropdownValue2 = '-- Select District --';
  var _kGooglePlex;

  StateListings li2;
  DistrictListings li1;

  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'group-view/' + planid;
    print(String_values.base_url);
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
      li = GroupView.fromJson(json.decode(response.body));
      NameController.text = li.groupName;
      GroupCodeController.text = li.groupCode;
      GroupContactNameController.text = li.groupContactName;
      GroupNumberController.text = li.groupContactPhone;
      PincodeController.text = li.groupPincode;
      addressController.text = li.groupAddress;
      if (li.serviceType == "COM")
        servicetypeController.text = "Service Type: Commercial";
      else
        servicetypeController.text = "Service Type: Residential";
      if (li.serviceType == "RES")
        dropdownValue = 'Residential';
      else
        dropdownValue = 'Commercial';
      _kGooglePlex = CameraPosition(
          // bearing: 192.8334901395799,
          target: LatLng(double.parse(li.latitude), double.parse(li.longitude)),
          zoom: 14);
      latitudecamera = double.parse(li.latitude);
      longitudecamera = double.parse(li.longitude);
      // if(li.res.planDatas.planServicetype.toString()=="RES")
      // ServiceTypeController.text="Service Type: Residential";
      // else
      //  ServiceTypeController.text="Service Type: Commercial";
      //  PropertyTypeController.text="Property Type: "+li.res.planDatas.planPropertytypeId;
      // // ServiceTypeController.text="Service Type: "+li.res.planDatas.planServicetype;
      //  SizeRangeControllermin.text=li.res.planDatas.planSizeFrom;
      //  SizeRangeControllermax.text=li.res.planDatas.planSizeTo;
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

  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });

  List<String> stringlist = [
    '-- Property Type --',
    "Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor"
  ];
  bool sort;
  TextEditingController PlanNameController = new TextEditingController();
  TextEditingController ServiceTypeController = new TextEditingController();
  TextEditingController SizeRangeControllermin = new TextEditingController();
  TextEditingController SizeRangeControllermax = new TextEditingController();

  String dropdownValue = 'Commercial';

  static List<String> friendsList = [null];

  void initState() {
    _kGooglePlex = CameraPosition(
        // bearing: 192.8334901395799,
        target: LatLng(0, 0),
        zoom: 17);
    sort = false;
    details(widget.groupid)
        .then((value) => stateRequest())
        .then((value) => districtRequest(li.stateId));
    super.initState();
  }

  Future<http.Response> stateRequest() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'state-list?page=1&limit=50';
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
        li2 = StateListings.fromJson(json.decode(response.body));
        stringlist.clear();
        stringlist.add('-- Select State --');
        for (int i = 0; i < li2.items.length; i++)
          stringlist.add(li2.items[i].stateName);
        dropdownValue1 = stringlist[int.parse(li.stateId)];
        print("drop:${dropdownValue1}");
      });
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
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'district/$stateid';
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
        li1 = DistrictListings.fromJson(json.decode(response.body));
        stringlist1.clear();
        stringlist1.add('-- Select District --');
        for (int i = 0; i < li1.items.length; i++) {
          stringlist1.add(li1.items[i].districtName);
          if(li.districtId==li1.items[i].districtId)
          dropdownValue2 = li1.items[i].districtName;
        }
        print("drop:${dropdownValue2}");
      });
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

  String searchAddr;

  DateTime _dateTime;

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

    Future<http.Response> postRequest() async {
      setState(() {
        loading = true;
      });
      String servicetype;
      // List<PlanServiceYearClass> tags = listplanyear;
      // String jsonTags = jsonEncode(tags);
      // List<PlanListClass> tags1 = listplan;
      // String jsonTags1 = jsonEncode(tags1);
      // print("response: ${jsonEncode(MapPlanServiceYearClass.getdata())}")
      if (dropdownValue == "Residential")
        servicetype = "RES";
      else if (dropdownValue == "Commercial") servicetype = "COM";
      var url = String_values.base_url + 'group-edit';
      Map data = {
        "group_id": widget.groupid,
        "group_name": GroupContactNameController.text,
        "group_address": addressController.text,
        "service_type": servicetype,
        "group_contact_name": GroupContactNameController.text,
        "group_contact_phone": GroupNumberController.text,
        "map_location": addressController.text,
        "latitude": latitudecamera.toString(),
        "longitude": longitudecamera.toString(),
        "district_id": districttype.toString(),
        "state_id": statetype.toString()
      };
      print("data: ${data}");
      print(String_values.base_url);
      //encode Map to JSON
      var body = json.encode(data);
      print("response: ${body}");
      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ${RegisterPagesState.token}'
          },
          body: body);
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GroupList()),
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
    return Scaffold(
      //backgroundColor: Colors.redAccent[100],
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: new Column(
                children: <Widget>[
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
                          "Group Edit",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 50,
                  ),

                  // Container(
                  //   padding: EdgeInsets.all(16),
                  //   width: width,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey,
                  //         offset: Offset(0.0, 1.0), //(x,y)
                  //         blurRadius: 1.0,
                  //       ),
                  //     ],
                  //   ),
                  //   // color: Colors.white,
                  //   margin: EdgeInsets.only(top:10.0,bottom: 10),
                  //
                  //   child: new Text(
                  //     "Group",
                  //     textAlign: TextAlign.left,
                  //     style:
                  //     TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  //   ),
                  // ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: NameController,
                        decoration: InputDecoration(
                          labelText: 'Group Name',
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: GroupCodeController,
                        decoration: InputDecoration(
                          labelText: 'Group Code',
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: GroupContactNameController,
                        decoration: InputDecoration(
                          labelText: 'Group Contact Name',
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: GroupNumberController,
                        decoration: InputDecoration(
                          labelText: 'Group Contact Mobile',
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
                  Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        border: new Border.all(color: Colors.black38)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          '-- Service Type --',
                          "Residential",
                          "Commercial"
                        ].map<DropdownMenuItem<String>>((String value) {
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        minLines: 3,
                        maxLines: 10,
                        controller: addressController,
                        decoration: InputDecoration(
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
                  Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      height: height / 2,
                      child: Stack(children: <Widget>[
                        GoogleMap(
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                          zoomControlsEnabled: true,
                          mapType: MapType.normal,
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },

                          onCameraIdle: () async {
                            if (cameramove == true) {
                              // placemark = await Geolocator()
                              //     .placemarkFromCoordinates(
                              //         latitudecamera, longitudecamera);
                              final coordinates = new Coordinates(
                                  latitudecamera, longitudecamera);
                              addressText = await Geocoder.local
                                  .findAddressesFromCoordinates(coordinates);
                              this.first = addressText.first;
                              //  print("moved" + value.target.latitude.toString());
                              setState(() {
                                cameramove = true;
                                addressController.text = "";
                                if (this.first != "")
                                  addressController.text =
                                      '${this.first.addressLine}';

                                cameramove = false;
                              });

                              // print(value.longitude);
                            }
                          },
                          onCameraMove: ((value) async {
                            latitudecamera = value.target.latitude;
                            longitudecamera = value.target.longitude;
                            //  print("moved" + value.target.latitude.toString());
                            setState(() {
                              cameramove = true;
                            });
                            // print(value.longitude);
                          }),
                          // markers: markers,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Align(
                            alignment: Alignment.center,
                            child: new Icon(
                              Icons.location_on,
                              size: 50.0,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ])),
                  SizedBox(
                    height: height / 80,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            for (int i = 0; i < li2.items.length; i++)
                              if (li2.items[i].stateName == newValue) {
                                statetype = int.parse(li2.items[i].stateId);

                                districtRequest(li2.items[i].stateId);
                              }

                            dropdownValue1 = newValue;
                            statetype = stringlist.indexOf(newValue);
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
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            dropdownValue2 = newValue;
                            districttype = stringlist1.indexOf(newValue);
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextField(
                        controller: PincodeController,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: FlatButton(
                            onPressed: () {
                              check().then((value) {
                                if (value) {
                                  if (NameController.text.length != 0 &&
                                      GroupNumberController.text.length != 0 &&
                                      NameController.text.length != 0 &&
                                      dropdownValue != '-- Service Type --' &&
                                      dropdownValue1 != '-- Select State --' &&
                                      dropdownValue2 !=
                                          '-- Select District --' &&
                                      addressController.text.length != 0)
                                    postRequest();
                                  else {
                                    if (NameController.text.length == 0)
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Group name cannot be empty"),
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
                                    else if (GroupNumberController
                                            .text.length ==
                                        0)
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Group number cannot be empty"),
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
                                    else if (GroupNumberController
                                            .text.length ==
                                        0)
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Group Contact Name cannot be empty"),
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
                                    else if (dropdownValue ==
                                        '-- Service Type --')
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Please Choose Service Type"),
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
                                    else if (dropdownValue1 ==
                                        '-- Select State --')
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
                                            title:
                                                Text("Please Choose District"),
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
                                  }
                                } else
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
                            },
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  // DataTable(
                  //   showBottomBorder: true,
                  //   showCheckboxColumn: true,
                  //   columns: [
                  //     DataColumn(label: Text("Name")),
                  //     DataColumn(label: Text("Year")),
                  //     DataColumn(label: Text("Plan")),
                  //     DataColumn(label: Text("Action")),
                  //   ],
                  //   rows: [
                  //     DataRow(cells: [
                  //       DataCell(Text("BalaKumar")),
                  //       DataCell(Text("2020")),
                  //       DataCell(Text("to get above 80k")),
                  //       DataCell(IconButton(
                  //         icon: Icon(Icons.add),
                  //         onPressed: () {},
                  //       ))
                  //     ]),
                  //     DataRow(cells: [
                  //       DataCell(Text("BalaKumar")),
                  //       DataCell(Text("2021")),
                  //       DataCell(Text("to get above 120k")),
                  //       DataCell(IconButton(
                  //         icon: Icon(Icons.add),
                  //         onPressed: () {},
                  //       ))
                  //     ]),
                  //   ],
                  // ),
                  // DataTable(
                  //   sortAscending: sort,
                  //   sortColumnIndex: 0,
                  //   columns: [
                  //     DataColumn(
                  //         label: Text("Plan Name", style: TextStyle(fontSize: 14)),
                  //         numeric: false,
                  //
                  //         // onSort: (columnIndex, ascending) {
                  //         //   onSortColum(columnIndex, ascending);
                  //         //   setState(() {
                  //         //     sort = !sort;
                  //         //   });
                  //         // }
                  //         ),
                  //     DataColumn(
                  //
                  //       label: Text("Total Services", style: TextStyle(fontSize: 14)),
                  //       numeric: false,
                  //     ),
                  //     DataColumn(
                  //
                  //       label: Text("Actions", style: TextStyle(fontSize: 14)),
                  //       numeric: false,
                  //     ),
                  //   ],
                  //   rows: listplan
                  //       .map(
                  //         (list) => DataRow(
                  //             selected: selectedAvengers.contains(list),
                  //             cells: [
                  //               DataCell(
                  //                 Text(list.name),
                  //                 onTap: () {
                  //                   print('Selected ${list.name}');
                  //                 },
                  //               ),
                  //               DataCell(
                  //                 Text(list.totalservices),
                  //               ),
                  //               DataCell(
                  //                 IconButton(icon:Icon(Icons.remove_circle_outline),onPressed: (){
                  //                   setState(() {
                  //                     listplan.remove(list);
                  //                   });
                  //                 }),
                  //               ),
                  //             ]),
                  //       )
                  //       .toList(),
                  // ),

                  // ...listdetails(),
                ],
              ),
            ),

     appBar: AppBar(
  title: Image.asset('logotitle.png',height: 40),
),
floatingActionButton: FloatingActionButton.extended(
  onPressed: () {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => Home(firsttime:false)),
          (Route<dynamic> route) => false,
    );
  },
  icon: Icon(Icons.dashboard_outlined),
  label: Text('Dashboard'),
  backgroundColor: Colors.red,
),
    );
  }
}
