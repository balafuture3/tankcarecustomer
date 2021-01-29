class EmployeeGroupAddSelectCusModel {
  bool status;
  List<Data> data;

  EmployeeGroupAddSelectCusModel({this.status, this.data});

  EmployeeGroupAddSelectCusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String cusId;
  String cusName;
  String cusCode;

  Data({this.cusId, this.cusName, this.cusCode});

  Data.fromJson(Map<String, dynamic> json) {
    cusId = json['cus_id'];
    cusName = json['cus_name'];
    cusCode = json['cus_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cus_id'] = this.cusId;
    data['cus_name'] = this.cusName;
    data['cus_code'] = this.cusCode;
    return data;
  }
}
