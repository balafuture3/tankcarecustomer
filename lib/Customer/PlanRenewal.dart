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
import 'package:intl/intl.dart';
import 'package:tankcarecustomer/Customer/PlanList.dart';
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/plandetail.dart';
import 'package:tankcarecustomer/CustomerModels/priceapi.dart';
import 'package:tankcarecustomer/CustomerModels/statelist.dart';

import '../string_values.dart';

class PlanRenewal extends StatefulWidget {
  PlanRenewal({Key key, this.planid, this.renewal});

  String planid;
  bool renewal;

  @override
  PlanRenewalState createState() => PlanRenewalState();
}

class PlanRenewalState extends State<PlanRenewal> {
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String sql_dob;
  List<String> stringlist1 = [
    '-- Select Year --',
  ];
  DateTime parseDt;
  List<String> stringlist2 = [
    '-- Select Service --',
  ];

  Future<http.Response> postRequest() async {
    setState(() {
      loading = true;
    });
    var url;
    if (widget.renewal)
      url = String_values.base_url +
          'property-plan-price?group_id=${li.property.groupId}&ptype_id=${li.property.propertyTypeId}&stype=${li.property.serviceType}&total_value=${li.property.propertyValue}&year_type=r';
    else
      url = String_values.base_url +
          'property-plan-price?group_id=${li.property.groupId}&ptype_id=${li.property.propertyTypeId}&stype=${li.property.serviceType}&total_value=${li.property.propertyValue}&year_type=d';
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
      li3 = PriceAPIListings.fromJson(json.decode(response.body));
      setState(() {
        PlanController.text = li3.items.planName.toString();
        stringlist1.clear();
        stringlist1.add('-- Select Year --');
        for (int i = 0; i < li3.items.price.length; i++)
          stringlist1.add(li3.items.price[i].year);

        stringlist2.clear();
        stringlist2.add('-- Select Service --');
        // for(int i=0;i<li3.items.price[0].service.length;i++)
        //   stringlist2.add(li3.items.price[0].service[i].totalService);
        if (widget.renewal)
          // dropdownValue2 = "1";
          dropdownValue2 = li.plan.pplanYear.toString();
        else {
          dropdownValue2 = "1";
          PlanYearController.text = "1";
        }
        for (int j = 0; j < li3.items.price.length; j++) {
          for (int i = 0; i < li3.items.price[j].service.length; i++) {
            if (dropdownValue2 == li3.items.price[j].year)
              stringlist2.add(li3.items.price[j].service[i].totalService);
          }
        }
        dropdownValue3 = li.plan.pplanService.toString();
      });
      for (int j = 0; j < li3.items.price.length; j++) {
        for (int i = 0; i < li3.items.price[j].service.length; i++) {
          if ((li3.items.price[j].service[i].totalService.toString() ==
                  dropdownValue3) &&
              (li3.items.price[j].year.toString() == dropdownValue2)) {
            print("for loop");
            setState(() {
              priceController.text = li3.items.price[j].service[i].fixedPrice;
              TotalServicesController.text =
                  (int.parse(dropdownValue2) * int.parse(dropdownValue3))
                      .toString();
              TotalPriceController.text =
                  li3.items.price[j].service[i].fixedPrice;
            });
          }
        }

        // districttype = stringlist1.indexOf(newValue);
      }
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

  Future<int> uploadImage(url) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };
    sql_dob = dateFormatter.format(parseDt);
    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'property-plan-add'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['property_id'] = li.property.propertyId;
    if (widget.renewal)
      request.fields['pplan_type'] = "R";
    else
      request.fields['pplan_type'] = "A";
    request.fields['plan_id'] = li3.items.planId;
    request.fields['pplan_name'] = li3.items.planName;
    request.fields['pplan_year'] = dropdownValue2;
    request.fields['pplan_service'] = dropdownValue3;
    request.fields['pplan_price'] = priceController.text;
    request.fields['pplan_tot_price'] = priceController.text;
    request.fields['pplan_start_date'] = sql_dob;
    var res = await request.send();
    print(res.statusCode);
    return res.statusCode;
  }

  bool loading = false;
  PlanDetailListings li;

  var _kGooglePlex;

  StateListings li2;

  PriceAPIListings li3;

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
        parseDt = DateTime.parse(li.plan.pplanStartDate.toString()).add(
            Duration(days: (365 * int.parse(li.plan.pplanYear.toString()))));
        datecontroller.text = parseDt.day.toString() +
            '/' +
            parseDt.month.toString() +
            '/' +
            parseDt.year.toString();
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
        // priceController.text=li.plan.pplanPrice.toString();

        // datecontroller.text=parseDt.day.toString()+'/'+parseDt.month.toString()+'/'+parseDt.year.toString();
        PlanPaidStatusController.text = li.plan.pplanPaidStatus.toString();
        if (li.plan.pplanStatus.toString() == "A")
          PlanCurrentStatusController.text = "Active";
        else if (li.plan.pplanStatus.toString() == "P")
          PlanCurrentStatusController.text = "Pending";
        else if (li.plan.pplanStatus.toString() == "C")
          PlanCurrentStatusController.text = "Completed";
        else if (li.plan.pplanStatus.toString() == "O")
          PlanCurrentStatusController.text = "Ongoing";
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

  List<String> items = List<String>.generate(7, (index) {
    return "Item - $index";
  });
  List<PlanListClass> listplan;
  TextEditingController ServiceController = new TextEditingController();
  TextEditingController TotalPriceController = new TextEditingController();
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

  String dropdownValue2 = '-- Select Year --';
  String dropdownValue3 = '-- Select Service --';
  static List<String> friendsList = [null];

  void initState() {
    check().then((value) {
      if (value)
        details(widget.planid).then((value) => postRequest());
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
                        child: Text(
                          widget.renewal ? "Plan Renewal" : "New Service ",
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
                  widget.renewal == true
                      ? Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 10.0),
                          decoration: new BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                              border: new Border.all(color: Colors.black38)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValue2,
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue2 = newValue;
                                  stringlist2.clear();
                                  priceController.text = "";
                                  TotalServicesController.text = "";
                                  dropdownValue3 = '-- Select Service --';
                                  stringlist2.add('-- Select Service --');
                                  datecontroller.text = "";
                                  for (int j = 0;
                                      j < li3.items.price.length;
                                      j++) {
                                    for (int i = 0;
                                        i < li3.items.price[j].service.length;
                                        i++) {
                                      if (dropdownValue2 ==
                                          li3.items.price[j].year)
                                        stringlist2.add(li3.items.price[j]
                                            .service[i].totalService);
                                    }
                                  }
                                  // districttype = stringlist1.indexOf(newValue);
                                });
                              },
                              items: stringlist1.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: height / 50,
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
                        value: dropdownValue3,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue3 = newValue;
                            parseDt = DateTime.parse(
                                    li.plan.pplanStartDate.toString())
                                .add(Duration(
                                    days: (365 * int.parse(dropdownValue2))));
                            datecontroller.text = parseDt.day.toString() +
                                '/' +
                                parseDt.month.toString() +
                                '/' +
                                parseDt.year.toString();

                            for (int j = 0; j < li3.items.price.length; j++) {
                              for (int i = 0;
                                  i < li3.items.price[j].service.length;
                                  i++) {
                                if ((li3.items.price[j].service[i].totalService
                                            .toString() ==
                                        dropdownValue3) &&
                                    (li3.items.price[j].year.toString() ==
                                        dropdownValue2)) {
                                  print("for loop");
                                  setState(() {
                                    priceController.text = li3
                                        .items.price[j].service[i].fixedPrice;
                                    TotalServicesController.text =
                                        (int.parse(dropdownValue2) *
                                                int.parse(dropdownValue3))
                                            .toString();
                                    TotalPriceController.text = (double.parse(
                                                li3.items.price[j].service[i]
                                                    .fixedPrice) *
                                            double.parse(
                                                TotalServicesController.text))
                                        .toString();
                                  });
                                }
                              }

                              // districttype = stringlist1.indexOf(newValue);
                            }
                          });
                        },
                        items: stringlist2
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
                    height: height / 80,
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new TextField(
                      onTap: () async {
                        // DateTime date = DateTime(1900);
                        // FocusScope.of(context)
                        //     .requestFocus(new FocusNode());
                        //
                        // date = await showDatePicker(
                        //     context: context,
                        //     initialDate: DateTime.now(),
                        //     firstDate: DateTime.now()
                        //         .subtract(new Duration(days: 23725)),
                        //     lastDate: DateTime.now());
                        // /*    var time =await showTimePicker(
                        //       initialTime: TimeOfDay.now(),
                        //       context: context,
                        //     );*/
                        // sql_dob = dateFormatter.format(date);
                        // print("date" + sql_dob);
                        // var month = date.month.toString();
                        // if (date.month == 1)
                        //   month = 'January';
                        // else if (date.month == 2)
                        //   month = 'February';
                        // else if (date.month == 3)
                        //   month = 'March';
                        // else if (date.month == 4)
                        //   month = 'April';
                        // else if (date.month == 5)
                        //   month = 'May';
                        // else if (date.month == 6)
                        //   month = 'June';
                        // else if (date.month == 7)
                        //   month = 'July';
                        // else if (date.month == 8)
                        //   month = 'August';
                        // else if (date.month == 9)
                        //   month = 'September';
                        // else if (date.month == 10)
                        //   month = 'October';
                        // else if (date.month == 11)
                        //   month = 'November';
                        // else if (date.month == 12) month = 'December';
                        //
                        //
                        //
                        // if (date.day == 1 ||
                        //     date.day == 21 ||
                        //     date.day == 31) {
                        //   datecontroller.text = date.day.toString() +
                        //       'st ' +
                        //       month +
                        //       ', ' +
                        //       date.year.toString();
                        // } else if (date.day == 2 || date.day == 22) {
                        //   datecontroller.text = date.day.toString() +
                        //       'nd ' +
                        //       month +
                        //       ', ' +
                        //       date.year.toString();
                        // } else if (date.day == 3 || date.day == 23) {
                        //   datecontroller.text = date.day.toString() +
                        //       'rd ' +
                        //       month +
                        //       ', ' +
                        //       date.year.toString();
                        // } else {
                        //   datecontroller.text = date.day.toString() +
                        //       'th ' +
                        //       month +
                        //       ', ' +
                        //       date.year.toString();
                        // }
                      },
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
                      controller: TotalServicesController,
                      decoration: InputDecoration(
                        labelText: 'Total Services',
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
                      controller: TotalPriceController,
                      decoration: InputDecoration(
                        labelText: 'Total Price',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: FlatButton(
                            onPressed: () {
                              check().then((value) {
                                if (value) {
                                  if (datecontroller.text.length != 0 &&
                                      (dropdownValue2 != '-- Select Year --') &&
                                      (dropdownValue3 !=
                                          '-- Select Service --')) {
                                    uploadImage("").then((value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlanList()));
                                    });
                                  } else {
                                    if (dropdownValue2 == '-- Select Year --')
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Please Choose Year"),
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
                                    else if (dropdownValue3 ==
                                        '-- Select Service --')
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text("Please Choose Service"),
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
                                    else if (datecontroller.text.length == 0)
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Start Date cannot be empty"),
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
                                  BorderRadius.all(Radius.circular(30))),
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
                    height: height / 40,
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
