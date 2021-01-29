class DistrictListings {
  int totalCount;
  List<Items> items;

  DistrictListings({this.totalCount, this.items});

  DistrictListings.fromJson(Map<String, dynamic> json) {
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
  String districtId;
  String districtName;
  String districtCode;
  String districtStatus;
  String stateName;

  Items(
      {this.districtId,
      this.districtName,
      this.districtCode,
      this.districtStatus,
      this.stateName});

  Items.fromJson(Map<String, dynamic> json) {
    districtId = json['district_id'];
    districtName = json['district_name'];
    districtCode = json['district_code'];
    districtStatus = json['district_status'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    data['district_code'] = this.districtCode;
    data['district_status'] = this.districtStatus;
    data['state_name'] = this.stateName;
    return data;
  }
}
