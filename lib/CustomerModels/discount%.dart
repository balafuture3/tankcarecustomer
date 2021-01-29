class DiscountPerc {
  bool status;
  Data data;

  DiscountPerc({this.status, this.data});

  DiscountPerc.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String rdId;
  String discountCode;
  String rdRefCount;
  String rdPercentage;
  String currentCount;
  String totalCount;

  Data(
      {this.rdId,
      this.discountCode,
      this.rdRefCount,
      this.rdPercentage,
      this.currentCount,
      this.totalCount});

  Data.fromJson(Map<String, dynamic> json) {
    rdId = json['rd_id'];
    discountCode = json['discount_code'];
    rdRefCount = json['rd_ref_count'];
    rdPercentage = json['rd_percentage'];
    currentCount = json['current_count'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rd_id'] = this.rdId;
    data['discount_code'] = this.discountCode;
    data['rd_ref_count'] = this.rdRefCount;
    data['rd_percentage'] = this.rdPercentage;
    data['current_count'] = this.currentCount;
    data['total_count'] = this.totalCount;
    return data;
  }
}
