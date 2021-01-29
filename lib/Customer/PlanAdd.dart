import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tankcarecustomer/Customer/GroupList.dart';
import 'package:tankcarecustomer/Customer/PropertyList.dart';
import 'package:tankcarecustomer/Customer/checkoutlist.dart';
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/ErrorResponse.dart';
import 'package:tankcarecustomer/CustomerModels/ImageUploadModel.dart';
import 'package:tankcarecustomer/CustomerModels/PlanAddResponse.dart';
import 'package:tankcarecustomer/CustomerModels/autocomplete.dart';
import 'package:tankcarecustomer/CustomerModels/autocompleteplan.dart';
import 'package:tankcarecustomer/CustomerModels/checkout.dart';
import 'package:tankcarecustomer/CustomerModels/checkoutpay.dart';
import 'package:tankcarecustomer/CustomerModels/discount.dart';
import 'package:tankcarecustomer/CustomerModels/priceapi.dart';
// import 'package:tankcarecustomer/Employee/EmployeeModels/Property/Property/PlanAddResponse.dart';
import 'package:tankcarecustomer/string_values.dart';

import 'PlanList.dart';

class PlanNew extends StatefulWidget {
  final String title = "AutoComplete Demo";

  @override
  PlanNewState createState() => PlanNewState();
}

class PlanNewState extends State<PlanNew> {
  bool valueinfeetshow = true;
  var file;
  List<File> files = [];
  bool heightshow = true;
  bool widthshow = true;
  bool lengthshow = true;
  bool buttonshow = true;
  final dateFormatter = DateFormat('yyyy-MM-dd');
  String sql_dob;
  String groupid;
  String ptypeid;
  String stype;
  String total;

  PriceAPIListings li3;

  String propid;

  String cusid;

  PlanCheckoutResult li2;

  PlanAddResponse li5;

