class ServiceDetailListings {
  bool status;
  PlanServices planServices;
  Plan plan;
  Property property;
  List<ServiceComplaint> serviceComplaint;
  List<ServiceDamage> serviceDamage;
  List<ServiceFeedback> serviceFeedback;

  ServiceDetailListings(
      {this.status,
      this.planServices,
      this.plan,
      this.property,
      this.serviceComplaint,
      this.serviceDamage,
      this.serviceFeedback});

  ServiceDetailListings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    planServices = json['plan_services'] != null
        ? new PlanServices.fromJson(json['plan_services'])
        : null;
    plan = json['plan'] != null ? new Plan.fromJson(json['plan']) : null;
    property = json['property'] != null
        ? new Property.fromJson(json['property'])
        : null;
    if (json['service_complaint'] != null) {
      serviceComplaint = new List<ServiceComplaint>();
      json['service_complaint'].forEach((v) {
        serviceComplaint.add(new ServiceComplaint.fromJson(v));
      });
    }
    if (json['service_damage'] != null) {
      serviceDamage = new List<ServiceDamage>();
      json['service_damage'].forEach((v) {
        serviceDamage.add(new ServiceDamage.fromJson(v));
      });
    }
    if (json['service_feedback'] != null) {
      serviceFeedback = new List<ServiceFeedback>();
      json['service_feedback'].forEach((v) {
        serviceFeedback.add(new ServiceFeedback.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.planServices != null) {
      data['plan_services'] = this.planServices.toJson();
    }
    if (this.plan != null) {
      data['plan'] = this.plan.toJson();
    }
    if (this.property != null) {
      data['property'] = this.property.toJson();
    }
    if (this.serviceComplaint != null) {
      data['service_complaint'] =
          this.serviceComplaint.map((v) => v.toJson()).toList();
    }
    if (this.serviceDamage != null) {
      data['service_damage'] =
          this.serviceDamage.map((v) => v.toJson()).toList();
    }
    if (this.serviceFeedback != null) {
      data['service_feedback'] =
          this.serviceFeedback.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanServices {
  String pserviceId;
  String pserviceCode;
  String cusId;
  String propertyId;
  String pplanId;
  String planId;
  String pserviceDate;
  String pserviceServiceStatus;
  String pserviceStartAt;
  String pserviceEndAt;
  String pserviceBeforeImg;
  String pserviceAfterImg;
  String pserviceOtp;
  String pserviceAsignStartAt;
  String pserviceAsignEndAt;
  String pserviceAssignUtype;
  String pserviceAssignUid;
  String pserviceCusRemark;
  String pserviceNote;
  String pserviceStatus;
  String pserviceApproval;
  String updatedUtype;
  String updatedAt;
  String updatedBy;

  PlanServices(
      {this.pserviceId,
      this.pserviceCode,
      this.cusId,
      this.propertyId,
      this.pplanId,
      this.planId,
      this.pserviceDate,
      this.pserviceServiceStatus,
      this.pserviceStartAt,
      this.pserviceEndAt,
      this.pserviceBeforeImg,
      this.pserviceAfterImg,
      this.pserviceOtp,
      this.pserviceAsignStartAt,
      this.pserviceAsignEndAt,
      this.pserviceAssignUtype,
      this.pserviceAssignUid,
      this.pserviceCusRemark,
      this.pserviceNote,
      this.pserviceStatus,
      this.pserviceApproval,
      this.updatedUtype,
      this.updatedAt,
      this.updatedBy});

  PlanServices.fromJson(Map<String, dynamic> json) {
    pserviceId = json['pservice_id'];
    pserviceCode = json['pservice_code'];
    cusId = json['cus_id'];
    propertyId = json['property_id'];
    pplanId = json['pplan_id'];
    planId = json['plan_id'];
    pserviceDate = json['pservice_date'];
    pserviceServiceStatus = json['pservice_service_status'];
    pserviceStartAt = json['pservice_start_at'];
    pserviceEndAt = json['pservice_end_at'];
    pserviceBeforeImg = json['pservice_before_img'];
    pserviceAfterImg = json['pservice_after_img'];
    pserviceOtp = json['pservice_otp'];
    pserviceAsignStartAt = json['pservice_asign_start_at'];
    pserviceAsignEndAt = json['pservice_asign_end_at'];
    pserviceAssignUtype = json['pservice_assign_utype'];
    pserviceAssignUid = json['pservice_assign_uid'];
    pserviceCusRemark = json['pservice_cus_remark'];
    pserviceNote = json['pservice_note'];
    pserviceStatus = json['pservice_status'];
    pserviceApproval = json['pservice_approval'];
    updatedUtype = json['updated_utype'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pservice_id'] = this.pserviceId;
    data['pservice_code'] = this.pserviceCode;
    data['cus_id'] = this.cusId;
    data['property_id'] = this.propertyId;
    data['pplan_id'] = this.pplanId;
    data['plan_id'] = this.planId;
    data['pservice_date'] = this.pserviceDate;
    data['pservice_service_status'] = this.pserviceServiceStatus;
    data['pservice_start_at'] = this.pserviceStartAt;
    data['pservice_end_at'] = this.pserviceEndAt;
    data['pservice_before_img'] = this.pserviceBeforeImg;
    data['pservice_after_img'] = this.pserviceAfterImg;
    data['pservice_otp'] = this.pserviceOtp;
    data['pservice_asign_start_at'] = this.pserviceAsignStartAt;
    data['pservice_asign_end_at'] = this.pserviceAsignEndAt;
    data['pservice_assign_utype'] = this.pserviceAssignUtype;
    data['pservice_assign_uid'] = this.pserviceAssignUid;
    data['pservice_cus_remark'] = this.pserviceCusRemark;
    data['pservice_note'] = this.pserviceNote;
    data['pservice_status'] = this.pserviceStatus;
    data['pservice_approval'] = this.pserviceApproval;
    data['updated_utype'] = this.updatedUtype;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
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

class Property {
  String propertyId;
  String cusId;
  String groupId;
  String propertyCode;
  String propertyName;
  String propertyUnit;
  String propertyValue;
  String propertySize;
  String propertyImages;
  String propertyApproval;
  String groupName;
  String groupCode;
  String groupAddress;
  String groupContactName;
  String groupContactPhone;
  String propertyTypeName;
  String serviceType;
  String latitude;
  String longitude;
  String mapLocation;
  String cusCode;
  String cusName;
  String cusPhone;

  Property(
      {this.propertyId,
      this.cusId,
      this.groupId,
      this.propertyCode,
      this.propertyName,
      this.propertyUnit,
      this.propertyValue,
      this.propertySize,
      this.propertyImages,
      this.propertyApproval,
      this.groupName,
      this.groupCode,
      this.groupAddress,
      this.groupContactName,
      this.groupContactPhone,
      this.propertyTypeName,
      this.serviceType,
      this.latitude,
      this.longitude,
      this.mapLocation,
      this.cusCode,
      this.cusName,
      this.cusPhone});

  Property.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    cusId = json['cus_id'];
    groupId = json['group_id'];
    propertyCode = json['property_code'];
    propertyName = json['property_name'];
    propertyUnit = json['property_unit'];
    propertyValue = json['property_value'];
    propertySize = json['property_size'];
    propertyImages = json['property_images'];
    propertyApproval = json['property_approval'];
    groupName = json['group_name'];
    groupCode = json['group_code'];
    groupAddress = json['group_address'];
    groupContactName = json['group_contact_name'];
    groupContactPhone = json['group_contact_phone'];
    propertyTypeName = json['property_type_name'];
    serviceType = json['service_type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mapLocation = json['map_location'];
    cusCode = json['cus_code'];
    cusName = json['cus_name'];
    cusPhone = json['cus_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_id'] = this.propertyId;
    data['cus_id'] = this.cusId;
    data['group_id'] = this.groupId;
    data['property_code'] = this.propertyCode;
    data['property_name'] = this.propertyName;
    data['property_unit'] = this.propertyUnit;
    data['property_value'] = this.propertyValue;
    data['property_size'] = this.propertySize;
    data['property_images'] = this.propertyImages;
    data['property_approval'] = this.propertyApproval;
    data['group_name'] = this.groupName;
    data['group_code'] = this.groupCode;
    data['group_address'] = this.groupAddress;
    data['group_contact_name'] = this.groupContactName;
    data['group_contact_phone'] = this.groupContactPhone;
    data['property_type_name'] = this.propertyTypeName;
    data['service_type'] = this.serviceType;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['map_location'] = this.mapLocation;
    data['cus_code'] = this.cusCode;
    data['cus_name'] = this.cusName;
    data['cus_phone'] = this.cusPhone;
    return data;
  }
}

class ServiceComplaint {
  String complaintId;
  String complaintCode;
  String complaintNote;
  String complaintStatus;
  String createdAt;

  ServiceComplaint(
      {this.complaintId,
      this.complaintCode,
      this.complaintNote,
      this.complaintStatus,
      this.createdAt});

  ServiceComplaint.fromJson(Map<String, dynamic> json) {
    complaintId = json['complaint_id'];
    complaintCode = json['complaint_code'];
    complaintNote = json['complaint_note'];
    complaintStatus = json['complaint_status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complaint_id'] = this.complaintId;
    data['complaint_code'] = this.complaintCode;
    data['complaint_note'] = this.complaintNote;
    data['complaint_status'] = this.complaintStatus;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class ServiceDamage {
  String damageId;
  String damageCode;
  String damageNote;
  String damageStatus;
  String createdAt;

  ServiceDamage(
      {this.damageId,
      this.damageCode,
      this.damageNote,
      this.damageStatus,
      this.createdAt});

  ServiceDamage.fromJson(Map<String, dynamic> json) {
    damageId = json['damage_id'];
    damageCode = json['damage_code'];
    damageNote = json['damage_note'];
    damageStatus = json['damage_status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['damage_id'] = this.damageId;
    data['damage_code'] = this.damageCode;
    data['damage_note'] = this.damageNote;
    data['damage_status'] = this.damageStatus;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class ServiceFeedback {
  String feedbackId;
  String cusId;
  String serviceId;
  String cleanRating;
  String servicerRating;
  String feedbackNote;
  String feedbackImg;
  String feedbackStatus;
  String createdAt;
  Null updatedAt;

  ServiceFeedback(
      {this.feedbackId,
      this.cusId,
      this.serviceId,
      this.cleanRating,
      this.servicerRating,
      this.feedbackNote,
      this.feedbackImg,
      this.feedbackStatus,
      this.createdAt,
      this.updatedAt});

  ServiceFeedback.fromJson(Map<String, dynamic> json) {
    feedbackId = json['feedback_id'];
    cusId = json['cus_id'];
    serviceId = json['service_id'];
    cleanRating = json['clean_rating'];
    servicerRating = json['servicer_rating'];
    feedbackNote = json['feedback_note'];
    feedbackImg = json['feedback_img'];
    feedbackStatus = json['feedback_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedback_id'] = this.feedbackId;
    data['cus_id'] = this.cusId;
    data['service_id'] = this.serviceId;
    data['clean_rating'] = this.cleanRating;
    data['servicer_rating'] = this.servicerRating;
    data['feedback_note'] = this.feedbackNote;
    data['feedback_img'] = this.feedbackImg;
    data['feedback_status'] = this.feedbackStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
