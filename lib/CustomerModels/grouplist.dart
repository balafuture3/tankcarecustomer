class GroupListings {
  bool status;
  int totalCount;
  List<Items> items;

  GroupListings({this.status, this.totalCount, this.items});

  GroupListings.fromJson(Map<String, dynamic> json) {
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
  String groupId;
  String groupCode;
  String groupContactName;
  String groupContactPhone;
  String groupName;
  String groupAddress;
  String groupPincode;
  String serviceType;
  String cusName;
  String cusCode;
  String stateName;
  String districtName;

  Items(
      {this.groupId,
      this.groupCode,
      this.groupContactName,
      this.groupContactPhone,
      this.groupName,
      this.groupAddress,
      this.groupPincode,
      this.serviceType,
      this.cusName,
      this.cusCode,
      this.stateName,
      this.districtName});

  Items.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    groupCode = json['group_code'];
    groupContactName = json['group_contact_name'];
    groupContactPhone = json['group_contact_phone'];
    groupName = json['group_name'];
    groupAddress = json['group_address'];
    groupPincode = json['group_pincode'];
    serviceType = json['service_type'];
    cusName = json['cus_name'];
    cusCode = json['cus_code'];
    stateName = json['state_name'];
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['group_code'] = this.groupCode;
    data['group_contact_name'] = this.groupContactName;
    data['group_contact_phone'] = this.groupContactPhone;
    data['group_name'] = this.groupName;
    data['group_address'] = this.groupAddress;
    data['group_pincode'] = this.groupPincode;
    data['service_type'] = this.serviceType;
    data['cus_name'] = this.cusName;
    data['cus_code'] = this.cusCode;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    return data;
  }
}
