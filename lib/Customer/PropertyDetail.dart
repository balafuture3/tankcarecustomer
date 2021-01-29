import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/APApproval.dart';
import 'package:tankcarecustomer/CustomerModels/PropertyDetail.dart';
import 'package:tankcarecustomer/string_values.dart';

class PropertyView extends StatefulWidget {
  PropertyView({Key key, this.propertyid});

  String propertyid;

  @override
  _PropertyViewState createState() => _PropertyViewState();
}

class _PropertyViewState extends State<PropertyView> {
  bool loading = false;
  PropertyDetailModel li;

  APDetails li2;

  Future<http.Response> approval(planid) async {
    setState(() {
      loading = true;
    });
    var url =
        String_values.base_url + 'ap-verify-details/' + planid + '/property';
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
      li2 = APDetails.fromJson(json.decode(response.body));
      setState(() {
        // ServiceByController.text=li.planServices.se
        //
        // DamageCodeController.text=li4.items.damageCode;
        // DamageStatusController.text=li4.items.damageStatus;
        // DamageNoteController.text=li4.items.damageNote;
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

  Future<http.Response> details(propertyid) async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'property-view/' + propertyid;
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
      li = PropertyDetailModel.fromJson(json.decode(response.body));

      PropertyNameController.text = li.propertyName.toString();
      GroupNameController.text = li.groupName.toString();
      if (li.serviceType.toString() == "COM")
        ServiceTypeController.text = "Commercial";
      else
        ServiceTypeController.text = "Residential";
      PropertyCodeController.text = li.propertyCode.toString();
      PropertyValueController.text = li.propertyValue.toString();
      PropertyTypeController.text = li.propertyTypeName;
      SelCusNameController.text = li.cusName;
      print("prop: ${li.propertyImages.toString()}");
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
  TextEditingController PropertyValueController = new TextEditingController();
  TextEditingController totalservicecontroller = new TextEditingController();
  TextEditingController literpricecontroller = new TextEditingController();
  TextEditingController fixedpricecontroller = new TextEditingController();
  List<PlanServiceYearClass> listplanyear;
  TextEditingController GroupNameController = new TextEditingController();
  TextEditingController ServiceTypeController = new TextEditingController();
  TextEditingController PropertyNameController = new TextEditingController();
  TextEditingController PropertyCodeController = new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController SelCusNameController = new TextEditingController();
  List<PlanListClass> selectedAvengers;
  bool sort;

  String dropdownValue = '-- Service Type --';

  String dropdownValue1 = '-- Property Type --';

  String dropdownValue2 = '-- Select Plan --';

  static List<String> friendsList = [null];

  void initState() {
    details(widget.propertyid).then((value) => approval(widget.propertyid));
    sort = false;
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
                    "View Property",
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
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            //   child: Container(
            //     child: new TextFormField(
            //       controller: SelCusNameController,
            //       enabled: false,
            //       decoration: InputDecoration(
            //         labelText: 'Selected Customer Name',
            //         hintStyle: TextStyle(
            //           color: Colors.grey,
            //           fontSize: 16.0,
            //         ),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(5.0),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: height / 50,
            // ),
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
                  controller: ServiceTypeController,
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
                  controller: PropertyNameController,
                  enabled: false,
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
            ),
            SizedBox(
              height: height / 80,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                child: new TextFormField(
                  controller: PropertyCodeController,
                  enabled: false,
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
            ),
            SizedBox(
              height: height / 80,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                child: new TextFormField(
                  controller: PropertyTypeController,
                  enabled: false,
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
            ),
            SizedBox(
              height: height / 80,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                child: new TextFormField(
                  controller: PropertyValueController,
                  enabled: false,
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
            ),
            SizedBox(
              height: height / 80,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 2.0,
                  ),
                ],
              ),
              // color: Colors.white,
              margin: EdgeInsets.all(3.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Text(
                        "Photos",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  li.propertyImages.toString() == "null"
                      ? Container()
                      : GridView.count(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    children: List.generate(
                      li.propertyImages.length,
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
                                            .propertyImages[index]
                                            .imgPath));
                                  },
                                  child: Image.network(
                                    li.propertyImages[index]
                                        .imgPath,
                                    height: 300,
                                    width: 300,
                                  ),
                                )));
                      },
                    ),
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
                      "Approval Process",
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
                                  Text("Order By",
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
                                  Text("Designation",
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
                                  Text("Approver",
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
                      ],
                      rows: li2.items
                          .map(
                            (list) => DataRow(cells: [
                          DataCell(Center(
                              child: Center(
                                child: Wrap(
                                    direction: Axis.vertical, //default
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        list.apDetailsOrderby.toString(),
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
                                      Text(list.urole.toString(),
                                          textAlign: TextAlign.center)
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
                                          Text(list.assignby.toString(),
                                              textAlign: TextAlign.center)
                                        ]))),
                          ),
                          list.apStatus.toString() == "P"
                              ? DataCell(
                            Center(
                                child: Center(
                                    child: Wrap(
                                        direction: Axis
                                            .vertical, //default
                                        alignment: WrapAlignment
                                            .center,
                                        children: [
                                          Text("Pending",
                                              textAlign:
                                              TextAlign.center)
                                        ]))),
                          )
                              : DataCell(
                            Center(
                                child: Center(
                                    child: Wrap(
                                        direction: Axis
                                            .vertical, //default
                                        alignment: WrapAlignment
                                            .center,
                                        children: [
                                          Text("Approved",
                                              textAlign:
                                              TextAlign.center)
                                        ]))),
                          ),
                        ]),
                      )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Image.asset('logotitle.png',height: 40),
      ),
    );
  }

//  onSortColum(int columnIndex, bool ascending) {
//    if (columnIndex == 0) {
//      if (ascending) {
//        listplan.sort((a, b) => a.name.compareTo(b.name));
//      } else {
//        listplan.sort((a, b) => b.name.compareTo(a.name));
//      }
//    }
//  }
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
