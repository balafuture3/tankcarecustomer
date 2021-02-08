import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
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
import 'package:tankcarecustomer/Customer/PlanRenewal.dart';
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/districtlist.dart';
import 'package:tankcarecustomer/CustomerModels/plandetail.dart';
import 'package:tankcarecustomer/CustomerModels/statelist.dart';

import '../string_values.dart';

class PlanDetail extends StatefulWidget {
  PlanDetail({Key key, this.planid});

  String planid;

  @override
  PlanDetailState createState() => PlanDetailState();
}

class PlanDetailState extends State<PlanDetail> {
  bool loading = false;
  PlanDetailListings li;

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
    var url = String_values.base_url + 'property-plan-view/?planid=' + planid;
    print(url);
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
      li = PlanDetailListings.fromJson(json.decode(response.body));
      setState(() {
        PropertyNameController.text = li.property.propertyName.toString();
        GroupNameController.text = li.property.groupName.toString();
        ServiceController.text = li.property.serviceType.toString();
        PropertyCodeController.text = li.property.propertyCode.toString();
        PropertyTypeController.text = li.property.propertyTypeName.toString();
        valuecontroller.text = li.property.propertyValue.toString();
        if (li.property.propertyStatus.toString() == "A")
          statusController.text = "Active";
        else if (li.property.propertyStatus.toString() == "P")
          statusController.text = "Pending";
        else if (li.property.propertyStatus.toString() == "C")
          statusController.text = "Completed";
        else if (li.property.propertyStatus.toString() == "O")
          statusController.text = "Ongoing";
        // statusController.text=li.property.propertyStatus.toString();

        PlanController.text = li.plan.pplanName.toString();
        PlanYearController.text = li.plan.pplanYear.toString();
        PlanServiceController.text = li.plan.pplanService.toString();
        priceController.text = li.plan.pplanPrice.toString();
        datecontroller.text =DateFormat('dd/MM/yyyy').format(
            DateTime.parse( li.plan.pplanStartDate.toString()));
        PlanPaidStatusController.text = li.plan.pplanPaidStatus.toString();

        PlanCurrentStatusController.text =
            li.plan.pplanCurrentStatus.toString();
      });

