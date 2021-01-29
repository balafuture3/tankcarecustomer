import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:tankcarecustomer/Customer/PlaNUpgrade.dart';
import 'package:tankcarecustomer/CustomerModels/MenuModel.dart';
import 'package:tankcarecustomer/main.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:tankcarecustomer/Customer/PlanAdd.dart';
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/planlist.dart';
import 'package:tankcarecustomer/string_values.dart';

import 'PlanDetail.dart';

class PlanList extends StatefulWidget {
  @override
  PlanListState createState() => PlanListState();
}

class PlanListState extends State<PlanList> {
  bool loading = false;

  PlanListings li;

  var page = 1;
  MenuList li3;
  String p_Update;
  String p_Delete;
  String p_Create;
  String p_Read;
  List<String> stringlist = [
    '-- Property Type --',
    "Tank",
    "OverHead Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor",
    "OverHead Tank Tile"
  ];
  List<String> stringlist1 = [
    '-- Property Type --',
    "Tank",
    "OverHead Tank",
    "Sump",
    "Sump-Tile",
    "Car",
    "Bike",
    "Floor",
    "OverHead Tank Tile"
  ];

  var dropdownValue5 = '- Service Status -';

  String dropdownValue4 = '- Paid Status -';

  String stype = "";

  String stat = "";

  String ptype = "";

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<http.Response> menulist() async {
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
      setState(() {
        stringlist.clear();
        stringlist.add("-Action-");
        stringlist1.clear();
        stringlist1.add("-Action-");

                  stringlist1.add("View");
                  stringlist.add("View");

                  stringlist.add("Edit");

                  stringlist.add("Delete");

      });

      print(p_Create);
      print(p_Update);
      print(p_Delete);
      print(p_Read);
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

  Future<http.Response> postRequest() async {
    setState(() {
      loading = true;
    });

    if (dropdownValue5 == '- Service Status -')
      stype = "";
    else
      stype = dropdownValue5.toUpperCase();

    if (dropdownValue4 == '- Paid Status -')
      stat = "";
    else
      stat = dropdownValue4.toUpperCase();

    if (dropdownValue2 == '-- Plan Type --')
      ptype = "";
    else
      ptype = dropdownValue2.substring(0, 1);

    var url = String_values.base_url +
        'property-cus-plan?page=${page}&limit=10&search=${searchController.text}&plan_type=$ptype&service_status=${stype}&paid=$stat';
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
      li = PlanListings.fromJson(json.decode(response.body));
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

  String dropdownValue2 = '-- Plan Type --';

  String dropdownValue3 = '-Action-';

  static List<String> friendsList = [null];

  void initState() {
    sort = false;
    setState(() {
      loading = true;
    });
    check().then((value) {
      if (value)
        postRequest().then((value) => menulist());
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Text(
                        "Property Plan List",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 17),
                      ),
                    ),
                  ),
                  // Container(
                  //     width: width / 2,
                  //     margin: EdgeInsets.all(12),
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //         color: Colors.red,
                  //         borderRadius: BorderRadius.all(Radius.circular(50))),
                  //     child: FlatButton(
                  //       onPressed: () {
                  //         Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => GroupService()));
                  //       },
                  //       child: Text(
                  //         "Add Group",
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //     )),
                Container(
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius:
                        BorderRadius.all(Radius.circular(20))),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PlanNew()));
                      },
                      child: Text(
                        "Add Plan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )

                ],
              ),
            ),
            SizedBox(
              height: height / 50,
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
            //   margin: EdgeInsets.only(top: 10.0, bottom: 10),
            //
            //   child: new Text(
            //     "Group",
            //     textAlign: TextAlign.left,
            //     style: TextStyle(
            //         fontWeight: FontWeight.bold, color: Colors.red),
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: new TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: height / 40,
            ),

            Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
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
                    });
                  },
                  items: <String>[
                    '-- Plan Type --',
                    "New",
                    'Renewal',
                    'Upgrade'
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
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  border: new Border.all(color: Colors.black38)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue5,
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue5 = newValue;
                    });
                  },
                  items: <String>[
                    '- Service Status -',
                    "Pending",
                    "Completed",
                    "Ongoing"
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
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  border: new Border.all(color: Colors.black38)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue4,
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue4 = newValue;
                    });
                  },
                  items: <String>['- Paid Status -', "Paid", "Unpaid"]
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
                        BorderRadius.all(Radius.circular(50))),
                    child: FlatButton(
                      onPressed: () {
                        postRequest();
                      },
                      child: Text(
                        "Filter",
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
                      onPressed: () {
                        searchController.text = "";

                        dropdownValue5 = '- Service Status -';
                        stype = "";

                        dropdownValue4 = '- Paid Status -';
                        stat = "";

                        dropdownValue2 = '-- Plan Type --';
                        ptype = "";
                        check().then((value) {
                          if (value)
                            postRequest();
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
                      },
                      child: Text(
                        "Clear",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ],
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
                            Text(
                              "Plan Name",
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
                            Text("Property Code",
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
                            Text("Group Code",
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
                            Text("Plan Year",
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
                            Text("Services",
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
                            Text("Type",
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
                            Text("Service Status",
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
                rows: li.items
                    .map(
                      (list) => DataRow(cells: [
                    DataCell(Center(
                        child: Center(
                          child: Wrap(
                              direction: Axis.vertical, //default
                              alignment: WrapAlignment.center,
                              children: [
                                Text(
                                  list.pplanName.toString(),
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
                                  list.cusName.toString(),
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
                                Text(list.propertyCode.toString(),
                                    textAlign: TextAlign.center)
                              ]),
                        ))),
                    DataCell(
                      Center(
                          child: Center(
                              child: Wrap(
                                  direction: Axis.vertical, //default
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text(list.groupCode.toString(),
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
                                    Text(list.pplanYear.toString(),
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
                                    Text(list.pplanService.toString(),
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
                                        list.pplanType.toString() == "N"
                                            ? "New"
                                            : list.pplanType.toString() == "R"
                                            ? "Renewal"
                                            : list.pplanType.toString() ==
                                            "U"
                                            ? "Upgrade"
                                            : "",
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
                                    Text(list.pplanCurrentStatus.toString(),
                                        textAlign: TextAlign.center)
                                  ]))),
                    ),
                    DataCell(
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownValue3,
                          onChanged: (String newValue) {
                            setState(() {
                              if (newValue == "View")
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PlanDetail(
                                                planid:
                                                list.pplanId)));
                              else if (newValue == "Upgrade")
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EmployeePlanUpgrade(
                                              id: list.pplanId,
                                              renewal: false,
                                            )));
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
                          items: (list.pplanType == "N" &&
                              list.pplanCurrentStatus ==
                                  "PENDING" &&
                              int.parse(list.udayCount) <= 15)
                              ? <String>[
                            "-Action-",
                            "View",
                            "Upgrade"
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
                              }).toList()
                              : <String>["-Action-", "View"]
                              .map<DropdownMenuItem<String>>(
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
