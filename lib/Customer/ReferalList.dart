import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:tankcarecustomer/main.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/discount%25.dart';
import 'package:tankcarecustomer/CustomerModels/referalList.dart';

import '../string_values.dart';

class ReferalList extends StatefulWidget {
  @override
  ReferalListState createState() => ReferalListState();
}

class ReferalListState extends State<ReferalList> {
  bool loading = false;

  ReferalListings li;

  var page = 1;

  DiscountPerc li2;

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

    var url = String_values.base_url + 'ref-cus-list';
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
      li = ReferalListings.fromJson(json.decode(response.body));
      // print("plan${li.items[0].mapLocation}");
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

  Future<http.Response> discount() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'ref-cus-discount';
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
      li2 = DiscountPerc.fromJson(json.decode(response.body));
      // print("plan${li.items[0].mapLocation}");
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

  Future<http.Response> delete(planid) async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'group-delete/' + planid;
    print(String_values.base_url);
    var response = await http.put(
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
  TextEditingController searchController = new TextEditingController();
  List<PlanListView> listplanyear;
  bool sort;

  String dropdownValue = '-- Service Type --';

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Select Plan --';

  String dropdownValue3 = '-Action-';

  static List<String> friendsList = [null];

  void initState() {
    sort = false;
    setState(() {
      loading = true;
    });
    check().then((value) {
      if (value)
        postRequest().then((value) => discount());
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
    listplanyear = PlanListView.getdata();
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Text(
                              "Referal List",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 17),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Referal Count : ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    Text(
                                      li2.data.currentCount.toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Discount: ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    Text(
                                      li2.data.rdPercentage.toString() + '%',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: height / 40,
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
                              Text("Customer Code",
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
                              Text(
                                "Customer Name",
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
                              Text("Discount Status",
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
                              Text("Purchase Status",
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
                      rows: li.items
                          .map(
                            (list) => DataRow(cells: [
                              DataCell(Center(
                                  child: Center(
                                child: Wrap(
                                    direction: Axis.vertical, //default
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(list.cusCode.toString(),
                                          textAlign: TextAlign.center)
                                    ]),
                              ))),
                              DataCell(Center(
                                  child: Center(
                                child: Wrap(
                                    direction: Axis.vertical, //default
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        list.cusName.toString(),
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
                                          list.discountApplied.toString() == "Y"
                                              ? "YES"
                                              : "NO",
                                          textAlign: TextAlign.center)
                                    ]))),
                              ),
                              DataCell(
                                Center(
                                    child: Center(
                                        child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                      Text(
                                          list.purchaseStatus.toString() == "Y"
                                              ? "YES"
                                              : "NO",
                                          textAlign: TextAlign.center)
                                    ]))),
                              ),
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: page > 1 ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          if (page > 1)
                            setState(() {
                              page--;
                              postRequest();
                            });
                        },
                      ),
                      int.parse(li.totalCount.toString()) == 0
                          ? Text("0 to 0 of 0")
                          : int.parse(li.totalCount.toString()) > (page * 10)
                              ? Text(
                                  "${(page * 10) - 9} to ${(page * 10)} of ${li.totalCount}")
                              : Text(
                                  "${(page * 10) - 9} to ${li.totalCount} of ${li.totalCount}"),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color:
                              int.parse(li.totalCount.toString()) > (page * 10)
                                  ? Colors.red
                                  : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (int.parse(li.totalCount.toString()) >
                                (page * 10)) {
                              page++;
                              postRequest();
                            }
                          });
                        },
                      )
                    ],
                  ),
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
                  //             initialValue: "2020",
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
                  //             initialValue: "1",
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
                  //             initialValue: "2020",
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
                  //             initialValue: "1",
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
                    height: height / 40,
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

class PlanListView {
  String planname;
  String property;
  String servicetype;
  String size;

  PlanListView({this.planname, this.property, this.servicetype, this.size});

  static List<PlanListView> getdata() {
    return <PlanListView>[
      PlanListView(
          planname: "Below 1000L",
          property: "Tank",
          servicetype: "Residential",
          size: "500"),
      PlanListView(
          planname: "1000L - 2000L",
          property: "Tank-sump",
          servicetype: "Commercial",
          size: "29966"),
      PlanListView(
          planname: "Above 1000L",
          property: "Car",
          servicetype: "Residential",
          size: "299"),
    ];
  }
}
