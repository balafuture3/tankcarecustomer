class ReferalListings {
  int totalCount;
  List<Items> items;

  ReferalListings({this.totalCount, this.items});

  ReferalListings.fromJson(Map<String, dynamic> json) {
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
  String cusId;
  String refferalCusId;
  String purchaseStatus;
  String discountApplied;
  String cusCode;
  String cusName;
  String refCusCode;
  String refCusName;

  Items(
      {this.cusId,
      this.refferalCusId,
      this.purchaseStatus,
      this.discountApplied,
      this.cusCode,
      this.cusName,
      this.refCusCode,
      this.refCusName});

  Items.fromJson(Map<String, dynamic> json) {
    cusId = json['cus_id'];
    refferalCusId = json['refferal_cus_id'];
    purchaseStatus = json['purchase_status'];
    discountApplied = json['discount_applied'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    refCusCode = json['ref_cus_code'];
    refCusName = json['ref_cus_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cus_id'] = this.cusId;
    data['refferal_cus_id'] = this.refferalCusId;
    data['purchase_status'] = this.purchaseStatus;
    data['discount_applied'] = this.discountApplied;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['ref_cus_code'] = this.refCusCode;
    data['ref_cus_name'] = this.refCusName;
    return data;
  }
}
