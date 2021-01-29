class ServiceListings {
  bool status;
  int totalCount;
  List<Items> items;

  ServiceListings({this.status, this.totalCount, this.items});

  ServiceListings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalCount = json['total_count'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total_count'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String districtId;
  String propertyName;
  String pplanName;
  String pserviceCode;
  String pserviceId;
  String pserviceDate;
  String pserviceServiceStatus;
  String propertyId;
  String planId;
  String pplanYear;
  String pplanStartDate;
  String pplanCurrentStatus;
  String cusName;
  String cusCode;
  String assignby;
  String assignUid;
  String assignUtype;

  Items(
      {this.districtId,
      this.propertyName,
      this.pplanName,
      this.pserviceCode,
      this.pserviceId,
      this.pserviceDate,
      this.pserviceServiceStatus,
      this.propertyId,
      this.planId,
      this.pplanYear,
      this.pplanStartDate,
      this.pplanCurrentStatus,
      this.cusName,
      this.cusCode,
      this.assignby,
      this.assignUid,
      this.assignUtype});

  Items.fromJson(Map<String, dynamic> json) {
    districtId = json['district_id'];
    propertyName = json['property_name'];
    pplanName = json['pplan_name'];
    pserviceCode = json['pservice_code'];
    pserviceId = json['pservice_id'];
    pserviceDate = json['pservice_date'];
    pserviceServiceStatus = json['pservice_service_status'];
    propertyId = json['property_id'];
    planId = json['plan_id'];
    pplanYear = json['pplan_year'];
    pplanStartDate = json['pplan_start_date'];
    pplanCurrentStatus = json['pplan_current_status'];
    cusName = json['cus_name'];
    cusCode = json['cus_code'];
    assignby = json['assignby'];
    assignUid = json['assign_uid'];
    assignUtype = json['assign_utype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['district_id'] = this.districtId;
    data['property_name'] = this.propertyName;
    data['pplan_name'] = this.pplanName;
    data['pservice_code'] = this.pserviceCode;
    data['pservice_id'] = this.pserviceId;
    data['pservice_date'] = this.pserviceDate;
    data['pservice_service_status'] = this.pserviceServiceStatus;
    data['property_id'] = this.propertyId;
    data['plan_id'] = this.planId;
    data['pplan_year'] = this.pplanYear;
    data['pplan_start_date'] = this.pplanStartDate;
    data['pplan_current_status'] = this.pplanCurrentStatus;
    data['cus_name'] = this.cusName;
    data['cus_code'] = this.cusCode;
    data['assignby'] = this.assignby;
    data['assign_uid'] = this.assignUid;
    data['assign_utype'] = this.assignUtype;
    return data;
  }
}
