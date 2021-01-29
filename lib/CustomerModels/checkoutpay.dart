class Checkout {
  bool status;
  List<Data> data;

  Checkout({this.status, this.data});

  Checkout.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != String) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != String) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String pplanId;
  String cusId;
  String propertyId;
  String planId;
  String pplanName;
  String pplanYear;
  String pplanService;
  String pplanTotService;
  String pplanStartDate;
  String pplanPrice;
  String pplanTotPrice;
  String pplanPaidStatus;
  String pplanCurrentStatus;
  String pplanStatus;
  String createdUtype;
  String updatedUtype;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;

  Data(
      {this.pplanId,
      this.cusId,
      this.propertyId,
      this.planId,
      this.pplanName,
      this.pplanYear,
      this.pplanService,
      this.pplanTotService,
      this.pplanStartDate,
      this.pplanPrice,
      this.pplanTotPrice,
      this.pplanPaidStatus,
      this.pplanCurrentStatus,
      this.pplanStatus,
      this.createdUtype,
      this.updatedUtype,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy});

  Data.fromJson(Map<String, dynamic> json) {
    pplanId = json['pplan_id'];
    cusId = json['cus_id'];
    propertyId = json['property_id'];
    planId = json['plan_id'];
    pplanName = json['pplan_name'];
    pplanYear = json['pplan_year'];
    pplanService = json['pplan_service'];
    pplanTotService = json['pplan_tot_service'];
    pplanStartDate = json['pplan_start_date'];
    pplanPrice = json['pplan_price'];
    pplanTotPrice = json['pplan_tot_price'];
    pplanPaidStatus = json['pplan_paid_status'];
    pplanCurrentStatus = json['pplan_current_status'];
    pplanStatus = json['pplan_status'];
    createdUtype = json['created_utype'];
    updatedUtype = json['updated_utype'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pplan_id'] = this.pplanId;
    data['cus_id'] = this.cusId;
    data['property_id'] = this.propertyId;
    data['plan_id'] = this.planId;
    data['pplan_name'] = this.pplanName;
    data['pplan_year'] = this.pplanYear;
    data['pplan_service'] = this.pplanService;
    data['pplan_tot_service'] = this.pplanTotService;
    data['pplan_start_date'] = this.pplanStartDate;
    data['pplan_price'] = this.pplanPrice;
    data['pplan_tot_price'] = this.pplanTotPrice;
    data['pplan_paid_status'] = this.pplanPaidStatus;
    data['pplan_current_status'] = this.pplanCurrentStatus;
    data['pplan_status'] = this.pplanStatus;
    data['created_utype'] = this.createdUtype;
    data['updated_utype'] = this.updatedUtype;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}