      //    GroupCodeController.text="Group Code: "+li.groupCode;
      //    GroupContactNameController.text="Group Contact Name: "+li.groupContactName;
      //    GroupContactMobileController.text="Group Contact Mobile : "+li.groupContactPhone;
      //    addressController.text="Address:\n\n"+li.groupAddress;
      //    if(li.serviceType=="COM")
      //    servicetypeController.text="Service Type: Commercial";
      //    else
      //      servicetypeController.text="Service Type: Residential";
      //
      // _kGooglePlex = CameraPosition(
      //   // bearing: 192.8334901395799,
      //     target: LatLng(double.parse(li.latitude),double.parse(li.longitude)),
      //     zoom: 17);
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
        // stateController.text=li2.items[int.parse(li.stateId)-1].stateName;
      });
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

    var url = String_values.base_url + 'district-list';
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
        // districtController.text=li3.items[int.parse(li.districtId)-1].districtName;
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
  TextEditingController ServiceController = new TextEditingController();
  TextEditingController PlanPaidStatusController = new TextEditingController();
  TextEditingController PlanCurrentStatusController =
      new TextEditingController();
  TextEditingController PropertyCodeController = new TextEditingController();
  TextEditingController PropertyNameController = new TextEditingController();
  TextEditingController valuecontroller = new TextEditingController();
  TextEditingController PlanController = new TextEditingController();
  TextEditingController PlanServiceController = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  TextEditingController priceController = new TextEditingController();
  TextEditingController GroupNameController = new TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController GroupContactMobileController =
      new TextEditingController();
  TextEditingController datecontroller = new TextEditingController();
  TextEditingController TotalServicesController = new TextEditingController();
  TextEditingController GroupCodeController = new TextEditingController();
  TextEditingController servicetypeController = new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController PlanYearController = new TextEditingController();

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
        details(widget.planid);
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
                          "Plan Details",
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
                  Container(
                    padding: EdgeInsets.all(16),
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    // color: Colors.white,
                    margin: EdgeInsets.only(top: 10.0, bottom: 10),

                    child: new Text(
                      "Property Details",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: PropertyNameController,
                      decoration: InputDecoration(
                        labelText: 'Property Name',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: GroupNameController,
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
                  SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: ServiceController,
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
                  SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: PropertyCodeController,
                      decoration: InputDecoration(
                        labelText: 'Property Code',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: PropertyTypeController,
                      decoration: InputDecoration(
                        labelText: 'Property Type',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: valuecontroller,
                      decoration: InputDecoration(
                        labelText: 'Property Value',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: statusController,
                      decoration: InputDecoration(
                        labelText: 'Status',
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
                  Container(
                    padding: EdgeInsets.all(16),
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    // color: Colors.white,
                    margin: EdgeInsets.only(top: 10.0, bottom: 10),

                    child: new Text(
                      "Plan Details",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    height: height / 50,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: PlanController,
                      decoration: InputDecoration(
                        labelText: 'Plan Name',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: PlanYearController,
                      decoration: InputDecoration(
                        labelText: 'Plan Year',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: PlanServiceController,
                      decoration: InputDecoration(
                        labelText: 'Plan Service',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: datecontroller,
                      decoration: InputDecoration(
                        labelText: 'Plan Start Date',
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
                  // Container(
                  //   padding: const EdgeInsets.only(right: 24, left: 50),
                  //   height: 80,
                  //   child: TextField(
                  //     onTap: () async {
                  //       DateTime date = DateTime(1900);
                  //       FocusScope.of(context)
                  //           .requestFocus(new FocusNode());
                  //
                  //       date = await showDatePicker(
                  //           context: context,
                  //           initialDate: DateTime.now(),
                  //           firstDate: DateTime.now()
                  //               .subtract(new Duration(days: 23725)),
                  //           lastDate: DateTime.now());
                  //       /*    var time =await showTimePicker(
                  //             initialTime: TimeOfDay.now(),
                  //             context: context,
                  //           );*/
                  //       sql_dob = dateFormatter.format(date);
                  //       print("date" + sql_dob);
                  //       var month = date.month.toString();
                  //       if (date.month == 1)
                  //         month = 'January';
                  //       else if (date.month == 2)
                  //         month = 'February';
                  //       else if (date.month == 3)
                  //         month = 'March';
                  //       else if (date.month == 4)
                  //         month = 'April';
                  //       else if (date.month == 5)
                  //         month = 'May';
                  //       else if (date.month == 6)
                  //         month = 'June';
                  //       else if (date.month == 7)
                  //         month = 'July';
                  //       else if (date.month == 8)
                  //         month = 'August';
                  //       else if (date.month == 9)
                  //         month = 'September';
                  //       else if (date.month == 10)
                  //         month = 'October';
                  //       else if (date.month == 11)
                  //         month = 'November';
                  //       else if (date.month == 12) month = 'December';
                  //
                  //
                  //
                  //       if (date.day == 1 ||
                  //           date.day == 21 ||
                  //           date.day == 31) {
                  //         datecontroller.text = date.day.toString() +
                  //             'st ' +
                  //             month +
                  //             ', ' +
                  //             date.year.toString();
                  //       } else if (date.day == 2 || date.day == 22) {
                  //         datecontroller.text = date.day.toString() +
                  //             'nd ' +
                  //             month +
                  //             ', ' +
                  //             date.year.toString();
                  //       } else if (date.day == 3 || date.day == 23) {
                  //         datecontroller.text = date.day.toString() +
                  //             'rd ' +
                  //             month +
                  //             ', ' +
                  //             date.year.toString();
                  //       } else {
                  //         datecontroller.text = date.day.toString() +
                  //             'th ' +
                  //             month +
                  //             ', ' +
                  //             date.year.toString();
                  //       }
                  //     },
                  //     controller: datecontroller,
                  //
                  //   ),
                  // ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: PlanPaidStatusController,
                      decoration: InputDecoration(
                        labelText: 'Plan Paid Status',
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      enabled: false,
                      controller: PlanCurrentStatusController,
                      decoration: InputDecoration(
                        labelText: 'Plan Current Status',
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

                  (li.plan.pplanCurrentStatus.toString() == "COMPLETED")
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: FlatButton(
                                  onPressed: () {
                                    print(li.plan.pplanId);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PlanRenewal(
                                                planid: li.plan.pplanId,
                                                renewal: true)));
                                  },
                                  child: Text(
                                    "Renewal",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                            Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: FlatButton(
                                  onPressed: () {
                                    // searchController.text = "";
                                    check().then((value) {
                                      if (value)
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlanRenewal(
                                                        planid: li.plan.pplanId,
                                                        renewal: false)));
                                      else
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible:
                                              false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "No Internet Connection"),
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
                                    "New Service Request",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ],
                        )
                      : Padding(
                          padding:
                              const EdgeInsets.only(left: 24.0, right: 24.0),
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: FlatButton(
                                onPressed: () {
                                  // searchController.text = "";
                                  check().then((value) {
                                    if (value)
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PlanRenewal(
                                                  planid: li.plan.pplanId,
                                                  renewal: false)));
                                    else
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible:
                                            false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text("No Internet Connection"),
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
                                  "New Service Request",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                  (li.plan.pplanCurrentStatus.toString() == "COMPLETED")
                      ? SizedBox(
                          height: height / 50,
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    // color: Colors.white,
                    margin: EdgeInsets.only(top: 10.0, bottom: 10),

                    child: new Text(
                      "Service Details",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortAscending: sort,
                      sortColumnIndex: 0,
                      columnSpacing: width / 20,
                      columns: [
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                "Follow Date",
                                softWrap: true,
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                          numeric: false,

                          // onSort: (columnIndex, ascending) {
                          //   onSortColum(columnIndex, ascending);
                          //   setState(() {
                          //     sort = !sort;
                          //   });
                          // }
                        ),
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Status",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                          numeric: false,

                          // onSort: (columnIndex, ascending) {
                          //   onSortColum(columnIndex, ascending);
                          //   setState(() {
                          //     sort = !sort;
                          //   });
                          // }
                        ),
                      ],
                      rows: li.planServices
                          .map(
                            (list) => DataRow(cells: [
                              DataCell(Center(
                                  child: Center(
                                child: Wrap(
                                    direction: Axis.vertical, //default
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                    DateFormat('dd/MM/yyyy').format(
                                    DateTime.parse(list.pserviceDate.toString())),
                                        textAlign: TextAlign.center,
                                      )
                                    ]),
                              ))),
                              DataCell(Center(
                                  child: Center(
                                child: Wrap(
                                    direction: Axis.vertical, //default
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                          list.pserviceServiceStatus.toString(),
                                          textAlign: TextAlign.center)
                                    ]),
                              ))),
                            ]),
                          )
                          .toList(),
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
