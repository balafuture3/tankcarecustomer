class PriceAPIListings {
  bool status;
  String messages;
  Items items;

  PriceAPIListings({this.status, this.messages, this.items});

  PriceAPIListings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'];
    items = json['items'] != null ? new Items.fromJson(json['items']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    if (this.items != null) {
      data['items'] = this.items.toJson();
    }
    return data;
  }
}

class Items {
  String planId;
  String planCode;
  String planName;
  String planUnit;
  String planSizeTo;
  String planSizeFrom;
  List<Price> price;

  Items(
      {this.planId,
      this.planCode,
      this.planName,
      this.planUnit,
      this.planSizeTo,
      this.planSizeFrom,
      this.price});

  Items.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    planCode = json['plan_code'];
    planName = json['plan_name'];
    planUnit = json['plan_unit'];
    planSizeTo = json['plan_size_to'];
    planSizeFrom = json['plan_size_from'];
    if (json['price'] != null) {
      price = new List<Price>();
      json['price'].forEach((v) {
        price.add(new Price.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_id'] = this.planId;
    data['plan_code'] = this.planCode;
    data['plan_name'] = this.planName;
    data['plan_unit'] = this.planUnit;
    data['plan_size_to'] = this.planSizeTo;
    data['plan_size_from'] = this.planSizeFrom;
    if (this.price != null) {
      data['price'] = this.price.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Price {
  String year;
  List<Service> service;

  Price({this.year, this.service});

  Price.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    if (json['service'] != null) {
      service = new List<Service>();
      json['service'].forEach((v) {
        service.add(new Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    if (this.service != null) {
      data['service'] = this.service.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  String priceId;
  String totalService;
  String literPrice;
  String fixedPrice;

  Service({this.priceId, this.totalService, this.literPrice, this.fixedPrice});

  Service.fromJson(Map<String, dynamic> json) {
    priceId = json['price_id'];
    totalService = json['total_service'];
    literPrice = json['liter_price'];
    fixedPrice = json['fixed_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price_id'] = this.priceId;
    data['total_service'] = this.totalService;
    data['liter_price'] = this.literPrice;
    data['fixed_price'] = this.fixedPrice;
    return data;
  }
}
