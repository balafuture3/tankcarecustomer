class ComplaintView {
  bool status;
  Items items;

  ComplaintView({this.status, this.items});

  ComplaintView.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    items = json['items'] != null ? new Items.fromJson(json['items']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items.toJson();
    }
    return data;
  }
}

class Items {
  String complaintId;
  String complaintCode;
  String complaintNote;
  String complaintStatus;
  List<ComplaintImage> complaintImage;
  String createdAt;
  String propertyCode;
  String propertyName;
  String cusCode;
  String cusName;
  String cusPhone;

  Items(
      {this.complaintId,
      this.complaintCode,
      this.complaintNote,
      this.complaintStatus,
      this.complaintImage,
      this.createdAt,
      this.propertyCode,
      this.propertyName,
      this.cusCode,
      this.cusName,
      this.cusPhone});

  Items.fromJson(Map<String, dynamic> json) {
    complaintId = json['complaint_id'];
    complaintCode = json['complaint_code'];
    complaintNote = json['complaint_note'];
    complaintStatus = json['complaint_status'];
    if (json['complaint_image'] != null) {
      complaintImage = new List<ComplaintImage>();
      json['complaint_image'].forEach((v) {
        complaintImage.add(new ComplaintImage.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complaint_id'] = this.complaintId;
    data['complaint_code'] = this.complaintCode;
    data['complaint_note'] = this.complaintNote;
    data['complaint_status'] = this.complaintStatus;
    if (this.complaintImage != null) {
      data['complaint_image'] =
          this.complaintImage.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    return data;
  }
}

class ComplaintImage {
  String imgId;
  String imgPath;

  ComplaintImage({this.imgId, this.imgPath});

  ComplaintImage.fromJson(Map<String, dynamic> json) {
    imgId = json['img_id'];
    imgPath = json['img_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_id'] = this.imgId;
    data['img_path'] = this.imgPath;
    return data;
  }
}
