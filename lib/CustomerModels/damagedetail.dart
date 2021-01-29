class DamageView {
  bool status;
  Items items;

  DamageView({this.status, this.items});

  DamageView.fromJson(Map<String, dynamic> json) {
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
  String damageId;
  String damageCode;
  String damageNote;
  String damageStatus;
  List<DamageImage> damageImage;
  String createdAt;
  String propertyCode;
  String propertyName;
  String cusCode;
  String cusName;
  String cusPhone;

  Items(
      {this.damageId,
      this.damageCode,
      this.damageNote,
      this.damageStatus,
      this.damageImage,
      this.createdAt,
      this.propertyCode,
      this.propertyName,
      this.cusCode,
      this.cusName,
      this.cusPhone});

  Items.fromJson(Map<String, dynamic> json) {
    damageId = json['damage_id'];
    damageCode = json['damage_code'];
    damageNote = json['damage_note'];
    damageStatus = json['damage_status'];
    if (json['damage_image'] != null) {
      damageImage = new List<DamageImage>();
      json['damage_image'].forEach((v) {
        damageImage.add(new DamageImage.fromJson(v));
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
    data['damage_id'] = this.damageId;
    data['damage_code'] = this.damageCode;
    data['damage_note'] = this.damageNote;
    data['damage_status'] = this.damageStatus;
    if (this.damageImage != null) {
      data['damage_image'] = this.damageImage.map((v) => v.toJson()).toList();
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

class DamageImage {
  String imgId;
  String imgPath;

  DamageImage({this.imgId, this.imgPath});

  DamageImage.fromJson(Map<String, dynamic> json) {
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
