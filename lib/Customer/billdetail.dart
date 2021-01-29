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
import 'package:http/http.dart' as http;
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/billdetail.dart';
import 'package:tankcarecustomer/CustomerModels/districtlist.dart';
import 'package:tankcarecustomer/CustomerModels/statelist.dart';

import '../string_values.dart';

class BillDetail extends StatefulWidget {
  BillDetail({Key key, this.groupid});

  String groupid;

  @override
  BillDetailState createState() => BillDetailState();
}

class BillDetailState extends State<BillDetail> {
  bool loading = false;
  BillView li;

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
    print("response: ${planid}");
    var url = String_values.base_url + 'plan-bill-view?bill_id=' + planid;
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
      li = BillView.fromJson(json.decode(response.body));
      CusNameController.text = li.data.cusName.toString();
      CusEmailController.text = li.data.cusEmail.toString();
      CusPhoneController.text = li.data.cusPhone.toString();
      CusCityController.text = li.data.cusDistrict.toString();
      CusAddressController.text = li.data.cusAddress.toString();
      CusStateController.text = li.data.cusState.toString();

      BillNoController.text = li.data.billNo.toString();
      BillDateController.text = li.data.invDatetime.toString();
      BillNoteController.text = li.data.billNotes.toString();
      BillStatusController.text = li.data.paidStatus.toString();

      PriceDiscountController.text = "0";
      PriceSubtotalController.text = li.data.billAmount.toString();
      PriceTotalAmountController.text = li.data.billAmount.toString();
      PriceTotalItemsController.text = li.data.totalItems.toString();
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
  TextEditingController serviceyearcontroller = new TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  TextEditingController CusNameController = new TextEditingController();
  TextEditingController CusPhoneController = new TextEditingController();
  TextEditingController CusCityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController CusEmailController = new TextEditingController();
  TextEditingController CusStateController = new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController CusAddressController = new TextEditingController();

  TextEditingController BillNoController = new TextEditingController();
  TextEditingController BillNoteController = new TextEditingController();
  TextEditingController BillDateController = new TextEditingController();
  TextEditingController BillStatusController = new TextEditingController();

  TextEditingController PriceTotalAmountController =
      new TextEditingController();
  TextEditingController PriceTotalItemsController = new TextEditingController();
  TextEditingController PriceSubtotalController = new TextEditingController();
  TextEditingController PriceDiscountController = new TextEditingController();

  bool sort;

  String dropdownValue = '-- Service Type --';

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Select Plan --';

  static List<String> friendsList = [null];

  void initState() {
    details(widget.groupid);


    super.initState();
  }

  String searchAddr;

  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                          offset: Offset(0.0, 1.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(3.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: new Text(
                          "Bill Details",
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
                  Container(
                    padding: EdgeInsets.all(16),
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: new Text(
                      "Customer Details",
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
                    child: Container(
                      child: new TextFormField(
                        controller: CusNameController,
                        enabled: false,
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
                      child: new TextFormField(
                        controller: CusEmailController,
                        enabled: false,
                        decoration: InputDecoration(
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
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      child: new TextFormField(
                        controller: CusPhoneController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
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
                        controller: CusCityController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'City',
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
                        controller: CusStateController,
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
                        minLines: 3,
                        maxLines: 10,
                        controller: CusAddressController,
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
                  SizedBox(
                    height: height / 40,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: new Text(
                      "Bill Details",
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
                    child: Container(
                      child: new TextFormField(
                        controller: BillNoController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Bill No',
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
                        controller: BillDateController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Bill Date',
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
                        controller: BillNoteController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Bill Note',
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
                        controller: BillStatusController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Bill Status',
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
                    height: height / 40,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: new Text(
                      "Item Details",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortColumnIndex: 0,
                      columnSpacing: width / 20,
                      columns: [
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical,
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                "Plan Name",
                                softWrap: true,
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical,
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Total Year",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical,
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Total Service",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical,
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Status",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Center(
                              child: Wrap(
                            direction: Axis.vertical,
                            alignment: WrapAlignment.center,
                            children: [
                              Text("Plan Price",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center),
                            ],
                          )),
                          numeric: false,
                        ),
                      ],
                      rows: li.data.billDetails
                          .map(
                            (list) => DataRow(cells: [
                              DataCell(Center(
                                  child: Center(
                                child: Wrap(
                                    direction: Axis.vertical,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        list.pplanName,
                                        textAlign: TextAlign.center,
                                      )
                                    ]),
                              ))),
                              DataCell(Center(
                                  child: Center(
                                child: Wrap(
                                    direction: Axis.vertical,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(list.pplanYear,
                                          textAlign: TextAlign.center)
                                    ]),
                              ))),
                              DataCell(
                                Center(
                                    child: Center(
                                        child: Wrap(
                                            direction: Axis.vertical,
                                            alignment: WrapAlignment.center,
                                            children: [
                                      Text(list.pplanService,
                                          textAlign: TextAlign.center)
                                    ]))),
                              ),
                              DataCell(
                                list.billDetailsStatus == "A"
                                    ? Center(
                                        child: Center(
                                            child: Wrap(
                                                direction: Axis.vertical,
                                                alignment: WrapAlignment.center,
                                                children: [
                                            Text("Active",
                                                textAlign: TextAlign.center)
                                          ])))
                                    : list.billDetailsStatus == "P"
                                        ? Center(
                                            child: Center(
                                                child: Wrap(
                                                    direction: Axis.vertical,
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                Text("Pending",
                                                    textAlign: TextAlign.center)
                                              ])))
                                        : Center(
                                            child: Center(
                                                child: Wrap(
                                                    direction: Axis.vertical,
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                Text("Complete",
                                                    textAlign: TextAlign.center)
                                              ]))),
                              ),
                              DataCell(
                                Center(
                                    child: Center(
                                        child: Wrap(
                                            direction: Axis.vertical,
                                            alignment: WrapAlignment.center,
                                            children: [
                                      Text(list.pplanPrice,
                                          textAlign: TextAlign.center)
                                    ]))),
                              ),
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Container(
                            child: new Text(
                              "Total: ${li.data.billAmount.toString()}",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 80,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: new Text(
                      "Price Details",
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
                    child: Container(
                      child: new TextFormField(
                        controller: PriceTotalItemsController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Total items',
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
                        controller: PriceSubtotalController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Sub total',
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
                        controller: PriceDiscountController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Discount',
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
                        controller: PriceTotalAmountController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Total Amount',
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
    );
  }
}

