class BillListings {
  bool status;
  int totalCount;
  List<Items> items;

  BillListings({this.status, this.totalCount, this.items});

  BillListings.fromJson(Map<String, dynamic> json) {
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
  String billId;
  String billNo;
  String invNo;
  String invDatetime;
  String cusId;
  String totalItems;
  String discount;
  String billAmount;
  String billPaidAmount;
  String paidStatus;
  String paidRefNo;
  Null billNotes;
  String billApproval;
  String billStatus;
  String createdAt;
  String createdBy;
  Null updatedAt;
  Null updatedBy;

  Items(
      {this.billId,
      this.billNo,
      this.invNo,
      this.invDatetime,
      this.cusId,
      this.totalItems,
      this.discount,
      this.billAmount,
      this.billPaidAmount,
      this.paidStatus,
      this.paidRefNo,
      this.billNotes,
      this.billApproval,
      this.billStatus,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy});

  Items.fromJson(Map<String, dynamic> json) {
    billId = json['bill_id'];
    billNo = json['bill_no'];
    invNo = json['inv_no'];
    invDatetime = json['inv_datetime'];
    cusId = json['cus_id'];
    totalItems = json['total_items'];
    discount = json['discount'];
    billAmount = json['bill_amount'];
    billPaidAmount = json['bill_paid_amount'];
    paidStatus = json['paid_status'];
    paidRefNo = json['paid_ref_no'];
    billNotes = json['bill_notes'];
    billApproval = json['bill_approval'];
    billStatus = json['bill_status'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_id'] = this.billId;
    data['bill_no'] = this.billNo;
    data['inv_no'] = this.invNo;
    data['inv_datetime'] = this.invDatetime;
    data['cus_id'] = this.cusId;
    data['total_items'] = this.totalItems;
    data['discount'] = this.discount;
    data['bill_amount'] = this.billAmount;
    data['bill_paid_amount'] = this.billPaidAmount;
    data['paid_status'] = this.paidStatus;
    data['paid_ref_no'] = this.paidRefNo;
    data['bill_notes'] = this.billNotes;
    data['bill_approval'] = this.billApproval;
    data['bill_status'] = this.billStatus;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}
