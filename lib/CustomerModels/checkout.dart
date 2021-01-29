class PlanCheckoutResult {
  String regFee;
  bool status;
  List<Data> data;

  PlanCheckoutResult({this.regFee, this.status, this.data});

  PlanCheckoutResult.fromJson(Map<String, dynamic> json) {
    regFee = json['reg_fee'];
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
    data['reg_fee'] = this.regFee;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String cusId;
  String pplanId;
  String planId;
  String pplanName;
  String pplanYear;
  String pplanService;
  String pplanTotPrice;
  String pplanTotService;
  String pplanType;
  String ptypeName;

  Data(
      {this.cusId,
        this.pplanId,
        this.planId,
        this.pplanName,
        this.pplanYear,
        this.pplanService,
        this.pplanTotPrice,
        this.pplanTotService,
        this.pplanType,
        this.ptypeName});

  Data.fromJson(Map<String, dynamic> json) {
    cusId = json['cus_id'];
    pplanId = json['pplan_id'];
    planId = json['plan_id'];
    pplanName = json['pplan_name'];
    pplanYear = json['pplan_year'];
    pplanService = json['pplan_service'];
    pplanTotPrice = json['pplan_tot_price'];
    pplanTotService = json['pplan_tot_service'];
    pplanType = json['pplan_type'];
    ptypeName = json['ptype_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cus_id'] = this.cusId;
    data['pplan_id'] = this.pplanId;
    data['plan_id'] = this.planId;
    data['pplan_name'] = this.pplanName;
    data['pplan_year'] = this.pplanYear;
    data['pplan_service'] = this.pplanService;
    data['pplan_tot_price'] = this.pplanTotPrice;
    data['pplan_tot_service'] = this.pplanTotService;
    data['pplan_type'] = this.pplanType;
    data['ptype_name'] = this.ptypeName;
    return data;
  }
}