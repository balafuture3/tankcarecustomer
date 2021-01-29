class PlanListings {
  bool status;
  int totalCount;
  List<Items> items;

  PlanListings({this.status, this.totalCount, this.items});

  PlanListings.fromJson(Map<String, dynamic> json) {
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
  String pplanId;
  String propertyId;
  String pplanName;
  String pplanYear;
  String pplanService;
  String pplanPrice;
  String pplanTotPrice;
  String pplanStartDate;
  String pplanCurrentStatus;
  String pplanType;
  String pplanPaidStatus;
  String createdAt;
  String propertyCode;
  String propertyName;
  String propertyApproval;
  String cusCode;
  String cusName;
  String udayCount;
  String groupCode;
  String groupName;
  String serviceType;
  String ptypeName;
  String propertyValue;

  Items(
      {this.pplanId,
      this.propertyId,
      this.pplanName,
      this.pplanYear,
      this.pplanService,
      this.pplanPrice,
      this.pplanTotPrice,
      this.pplanStartDate,
      this.pplanCurrentStatus,
      this.pplanType,
      this.pplanPaidStatus,
      this.createdAt,
      this.propertyCode,
      this.propertyName,
      this.propertyApproval,
      this.cusCode,
      this.cusName,
      this.udayCount,
      this.groupCode,
      this.groupName,
      this.serviceType,
      this.ptypeName,
      this.propertyValue});

  Items.fromJson(Map<String, dynamic> json) {
    pplanId = json['pplan_id'];
    propertyId = json['property_id'];
    pplanName = json['pplan_name'];
    pplanYear = json['pplan_year'];
    pplanService = json['pplan_service'];
    pplanPrice = json['pplan_price'];
    pplanTotPrice = json['pplan_tot_price'];
    pplanStartDate = json['pplan_start_date'];
    pplanCurrentStatus = json['pplan_current_status'];
    pplanType = json['pplan_type'];
    pplanPaidStatus = json['pplan_paid_status'];
    createdAt = json['created_at'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
    propertyApproval = json['property_approval'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    udayCount = json['uday_count'];
    groupCode = json['group_code'];
    groupName = json['group_name'];
    serviceType = json['service_type'];
    ptypeName = json['ptype_name'];
    propertyValue = json['property_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pplan_id'] = this.pplanId;
    data['property_id'] = this.propertyId;
    data['pplan_name'] = this.pplanName;
    data['pplan_year'] = this.pplanYear;
    data['pplan_service'] = this.pplanService;
    data['pplan_price'] = this.pplanPrice;
    data['pplan_tot_price'] = this.pplanTotPrice;
    data['pplan_start_date'] = this.pplanStartDate;
    data['pplan_current_status'] = this.pplanCurrentStatus;
    data['pplan_type'] = this.pplanType;
    data['pplan_paid_status'] = this.pplanPaidStatus;
    data['created_at'] = this.createdAt;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    data['property_approval'] = this.propertyApproval;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['uday_count'] = this.udayCount;
    data['group_code'] = this.groupCode;
    data['group_name'] = this.groupName;
    data['service_type'] = this.serviceType;
    data['ptype_name'] = this.ptypeName;
    data['property_value'] = this.propertyValue;
    return data;
  }
}
