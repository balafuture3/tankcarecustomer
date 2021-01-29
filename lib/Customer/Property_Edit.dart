import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tankcarecustomer/Customer/GroupList.dart';
import 'package:tankcarecustomer/Customer/PropertyList.dart';
import 'package:tankcarecustomer/Customer/register.dart';
import 'package:tankcarecustomer/CustomerModels/ErrorResponse.dart';
import 'package:tankcarecustomer/CustomerModels/GroupAddSelCus.dart';
import 'package:tankcarecustomer/CustomerModels/ImageUploadModel.dart';
import 'package:tankcarecustomer/CustomerModels/PropertyDetail.dart';
import 'package:tankcarecustomer/CustomerModels/autocomplete.dart';
import 'package:tankcarecustomer/string_values.dart';

class PropertyEdit extends StatefulWidget {
  PropertyEdit({Key key, this.propertyid});

  String propertyid;
  final String title = "AutoComplete Demo";

  @override
  PropertyEditState createState() => PropertyEditState();
}

class PropertyEditState extends State<PropertyEdit> {
  bool valueinfeetshow = true;

  bool heightshow = true;
  bool widthshow = true;
  bool lengthshow = true;
  bool buttonshow = true;
  int proprtytype = 1;
  String groupid;
  List<String> stringlist = [
    '-- Property Type --',
    "Tank",
    "Overhead Tank",
    "Sump",
    "Sump Tile",
    "Car",
    "Bike",
    "Floor",
    "Overhead Tank Tile"
  ];
  static PropertyDetailModel li2;

  String cusid;

  String propertyunit;

  ErrorResponse ei;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  List<File> files = [];

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
      li2 = PropertyDetailModel.fromJson(json.decode(response.body));

      PropertyController.text = li2.propertyName.toString();
      GroupNameController.text = li2.groupName.toString();
      _typeAheadController.text = li2.cusName.toString();
      cusid = li2.cusId.toString();
      if (li2.serviceType.toString() == "COM")
        ServiceController.text = "Commercial";
      else
        ServiceController.text = "Residential";
      PropertyCodeController.text = li2.propertyCode.toString();
      valuecontroller.text = li2.propertyValue.toString();
      dropdownValue1 = li2.propertyTypeName;
      groupid = li2.groupId;
      propertyunit = li2.propertyUnit;
      if (dropdownValue1 == 'Tank' ||
          dropdownValue1 == 'Car' ||
          dropdownValue1 == 'Bike') {
        buttonshow = false;
        lengthshow = false;
        widthshow = false;
        heightshow = false;
        valueinfeetshow = false;
      } else if (dropdownValue1 == 'Floor') {
        valuecontroller.text = "";
        buttonshow = true;
        lengthshow = true;
        widthshow = true;
        heightshow = false;
        heightcontroller.text = "0";
        valueinfeetshow = true;
      } else {
        valuecontroller.text = "";
        buttonshow = true;
        lengthshow = true;
        widthshow = true;
        heightshow = true;
        valueinfeetshow = true;
      }

