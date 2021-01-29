class CheckOutListings {
  bool status;
  int totalCount;
  List<Items> items;

  CheckOutListings({this.status, this.totalCount, this.items});

  CheckOutListings.fromJson(Map<String, dynamic> json) {
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
  String pplanStartDate;
  String pplanCurrentStatus;
  String propertyCode;
  String propertyName;
  String propertyApproval;
  String cusCode;
  String cusName;

  Items(
      {this.pplanId,
      this.propertyId,
      this.pplanName,
      this.pplanYear,
      this.pplanService,
      this.pplanPrice,
      this.pplanStartDate,
      this.pplanCurrentStatus,
      this.propertyCode,
      this.propertyName,
      this.propertyApproval,
      this.cusCode,
      this.cusName});

  Items.fromJson(Map<String, dynamic> json) {
    pplanId = json['pplan_id'];
    propertyId = json['property_id'];
    pplanName = json['pplan_name'];
    pplanYear = json['pplan_year'];
    pplanService = json['pplan_service'];
    pplanPrice = json['pplan_price'];
    pplanStartDate = json['pplan_start_date'];
    pplanCurrentStatus = json['pplan_current_status'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
    propertyApproval = json['property_approval'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pplan_id'] = this.pplanId;
    data['property_id'] = this.propertyId;
    data['pplan_name'] = this.pplanName;
    data['pplan_year'] = this.pplanYear;
    data['pplan_service'] = this.pplanService;
    data['pplan_price'] = this.pplanPrice;
    data['pplan_start_date'] = this.pplanStartDate;
    data['pplan_current_status'] = this.pplanCurrentStatus;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    data['property_approval'] = this.propertyApproval;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    return data;
  }
}
