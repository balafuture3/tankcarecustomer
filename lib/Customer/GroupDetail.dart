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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/districtlist.dart';
import 'package:tankcarecustomer/CustomerModels/groupview.dart';
import 'package:tankcarecustomer/CustomerModels/statelist.dart';

import '../string_values.dart';

class GroupDetail extends StatefulWidget {
  GroupDetail({Key key, this.groupid});

  String groupid;

  @override
  GroupDetailState createState() => GroupDetailState();
}

class GroupDetailState extends State<GroupDetail> {
  bool loading = false;
  GroupView li;

  var _kGooglePlex;

  StateListings li2;

  DistrictListings li3;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

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
      GroupNameController.text = li.groupName;
      GroupCodeController.text = li.groupCode;
      GroupContactNameController.text = li.groupContactName;
      GroupContactMobileController.text = li.groupContactPhone;
      PincodeController.text = li.groupPincode;
      addressController.text = li.groupAddress;
      CustomerNameController.text = li.cusName;
      if (li.serviceType == "COM")
        servicetypeController.text = "Commercial";
      else
        servicetypeController.text = "Residential";
      li.latitude!=null?
      _kGooglePlex = CameraPosition(
          // bearing: 192.8334901395799,
          target: LatLng(double.parse(li.latitude), double.parse(li.longitude)),
          zoom: 14):  _kGooglePlex = CameraPosition(
        // bearing: 192.8334901395799,
          target: LatLng(0,0));
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
        li2 = StateListings.fromJson(json.decode(response.body));
        stateController.text = li2.items[int.parse(li.stateId) - 1].stateName;
      });
      print("state:${stateController}");
      // for(int i=0;i<li.items.length;i++)
      //   stringlist.add(li.items[i].stateName);
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

  Future<http.Response> districtRequest() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'district/${li.stateId}';
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
        li3 = DistrictListings.fromJson(json.decode(response.body));
        for(int i=0;i<li3.items.length;i++)
        if(li.districtId==li3.items[i].districtId)

        districtController.text =
            li3.items[i].districtName;
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

  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  List<PlanListClass> listplan;
  TextEditingController serviceyearcontroller = new TextEditingController();
  TextEditingController CustomerNameController = new TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  TextEditingController GroupNameController = new TextEditingController();
  TextEditingController GroupContactNameController =
      new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController GroupContactMobileController =
      new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController GroupCodeController = new TextEditingController();
  TextEditingController servicetypeController = new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController PincodeController = new TextEditingController();

//  TextEditingController SizeRangeControllermax = new TextEditingController();
  List<PlanListClass> selectedAvengers;
  bool sort;

  String dropdownValue = '-- Service Type --';

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Select Plan --';

  static List<String> friendsList = [null];

  void initState() {
    check().then((value) {
      if (value)
        details(widget.groupid)
            .then((value) => li.stateId!=null?stateRequest():null)
            .then((value) => li.districtId!=null?districtRequest():null);
    });
    sort = false;
    //stateRequest();
    //  districtRequest();
    selectedAvengers = [];
    listplan = PlanListClass.getdata();
    listplanyear = PlanServiceYearClass.getdata();
    super.initState();
  }

  String searchAddr;

  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
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
                          "Group Details",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: height / 40,
                  // ),
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
                        controller: GroupNameController,
                        enabled: false,
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
                        enabled: false,
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
                        enabled: false,
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
                        controller: GroupContactMobileController,
                        enabled: false,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: servicetypeController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Service Type',
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
                        controller: CustomerNameController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Customer Name',
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
                        minLines: 3,
                        maxLines: 10,
                        controller: addressController,
                        enabled: false,
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
                          zoomControlsEnabled: true,
                          mapType: MapType.normal,
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                        // markers: markers,

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
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: stateController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'State',
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
                        controller: districtController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'District',
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
                        controller: PincodeController,
                        enabled: false,
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
                    height: height / 80,
                  ),
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

class PlanListClass {
  String name;
  String totalservices;

  PlanListClass({this.name, this.totalservices});

  static List<PlanListClass> getdata() {
    return <PlanListClass>[
      PlanListClass(name: "Below 1000L", totalservices: "1 "),
      PlanListClass(name: "1000L - 2000L", totalservices: "5"),
      PlanListClass(name: "Above 2000L", totalservices: "2"),
      PlanListClass(name: "2000L -  4000L ", totalservices: "6"),
    ];
  }
}

class PlanServiceYearClass {
  String serviceyear;
  String totalservices;
  String literprice;
  String fixedprice;

  PlanServiceYearClass(
      {this.serviceyear, this.totalservices, this.literprice, this.fixedprice});

  static List<PlanServiceYearClass> getdata() {
    return <PlanServiceYearClass>[
      PlanServiceYearClass(
          serviceyear: "1999"
              "",
          totalservices: "1 ",
          literprice: "10",
          fixedprice: "299"),
      PlanServiceYearClass(
          serviceyear: "2003",
          totalservices: "5",
          literprice: "10",
          fixedprice: "299"),
      PlanServiceYearClass(
          serviceyear: "2019",
          totalservices: "2",
          literprice: "10",
          fixedprice: "299"),
      PlanServiceYearClass(
          serviceyear: "2020",
          totalservices: "6",
          literprice: "10",
          fixedprice: "299"),
    ];
  }
}
