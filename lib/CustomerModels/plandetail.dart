class PlanDetailListings {
  bool status;
  Plan plan;
  Property property;
  List<PlanServices> planServices;

  PlanDetailListings(
      {this.status, this.plan, this.property, this.planServices});

  PlanDetailListings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    plan = json['plan'] != null ? new Plan.fromJson(json['plan']) : null;
    property = json['property'] != null
        ? new Property.fromJson(json['property'])
        : null;
    if (json['plan_services'] != null) {
      planServices = new List<PlanServices>();
      json['plan_services'].forEach((v) {
        planServices.add(new PlanServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.plan != null) {
      data['plan'] = this.plan.toJson();
    }
    if (this.property != null) {
      data['property'] = this.property.toJson();
    }
    if (this.planServices != null) {
      data['plan_services'] = this.planServices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plan {
  String pplanId;
  String cusId;
  String propertyId;
  String planId;
  String pplanName;
  String pplanYear;
  String pplanService;
  String pplanTotService;
  String pplanStartDate;
  String pplanPrice;
  String pplanTotPrice;
  String pplanPaidStatus;
  String pplanCurrentStatus;
  String pplanStatus;
  String createdUtype;
  String updatedUtype;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;

  Plan(
      {this.pplanId,
      this.cusId,
      this.propertyId,
      this.planId,
      this.pplanName,
      this.pplanYear,
      this.pplanService,
      this.pplanTotService,
      this.pplanStartDate,
      this.pplanPrice,
      this.pplanTotPrice,
      this.pplanPaidStatus,
      this.pplanCurrentStatus,
      this.pplanStatus,
      this.createdUtype,
      this.updatedUtype,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy});

  Plan.fromJson(Map<String, dynamic> json) {
    pplanId = json['pplan_id'];
    cusId = json['cus_id'];
    propertyId = json['property_id'];
    planId = json['plan_id'];
    pplanName = json['pplan_name'];
    pplanYear = json['pplan_year'];
    pplanService = json['pplan_service'];
    pplanTotService = json['pplan_tot_service'];
    pplanStartDate = json['pplan_start_date'];
    pplanPrice = json['pplan_price'];
    pplanTotPrice = json['pplan_tot_price'];
    pplanPaidStatus = json['pplan_paid_status'];
    pplanCurrentStatus = json['pplan_current_status'];
    pplanStatus = json['pplan_status'];
    createdUtype = json['created_utype'];
    updatedUtype = json['updated_utype'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pplan_id'] = this.pplanId;
    data['cus_id'] = this.cusId;
    data['property_id'] = this.propertyId;
    data['plan_id'] = this.planId;
    data['pplan_name'] = this.pplanName;
    data['pplan_year'] = this.pplanYear;
    data['pplan_service'] = this.pplanService;
    data['pplan_tot_service'] = this.pplanTotService;
    data['pplan_start_date'] = this.pplanStartDate;
    data['pplan_price'] = this.pplanPrice;
    data['pplan_tot_price'] = this.pplanTotPrice;
    data['pplan_paid_status'] = this.pplanPaidStatus;
    data['pplan_current_status'] = this.pplanCurrentStatus;
    data['pplan_status'] = this.pplanStatus;
    data['created_utype'] = this.createdUtype;
    data['updated_utype'] = this.updatedUtype;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}

class Property {
  String propertyId;
  String cusId;
  String groupId;
  String propertyCode;
  String propertyName;
  String propertyTypeId;
  String propertyUnit;
  String propertyValue;
  String propertySize;
  String propertyImages;
  String propertyApproval;
  String propertyStatus;
  String createdUtype;
  Null updatedUtype;
  String createdAt;
  String createdBy;
  Null updatedAt;
  Null updatedBy;
  String propertyTypeName;
  String serviceType;
  String groupCode;
  String groupName;

  Property(
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
      this.serviceType,
      this.groupCode,
      this.groupName});

  Property.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    cusId = json['cus_id'];
    groupId = json['group_id'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
    propertyTypeId = json['property_type_id'];
    propertyUnit = json['property_unit'];
    propertyValue = json['property_value'];
    propertySize = json['property_size'];
    propertyImages = json['property_images'];
    propertyApproval = json['property_approval'];
    propertyStatus = json['property_status'];
    createdUtype = json['created_utype'];
    updatedUtype = json['updated_utype'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    propertyTypeName = json['property_type_name'];
    serviceType = json['service_type'];
    groupCode = json['group_code'];
    groupName = json['group_name'];
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
    data['property_images'] = this.propertyImages;
    data['property_approval'] = this.propertyApproval;
    data['property_status'] = this.propertyStatus;
    data['created_utype'] = this.createdUtype;
    data['updated_utype'] = this.updatedUtype;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['property_type_name'] = this.propertyTypeName;
    data['service_type'] = this.serviceType;
    data['group_code'] = this.groupCode;
    data['group_name'] = this.groupName;
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
