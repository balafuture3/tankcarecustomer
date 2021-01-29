class BillView {
  bool staus;
  Data data;

  BillView({this.staus, this.data});

  BillView.fromJson(Map<String, dynamic> json) {
    staus = json['staus'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staus'] = this.staus;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String billId;
  String billNo;
  String invNo;
  String invDatetime;
  String cusId;
  String totalItems;
  String discount;
  String billAmount;
  String billPaidAmount;
  String paidStatus;
  String paidRefNo;
  Null billNotes;
  String billApproval;
  String billStatus;
  String createdAt;
  String createdBy;
  Null updatedAt;
  Null updatedBy;
  String cusCode;
  String cusName;
  String cusPhone;
  String cusEmail;
  String cusAddress;
  String cusDistrict;
  String cusState;
  String cusPincode;
  List<BillDetails> billDetails;

  Data(
      {this.billId,
      this.billNo,
      this.invNo,
      this.invDatetime,
      this.cusId,
      this.totalItems,
      this.discount,
      this.billAmount,
      this.billPaidAmount,
      this.paidStatus,
      this.paidRefNo,
      this.billNotes,
      this.billApproval,
      this.billStatus,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.cusCode,
      this.cusName,
      this.cusPhone,
      this.cusEmail,
      this.cusAddress,
      this.cusDistrict,
      this.cusState,
      this.cusPincode,
      this.billDetails});

  Data.fromJson(Map<String, dynamic> json) {
    billId = json['bill_id'];
    billNo = json['bill_no'];
    invNo = json['inv_no'];
    invDatetime = json['inv_datetime'];
    cusId = json['cus_id'];
    totalItems = json['total_items'];
    discount = json['discount'];
    billAmount = json['bill_amount'];
    billPaidAmount = json['bill_paid_amount'];
    paidStatus = json['paid_status'];
    paidRefNo = json['paid_ref_no'];
    billNotes = json['bill_notes'];
    billApproval = json['bill_approval'];
    billStatus = json['bill_status'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
    cusEmail = json['cus_email'];
    cusAddress = json['cus_address'];
    cusDistrict = json['cus_district'];
    cusState = json['cus_state'];
    cusPincode = json['cus_pincode'];
    if (json['bill_details'] != null) {
      billDetails = new List<BillDetails>();
      json['bill_details'].forEach((v) {
        billDetails.add(new BillDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_id'] = this.billId;
    data['bill_no'] = this.billNo;
    data['inv_no'] = this.invNo;
    data['inv_datetime'] = this.invDatetime;
    data['cus_id'] = this.cusId;
    data['total_items'] = this.totalItems;
    data['discount'] = this.discount;
    data['bill_amount'] = this.billAmount;
    data['bill_paid_amount'] = this.billPaidAmount;
    data['paid_status'] = this.paidStatus;
    data['paid_ref_no'] = this.paidRefNo;
    data['bill_notes'] = this.billNotes;
    data['bill_approval'] = this.billApproval;
    data['bill_status'] = this.billStatus;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    data['cus_email'] = this.cusEmail;
    data['cus_address'] = this.cusAddress;
    data['cus_district'] = this.cusDistrict;
    data['cus_state'] = this.cusState;
    data['cus_pincode'] = this.cusPincode;
    if (this.billDetails != null) {
      data['bill_details'] = this.billDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BillDetails {
  String billDetailsId;
  String billId;
  String planId;
  String pplanId;
  String propertyId;
  String pplanName;
  String pplanYear;
  String pplanService;
  String pplanPrice;
  String pplanStartDate;
  String billDetailsStatus;
  String pplanCurrentStatus;

  BillDetails(
      {this.billDetailsId,
      this.billId,
      this.planId,
      this.pplanId,
      this.propertyId,
      this.pplanName,
      this.pplanYear,
      this.pplanService,
      this.pplanPrice,
      this.pplanStartDate,
      this.billDetailsStatus,
      this.pplanCurrentStatus});

  BillDetails.fromJson(Map<String, dynamic> json) {
    billDetailsId = json['bill_details_id'];
    billId = json['bill_id'];
    planId = json['plan_id'];
    pplanId = json['pplan_id'];
    propertyId = json['property_id'];
    pplanName = json['pplan_name'];
    pplanYear = json['pplan_year'];
    pplanService = json['pplan_service'];
    pplanPrice = json['pplan_price'];
    pplanStartDate = json['pplan_start_date'];
    billDetailsStatus = json['bill_details_status'];
    pplanCurrentStatus = json['pplan_current_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_details_id'] = this.billDetailsId;
    data['bill_id'] = this.billId;
    data['plan_id'] = this.planId;
    data['pplan_id'] = this.pplanId;
    data['property_id'] = this.propertyId;
    data['pplan_name'] = this.pplanName;
    data['pplan_year'] = this.pplanYear;
    data['pplan_service'] = this.pplanService;
    data['pplan_price'] = this.pplanPrice;
    data['pplan_start_date'] = this.pplanStartDate;
    data['bill_details_status'] = this.billDetailsStatus;
    data['pplan_current_status'] = this.pplanCurrentStatus;
    return data;
  }
}
