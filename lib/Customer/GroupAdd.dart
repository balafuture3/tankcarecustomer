import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:tankcarecustomer/CustomerModels/ErrorResponse.dart';
import 'package:tankcarecustomer/CustomerModels/GroupAddSelCus.dart';
import 'package:tankcarecustomer/CustomerModels/State.dart';
import 'package:tankcarecustomer/main.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/districtlist.dart';
import 'package:tankcarecustomer/CustomerModels/groupadd.dart';

import 'package:tankcarecustomer/string_values.dart';

import 'GroupList.dart';

class GroupAdd extends StatefulWidget {
  @override
  GroupAddState createState() => GroupAddState();
}

class GroupAddState extends State<GroupAdd> {
  Set<Marker> markers = Set();
  bool isenable = true;
  bool cameramove = false;
  double latitudecamera, longitudecamera;
  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  List<PlanListClass> listplan;
  var addressText;
  var first;
  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.127123, 78.656891),
    zoom: 14,
  );
  TextEditingController serviceyearcontroller = new TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  List<PlanListClass> selectedAvengers;
  final TextEditingController _typeAheadController = TextEditingController();
  bool sort;

  String dropdownValue = '-- Service Type --';
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
  String dropdownValue1 = '-- Select State --';
  int proprtytype = 0;
  List<Placemark> placemark;
  String dropdownValue2 = '-- Select District --';

  static List<String> friendsList = [null];
  static LatLng _initialPosition;
  TextEditingController NameController = new TextEditingController();

  TextEditingController SizeControllerFrom = new TextEditingController();
  TextEditingController PincodeController = new TextEditingController();
  TextEditingController SizeControllerTo = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  var loading = false;
  Position position;
  TextEditingController GroupNameController = new TextEditingController();
  TextEditingController GroupNumberController = new TextEditingController();

  TextEditingController addressController = new TextEditingController();

  States li;

  DistrictListings li1;

  int statetype = 1;
  int districttype = 1;

  GroupAdd li2;

  String cusid;

  ErrorResponse ei;

  void initState() {
    sort = false;
    selectedAvengers = [];
    listplan = PlanListClass.getdata();
    _currentposition().then((value) {
      latitudecamera = position.latitude;
      longitudecamera = position.longitude;
    });
    stateRequest();

    listplanyear = PlanServiceYearClass.getdata();
    List<PlanServiceYearClass> tags = PlanServiceYearClass.getdata();
    String jsonTags = jsonEncode(tags);
    // print("res:${jsonTags}");
//    print("response: ${PlanServiceYearClass.toJson()}");
    super.initState();
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
      li = States.fromJson(json.decode(response.body));

      stringlist.clear();
      stringlist.add('-- Select State --');
      for (int i = 0; i < li.items.length; i++)
        stringlist.add(li.items[i].stateName);
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
        li1 = DistrictListings.fromJson(json.decode(response.body));
        stringlist1.clear();

        stringlist1.add('-- Select District --');
        for (int i = 0; i < li1.items.length; i++)
          stringlist1.add(li1.items[i].districtName);
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

  Future<void> _currentposition() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    addressText =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.first = addressText.first;
    print("test" "${this.first.featureName} : ${this.first.addressLine}");
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      Marker resultMarker = Marker(
        //  onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context) => MapSample()));},

        markerId: MarkerId("I'm Here"),

        draggable: true,

        onDragEnd: ((value) async {
          placemark = await Geolocator()
              .placemarkFromCoordinates(value.latitude, value.longitude);
          //   print("Full Address - " + address.toString());
          print("dragged" + value.latitude.toString());

          final coordinates =
          new Coordinates(position.latitude, position.longitude);
          addressText =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
          this.first = addressText.first;
          print("test" "${this.first.featureName} : ${this.first.addressLine}");
          setState(() {
            _kGooglePlex = CameraPosition(
              // bearing: 192.8334901395799,
                target: LatLng(value.latitude, value.longitude),
                zoom: 14);
            addressController.text = "";
            if (this.first != "")
              addressController.text = '${this.first.addressLine}';
            // if (placemark[0].subLocality != "")
            //   addressController.text =
            //       addressController.text + " ${placemark[0].subLocality}, ";
            // if (placemark[0].locality != "")
            //   addressController.text =
            //       addressController.text + " ${placemark[0].locality}, ";
            // if (placemark[0].subAdministrativeArea != "")
            //   addressController.text = addressController.text +
            //       " ${placemark[0].subAdministrativeArea}, ";
            // if (placemark[0].administrativeArea != "")
            //   addressController.text = addressController.text +
            //       " ${placemark[0].administrativeArea}, ";
            // if (placemark[0].country != "")
            //   addressController.text =
            //       addressController.text + " ${placemark[0].country}";
          });
          // print(value.longitude);
        }),

        position: LatLng(position.latitude, position.longitude),
      );
      markers.add(resultMarker);
      // print('${placemark[0].name}');
      // print('${placemark[0].locality}');
      // print('${placemark[0].administrativeArea}');
      print('${placemark[0].postalCode}');
      print('${this.first.addressLine}');

      addressController.text = "";
      if (this.first != "")
        addressController.text = '${this.first.addressLine}';
      // if (placemark[0].subLocality != "")
      //   addressController.text =
      //       addressController.text + " ${placemark[0].subLocality}, ";
      // if (placemark[0].locality != "")
      //   addressController.text =
      //       addressController.text + " ${placemark[0].locality}, ";
      // if (placemark[0].subAdministrativeArea != "")
      //   addressController.text =
      //       addressController.text + " ${placemark[0].subAdministrativeArea}, ";
      // if (placemark[0].administrativeArea != "")
      //   addressController.text =
      //       addressController.text + " ${placemark[0].administrativeArea}, ";
      // if (placemark[0].country != "")
      //   addressController.text =
      //       addressController.text + " ${placemark[0].country}";
    });
    GoogleMapController controller = await _controller.future;
    _kGooglePlex = CameraPosition(
      // bearing: 192.8334901395799,
        target: LatLng(position.latitude, position.longitude),
        zoom: 17);
    print(position.latitude);
    print(position.longitude);
    controller.moveCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  String searchAddr;

  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    Future<http.Response> postRequest() async {
      setState(() {
        loading = true;
      });
      String servicetype;
      List<PlanServiceYearClass> tags = listplanyear;
      String jsonTags = jsonEncode(tags);
      List<PlanListClass> tags1 = listplan;
      String jsonTags1 = jsonEncode(tags1);
      // print("response: ${jsonEncode(MapPlanServiceYearClass.getdata())}")
      if (dropdownValue == "Residential")
        servicetype = "RES";
      else if (dropdownValue == "Commercial") servicetype = "COM";
      var url = String_values.base_url + 'group-add';
      Map data = {
        //"group_name":"Test", "group_address":"123 Coimbaotre, Tamilnadu", "service_type":"RES", "group_contact_name":"Raj", "group_contact_phone":"9597318426", "map_location":"123 Coimbaotre, Tamilnadu", "latitude":"1234657", "longitude":"12346578", "district_id":"1", "state_id":"1"}
        // "cus_id": cusid,
        "group_name": NameController.text,
        "group_address": addressController.text,
        "service_type": servicetype,
        "group_contact_name": GroupNameController.text,
        "group_contact_phone": GroupNumberController.text,
        "map_location": addressController.text,
        "group_pincode": PincodeController.text,
        "latitude": latitudecamera.toString(),
        "longitude": longitudecamera.toString(),
        "district_id": districttype,
        "state_id": statetype
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
        if(response.body.toString().contains("true")) {
          Fluttertoast.showToast(
              msg: "Group Added Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GroupList()),
          );
        }
        else
        {
          ei=ErrorResponse.fromJson(jsonDecode(response.body));
          Fluttertoast.showToast(
              msg: ei.messages,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }



        setState(() {
          loading = false;
        });
        //li2= GroupAdd.fromJson(json.decode(response.body));
        // if(li2.status)

        // else
        //   showDialog<void>(
        //     context: context,
        //     barrierDismissible: false, // user must tap button!
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         backgroundColor: Colors.white,
        //         title: Text("Group Name Already Exist"),
        //         actions: <Widget>[
        //           TextButton(
        //             child: Text('OK'),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //       );
        //     },
        //   );
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
                    "New Group",
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
              height: height / 40,
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
            //         TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            //   ),
            // ),
            // SizedBox(
            //   height: height / 50,
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            //   child: TypeAheadFormField(
            //     textFieldConfiguration: TextFieldConfiguration(
            //       enabled: true,
            //       controller: this._typeAheadController,
            //       // onTap: ()
            //       // {
            //       //   Navigator.push(
            //       //       context,
            //       //       MaterialPageRoute(
            //       //           builder: (context) =>
            //       //               Category(userid:HomeState.userid,mapselection: true)));
            //       // },
            //       keyboardType: TextInputType.text,
            //       decoration: InputDecoration(
            //         labelText: 'Select Customer Name',
            //         hintStyle: TextStyle(
            //           color: Colors.grey,
            //           fontSize: 16.0,
            //         ),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(5.0),
            //         ),
            //       ),
            //     ),
            //     suggestionsCallback: (pattern) {
            //       return BackendService.getSuggestions(pattern);
            //     },
            //     itemBuilder: (context, suggestion) {
            //       return ListTile(
            //         title: Text(suggestion),
            //       );
            //     },
            //     transitionBuilder: (context, suggestionsBox, controller) {
            //       return suggestionsBox;
            //     },
            //     onSuggestionSelected: (suggestion) {
            //       // postRequest(suggestion);
            //       for (int i = 0;
            //       i < BackendService.li1.data.length;
            //       i++) {
            //         print(BackendService.li1.data[i].cusName);
            //         if (BackendService.li1.data[i].cusName ==
            //             suggestion) {
            //           cusid = BackendService.li1.data[i].cusId;
            //         }
            //       }
            //       this._typeAheadController.text = suggestion;
            //     },
            //     validator: (value) {
            //       if (value.isEmpty) {
            //         return 'Please select a city';
            //       } else
            //         return 'nothing';
            //     },
            //     // onSaved: (value) => this._selectedCity = value,
            //   ),
            // ),
            // SizedBox(
            //   height: height / 50,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                child: new TextField(
                  controller: NameController,
                  decoration: InputDecoration(
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
            ),
            SizedBox(
              height: height / 80,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                child: new TextField(
                  controller: GroupNameController,
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
                child: new TextField(
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: GroupNumberController,
                  decoration: InputDecoration(
                    counterText: "",
                    labelText: 'Group Contact Mobile No',
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
              height: height / 50,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Please select address by moving the map",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height / 50,
            ),

            _kGooglePlex!=null?Container(
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
                ])):Container(),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5.0),
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey,
            //         offset: Offset(0.0, 1.0), //(x,y)
            //         blurRadius: 0.2,
            //       ),
            //     ],
            //   ),
            //   // decoration: new BoxDecoration(
            //   //     borderRadius:BorderRadius.all(Radius.circular(2.0)),
            //   //     border: new Border.all(color: Colors.red)
            //   // ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       new Flexible(
            //         flex: 3,
            //         child: Padding(
            //           padding: const EdgeInsets.only(left: 10.0),
            //           child: new TextFormField(
            //             initialValue: "Service Year",
            //             maxLines: 2,
            //             minLines: 2,
            //             textAlign: TextAlign.center,
            //             enabled: false,
            //             style: TextStyle(
            //                 fontSize: 12,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w800),
            //             decoration: InputDecoration(
            //               border: InputBorder.none,
            //             ),
            //           ),
            //         ),
            //       ),
            //       new Flexible(
            //         flex: 3,
            //         child: Padding(
            //           padding: const EdgeInsets.only(
            //             left: 10.0,
            //           ),
            //           child: new TextFormField(
            //             initialValue: "Total Services",
            //             maxLines: 2,
            //             minLines: 2,
            //             textAlign: TextAlign.center,
            //             enabled: false,
            //             style: TextStyle(
            //                 fontSize: 12,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w800),
            //             decoration: InputDecoration(
            //               border: InputBorder.none,
            //             ),
            //           ),
            //         ),
            //       ),
            //       new Flexible(
            //         flex: 3,
            //         child: Padding(
            //           padding: const EdgeInsets.only(left: 10.0),
            //           child: new TextFormField(
            //             initialValue: "Liter Price",
            //             maxLines: 2,
            //             minLines: 2,
            //             textAlign: TextAlign.center,
            //             enabled: false,
            //             style: TextStyle(
            //                 fontSize: 12,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w800),
            //             decoration: InputDecoration(
            //               border: InputBorder.none,
            //             ),
            //           ),
            //         ),
            //       ),
            //       new Flexible(
            //         flex: 3,
            //         child: Padding(
            //           padding: const EdgeInsets.only(left: 10.0),
            //           child: new TextFormField(
            //             initialValue: "Fixed Price",
            //             maxLines: 2,
            //             minLines: 2,
            //             textAlign: TextAlign.center,
            //             enabled: false,
            //             style: TextStyle(
            //                 fontSize: 12,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w800),
            //             decoration: InputDecoration(
            //               border: InputBorder.none,
            //             ),
            //           ),
            //         ),
            //       ),
            //       new Flexible(
            //           flex: 2,
            //           child: Padding(
            //             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            //             child: new TextFormField(
            //               initialValue: "Action",
            //               maxLines: 2,
            //               minLines: 2,
            //               textAlign: TextAlign.center,
            //               enabled: false,
            //               style: TextStyle(
            //                   fontSize: 12,
            //                   color: Colors.black,
            //                   fontWeight: FontWeight.w800),
            //               decoration: InputDecoration(
            //                 border: InputBorder.none,
            //               ),
            //             ),
            //           ))
            //     ],
            //   ),
            // ),
            SizedBox(
              height: height / 80,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                child: new TextField(
                  minLines: 3,
                  maxLines: 15,
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
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5.0),
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey,
            //         offset: Offset(0.0, 1.0), //(x,y)
            //         blurRadius: 0.2,
            //       ),
            //     ],
            //   ),
            //   // decoration: new BoxDecoration(
            //   //     borderRadius:BorderRadius.all(Radius.circular(2.0)),
            //   //     border: new Border.all(color: Colors.red)
            //   // ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       new Flexible(
            //         flex: 3,
            //         child: Padding(
            //           padding: const EdgeInsets.only(left: 10.0),
            //           child: new TextFormField(
            //             initialValue: "Plan Name",
            //             maxLines: 2,
            //             minLines: 2,
            //             textAlign: TextAlign.center,
            //             enabled: false,
            //             style: TextStyle(
            //                 fontSize: 12,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w800),
            //             decoration: InputDecoration(
            //               border: InputBorder.none,
            //             ),
            //           ),
            //         ),
            //       ),
            //       new Flexible(
            //         flex: 3,
            //         child: Padding(
            //           padding: const EdgeInsets.only(left: 10.0),
            //           child: new TextFormField(
            //             initialValue: "Total Services",
            //             maxLines: 2,
            //             minLines: 2,
            //             textAlign: TextAlign.center,
            //             enabled: false,
            //             style: TextStyle(
            //                 fontSize: 12,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w800),
            //             decoration: InputDecoration(
            //               border: InputBorder.none,
            //             ),
            //           ),
            //         ),
            //       ),
            //       new Flexible(
            //           flex: 2,
            //           child: Padding(
            //             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            //             child: new TextFormField(
            //               initialValue: "Action",
            //               maxLines: 2,
            //               minLines: 2,
            //               textAlign: TextAlign.center,
            //               enabled: false,
            //               style: TextStyle(
            //                   fontSize: 12,
            //                   color: Colors.black,
            //                   fontWeight: FontWeight.w800),
            //               decoration: InputDecoration(
            //                 border: InputBorder.none,
            //               ),
            //             ),
            //           )),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       new Flexible(
            //         flex: 3,
            //         child: Container(
            //           height: height / 20,
            //           padding: EdgeInsets.all(5),
            //           child: new TextFormField(
            //             initialValue: "0.3",
            //             enabled: false,
            //             textAlign: TextAlign.center,
            //             style: TextStyle(fontSize: 12),
            //             decoration: InputDecoration(
            //               hintStyle: TextStyle(
            //                 color: Colors.grey,
            //                 fontSize: 16.0,
            //               ),
            //               border: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(5.0),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       new Flexible(
            //         flex: 3,
            //         child: Container(
            //           height: height / 20,
            //           padding: EdgeInsets.all(5),
            //           child: new TextFormField(
            //             initialValue: "299",
            //             enabled: false,
            //             textAlign: TextAlign.center,
            //             style: TextStyle(fontSize: 12),
            //             decoration: InputDecoration(
            //               hintStyle: TextStyle(
            //                 color: Colors.grey,
            //                 fontSize: 16.0,
            //               ),
            //               border: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(5.0),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       new Flexible(
            //         flex: 2,
            //         child: Container(
            //             height: height / 20,
            //             child: IconButton(
            //               icon: Icon(Icons.remove_circle_outline),
            //               onPressed: () {},
            //             )),
            //       ),
            //     ],
            //   ),
            // ),

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
                      for (int i = 0; i < li.items.length; i++)
                        if (li.items[i].stateName == newValue) {
                          statetype = int.parse(li.items[i].stateId);

                          districtRequest(li.items[i].stateId);
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
                      for (int i = 0; i < li1.items.length; i++)
                        if (li1.items[i].districtName == newValue) {
                          districttype =
                              int.parse(li1.items[i].districtId);
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
                        if (PincodeController.text.length == 6 &&
                            NameController.text.length != 0 &&
                            GroupNumberController.text.length != 0 &&
                            GroupNameController.text.length != 0 &&
                            dropdownValue != '-- Service Type --' &&
                            dropdownValue1 != '-- Select State --' &&
                            dropdownValue2 != '-- Select District --' &&
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
                                  title:
                                  Text("Group name cannot be empty"),
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
                          else if (GroupNumberController.text.length == 0)
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
                          else if (PincodeController.text.length != 6)
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                  Text("Pincode Should be 6 digits"),
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
                          else if (GroupNumberController.text.length == 0)
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
                          else if (dropdownValue == '-- Service Type --')
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                  Text("Please Choose Service Type"),
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
                                );
                              },
                            );
                        }
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

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        listplan.sort((a, b) => a.name.compareTo(b.name));
      } else {
        listplan.sort((a, b) => b.name.compareTo(a.name));
      }
    }
  }
}

