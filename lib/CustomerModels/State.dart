class States {
  bool status;
  List<Items> items;

  States({this.status, this.items});

  States.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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

  Items({this.stateId, this.stateName, this.stateCode});

  Items.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
    stateCode = json['state_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['state_code'] = this.stateCode;
    return data;
  }
}
