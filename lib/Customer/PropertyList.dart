import 'dart:convert';
import 'package:tankcarecustomer/Customer/New_Property.dart';
import 'package:tankcarecustomer/Customer/PropertyDetail.dart';
import 'package:tankcarecustomer/Customer/Property_Edit.dart';
import 'package:tankcarecustomer/CustomerModels/MenuModel.dart';
import 'package:tankcarecustomer/CustomerModels/PropertyType.dart';
import 'dart:io';
import 'dart:ui';
import 'package:tankcarecustomer/main.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/Property_List_Model.dart';
import 'package:tankcarecustomer/string_values.dart';

class PropertyList extends StatefulWidget {
  PropertyList({Key key, this.propertyid});

  String propertyid;

  @override
  _PropertyListState createState() => _PropertyListState();
}

class _PropertyListState extends State<PropertyList> {
  bool loading = false;
  bool sort;
  String dropdownValue3 = '-Action-';
  String propertyid;
  MenuList li3;
  ProprtyTypeList li4;
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
  List<String> stringlist2 = [
    '- Property Type -',
  ];
  PropertyListings li;

  TextEditingController searchController = new TextEditingController();

  var page = 1;

  var dropdownValue2 = '- Property Type -';
  var dropdownValue5 = '- Service Type -';
  var dropdownValue4 = '- Status -';
  String ptype = "";

  String stype = "";

  String stat = "";

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

  Future<http.Response> propertytypelist() async {
    setState(() {
      loading = true;
    });
    var url = String_values.base_url + 'property-type';
    print(url);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      li4 = ProprtyTypeList.fromJson(jsonDecode(response.body));
      setState(() {
        stringlist2.clear();
        stringlist2.add('- Property Type -');
        for (int i = 0; i < li4.tariff.length; i++)
          stringlist2.add(li4.tariff[i].ptypeName);
      });
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

    if (dropdownValue5 == '- Service Type -')
      stype = "";
    else if (dropdownValue5 == "Residential")
      stype = "RES";
    else
      stype = "COM";

    if (dropdownValue4 == '- Status -')
      stat = "";
    else
      stat = dropdownValue4.toString().substring(0, 1);
    print(stat);

    var url = String_values.base_url +
        'property-list?page=${page}&limit=10&search=${searchController.text}&ptype=$ptype&stype=$stype&verify_status=$stat';
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
      li = PropertyListings.fromJson(json.decode(response.body));
      print("plan${li.items[0].propertyName}");
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

  void initState() {
    sort = false;
    check().then((value) {
      if (value)
        postRequest()
            .then((value) => menulist())
            .then((value) => propertytypelist());
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
    // listplanyear = PlanListView.getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
          child: new Column(children: <Widget>[
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
                        "Property List",
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
                                    PropertyNew()));
                      },
                      child: Text(
                        "Add Property",
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
            SizedBox(
              height: height / 50,
            ),

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
                      if (newValue == '- Property Type -')
                        ptype = "";
                      else
                        for (int i = 0; i < li4.tariff.length; i++)
                          if (newValue == li4.tariff[i].ptypeName)
                            ptype = li4.tariff[i].ptypeId;
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
                    '- Service Type -',
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
                  items: <String>[
                    '- Status -',
                    "Approval",
                    "Pending",
                    "Rejected"
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: FlatButton(
                      onPressed: () {
                        postRequest();
                      },
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: FlatButton(
                      onPressed: () {
                        searchController.text = "";
                        ptype = "";

                        dropdownValue2 = '- Property Type -';
                        dropdownValue5 = '- Service Type -';
                        dropdownValue4 = '- Status -';
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

            SizedBox(
              height: height / 80,
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
                              "Name",
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
                            Text("Property Type",
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
                            Text("Group name",
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
                            Text("Verify Status",
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
                            Text("Actions",
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
                                    list.propertyName.toString(),
                                    textAlign: TextAlign.center,
                                  )
                                ])))),
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
                                ])))),
                    DataCell(Center(
                        child: Center(
                            child: Wrap(
                                direction: Axis.vertical, //default
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(list.propertyTypeName.toString(),
                                      textAlign: TextAlign.center)
                                ])))),
                    DataCell(Center(
                        child: Center(
                            child: Wrap(
                                direction: Axis.vertical, //default
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(list.propertyCode.toString(),
                                      textAlign: TextAlign.center)
                                ])))),
                    DataCell(Center(
                        child: Center(
                            child: Wrap(
                                direction: Axis.vertical, //default
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(list.groupName.toString(),
                                      textAlign: TextAlign.center)
                                ])))),
                    if (list.propertyApproval == "A")
                      DataCell(Center(
                          child: Center(
                              child: Wrap(
                                  direction: Axis.vertical, //default
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text("Approved", textAlign: TextAlign.center)
                                  ]))))
                    else if (list.propertyApproval == "R")
                      DataCell(Center(
                          child: Center(
                              child: Wrap(
                                  direction: Axis.vertical, //default
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text("Rejected", textAlign: TextAlign.center)
                                  ]))))
                    else if (list.propertyApproval == "P")
                        DataCell(Center(
                            child: Center(
                                child: Wrap(
                                    direction: Axis.vertical,
                                    //default
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text("Pending", textAlign: TextAlign.center)
                                    ])))),
                    if (list.propertyStatus == "A")
                      DataCell(Center(
                          child: Center(
                              child: Wrap(
                                  direction: Axis.vertical, //default
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text("Active", textAlign: TextAlign.center)
                                  ]))))
                    else
                      DataCell(Center(
                          child: Center(
                              child: Wrap(
                                  direction: Axis.vertical, //default
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text("InActive", textAlign: TextAlign.center)
                                  ])))),
                    if (list.propertyApproval != "A")
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
                                              PropertyView(
                                                  propertyid:
                                                  list.propertyId)));
                                else if (newValue == "Edit")
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PropertyEdit(
                                                  propertyid:
                                                  list.propertyId)));
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
                            items: stringlist
                                .map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value,
                                      child: Wrap(
                                          direction: Axis.vertical, //default
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
                    else
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
                                              PropertyView(
                                                  propertyid:
                                                  list.propertyId)));

//                                    else if (newValue == "Delete") {
//                                      delete(list.propertyId);
//                                      li.items.remove(list);
//                                    }
                              });
                            },
                            items: stringlist1
                                .map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value,
                                      child: Wrap(
                                          direction: Axis.vertical, //default
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
                    color: int.parse(li.totalCount.toString()) > (page * 10)
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (int.parse(li.totalCount.toString()) > (page * 10)) {
                        page++;
                        postRequest();
                      }
                    });
                  },
                )
              ],
            ),
          ])),
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
