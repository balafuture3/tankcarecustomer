class CustomerSelectPhoneModel {
  bool status;
  Data data;

  CustomerSelectPhoneModel({this.status, this.data});

  CustomerSelectPhoneModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String cusId;
  String cusName;
  String cusCode;
  String cusEmail;
  String cusAddress;
  String cusPincode;
  Null cusGender;
  String stateId;
  String stateName;
  String districtId;
  String districtName;

  Data(
      {this.cusId,
        this.cusName,
        this.cusCode,
        this.cusEmail,
        this.cusAddress,
        this.cusPincode,
        this.cusGender,
        this.stateId,
        this.stateName,
        this.districtId,
        this.districtName});

  Data.fromJson(Map<String, dynamic> json) {
    cusId = json['cus_id'];
    cusName = json['cus_name'];
    cusCode = json['cus_code'];
    cusEmail = json['cus_email'];
    cusAddress = json['cus_address'];
    cusPincode = json['cus_pincode'];
    cusGender = json['cus_gender'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    districtId = json['district_id'];
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cus_id'] = this.cusId;
    data['cus_name'] = this.cusName;
    data['cus_code'] = this.cusCode;
    data['cus_email'] = this.cusEmail;
    data['cus_address'] = this.cusAddress;
    data['cus_pincode'] = this.cusPincode;
    data['cus_gender'] = this.cusGender;
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    return data;
  }
}