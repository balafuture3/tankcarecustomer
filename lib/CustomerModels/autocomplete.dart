class Response {
  bool status;
  int totalCount;
  List<Items> items;

  Response({this.status, this.totalCount, this.items});

  Response.fromJson(Map<String, dynamic> json) {
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
  String cusId;
  String groupName;
  String serviceType;
  String groupStatus;
  String groupAddress;
  String groupContactName;
  String groupContactPhone;
  String groupPincode;
  String locationId;
  String districtId;
  String stateId;
  String modifyUtype;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  String latitude;
  String longitude;
  String mapLocation;

  Items(
      {this.groupId,
      this.groupCode,
      this.cusId,
      this.groupName,
      this.serviceType,
      this.groupStatus,
      this.groupAddress,
      this.groupContactName,
      this.groupContactPhone,
      this.groupPincode,
      this.locationId,
      this.districtId,
      this.stateId,
      this.modifyUtype,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.latitude,
      this.longitude,
      this.mapLocation});

  Items.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    groupCode = json['group_code'];
    cusId = json['cus_id'];
    groupName = json['group_name'];
    serviceType = json['service_type'];
    groupStatus = json['group_status'];
    groupAddress = json['group_address'];
    groupContactName = json['group_contact_name'];
    groupContactPhone = json['group_contact_phone'];
    groupPincode = json['group_pincode'];
    locationId = json['location_id'];
    districtId = json['district_id'];
    stateId = json['state_id'];
    modifyUtype = json['modify_utype'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mapLocation = json['map_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['group_code'] = this.groupCode;
    data['cus_id'] = this.cusId;
    data['group_name'] = this.groupName;
    data['service_type'] = this.serviceType;
    data['group_status'] = this.groupStatus;
    data['group_address'] = this.groupAddress;
    data['group_contact_name'] = this.groupContactName;
    data['group_contact_phone'] = this.groupContactPhone;
    data['group_pincode'] = this.groupPincode;
    data['location_id'] = this.locationId;
    data['district_id'] = this.districtId;
    data['state_id'] = this.stateId;
    data['modify_utype'] = this.modifyUtype;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['map_location'] = this.mapLocation;
    return data;
  }
}
