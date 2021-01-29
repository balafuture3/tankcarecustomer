import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:tankcarecustomer/CustomerModels/VendorServiceDetailModel.dart';
import 'package:tankcarecustomer/main.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tankcarecustomer/Customer/ComplaintDetail.dart';
import 'package:tankcarecustomer/Customer/DamageDetail.dart';
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/districtlist.dart';
import 'package:tankcarecustomer/CustomerModels/statelist.dart';

import '../string_values.dart';

class ServiceDetail extends StatefulWidget {
  ServiceDetail({Key key, this.serviceid});

  String serviceid;

  @override
  ServiceDetailState createState() => ServiceDetailState();
}

class ServiceDetailState extends State<ServiceDetail> {
  bool loading = false;
  VendorServiceDetailModel li;
  List<File> files = [];
  var _kGooglePlex;
  Future<File> _imageFile;
  StateListings li2;

  DistrictListings li3;

  String dropdownValue3 = '-Action-';

  num a;

  File image;

  var file;

  int servicerating = 0;
  int servicerrating = 0;

  DateTime damageEndDate;

  bool damageenable = true;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<int> feedback(url) async {
    setState(() {
      loading = true;
    });
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'service-feedback-save'));
    for (int i = 0; i < files.length; i++)
      request.files.add(
          await http.MultipartFile.fromPath('feedback_img[]', files[i].path));
    request.headers.addAll(headers);
    request.fields['service_id'] = widget.serviceid;
    request.fields['clean_rating'] = servicerating.toString();
    request.fields['servicer_rating'] = servicerrating.toString();
    request.fields['feedback_note'] = FeedBackController.text;
    var res = await request.send();
    print(res.statusCode);
    setState(() {
      loading = false;
    });
    return res.statusCode;
  }

  Future<int> complaint(url) async {
    setState(() {
      loading = true;
    });
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'service-complaint-save'));
    for (int i = 0; i < files.length; i++)
      request.files.add(await http.MultipartFile.fromPath(
          'complaint_image[]', files[i].path));
    request.headers.addAll(headers);
    request.fields['service_id'] = widget.serviceid;
    request.fields['complaint_note'] = ComplaintController.text;
    var res = await request.send();
    print(res.statusCode);
    setState(() {
      loading = false;
    });
    return res.statusCode;
  }

  Future<int> damage(url) async {
    setState(() {
      loading = true;
    });
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'service-damage-save'));
    for (int i = 0; i < files.length; i++)
      request.files.add(
          await http.MultipartFile.fromPath('damage_image[]', files[i].path));
    request.headers.addAll(headers);
    request.fields['service_id'] = widget.serviceid;
    request.fields['damage_note'] = DamageController.text;
    var res = await request.send();
    print(res.statusCode);
    setState(() {
      loading = false;
    });
    return res.statusCode;
  }

  Future<http.Response> details(planid) async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url +
        'property-plan-services-view/?serviceid=' +
        planid;
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
      li = VendorServiceDetailModel.fromJson(json.decode(response.body));
      setState(() {
        // ServiceByController.text=li.planServices.se
        ServiceStartDateController.text =
            li.planServices.pserviceDate.toString();
        ServiceStatusController.text =
            li.planServices.pserviceServiceStatus.toString();
        if (li.planServices.pserviceStatus.toString() == "A")
          StatusController.text = "Active";
        else if (li.planServices.pserviceStatus.toString() == "P")
          StatusController.text = "Pending";

        PropertyNameController.text = li.property.propertyName.toString();
        GroupNameController.text = li.property.groupName.toString();
        if (li.property.serviceType.toString() == "RES")
          ServiceController.text = "Residential";
        else
          ServiceController.text = "Commercial";
        PropertyCodeController.text = li.property.propertyCode.toString();
        PropertyTypeController.text = li.property.propertyTypeName.toString();
        valuecontroller.text = li.property.propertyValue.toString();

        PlanController.text = li.plan.pplanName.toString();
        PlanYearController.text = li.plan.pplanYear.toString();
        PlanServiceController.text = li.plan.pplanService.toString();
        priceController.text = li.plan.pplanPrice.toString();
        datecontroller.text = li.plan.pplanStartDate.toString();
        PlanCurrentStatusController.text =
            li.plan.pplanCurrentStatus.toString();
        damageEndDate = DateTime.parse(li.planServices.pserviceEndAt)
            .add(Duration(days: 2));
        if (DateTime.now().isBefore(damageEndDate))
          damageenable = true;
        else
          damageenable = false;
        print(damageenable);
        print(damageEndDate);
        print(li.planServices.pserviceEndAt);
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
  TextEditingController StatusController = new TextEditingController();
  TextEditingController ServiceStatusController = new TextEditingController();
  TextEditingController ServiceStartDateController =
      new TextEditingController();
  TextEditingController ServiceByController = new TextEditingController();
  TextEditingController ComplaintController = new TextEditingController();
  TextEditingController DamageController = new TextEditingController();
  TextEditingController ServiceController = new TextEditingController();
  TextEditingController PlanPaidStatusController = new TextEditingController();
  TextEditingController PlanCurrentStatusController =
      new TextEditingController();
  TextEditingController PropertyCodeController = new TextEditingController();
  TextEditingController FeedBackController = new TextEditingController();
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
    details(widget.serviceid);
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
                          "Service Details",
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
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Service Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: ServiceByController,
                                decoration: InputDecoration(
                                  labelText: 'Service By',
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: ServiceStartDateController,
                                decoration: InputDecoration(
                                  labelText: 'Service Start Date',
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: ServiceStatusController,
                                decoration: InputDecoration(
                                  labelText: 'Service Status',
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new TextField(
                                enabled: false,
                                controller: StatusController,
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
                          ])),
                  (li.planServices.pserviceServiceStatus.toString() ==
                              "COMPLETED") ||
                          (li.planServices.pserviceServiceStatus.toString() ==
                              "ONGOING")
                      ? Container(
                          margin: const EdgeInsets.only(top: 10),
                          color: Colors.red.shade50,
                          child: ExpansionTile(
                              backgroundColor: Colors.white,
                              initiallyExpanded: false,
                              title: Text(
                                "Service Before Images",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                              children: [
                                Container(
                                  child: GridView.count(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    children: List.generate(

                                              li.planServices.pserviceBeforeImg
                                          .length,
                                      (index) {
                                        return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Card(
                                                elevation: 5,
                                                clipBehavior: Clip.antiAlias,
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        child: Image.network(li
                                                                    .planServices
                                                                    .pserviceBeforeImg[
                                                                index].imgPath));
                                                  },
                                                  child: Image.network(li.planServices
                                                            .pserviceBeforeImg[
                                                        index].imgPath,
                                                    height: 300,
                                                    width: 300,
                                                  ),
                                                )));
                                      },
                                    ),
                                  ),
                                )
                              ]))
                      : Container(),

                  (li.planServices.pserviceServiceStatus.toString() ==
                          "COMPLETED")
                      ? Container(
                          margin: const EdgeInsets.only(top: 10),
                          color: Colors.red.shade50,
                          child: ExpansionTile(
                              backgroundColor: Colors.white,
                              initiallyExpanded: false,
                              title: Text(
                                "Service After Images",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                              children: [
                                Container(
                                  child: GridView.count(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    children: List.generate(
                                              li.planServices.pserviceAfterImg
                                          .length,
                                      (index) {
                                        return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Card(
                                                elevation: 5,
                                                clipBehavior: Clip.antiAlias,
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        child: Image.network(li
                                                                    .planServices
                                                                    .pserviceAfterImg[
                                                                index].imgPath));
                                                  },
                                                  child: Image.network(li.planServices
                                                            .pserviceAfterImg[
                                                        index].imgPath,
                                                    height: 300,
                                                    width: 300,
                                                  ),
                                                )));
                                      },
                                    ),
                                  ),
                                )
                              ]))
                      : Container(),

                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Property Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                          ])),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                          backgroundColor: Colors.white,
                          initiallyExpanded: false,
                          title: Text(
                            "Plan Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                          children: [
                            SizedBox(
                              height: height / 50,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
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
                          ])),
                  SizedBox(
                    height: height / 80,
                  ),

                  (li.planServices.pserviceServiceStatus.toString() ==
                          "COMPLETED")
                      ? Container(
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

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Text(
                                "Feedback Details",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              (li.planServices.pserviceServiceStatus
                                          .toString() ==
                                      "COMPLETED")
                                  ? Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: FlatButton(
                                        onPressed: () {
                                          showDialog<void>(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (context,
                                                        StateSetter setState) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Provide Feedback",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            width: width,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            // color: Colors.white,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10.0,
                                                                    bottom: 10),

                                                            child: new Text(
                                                              "Service Ratings",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RatingBar.builder(
                                                            initialRating: 0,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                false,
                                                            itemCount: 5,
                                                            minRating: 1,
                                                            itemSize: 35.0,
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            onRatingUpdate:
                                                                (rating) {
                                                              servicerating =
                                                                  rating
                                                                      .round();
                                                            },
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            width: width,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            // color: Colors.white,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10.0,
                                                                    bottom: 10),

                                                            child: new Text(
                                                              "Servicer Ratings",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RatingBar.builder(
                                                            initialRating: 0,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                false,
                                                            itemCount: 5,
                                                            minRating: 1,
                                                            itemSize: 35.0,
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            onRatingUpdate:
                                                                (rating) {
                                                              servicerrating =
                                                                  rating
                                                                      .round();
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: height / 50,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            width: width,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            // color: Colors.white,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10.0,
                                                                    bottom: 10),

                                                            child: new Text(
                                                              "Feedback Details",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextFormField(
                                                              enabled: true,
                                                              minLines: 3,
                                                              maxLines: 20,
                                                              controller:
                                                                  FeedBackController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Feedback Note',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            width: width,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            // color: Colors.white,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10.0,
                                                                    bottom: 10),

                                                            child: new Text(
                                                              "Feedback Images",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                          for (int index = 0;
                                                              index <
                                                                  files.length;
                                                              index++)
                                                            Container(
                                                              child: Card(
                                                                  child: Stack(
                                                                      children: <
                                                                          Widget>[
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: Image
                                                                          .file(
                                                                        files[
                                                                            index],
                                                                        width:
                                                                            width /
                                                                                3,
                                                                        height:
                                                                            100,
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                        right:
                                                                            5,
                                                                        top: 5,
                                                                        child: InkWell(
                                                                            child: Icon(
                                                                              Icons.remove_circle,
                                                                              size: 25,
                                                                              color: Colors.red,
                                                                            ),
                                                                            onTap: () {
                                                                              setState(() {
                                                                                files.removeAt(index);
                                                                                print(files);
                                                                                // images.replaceRange(index, index + 1, ['Add Image']);
                                                                              });
                                                                            }))
                                                                  ])),
                                                            ),
                                                          Container(
                                                              child: Card(
                                                            child: Container(
                                                              width: width / 3,
                                                              height: 100,
                                                              child: IconButton(
                                                                  icon: Icon(
                                                                    Icons.add,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    file =
                                                                        await _onAddImageClick();
                                                                    if (file !=
                                                                        null)
                                                                      setState(
                                                                          () {
                                                                        files.add(
                                                                            file);
                                                                      });
                                                                  }),
                                                            ),
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text('OK'),
                                                        onPressed: () {
                                                          check().then((value) {
                                                            if (value) {
                                                              if (servicerrating !=
                                                                      0 &&
                                                                  servicerrating !=
                                                                      0) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                feedback("")
                                                                    .then(
                                                                        (value) {
                                                                  servicerrating =
                                                                      0;
                                                                  servicerating =
                                                                      0;
                                                                  FeedBackController
                                                                      .text = "";
                                                                  files.clear();
                                                                  details(widget
                                                                      .serviceid);
                                                                });
                                                              } else {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "Please Provide Service and Servicer Ratings",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_LONG,
                                                                    gravity: ToastGravity
                                                                        .SNACKBAR,
                                                                    timeInSecForIosWeb:
                                                                        1,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        16.0);
                                                              }
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                              });
                                        },
                                        child: Text(
                                          "Provide Feedback",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ))
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),
                  (li.planServices.pserviceServiceStatus.toString() ==
                          "COMPLETED")
                      ? SingleChildScrollView(
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
                                      "Feedback Note",
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
                                    Text("Servicer Rating",
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
                              DataColumn(
                                label: Center(
                                    child: Wrap(
                                  direction: Axis.vertical, //default
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text("Service Rating",
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
                              DataColumn(
                                label: Center(
                                    child: Wrap(
                                  direction: Axis.vertical, //default
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text("Date",
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
                            rows: li.serviceFeedback
                                .map(
                                  (list) => DataRow(cells: [
                                    DataCell(Center(
                                        child: Center(
                                      child: Wrap(
                                          direction: Axis.vertical, //default
                                          alignment: WrapAlignment.center,
                                          children: [
                                            Text(
                                              list.feedbackNote.toString(),
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
                                            RatingBar.builder(
                                              initialRating: double.parse(list
                                                  .servicerRating
                                                  .toString()),
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              itemSize: 15.0,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            )
                                          ]),
                                    ))),
                                    DataCell(
                                      Center(
                                          child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                            RatingBar.builder(
                                              initialRating: double.parse(
                                                  list.cleanRating.toString()),
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              itemSize: 15.0,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            )

                                            // Text(list.cleanRating.toString(),
                                            //     textAlign: TextAlign.center)
                                          ]))),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                            Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    DateTime.parse(list
                                                        .createdAt
                                                        .toString())),
                                                textAlign: TextAlign.center)
                                          ]))),
                                    ),
                                  ]),
                                )
                                .toList(),
                          ),
                        )
                      : Container(),
                  (li.planServices.pserviceServiceStatus.toString() ==
                          "COMPLETED")
                      ? SizedBox(
                          height: height / 40,
                        )
                      : Container(),
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
                  //   margin: EdgeInsets.only(top: 10.0, bottom: 10),
                  //
                  //   child: new Text(
                  //     "Plan",
                  //     textAlign: TextAlign.left,
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.bold, color: Colors.red),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 50,
                  // ),

                  (li.planServices.pserviceServiceStatus.toString() ==
                          "COMPLETED")
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

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text(
                          "Complaints Details",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: FlatButton(
                              onPressed: () {
                                files.clear();
                                showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (context, StateSetter setState) {
                                        return AlertDialog(
                                          title: Text(
                                            "New Complaint",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  // color: Colors.white,
                                                  margin: EdgeInsets.only(
                                                      top: 10.0, bottom: 10),

                                                  child: new Text(
                                                    "Complaint Details",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: new TextFormField(
                                                    enabled: true,
                                                    minLines: 3,
                                                    maxLines: 20,
                                                    controller:
                                                        ComplaintController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Complaint Reason',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  // color: Colors.white,
                                                  margin: EdgeInsets.only(
                                                      top: 10.0, bottom: 10),

                                                  child: new Text(
                                                    "Complaint Images",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                for (int index = 0;
                                                    index < files.length;
                                                    index++)
                                                  Container(
                                                    child: Card(
                                                        child: Stack(children: <
                                                            Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.file(
                                                          files[index],
                                                          width: width / 3,
                                                          height: 100,
                                                        ),
                                                      ),
                                                      Positioned(
                                                          right: 5,
                                                          top: 5,
                                                          child: InkWell(
                                                              child: Icon(
                                                                Icons
                                                                    .remove_circle,
                                                                size: 25,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onTap: () {
                                                                setState(() {
                                                                  files.removeAt(
                                                                      index);
                                                                  print(files);
                                                                  // images.replaceRange(index, index + 1, ['Add Image']);
                                                                });
                                                              }))
                                                    ])),
                                                  ),
                                                Container(
                                                    child: Card(
                                                  child: Container(
                                                    width: width / 3,
                                                    height: 100,
                                                    child: IconButton(
                                                        icon: Icon(
                                                          Icons.add,
                                                        ),
                                                        onPressed: () async {
                                                          file =
                                                              await _onAddImageClick();
                                                          if (file != null)
                                                            setState(() {
                                                              files.add(file);
                                                            });
                                                        }),
                                                  ),
                                                ))
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                check().then((value) {
                                                  if (value) {
                                                    if ((ComplaintController
                                                                .text !=
                                                            null) &&
                                                        (ComplaintController
                                                                .text !=
                                                            "")) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      complaint("")
                                                          .then((value) {
                                                        ComplaintController
                                                            .text = "";
                                                        files.clear();
                                                        details(
                                                            widget.serviceid);
                                                      });
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Please Provide Complaint Reason",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .SNACKBAR,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    });
                              },
                              child: Text(
                                "New Complaint",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
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
                                "Complaint Code",
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
                              Text("Complaint Note",
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
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Date",
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
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical, //default
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Action",
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
                      rows: li.serviceComplaint
                          .map(
                            (list) => DataRow(cells: [
                              DataCell(Center(
                                  child: Center(
                                child: Wrap(
                                    direction: Axis.vertical, //default
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        list.complaintCode.toString(),
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
                                        list.complaintNote.toString(),
                                        textAlign: TextAlign.center,
                                      )
                                    ]),
                              ))),
                              DataCell(
                                Center(
                                    child: Center(
                                        child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                      Text(
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                  list.createdAt.toString())),
                                          textAlign: TextAlign.center)
                                    ]))),
                              ),
                              DataCell(Center(
                                  child: Center(
                                child: Wrap(
                                    direction: Axis.vertical, //default
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        list.complaintStatus.toString(),
                                        textAlign: TextAlign.center,
                                      )
                                    ]),
                              ))),
                              DataCell(
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: dropdownValue3,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        if (newValue == "View")
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ComplaintDetail(
                                                          complaintid: list
                                                              .complaintId)));
                                        // else if (newValue == "Edit")
                                        //   Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               PlanEdit(planid: list.pplanId)));
//                                    else if (newValue == "Edit")
//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) =>
//                                                  PropertyEdit(
//                                                      propertyid:
//                                                          list.propertyId)));
//                                    else if (newValue == "Delete") {
//                                      delete(list.propertyId);
//                                      li.items.remove(list);
//                                    }
                                      });
                                    },
                                    items: <String>[
                                      '-Action-',
                                      "View",
//                                  "Delete"
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Wrap(
                                              direction:
                                                  Axis.vertical, //default
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text(
                                                  value,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ]));
                                    }).toList(),
                                  ),
                                ),
                              )
                            ]),
                          )
                          .toList(),
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
                  //   margin: EdgeInsets.only(top: 10.0, bottom: 10),
                  //
                  //   child: new Text(
                  //     "Plan",
                  //     textAlign: TextAlign.left,
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.bold, color: Colors.red),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 50,
                  // ),

                  SizedBox(
                    height: height / 50,
                  ),
                  ((li.planServices.pserviceServiceStatus.toString() ==
                              "COMPLETED") &&
                          (li.property.propertyTypeName.toString() == "Tank") &&
                          damageenable)
                      ? Container(
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

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Text(
                                "Damage Details",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              ((li.planServices.pserviceServiceStatus
                                              .toString() ==
                                          "COMPLETED") &&
                                      (li.property.propertyTypeName
                                              .toString() ==
                                          "Tank") &&
                                      damageenable)
                                  ? Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: FlatButton(
                                        onPressed: () {
                                          files.clear();
                                          showDialog<void>(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (context,
                                                        StateSetter setState) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "New Damage",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            width: width,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            // color: Colors.white,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10.0,
                                                                    bottom: 10),

                                                            child: new Text(
                                                              "Damage Details",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new TextFormField(
                                                              enabled: true,
                                                              minLines: 3,
                                                              maxLines: 20,
                                                              controller:
                                                                  DamageController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Damage Notes',
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            width: width,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            // color: Colors.white,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10.0,
                                                                    bottom: 10),

                                                            child: new Text(
                                                              "Damage Images",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                          for (int index = 0;
                                                              index <
                                                                  files.length;
                                                              index++)
                                                            Container(
                                                              child: Card(
                                                                  child: Stack(
                                                                      children: <
                                                                          Widget>[
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: Image
                                                                          .file(
                                                                        files[
                                                                            index],
                                                                        width:
                                                                            width /
                                                                                3,
                                                                        height:
                                                                            100,
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                        right:
                                                                            5,
                                                                        top: 5,
                                                                        child: InkWell(
                                                                            child: Icon(
                                                                              Icons.remove_circle,
                                                                              size: 25,
                                                                              color: Colors.red,
                                                                            ),
                                                                            onTap: () {
                                                                              setState(() {
                                                                                files.removeAt(index);
                                                                                print(files);
                                                                                // images.replaceRange(index, index + 1, ['Add Image']);
                                                                              });
                                                                            }))
                                                                  ])),
                                                            ),
                                                          Container(
                                                              child: Card(
                                                            child: Container(
                                                              width: width / 3,
                                                              height: 100,
                                                              child: IconButton(
                                                                  icon: Icon(
                                                                    Icons.add,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    file =
                                                                        await _onAddImageClick();
                                                                    if (file !=
                                                                        null)
                                                                      setState(
                                                                          () {
                                                                        files.add(
                                                                            file);
                                                                      });
                                                                  }),
                                                            ),
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text('OK'),
                                                        onPressed: () {
                                                          check().then((value) {
                                                            if (value) {
                                                              if ((DamageController
                                                                          .text !=
                                                                      null) &&
                                                                  (DamageController
                                                                          .text !=
                                                                      "") &&
                                                                  (files.length !=
                                                                      0)) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                damage("").then(
                                                                    (value) {
                                                                  DamageController
                                                                      .text = "";
                                                                  files.clear();
                                                                  details(widget
                                                                      .serviceid);
                                                                });
                                                              } else {
                                                                print(files
                                                                    .length);
                                                                if ((DamageController
                                                                            .text ==
                                                                        null) ||
                                                                    (DamageController
                                                                            .text ==
                                                                        ""))
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "Please Provide Damage Notes",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity: ToastGravity
                                                                          .SNACKBAR,
                                                                      timeInSecForIosWeb:
                                                                          1,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          16.0);
                                                                else
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "Please Provide Damage Images",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity: ToastGravity
                                                                          .SNACKBAR,
                                                                      timeInSecForIosWeb:
                                                                          1,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          16.0);
                                                              }
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                              });
                                        },
                                        child: Text(
                                          "New Damage",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ))
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),
                  ((li.planServices.pserviceServiceStatus.toString() ==
                              "COMPLETED") &&
                          (li.property.propertyTypeName.toString() == "Tank") &&
                          damageenable)
                      ? SingleChildScrollView(
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
                                      "Damage Code",
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
                                    Text("Damage Note",
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
                              DataColumn(
                                label: Center(
                                    child: Wrap(
                                  direction: Axis.vertical, //default
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text("Date",
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
                              DataColumn(
                                label: Center(
                                    child: Wrap(
                                  direction: Axis.vertical, //default
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text("Action",
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
                            rows: li.serviceDamage
                                .map(
                                  (list) => DataRow(cells: [
                                    DataCell(Center(
                                        child: Center(
                                      child: Wrap(
                                          direction: Axis.vertical, //default
                                          alignment: WrapAlignment.center,
                                          children: [
                                            Text(
                                              list.damageCode.toString(),
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
                                              list.damageNote.toString(),
                                              textAlign: TextAlign.center,
                                            )
                                          ]),
                                    ))),
                                    DataCell(
                                      Center(
                                          child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                            Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    DateTime.parse(list
                                                        .createdAt
                                                        .toString())),
                                                textAlign: TextAlign.center)
                                          ]))),
                                    ),
                                    DataCell(Center(
                                        child: Center(
                                      child: Wrap(
                                          direction: Axis.vertical, //default
                                          alignment: WrapAlignment.center,
                                          children: [
                                            Text(
                                              list.damageStatus.toString(),
                                              textAlign: TextAlign.center,
                                            )
                                          ]),
                                    ))),
                                    DataCell(
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: dropdownValue3,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              if (newValue == "View")
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DamageDetail(
                                                                damageid: list
                                                                    .damageId)));

                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             ServiceDetail(serviceid: list.pserviceId)));
                                              // else if (newValue == "Edit")
                                              //   Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (context) =>
                                              //               PlanEdit(planid: list.pplanId)));
//                                    else if (newValue == "Edit")
//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) =>
//                                                  PropertyEdit(
//                                                      propertyid:
//                                                          list.propertyId)));
//                                    else if (newValue == "Delete") {
//                                      delete(list.propertyId);
//                                      li.items.remove(list);
//                                    }
                                            });
                                          },
                                          items: <String>[
                                            '-Action-',
                                            "View",
//                                  "Delete"
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Wrap(
                                                    direction:
                                                        Axis.vertical, //default
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text(
                                                        value,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ]));
                                          }).toList(),
                                        ),
                                      ),
                                    )
                                  ]),
                                )
                                .toList(),
                          ),
                        )
                      : Container(),
                  ((li.planServices.pserviceServiceStatus.toString() ==
                              "COMPLETED") &&
                          (li.property.propertyTypeName.toString() == "Tank") &&
                          damageenable)
                      ? SizedBox(
                          height: height / 40,
                        )
                      : Container(),
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
                  //   margin: EdgeInsets.only(top: 10.0, bottom: 10),
                  //
                  //   child: new Text(
                  //     "Plan",
                  //     textAlign: TextAlign.left,
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.bold, color: Colors.red),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: height / 50,
                  // ),
                  SizedBox(
                    height: height / 50,
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

  _onAddImageClick() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) return image;

    // print("Uploaded Image: $_imageFile");
    // _imageFile.then((file) async {
    //   return file;
    // setState(() {
    //   files.add(file);
    //
    // });
    // });
  }

  getFileImage(file) {}
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
