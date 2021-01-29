class ProprtyTypeList {
  final List<PropertyType> tariff;

  ProprtyTypeList({
    this.tariff,
  });

  factory ProprtyTypeList.fromJson(List<dynamic> parsedJson) {
    List<PropertyType> tariffs = new List<PropertyType>();
    tariffs = parsedJson.map((i) => PropertyType.fromJson(i)).toList();

    return new ProprtyTypeList(tariff: tariffs);
  }
}

class PropertyType {
  String ptypeId;
  String ptypeName;
  String ptypeUnit;

  PropertyType({this.ptypeId, this.ptypeName, this.ptypeUnit});

  PropertyType.fromJson(Map<String, dynamic> json) {
    ptypeId = json['ptype_id'];
    ptypeName = json['ptype_name'];
    ptypeUnit = json['ptype_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ptype_id'] = this.ptypeId;
    data['ptype_name'] = this.ptypeName;
    data['ptype_unit'] = this.ptypeUnit;
    return data;
  }
}