class BackendService {
  static EmployeeGroupAddSelectCusModel li1;

  static Future<List> getSuggestions(String query) async {
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
    String_values.base_url + 'find-customer?search=${query}';

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      li1 = EmployeeGroupAddSelectCusModel.fromJson(json.decode(response.body));
      List<String> s = new List();
      if (li1.data.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li1.data.length; i++)
          s.add(li1.data[i].cusName.toString());
        print(s);
        return s;
      }
      // }
      // else {
      //
      //   print("not contains list");
      //   //return "" as List;
      // }

      //["result"];
      // print(json.decode(response.body)["result"]["categoryName"]);
    } else {
      print("Retry");
    }
  }
}

class PlanListClass {
  String name;
  String totalservices;

  PlanListClass({this.name, this.totalservices});

  Map<String, dynamic> toJson() {
    return {
      'plan_name': name,
      'total_service': totalservices,
    };
  }

  static List<PlanListClass> getdata() {
    return <PlanListClass>[];
  }
}

class PlanServiceYearClass {
  String serviceyear;
  String totalservices;
  String literprice;
  String fixedprice;

  PlanServiceYearClass(
      {this.serviceyear, this.totalservices, this.literprice, this.fixedprice});

  Map<String, dynamic> toJson() {
    return {
      'service_year': serviceyear,
      'total_service': totalservices,
      'liter_price': literprice,
      'fixed_price': fixedprice
    };
  }

  static List<PlanServiceYearClass> getdata() {
    return <PlanServiceYearClass>[];
  }
}
