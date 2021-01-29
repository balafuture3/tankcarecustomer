class PropertyListings {
  int totalCount;
  List<Items> items;

  PropertyListings({this.totalCount, this.items});

  PropertyListings.fromJson(Map<String, dynamic> json) {
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
    data['total_count'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String propertyId;
  String groupId;
  String propertyCode;
  String propertyName;
  String propertyTypeId;
  String propertyUnit;
  String propertySize;
  String propertyValue;
  String propertyImages;
  String propertyStatus;
  String propertyApproval;
  String propertyTypeName;
  String groupCode;
  String groupName;
  String serviceType;
  String cusCode;
  String cusName;

  Items(
      {this.propertyId,
      this.groupId,
      this.propertyCode,
      this.propertyName,
      this.propertyTypeId,
      this.propertyUnit,
      this.propertySize,
      this.propertyValue,
      this.propertyImages,
      this.propertyStatus,
      this.propertyApproval,
      this.propertyTypeName,
      this.groupCode,
      this.groupName,
      this.serviceType,
      this.cusCode,
      this.cusName});

  Items.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    groupId = json['group_id'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
    propertyTypeId = json['property_type_id'];
    propertyUnit = json['property_unit'];
    propertySize = json['property_size'];
    propertyValue = json['property_value'];
    propertyImages = json['property_images'];
    propertyStatus = json['property_status'];
    propertyApproval = json['property_approval'];
    propertyTypeName = json['property_type_name'];
    groupCode = json['group_code'];
    groupName = json['group_name'];
    serviceType = json['service_type'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_id'] = this.propertyId;
    data['group_id'] = this.groupId;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    data['property_type_id'] = this.propertyTypeId;
    data['property_unit'] = this.propertyUnit;
    data['property_size'] = this.propertySize;
    data['property_value'] = this.propertyValue;
    data['property_images'] = this.propertyImages;
    data['property_status'] = this.propertyStatus;
    data['property_approval'] = this.propertyApproval;
    data['property_type_name'] = this.propertyTypeName;
    data['group_code'] = this.groupCode;
    data['group_name'] = this.groupName;
    data['service_type'] = this.serviceType;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    return data;
  }
}
