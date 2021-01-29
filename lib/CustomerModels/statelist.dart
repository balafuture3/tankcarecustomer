class StateListings {
  int totalCount;
  List<Items> items;

  StateListings({this.totalCount, this.items});

  StateListings.fromJson(Map<String, dynamic> json) {
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
  String stateId;
  String stateName;
  String stateCode;
  String stateStatus;

  Items({this.stateId, this.stateName, this.stateCode, this.stateStatus});

  Items.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
    stateCode = json['state_code'];
    stateStatus = json['state_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['state_code'] = this.stateCode;
    data['state_status'] = this.stateStatus;
    return data;
  }
}