      // setState(() {
      //   mulitpleFiles.addAll(files);
      // });

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
    details(widget.propertyid);
    _isVisible = !_isVisible;
    images.add("Add Image");
    images.add("Add Image");
    images.add("Add Image");
    images.add("Add Image");
    images.add("Add Image");
    images.add("Add Image");
    super.initState();
  }

  List<Object> images = List<Object>();
  List<String> proprtyimages = List<String>();
  Future<File> _imageFile;
  bool loading = false;
  String dropdownValue1 = '-- Property Type --';
  bool _isVisible = false;
  String result = "0";
  final TextEditingController _typeAheadController = TextEditingController();
  TextEditingController heightcontroller = new TextEditingController();
  TextEditingController widthcontroller = new TextEditingController();
  TextEditingController lengthcontroller = new TextEditingController();
  TextEditingController valuecontroller = new TextEditingController();
  TextEditingController GroupNameController = new TextEditingController();
  TextEditingController PropertyController = new TextEditingController();
  TextEditingController PropertyCodeController = new TextEditingController();
  TextEditingController ServiceController = new TextEditingController();
  List<String> imagefile = new List();

  Future<int> uploadImage(url) async {
    Map<String, String> size = {
      "length": lengthcontroller.text,
      "width": widthcontroller.text,
      "height": heightcontroller.text,
      "swidth": widthcontroller.text,
      "sheight": heightcontroller.text
    };
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'property-edit'));
    print(files);
    for (int i = 0; i < files.length; i++) {
      request.files.add(
          await http.MultipartFile.fromPath('property_image[]', files[i].path));
    }

    request.headers.addAll(headers);
    request.fields['group_id'] = groupid;
    request.fields['cus_id'] = cusid;
    request.fields['property_name'] = PropertyController.text;
    request.fields['property_type_id'] = (proprtytype).toString();
    request.fields['property_unit'] = propertyunit;
    request.fields['property_size'] = json.encode(size);
    request.fields['property_id'] = widget.propertyid;
    request.fields['property_value'] = valuecontroller.text;
    var res = await request.send();
    res.stream.transform(utf8.decoder).listen((value) {
      print(value);

      setState(() {
        loading = false;
      });
      if(value.toString().contains("true")) {
        Fluttertoast.showToast(
            msg: "Property Edited Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PropertyList()),
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
    });


    print(res.statusCode);
    return res.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    Future<http.Response> postRequest() async {
      setState(() {
        loading = true;
      });

      var url = String_values.base_url + 'property-add';
      Map data = {
        "cus_id": '1',
        "group_id": '1',
        "property_name": '1',
        "property_type_id": '1',
        "property_unit": '1',
        "property_value": 1,
        "property_size": '1',
      };
      print("data: ${data}");
      print(String_values.base_url);
      //encode Map to JSON
      var body = json.encode(data);
      print("response: ${body}");
      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ${RegisterPagesState.token}'
          },
          body: body);
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PropertyList()),
        );
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
            SizedBox(
              height: height / 50,
            ),
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
                    "Edit Property",
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
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            //   child: TypeAheadFormField(
            //     textFieldConfiguration: TextFieldConfiguration(
            //       enabled: true,
            //       controller: this._typeAheadController,
            //       // onTap: ()
            //       // {
            //       //   Navigator.push(
            //       //       context,
            //       //       MaterialPageRoute(
            //       //           builder: (context) =>
            //       //               Category(userid:HomeState.userid,mapselection: true)));
            //       // },
            //       keyboardType: TextInputType.text,
            //       decoration: InputDecoration(
            //         labelText: 'Select Customer Name',
            //         hintStyle: TextStyle(
            //           color: Colors.grey,
            //           fontSize: 16.0,
            //         ),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(5.0),
            //         ),
            //       ),
            //     ),
            //     suggestionsCallback: (pattern) {
            //       return BackendService.getSuggestions(pattern);
            //     },
            //     itemBuilder: (context, suggestion) {
            //       return ListTile(
            //         title: Text(suggestion),
            //       );
            //     },
            //     transitionBuilder: (context, suggestionsBox, controller) {
            //       return suggestionsBox;
            //     },
            //     onSuggestionSelected: (suggestion) {
            //       // postRequest(suggestion);
            //       for (int i = 0; i < BackendService.li1.data.length; i++) {
            //         print(BackendService.li1.data[i].cusName);
            //         if (BackendService.li1.data[i].cusName == suggestion) {
            //           cusid = BackendService.li1.data[i].cusId;
            //         }
            //       }
            //       this._typeAheadController.text = suggestion;
            //     },
            //     validator: (value) {
            //       if (value.isEmpty) {
            //         return 'Please select a city';
            //       } else
            //         return 'nothing';
            //     },
            //     // onSaved: (value) => this._selectedCity = value,
            //   ),
            // ),
            // SizedBox(
            //   height: height / 50,
            // ),
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
                controller: PropertyController,
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
            Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  border: new Border.all(color: Colors.black38)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue1,
                  onChanged: (String newValue) {
                    proprtytype = stringlist.indexOf(newValue);
                    print(proprtytype);
                    setState(() {
                      dropdownValue1 = newValue;
                      if (dropdownValue1 == 'Tank' ||
                          dropdownValue1 == 'Car' ||
                          dropdownValue1 == 'Bike') {
                        setState(() {
                          if (dropdownValue1 == 'Tank')
                            propertyunit = "LTR";
                          else
                            propertyunit = "QTY";
                          buttonshow = false;
                          lengthshow = false;
                          widthshow = false;
                          heightshow = false;
                          valueinfeetshow = false;
                        });
                      } else if (dropdownValue1 == 'Floor') {
                        setState(() {
                          propertyunit = "feet";
                          valuecontroller.text = "";
                          buttonshow = true;
                          lengthshow = true;
                          widthshow = true;
                          heightshow = false;
                          heightcontroller.text = "0";
                          valueinfeetshow = true;
                        });
                      } else {
                        setState(() {
                          valuecontroller.text = "";
                          buttonshow = true;
                          lengthshow = true;
                          widthshow = true;
                          heightshow = true;
                          valueinfeetshow = true;
                        });
                      }
                    });
                  },
                  items: stringlist
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
              height: height / 80,
            ),
            Visibility(
                visible: valueinfeetshow,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        "Value in Feet",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                )),
            Visibility(
                visible: valueinfeetshow,
                child: SizedBox(
                  height: height / 50,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Visibility(
                  visible: heightshow,
                  child: new Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: new TextField(
                        controller: heightcontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Height',
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
                ),
                new Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new Text(' '),
                  ),
                ),
                Visibility(
                  visible: widthshow,
                  child: new Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: new TextField(
                        controller: widthcontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Width',
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
                ),
                new Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new Text(' '),
                  ),
                ),
                Visibility(
                  visible: lengthshow,
                  child: new Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: new TextField(
                        controller: lengthcontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Length',
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
                ),
              ],
            ),
            Visibility(
                visible: valueinfeetshow,
                child: SizedBox(
                  height: height / 30,
                )),
            Visibility(
              visible: buttonshow,
              child: Row(
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
                          setState(() {
                            double sum = double.parse(lengthcontroller.text) +
                                double.parse(widthcontroller.text) +
                                double.parse(heightcontroller.text);
                            result = sum.toString();
                            valuecontroller.text = (result);
                          });
                        },
                        child: Text(
                          "Calculate",
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
                          "Clear",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              ),
            ),
            Visibility(
                visible: valueinfeetshow,
                child: SizedBox(
                  height: height / 30,
                )),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new TextField(
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
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 1.0,
                  ),
                ],
              ),
              // color: Colors.white,
              margin: EdgeInsets.only(top: 10.0, bottom: 10),

              child: new Text(
                "Photos",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            buildGridView1(),
            buildGridView(),
            //   Padding(
            //     padding: const EdgeInsets.all(18.0),
            //     child: Container(
            //         width:width/2,
            //         child: Image.network(json.decode(li2.propertyImages)[i])),
            //   ),
            // SizedBox(
            //   height: height / 40,
            // ),
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
                                PropertyController.text.length != 0 &&
                                valuecontroller.text.length != 0 &&
                                dropdownValue1 != '-- Property Type --'
                            ) {
                              print(files);

                              uploadImage("").then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PropertyList()));
                              });
                            } else {
                              if (_typeAheadController.text.length == 0)
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                      Text("Group name cannot be empty"),
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
                              else if (PropertyController.text.length == 0)
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          "Property Name cannot be empty"),
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
                              else if (dropdownValue1 ==
                                  '-- Property Type --')
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                      Text("Please Choose Property Type"),
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
                              else if (valuecontroller.text.length == 0)
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          "Property Value cannot be empty"),
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
                              else if (files.length == 0)
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Please choose image "),
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
                          }
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

  Widget buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: List.generate(
          files.length + 1,
              (index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  child: Stack(children: <Widget>[
                    index < files.length
                        ? InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            child: Image.file(files[index]));
                      },
                      child: Image.file(
                        files[index],
                        width: 300,
                        height: 300,
                      ),
                    )
                        : Container(
                      width: 300,
                      height: 300,
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                        ),
                        onPressed: () {
                          _onAddImageClick(index);
                        },
                      ),
                    ),
                    index < files.length
                        ? Positioned(
                        right: 5,
                        top: 5,
                        child: InkWell(
                            child: Icon(
                              Icons.remove_circle,
                              size: 20,
                              color: Colors.red,
                            ),
                            onTap: () {
                              setState(() {
                                files.removeAt(index);
                                print(files);
                                // images.replaceRange(index, index + 1, ['Add Image']);
                              });
                            }))
                        : Container()
                  ])),
            );
          },
        ),
      ),
      // child: GridView.count(
      //         physics: ScrollPhysics(),
      //   shrinkWrap: true,
      //   crossAxisCount: 3,
      //   childAspectRatio: 1,
      //   children: List.generate(images.length+1, (index) {
      //     if (images[index] is ImageUploadModel)
      //     {
      //       ImageUploadModel uploadModel = images[index];
      //       return Card(
      //         elevation: 20,
      //         clipBehavior: Clip.antiAlias,
      //         child: Stack(
      //           children: <Widget>[
      //             Image.file(
      //               uploadModel.imageFile,
      //               width: 300,
      //               height: 300,
      //             ),
      //             Positioned(
      //               right: 5,
      //               top: 5,
      //               child: InkWell(
      //                 child: Icon(
      //                   Icons.remove_circle,
      //                   size: 20,
      //                   color: Colors.red,
      //                 ),
      //                 onTap: () {
      //                   setState(() {
      //                     imagefile.removeAt(index);
      //                     images.replaceRange(index, index + 1, ['Add Image']);
      //                   });
      //                 },
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     } else {
      //       return Card(
      //         elevation: 3,
      //         child: IconButton(
      //           icon: Icon(Icons.add),
      //           onPressed: () {
      //             _onAddImageClick(index);
      //           },
      //         ),
      //       );
      //     }
      //   }),
      // ),
    );
  }

  Widget buildGridView1() {
    return li2.propertyImages.toString() != "null"
        ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: List.generate(
          li2.propertyImages.length,
              (index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  child: Stack(children: <Widget>[
                    index < li2.propertyImages.length
                        ? InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            child: Image.network(
                                li2.propertyImages[index].imgPath));
                      },
                      child: Image.network(
                        li2.propertyImages[index].imgPath,
                        width: 300,
                        height: 300,
                      ),
                    )
                        : Container(
                      width: 300,
                      height: 300,
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                        ),
                        onPressed: () {
                          _onAddImageClick(index);
                        },
                      ),
                    ),
                    index < li2.propertyImages.length
                        ? Positioned(
                        right: 5,
                        top: 5,
                        child: InkWell(
                            child: Icon(
                              Icons.remove_circle,
                              size: 20,
                              color: Colors.red,
                            ),
                            onTap: () {
                              setState(() {
                                deleteimage(
                                    li2.propertyImages[index].imgId);
                                li2.propertyImages.removeAt(index);
                                print(files);
                                // images.replaceRange(index, index + 1, ['Add Image']);
                              });
                            }))
                        : Container()
                  ])),
            );
          },
        ),
      ),
      // child: GridView.count(
      //         physics: ScrollPhysics(),
      //   shrinkWrap: true,
      //   crossAxisCount: 3,
      //   childAspectRatio: 1,
      //   children: List.generate(images.length+1, (index) {
      //     if (images[index] is ImageUploadModel)
      //     {
      //       ImageUploadModel uploadModel = images[index];
      //       return Card(
      //         elevation: 20,
      //         clipBehavior: Clip.antiAlias,
      //         child: Stack(
      //           children: <Widget>[
      //             Image.file(
      //               uploadModel.imageFile,
      //               width: 300,
      //               height: 300,
      //             ),
      //             Positioned(
      //               right: 5,
      //               top: 5,
      //               child: InkWell(
      //                 child: Icon(
      //                   Icons.remove_circle,
      //                   size: 20,
      //                   color: Colors.red,
      //                 ),
      //                 onTap: () {
      //                   setState(() {
      //                     imagefile.removeAt(index);
      //                     images.replaceRange(index, index + 1, ['Add Image']);
      //                   });
      //                 },
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     } else {
      //       return Card(
      //         elevation: 3,
      //         child: IconButton(
      //           icon: Icon(Icons.add),
      //           onPressed: () {
      //             _onAddImageClick(index);
      //           },
      //         ),
      //       );
      //     }
      //   }),
      // ),
    )
        : Container();
  }

  // Widget buildGridView()
  // {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: GridView.count(
  //           physics: ScrollPhysics(),
  //       shrinkWrap: true,
  //       crossAxisCount: 3,
  //       childAspectRatio: 1,
  //       children: List.generate(images.length, (index) {
  //         if (images[index] is ImageUploadModel)
  //         {
  //           ImageUploadModel uploadModel = images[index];
  //           return Card(
  //             elevation: 20,
  //             clipBehavior: Clip.antiAlias,
  //             child: Stack(
  //               children: <Widget>[
  //                 Image.file(
  //                   uploadModel.imageFile,
  //                   width: 300,
  //                   height: 300,
  //                 ),
  //                 Positioned(
  //                   right: 5,
  //                   top: 5,
  //                   child: InkWell(
  //                     child: Icon(
  //                       Icons.remove_circle,
  //                       size: 20,
  //                       color: Colors.red,
  //                     ),
  //                     onTap: () {
  //                       setState(() {
  //                         imagefile.removeAt(index);
  //                         images.replaceRange(index, index + 1, ['Add Image']);
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         } else {
  //           return Card(
  //             elevation: 3,
  //             child: IconButton(
  //               icon: Icon(Icons.add),
  //               onPressed: () {
  //                 _onAddImageClick(index);
  //               },
  //             ),
  //           );
  //         }
  //       }),
  //     ),
  //   );
  // }

  Future _onAddImageClick(int index) async {
    setState(() {
      final picker = ImagePicker();
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      print("Uploaded Image: $_imageFile");

      getFileImage(index);
    });
  }

  Future getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();
    _imageFile.then((file) async {
      setState(() {
        // ImageUploadModel imageUpload = new ImageUploadModel();
        // imageUpload.isUploaded = false;
        // imageUpload.uploading = false;
        // imageUpload.imageFile = file;
        // imageUpload.imageUrl = '';
        // // images.replaceRange(index, index + 1, [imageUpload]);
        // print("images Image: $file");

        files.add(file);
      });
    });
  }

  Future<http.Response> deleteimage(String imgId) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${RegisterPagesState.token}}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(String_values.base_url + 'img-delete'));

    request.headers.addAll(headers);
    request.fields['img_id'] = imgId;

    var res = await request.send();
    print(res.statusCode);
  }
}

class BackendService {
  static EmployeeGroupAddSelectCusModel li1;

  static Future<List> getSuggestions(String query) async {
    var url = //'http://35.184.156.126.xip.io/cyberhome/home.php?username=kavin&query=table';
    String_values.base_url + 'find-customer?search=${query}';

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${RegisterPagesState.token}'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      li1 = EmployeeGroupAddSelectCusModel.fromJson(json.decode(response.body));
      List<String> s = new List();
      if (li1.data.length == 0) {
        // return ["No details"];
      } else {
        for (int i = 0; i < li1.data.length; i++)
          s.add(li1.data[i].cusName.toString());
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
