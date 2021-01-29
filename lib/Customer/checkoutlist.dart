import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:tankcarecustomer/CustomerModels/checkout.dart';
import 'package:tankcarecustomer/main.dart';
import 'package:tankcarecustomer/main.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tankcarecustomer/Customer/billlist.dart';
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/checkoutlist.dart';
import 'package:tankcarecustomer/CustomerModels/checkoutpay.dart';
import 'package:tankcarecustomer/CustomerModels/discount.dart';

import '../string_values.dart';

class CheckOutList extends StatefulWidget {
  @override
  CheckOutListState createState() => CheckOutListState();
}

class CheckOutListState extends State<CheckOutList> {
  bool loading = false;
  var file;
  List<File> files = [];
  CheckOutListings li;

  List<bool> rowselected = new List();

  List<String> selectedPlanIds = new List();

  CheckOutListings row;

  Checkout li2;

  double totalamount = 0;
  double discount1 = 0;
  Discount li4;

  bool discountapply = false;
  TextEditingController PaymentRemarksController = new TextEditingController();
  TextEditingController PaymentReferanceController = new TextEditingController();
  PlanCheckoutResult li11;

  String dropdownValue5='-- Select Payment Type --';

  File image;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  // Future<http.Response> showBill() async {
  //   setState(() {
  //     loading=true;
  //   });
  //
  //   var url =
  //       String_values.base_url+'get-checkout-plan';
  //   Map data =
  //   {//"group_name":"Test", "group_address":"123 Coimbaotre, Tamilnadu", "service_type":"RES", "group_contact_name":"Raj", "group_contact_phone":"9597318426", "map_location":"123 Coimbaotre, Tamilnadu", "latitude":"1234657", "longitude":"12346578", "district_id":"1", "state_id":"1"}
  //     "plan_id":selectedPlanIds,
  //  }
  //   ;
  //   print("data: ${data}");
  //   print(String_values.base_url);
  //   //encode Map to JSON
  //   var body = json.encode(data);
  //   print("response: ${body}");
  //   var response = await http.post(url,
  //       headers: {"Content-Type": "application/json",'Authorization': 'Bearer ${RegisterPagesState.token}'},
  //       body: body);
  //   if (response.statusCode == 200)
  //   {
  //     setState(() {
  //       loading=false;
  //     });
  //     //li2= GroupAdd.fromJson(json.decode(response.body));
  //     // if(li2.status)
  //
  //     // else
  //     //   showDialog<void>(
  //     //     context: context,
  //     //     barrierDismissible: false, // user must tap button!
  //     //     builder: (BuildContext context) {
  //     //       return AlertDialog(
  //     //         backgroundColor: Colors.white,
  //     //         title: Text("Group Name Already Exist"),
  //     //         actions: <Widget>[
  //     //           TextButton(
  //     //             child: Text('OK'),
  //     //             onPressed: () {
  //     //               Navigator.of(context).pop();
  //     //             },
  //     //           ),
  //     //         ],
  //     //       );
  //     //     },
  //     //   );
  //   }
  //
  //   else {
  //     setState(() {
  //       loading=false;
  //     });
  //     print("Retry");
  //   }
  //   print("response: ${response.statusCode}");
  //   print("response: ${response.body}");
  //   return response;
  // }

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
      li4 = Discount.fromJson(json.decode(response.body));
      //  print("plan${li.items[0].mapLocation}");
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

    var url = String_values.base_url + 'property-cus-plan?paid=unpaid&verify=y';
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
      li = CheckOutListings.fromJson(json.decode(response.body));
      //  print("plan${li.items[0].mapLocation}");
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