  ErrorResponse ei;

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
  Future<http.Response> discount() async {
    setState(() {
      loading = true;
    });

    var url = String_values.base_url + 'ref-cus-discount?cus_id=$cusid';
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
  @override
  void initState() {
    _isVisible = !_isVisible;
    images.add("Add Image");
    images.add("Add Image");
    images.add("Add Image");
    images.add("Add Image");
    images.add("Add Image");
    images.add("Add Image");
    super.initState();
  }

  List<String> stringlist1 = [
    '-- Select Year --',
  ];
  List<String> stringlist2 = [
    '-- Select Service --',
  ];
  List<Object> images = List<Object>();
  bool loading = false;
  String dropdownValue2 = '-- Select Year --';
  String dropdownValue3 = '-- Select Service --';

  String dropdownValue5 =  '-- Select Payment Type --';
  bool _isVisible = false;
  String result = "0";
  final TextEditingController _typeAheadController = TextEditingController();
  TextEditingController heightcontroller = new TextEditingController();
  TextEditingController PaymentReferanceController = new TextEditingController();
  TextEditingController CusNameController = new TextEditingController();
  TextEditingController widthcontroller = new TextEditingController();
  TextEditingController lengthcontroller = new TextEditingController();
  TextEditingController valuecontroller = new TextEditingController();
  TextEditingController Group_name = new TextEditingController();
  TextEditingController GroupNameController = new TextEditingController();
  TextEditingController ServiceController = new TextEditingController();
  TextEditingController PaymentRemarksController = new TextEditingController();
  TextEditingController PropertyCodeController = new TextEditingController();
  TextEditingController PropertyTypeController = new TextEditingController();
  TextEditingController PlanController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController TotalServicesController = new TextEditingController();
  TextEditingController PlanStartController = new TextEditingController();
  TextEditingController datecontroller = new TextEditingController();
  List<String> imagefile = new List();
  double totalamount = 0;
  double discount1 = 0;
  Discount li4;
  List<String> selectedPlanIds = new List();
  bool discountapply = false;

  Future<int> payBill(url) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'plan-bill'));
    for (int i = 0; i < files.length; i++)
      request.files.add(
          await http.MultipartFile.fromPath('pay_image[]', files[i].path));
    request.headers.addAll(headers);
    request.fields['pplan_id'] = li5.pplanId;
    request.fields['pay_ref'] = PaymentReferanceController.text;
    request.fields['cus_id']=cusid;
    request.fields["total_items"] = li2.data.length.toString();
    if (li4.data.rdPercentage != null)
      request.fields["ref_discount_id"] = li4.data.rdId;
    request.fields["bill_amount"] = ((totalamount+double.parse(li2.regFee)) - discount1).toString();
    request.fields["discount"] = discount1.toString();
    if (li4.data.rdPercentage != null)
      request.fields["paid_amount"] = ((totalamount+double.parse(li2.regFee)) - discount1).toString();
    else
      request.fields["paid_amount"] = (totalamount+double.parse(li2.regFee)).toString();
    request.fields["reg_fee"] = li2.regFee.toString();
    request.fields["payment_remarks"] = PaymentRemarksController.text;
    request.fields["paid_status"] = "PAID";
    if(dropdownValue5=="Cash")
      request.fields["payment_type"] = "CASH";
    else if(dropdownValue5=="Bank Transfer")
      request.fields["payment_type"] = "BANK";
    else if(dropdownValue5=="POS(Point Of Sales)")
      request.fields["payment_type"] = "POS";
    var res = await request.send();
    res.stream.transform(utf8.decoder).listen((value) {

      print(value);

      setState(() {
        loading = false;
      });
      if(value.toString().contains("true")) {
        Fluttertoast.showToast(
            msg: "Plan Added Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PlanList()),
        );
      }
      else
      {
        ei=ErrorResponse.fromJson(jsonDecode(value));
        Fluttertoast.showToast(
            msg: ei.messages,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }


      setState(() {
        loading = false;
      });
    });
    return res.statusCode;
  }

  Future<int> showBill(planid) async {
    setState(() {
      loading = true;
    });
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };

    Map data = {'plan_id': planid};

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
      li2 = PlanCheckoutResult.fromJson(json.decode(response.body));
      totalamount = 0;
      for (int i = 0; i < li2.data.length; i++)
        totalamount = totalamount + double.parse(li2.data[i].pplanTotPrice);
      if (li4.data.rdPercentage != null)
        discount1 =
            (totalamount * double.parse(li4.data.rdPercentage.toString())) /
                100;
      else
        discount1 = 0;
      if (li2.status)
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
                          rows: li2.data
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
                                  "Total Items: ${li2.data.length}",
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
                                  "Registration Fee: ${li2.regFee.toString()}",
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
                                  "Total Amount: ${(totalamount+double.parse(li2.regFee)) - discount1}",
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
  Future<int> uploadImage(url,checkout) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'property-plan-add'));
    //property_id plan_id pplan_name pplan_year pplan_service pplan_price pplan_tot_price pplan_start_date
    request.headers.addAll(headers);
    request.fields['property_id'] = propid;
    request.fields['pplan_type'] = "N";
    request.fields['plan_id'] = li3.items.planId;
    request.fields['cus_id'] = cusid;
    request.fields['pplan_name'] = li3.items.planName;
    request.fields['pplan_year'] = dropdownValue2;
    request.fields['pplan_service'] = dropdownValue3;
    request.fields['pplan_price'] = priceController.text;
    request.fields['pplan_tot_price'] = priceController.text;
    request.fields['pplan_start_date'] = sql_dob;
    var res = await request.send();
    res.stream.transform(utf8.decoder).listen((value) {
      print(value);
      li5= PlanAddResponse.fromJson(json.decode(value));
      if(checkout)
      showBill(li5.pplanId);
      else
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CheckOutList()));
      setState(() {
        loading = false;
      });});
    print(res.statusCode);
    return res.statusCode;

  }

  @override
  Widget build(BuildContext context) {

    Future<http.Response> postRequest() async {
      setState(() {
        loading = true;
      });

      var url = String_values.base_url +
          'property-plan-price?group_id=${groupid}&ptype_id=${ptypeid}&stype=${stype}&total_value=${total}&year_type=d';
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
          for (int i = 0; i < li3.items.price[0].service.length; i++)
            stringlist2.add(li3.items.price[0].service[i].totalService);
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Text(
                    "New Plan",
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
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  enabled: true,
                  controller: this._typeAheadController,
                  // onTap: ()
                  // {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               Category(userid:HomeState.userid,mapselection: true)));
                  // },
                  keyboardType: TextInputType.text,
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
                suggestionsCallback: (pattern) {
                  return BackendService.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  // postRequest(suggestion);
                  for (int i = 0; i < BackendService.li1.items.length; i++) {
                    print(BackendService.li1.items[i].propertyName);
                    if (BackendService.li1.items[i].propertyName ==
                        suggestion) {
                      GroupNameController.text =
                          BackendService.li1.items[i].groupName.toString();
                      PropertyCodeController.text =
                          BackendService.li1.items[i].propertyCode.toString();
                      PropertyTypeController.text = BackendService
                          .li1.items[i].propertyTypeName
                          .toString();
                      valuecontroller.text = BackendService
                          .li1.items[i].propertyValue
                          .toString();
                      groupid =
                          BackendService.li1.items[i].groupId.toString();
                      propid =
                          BackendService.li1.items[i].propertyId.toString();

                      ptypeid = BackendService.li1.items[i].propertyTypeId
                          .toString();
                      CusNameController.text =
                          BackendService.li1.items[i].cusName.toString();
                      stype =
                          BackendService.li1.items[i].serviceType.toString();
                      cusid = BackendService.li1.items[i].cusId.toString();
                      total = BackendService.li1.items[i].propertyValue
                          .toString();
                      if (BackendService.li1.items[i].serviceType
                          .toString() ==
                          "RES")
                        ServiceController.text = "Residential";
                      else
                        ServiceController.text = "Commercial";
                    }
                  }
                  this._typeAheadController.text = suggestion;
                  postRequest();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please select a city';
                  } else
                    return 'nothing';
                },
                // onSaved: (value) => this._selectedCity = value,
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
                controller: CusNameController,
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
                "Plan",
                textAlign: TextAlign.left,
                style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
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
                  labelText: 'Plan',
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
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                      stringlist2.clear();
                      priceController.text = "";
                      TotalServicesController.text = "";
                      dropdownValue3 = '-- Select Service --';
                      stringlist2.add('-- Select Service --');
                      for (int j = 0; j < li3.items.price.length; j++) {
                        for (int i = 0;
                        i < li3.items.price[j].service.length;
                        i++) {
                          if (dropdownValue2 == li3.items.price[j].year)
                            stringlist2.add(
                                li3.items.price[j].service[i].totalService);
                        }
                      }
                      // districttype = stringlist1.indexOf(newValue);
                    });
                  },
                  items: stringlist1
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
                              priceController.text =
                                  li3.items.price[j].service[i].fixedPrice;
                              TotalServicesController.text =
                                  (int.parse(dropdownValue2) *
                                      int.parse(dropdownValue3))
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
              height: height / 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new TextField(
                onTap: () async {
                  DateTime date = DateTime(1900);
                  FocusScope.of(context).requestFocus(new FocusNode());

                  date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                      DateTime.now().subtract(new Duration(days: 23725)),
                      lastDate: DateTime.now().add(new Duration(days: 365)));
                  /*    var time =await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );*/
                  sql_dob = dateFormatter.format(date);
                  print("date" + sql_dob);
                  var month = date.month.toString();
                  if (date.month == 1)
                    month = 'January';
                  else if (date.month == 2)
                    month = 'February';
                  else if (date.month == 3)
                    month = 'March';
                  else if (date.month == 4)
                    month = 'April';
                  else if (date.month == 5)
                    month = 'May';
                  else if (date.month == 6)
                    month = 'June';
                  else if (date.month == 7)
                    month = 'July';
                  else if (date.month == 8)
                    month = 'August';
                  else if (date.month == 9)
                    month = 'September';
                  else if (date.month == 10)
                    month = 'October';
                  else if (date.month == 11)
                    month = 'November';
                  else if (date.month == 12) month = 'December';

                  if (date.day == 1 || date.day == 21 || date.day == 31) {
                    datecontroller.text = date.day.toString() +
                        'st ' +
                        month +
                        ', ' +
                        date.year.toString();
                  } else if (date.day == 2 || date.day == 22) {
                    datecontroller.text = date.day.toString() +
                        'nd ' +
                        month +
                        ', ' +
                        date.year.toString();
                  } else if (date.day == 3 || date.day == 23) {
                    datecontroller.text = date.day.toString() +
                        'rd ' +
                        month +
                        ', ' +
                        date.year.toString();
                  } else {
                    datecontroller.text = date.day.toString() +
                        'th ' +
                        month +
                        ', ' +
                        date.year.toString();
                  }
                },
                enabled: true,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: FlatButton(
                      onPressed: () {
                        check().then((value) {
                          if (value) {
                            if (_typeAheadController.text.length != 0 &&
                                datecontroller.text.length != 0 &&
                                (dropdownValue2 != '-- Select Year --') &&
                                (dropdownValue3 != '-- Select Service --')) {
                              print(imagefile);
                              discount().then((value) =>
                                  uploadImage("",true).then((value) {


                                  }));
                            } else {
                              if (_typeAheadController.text.length == 0)
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          "Property name cannot be empty"),
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
                              else if (dropdownValue2 == '-- Select Year --')
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
                                      title: Text("Please Choose Service"),
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
                                      title:
                                      Text("Start Date cannot be empty"),
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
                        "Checkout",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: FlatButton(
                      onPressed: () {
                        check().then((value) {
                          if (value) {
                            if (_typeAheadController.text.length != 0 &&
                                datecontroller.text.length != 0 &&
                                (dropdownValue2 != '-- Select Year --') &&
                                (dropdownValue3 != '-- Select Service --')) {
                              print(imagefile);
                              discount().then((value) =>
                                  uploadImage("",false).then((value) {


                                  }));
                            } else {
                              if (_typeAheadController.text.length == 0)
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          "Property name cannot be empty"),
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
                              else if (dropdownValue2 == '-- Select Year --')
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
                                      title: Text("Please Choose Service"),
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
                                      title:
                                      Text("Start Date cannot be empty"),
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
                        "Add to Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
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
          ])),
      appBar: AppBar(
        title: Image.asset('logotitle.png',height: 40),
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

class BackendService {
  static PlanListings li1;

  static Future<List> getSuggestions(String query) async {
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
    String_values.base_url + 'property-list?search=${query}&verify=a';

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      li1 = PlanListings.fromJson(json.decode(response.body));
      List<String> s = new List();
      if (li1.items.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li1.items.length; i++)
          s.add(li1.items[i].propertyName.toString());
        print(s);
        return s;
      }
      // }
      // else {
      //
      //   print("not contains list");
      //   //return "" as List;
      // }

      //["result"];
      // print(json.decode(response.body)["result"]["categoryName"]);
    } else {
      print("Retry");
    }
  }
}
