class APDetails {
  bool status;
  List<Items> items;

  APDetails({this.status, this.items});

  APDetails.fromJson(Map<String, dynamic> json) {
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
  String apCode;
  String apId;
  String apDetailsOrderby;
  String apTbl;
  String apTblId;
  String apStatus;
  String apNote;
  String apDatetime;
  String apProcessId;
  String apProcessName;
  String uid;
  String utype;
  String urole;
  String assignby;

  Items(
      {this.apCode,
      this.apId,
      this.apDetailsOrderby,
      this.apTbl,
      this.apTblId,
      this.apStatus,
      this.apNote,
      this.apDatetime,
      this.apProcessId,
      this.apProcessName,
      this.uid,
      this.utype,
      this.urole,
      this.assignby});

  Items.fromJson(Map<String, dynamic> json) {
    apCode = json['ap_code'];
    apId = json['ap_id'];
    apDetailsOrderby = json['ap_details_orderby'];
    apTbl = json['ap_tbl'];
    apTblId = json['ap_tbl_id'];
    apStatus = json['ap_status'];
    apNote = json['ap_note'];
    apDatetime = json['ap_datetime'];
    apProcessId = json['ap_process_id'];
    apProcessName = json['ap_process_name'];
    uid = json['uid'];
    utype = json['utype'];
    urole = json['urole'];
    assignby = json['assignby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ap_code'] = this.apCode;
    data['ap_id'] = this.apId;
    data['ap_details_orderby'] = this.apDetailsOrderby;
    data['ap_tbl'] = this.apTbl;
    data['ap_tbl_id'] = this.apTblId;
    data['ap_status'] = this.apStatus;
    data['ap_note'] = this.apNote;
    data['ap_datetime'] = this.apDatetime;
    data['ap_process_id'] = this.apProcessId;
    data['ap_process_name'] = this.apProcessName;
    data['uid'] = this.uid;
    data['utype'] = this.utype;
    data['urole'] = this.urole;
    data['assignby'] = this.assignby;
    return data;
  }
}