  Future<int> showBill() async {
    setState(() {
      loading = true;
    });
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    Map data = {'plan_id': selectedPlanIds};

    print(String_values.base_url);
    //encode Map to JSON
    var url = String_values.base_url + 'get-checkout-plan';
    var body = json.encode(data);
    print("${body}");
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${RegisterPagesState.token}'
        },
        body: body);
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        loading = false;
      });
      li11 = PlanCheckoutResult.fromJson(json.decode(response.body));
      totalamount = 0;
      for (int i = 0; i < li11.data.length; i++)
        totalamount = totalamount + double.parse(li11.data[i].pplanTotPrice);
      if (li4.data.rdPercentage != null)
        discount1 =
            (totalamount * double.parse(li4.data.rdPercentage.toString())) /
                100;
      else
        discount1 = 0;
      if (li11.status)
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            child: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, StateSetter setState) {
                  return AlertDialog(
                    title: Text(
                      "Checkout",
                      style: TextStyle(color: Colors.red),
                    ),
                    actions: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          sortColumnIndex: 0,
                          columnSpacing: MediaQuery.of(context).size.width / 50,
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
                                      Text("Total Service",
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
                                      Text("Total Year",
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
                                      Text("Plan Price",
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

                            // DataColumn(
                            //   label: Center(
                            //       child: Wrap(
                            //         direction: Axis.vertical, //default
                            //         alignment: WrapAlignment.center,
                            //         children: [
                            //           Text("Action",
                            //               softWrap: true,
                            //               style: TextStyle(fontSize: 12),
                            //               textAlign: TextAlign.center),
                            //         ],
                            //       )),
                            //   numeric: false,
                            //
                            //   // onSort: (columnIndex, ascending) {
                            //   //   onSortColum(columnIndex, ascending);
                            //   //   setState(() {
                            //   //     sort = !sort;
                            //   //   });
                            //   // }
                            // ),
                          ],
                          rows: li11.data
                              .map(
                                (list) => DataRow(cells: [
                              DataCell(Center(
                                  child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
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
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(list.pplanService,
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),
                              DataCell(Center(
                                  child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(list.pplanYear,
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),
                              DataCell(Center(
                                  child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(list.pplanTotPrice,
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),

                              // DataCell(list.billApproval == "A"
                              //     ? Center(
                              //     child: Center(
                              //         child: Wrap(
                              //             direction:
                              //             Axis.vertical, //default
                              //             alignment: WrapAlignment.center,
                              //             children: [
                              //               Text("Active",
                              //                   textAlign: TextAlign.center)
                              //             ])))
                              //     : list.billApproval == "P"
                              //     ? Center(
                              //     child: Center(
                              //         child: Wrap(
                              //             direction:
                              //             Axis.vertical, //default
                              //             alignment:
                              //             WrapAlignment.center,
                              //             children: [
                              //               Text("Pending",
                              //                   textAlign: TextAlign.center)
                              //             ])))
                              //     : Center(
                              //     child: Center(
                              //       child: Wrap(
                              //           direction:
                              //           Axis.vertical, //default
                              //           alignment: WrapAlignment.center,
                              //           children: [
                              //             Text("Complete",
                              //                 textAlign: TextAlign.center)
                              //           ]),
                              //     ))),
                              // DataCell(
                              //   list.billStatus == "A"
                              //       ? Center(
                              //       child: Center(
                              //           child: Wrap(
                              //               direction:
                              //               Axis.vertical, //default
                              //               alignment: WrapAlignment.center,
                              //               children: [
                              //                 Text("Active",
                              //                     textAlign: TextAlign.center)
                              //               ])))
                              //       : list.billStatus == "P"
                              //       ? Center(
                              //       child: Center(
                              //           child: Wrap(
                              //               direction:
                              //               Axis.vertical, //default
                              //               alignment:
                              //               WrapAlignment.center,
                              //               children: [
                              //                 Text("Pending",
                              //                     textAlign: TextAlign.center)
                              //               ])))
                              //       : Center(
                              //       child: Center(
                              //           child: Wrap(
                              //               direction:
                              //               Axis.vertical, //default
                              //               alignment:
                              //               WrapAlignment.center,
                              //               children: [
                              //                 Text("Complete",
                              //                     textAlign: TextAlign.center)
                              //               ]))),
                              // ),
                              // DataCell(
                              //   FlatButton(
                              //     onPressed: ()
                              //{

                              //       // Navigator.push(
                              //       //     context,
                              //       //     MaterialPageRoute(
                              //       //         builder: (context) =>
                              //       //             BillDetail(
                              //       //                 groupid:
                              //       //                 list.pplanId)));
                              //     },
                              //     child: Text("Pay",style: TextStyle(color:Colors.red),),
                              //   ),
                              // ),
                            ]),
                          )
                              .toList(),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text('Total Amount : ${totalamount}'),
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),

                            // color: Colors.white,

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Text(
                                  "Total Items: ${li11.data.length}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Text(
                                  "Subtotal Amount: ${totalamount}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Text(
                                  "Registration Fee: ${li11.regFee.toString()}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Text(
                                  "Discount Amount: ${discount1}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // discountapply
                                //     ?
                                Text(
                                  "Total Amount: ${(totalamount+double.parse(li11.regFee)) - discount1}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                )
                                //     : Text(
                                //   "Total Amount: ${totalamount+li2.regFee}",
                                //   textAlign: TextAlign.left,
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       color: Colors.red),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height / 50),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height:50,width: MediaQuery.of(context).size.width-50,
                                  margin:
                                  const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0),
                                  padding:
                                  const EdgeInsets.only(
                                      left: 20.0,
                                      right: 10.0),
                                  decoration: new BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              2.0)),
                                      border: new Border
                                          .all(
                                          color: Colors
                                              .black38)),
                                  child:
                                  DropdownButtonHideUnderline(
                                      child:
                                      DropdownButton<
                                          String>(
                                        isExpanded: true,
                                        value: dropdownValue5,
                                        onChanged: (String
                                        newValue) {
                                          setState(() {
                                            dropdownValue5 =
                                                newValue;
                                          });
                                        },
                                        items: <String>[
                                          '-- Select Payment Type --',
                                          "Cash",
                                          "Bank Transfer",
                                          "POS(Point Of Sales)"
                                        ].map<
                                            DropdownMenuItem<
                                                String>>((String
                                        value) {
                                          return DropdownMenuItem<
                                              String>(
                                              value: value,
                                              child: Wrap(
                                                  direction: Axis
                                                      .vertical,
                                                  //default
                                                  alignment:
                                                  WrapAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      value,
                                                      style: TextStyle(
                                                          fontSize:
                                                          12,
                                                          color:
                                                          Colors.red,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ]));
                                        }).toList(),
                                      ))),

                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height:60,width: MediaQuery.of(context).size.width-50,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: new TextField(
                              enabled: true,
                              controller: PaymentReferanceController,
                              decoration: InputDecoration(
                                labelText: 'Payment Reference No',
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
                            height: 10,
                          ),
                          Container(
                            height:60,width: MediaQuery.of(context).size.width-50,
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: new TextField(
                              enabled: true,
                              controller: PaymentRemarksController,
                              decoration: InputDecoration(
                                labelText: 'Payment Remarks',
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
                            height: 20,
                          ),
                          Container(
                            padding:
                            EdgeInsets.all(
                                5),
                            width: MediaQuery.of(context).size.width,
                            decoration:
                            BoxDecoration(
                              color:
                              Colors.white,
                            ),
                            // color: Colors.white,
                            margin:
                            EdgeInsets.only(
                                top: 5.0),

                            child: new Text(
                              "Payment Images",
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
                                            MediaQuery.of(context).size.width /
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
                                  width: MediaQuery.of(context).size.width / 3,
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
                              )),
                          SizedBox(
                            height: 10,
                          ),

                          // Container(
                          //   height: 30,
                          //   padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                          //   decoration: new BoxDecoration(
                          //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          //       border: new Border.all(color: Colors.black38)),
                          //   child: DropdownButtonHideUnderline(
                          //     child: DropdownButton<String>(
                          //       // dropdownColor: Colors.red,
                          //       isExpanded: true,
                          //       value: dropdownValue5,
                          //       onChanged: (String newValue) {
                          //         setState(() {
                          //           dropdownValue5 = newValue;
                          //         });
                          //       },
                          //       items: <String>[
                          //         '-- Select Payment Type --',
                          //         "Cash",
                          //         "Bank Transfer",
                          //         "POS(Point Of Sales)",
                          //       ].map<DropdownMenuItem<String>>((String value) {
                          //         return DropdownMenuItem<String>(
                          //           value: value,
                          //           child: Text(
                          //             value,
                          //             style: TextStyle(color: Colors.red),
                          //           ),
                          //         );
                          //       }).toList(),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: MediaQuery.of(context).size.height / 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                    width: MediaQuery.of(context).size.width / 4,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                    child: FlatButton(
                                      onPressed: () {
                                        if(dropdownValue5!='-- Select Payment Type --')
                                          payBill("");
                                        else
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Please select payment type"),
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
                                      },
                                      child: Text(
                                        "Pay",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                    width: MediaQuery.of(context).size.width / 4,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ),
                            ],
                          )
                        ],
                      )

                    ],
                  );
                },
              ),
            ));
    }
  }

  Future<int> payBill(url) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'plan-bill-mobile'));
    for (int i = 0; i < files.length; i++)
      request.files.add(
          await http.MultipartFile.fromPath('pay_image[]', files[i].path));

    request.headers.addAll(headers);
    request.fields['pay_ref'] = PaymentReferanceController.text;
    request.fields['pplan_id'] = json.encode(selectedPlanIds);
    request.fields["total_items"] = li11.data.length.toString();
    if (li4.data.rdPercentage != null)
      request.fields["ref_discount_id"] = li4.data.rdId;
    request.fields["bill_amount"] = totalamount.toString();
    request.fields["discount"] = discount1.toString();
    if (li4.data.rdPercentage != null)
      request.fields["paid_amount"] = (totalamount - discount1).toString();
    else
      request.fields["paid_amount"] = totalamount.toString();
    request.fields["paid_status"] = "PAID";
    var res = await request.send();
    print(json.encode(selectedPlanIds));
    postRequest();
    Navigator.pop(context);
    return res.statusCode;

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
        postRequest();
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
                        child: new Text(
                          "Checkout List",
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
                    margin: const EdgeInsets.only(left: 24, right: 24),
                    child: new TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
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
                    height: height / 40,
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
                              "Search",
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
                    height: height / 40,
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
                              Text("Total Service",
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
                              Text("Total Year",
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
                              Text("Plan Price",
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

                        // DataColumn(
                        //   label: Center(
                        //       child: Wrap(
                        //         direction: Axis.vertical, //default
                        //         alignment: WrapAlignment.center,
                        //         children: [
                        //           Text("Action",
                        //               softWrap: true,
                        //               style: TextStyle(fontSize: 12),
                        //               textAlign: TextAlign.center),
                        //         ],
                        //       )),
                        //   numeric: false,
                        //
                        //   // onSort: (columnIndex, ascending) {
                        //   //   onSortColum(columnIndex, ascending);
                        //   //   setState(() {
                        //   //     sort = !sort;
                        //   //   });
                        //   // }
                        // ),
                      ],
                      rows: li.items
                          .map(
                            (list) => DataRow(
                                selected:
                                    selectedPlanIds.contains(list.pplanId),
                                onSelectChanged: (b) {
                                  setState(() {
                                    if (b) {
                                      selectedPlanIds.add(list.pplanId);
                                    } else {
                                      selectedPlanIds.remove(list.pplanId);
                                    }
                                  });
                                },
                                cells: [
                                  DataCell(Center(
                                      child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
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
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(list.pplanService,
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),
                                  DataCell(Center(
                                      child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(list.pplanYear,
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),
                                  DataCell(Center(
                                      child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(list.pplanPrice,
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),
                                  DataCell(Center(
                                      child: Center(
                                    child: Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(list.pplanCurrentStatus,
                                              textAlign: TextAlign.center)
                                        ]),
                                  ))),

                                  // DataCell(list.billApproval == "A"
                                  //     ? Center(
                                  //     child: Center(
                                  //         child: Wrap(
                                  //             direction:
                                  //             Axis.vertical, //default
                                  //             alignment: WrapAlignment.center,
                                  //             children: [
                                  //               Text("Active",
                                  //                   textAlign: TextAlign.center)
                                  //             ])))
                                  //     : list.billApproval == "P"
                                  //     ? Center(
                                  //     child: Center(
                                  //         child: Wrap(
                                  //             direction:
                                  //             Axis.vertical, //default
                                  //             alignment:
                                  //             WrapAlignment.center,
                                  //             children: [
                                  //               Text("Pending",
                                  //                   textAlign: TextAlign.center)
                                  //             ])))
                                  //     : Center(
                                  //     child: Center(
                                  //       child: Wrap(
                                  //           direction:
                                  //           Axis.vertical, //default
                                  //           alignment: WrapAlignment.center,
                                  //           children: [
                                  //             Text("Complete",
                                  //                 textAlign: TextAlign.center)
                                  //           ]),
                                  //     ))),
                                  // DataCell(
                                  //   list.billStatus == "A"
                                  //       ? Center(
                                  //       child: Center(
                                  //           child: Wrap(
                                  //               direction:
                                  //               Axis.vertical, //default
                                  //               alignment: WrapAlignment.center,
                                  //               children: [
                                  //                 Text("Active",
                                  //                     textAlign: TextAlign.center)
                                  //               ])))
                                  //       : list.billStatus == "P"
                                  //       ? Center(
                                  //       child: Center(
                                  //           child: Wrap(
                                  //               direction:
                                  //               Axis.vertical, //default
                                  //               alignment:
                                  //               WrapAlignment.center,
                                  //               children: [
                                  //                 Text("Pending",
                                  //                     textAlign: TextAlign.center)
                                  //               ])))
                                  //       : Center(
                                  //       child: Center(
                                  //           child: Wrap(
                                  //               direction:
                                  //               Axis.vertical, //default
                                  //               alignment:
                                  //               WrapAlignment.center,
                                  //               children: [
                                  //                 Text("Complete",
                                  //                     textAlign: TextAlign.center)
                                  //               ]))),
                                  // ),
                                  // DataCell(
                                  //   FlatButton(
                                  //     onPressed: ()
                                  //{

                                  //       // Navigator.push(
                                  //       //     context,
                                  //       //     MaterialPageRoute(
                                  //       //         builder: (context) =>
                                  //       //             BillDetail(
                                  //       //                 groupid:
                                  //       //                 list.pplanId)));
                                  //     },
                                  //     child: Text("Pay",style: TextStyle(color:Colors.red),),
                                  //   ),
                                  // ),
                                ]),
                          )
                          .toList(),
                    ),
                  ),

                  SizedBox(
                    height: height / 40,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        width: width / 2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: FlatButton(
                          onPressed: () {
                            discount().then((value) => showBill());
                          },
                          child: Text(
                            "Pay",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
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
