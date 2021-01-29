class PropertyDetailModel {
  String propertyId;
  String cusId;
  String groupId;
  String propertyCode;
  String propertyName;
  String propertyTypeId;
  String propertyUnit;
  String propertyValue;
  String propertySize;
  List<PropertyImages> propertyImages;
  String propertyApproval;
  String propertyStatus;
  String createdUtype;
  String updatedUtype;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  String propertyTypeName;
  String latitude;
  String longitude;
  String mapLocation;
  String propertyNote;
  String serviceType;
  String groupName;
  String groupCode;
  String groupContactName;
  String groupContactPhone;
  String cusCode;
  String cusName;
  String cusPhone;
  List<Plan> plan;
  List<PlanServices> planServices;

  PropertyDetailModel(
      {this.propertyId,
      this.cusId,
      this.groupId,
      this.propertyCode,
      this.propertyName,
      this.propertyTypeId,
      this.propertyUnit,
      this.propertyValue,
      this.propertySize,
      this.propertyImages,
      this.propertyApproval,
      this.propertyStatus,
      this.createdUtype,
      this.updatedUtype,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.propertyTypeName,
      this.latitude,
      this.longitude,
      this.mapLocation,
      this.propertyNote,
      this.serviceType,
      this.groupName,
      this.groupCode,
      this.groupContactName,
      this.groupContactPhone,
      this.cusCode,
      this.cusName,
      this.cusPhone,
      this.plan,
      this.planServices});

  PropertyDetailModel.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    cusId = json['cus_id'];
    groupId = json['group_id'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
    propertyTypeId = json['property_type_id'];
    propertyUnit = json['property_unit'];
    propertyValue = json['property_value'];
    propertySize = json['property_size'];
    if (json['property_images'] != "null") {
      propertyImages = new List<PropertyImages>();
      json['property_images'].forEach((v) {
        propertyImages.add(new PropertyImages.fromJson(v));
      });
    }
    propertyApproval = json['property_approval'];
    propertyStatus = json['property_status'];
    createdUtype = json['created_utype'];
    updatedUtype = json['updated_utype'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    propertyTypeName = json['property_type_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mapLocation = json['map_location'];
    propertyNote = json['property_note'];
    serviceType = json['service_type'];
    groupName = json['group_name'];
    groupCode = json['group_code'];
    groupContactName = json['group_contact_name'];
    groupContactPhone = json['group_contact_phone'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
    if (json['plan'] != null) {
      plan = new List<Plan>();
      json['plan'].forEach((v) {
        plan.add(new Plan.fromJson(v));
      });
    }
    if (json['plan_services'] != null) {
      planServices = new List<PlanServices>();
      json['plan_services'].forEach((v) {
        planServices.add(new PlanServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_id'] = this.propertyId;
    data['cus_id'] = this.cusId;
    data['group_id'] = this.groupId;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    data['property_type_id'] = this.propertyTypeId;
    data['property_unit'] = this.propertyUnit;
    data['property_value'] = this.propertyValue;
    data['property_size'] = this.propertySize;
    if (this.propertyImages != null) {
      data['property_images'] =
          this.propertyImages.map((v) => v.toJson()).toList();
    }
    data['property_approval'] = this.propertyApproval;
    data['property_status'] = this.propertyStatus;
    data['created_utype'] = this.createdUtype;
    data['updated_utype'] = this.updatedUtype;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['property_type_name'] = this.propertyTypeName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['map_location'] = this.mapLocation;
    data['property_note'] = this.propertyNote;
    data['service_type'] = this.serviceType;
    data['group_name'] = this.groupName;
    data['group_code'] = this.groupCode;
    data['group_contact_name'] = this.groupContactName;
    data['group_contact_phone'] = this.groupContactPhone;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    if (this.plan != null) {
      data['plan'] = this.plan.map((v) => v.toJson()).toList();
    }
    if (this.planServices != null) {
      data['plan_services'] = this.planServices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyImages {
  String imgId;
  String imgPath;

  PropertyImages({this.imgId, this.imgPath});

  PropertyImages.fromJson(Map<String, dynamic> json) {
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

class Plan {
  String pplanId;
  String pplanName;
  String pplanYear;
  String pplanService;
  String pplanPrice;
  String pplanStartDate;
  String pplanCurrentStatus;

  Plan(
      {this.pplanId,
      this.pplanName,
      this.pplanYear,
      this.pplanService,
      this.pplanPrice,
      this.pplanStartDate,
      this.pplanCurrentStatus});

  Plan.fromJson(Map<String, dynamic> json) {
    pplanId = json['pplan_id'];
    pplanName = json['pplan_name'];
    pplanYear = json['pplan_year'];
    pplanService = json['pplan_service'];
    pplanPrice = json['pplan_price'];
    pplanStartDate = json['pplan_start_date'];
    pplanCurrentStatus = json['pplan_current_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pplan_id'] = this.pplanId;
    data['pplan_name'] = this.pplanName;
    data['pplan_year'] = this.pplanYear;
    data['pplan_service'] = this.pplanService;
    data['pplan_price'] = this.pplanPrice;
    data['pplan_start_date'] = this.pplanStartDate;
    data['pplan_current_status'] = this.pplanCurrentStatus;
    return data;
  }
}

class PlanServices {
  String pserviceId;
  String pserviceDate;
  String pserviceServiceStatus;

  PlanServices(
      {this.pserviceId, this.pserviceDate, this.pserviceServiceStatus});

  PlanServices.fromJson(Map<String, dynamic> json) {
    pserviceId = json['pservice_id'];
    pserviceDate = json['pservice_date'];
    pserviceServiceStatus = json['pservice_service_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pservice_id'] = this.pserviceId;
    data['pservice_date'] = this.pserviceDate;
    data['pservice_service_status'] = this.pserviceServiceStatus;
    return data;
  }
}
