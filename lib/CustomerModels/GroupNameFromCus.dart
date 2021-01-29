class GroupNameFromCusList {
  final List<GroupNameFromCus> tariff;

  GroupNameFromCusList({
    this.tariff,
  });

  factory GroupNameFromCusList.fromJson(List<dynamic> parsedJson) {
    List<GroupNameFromCus> tariffs = new List<GroupNameFromCus>();
    tariffs = parsedJson.map((i) => GroupNameFromCus.fromJson(i)).toList();

    return new GroupNameFromCusList(tariff: tariffs);
  }
}

class GroupNameFromCus {
  String groupId;
  String groupCode;
  String groupName;
  String serviceType;

  GroupNameFromCus(
      {this.groupId, this.groupCode, this.groupName, this.serviceType});

  GroupNameFromCus.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    groupCode = json['group_code'];
    groupName = json['group_name'];
    serviceType = json['service_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['group_code'] = this.groupCode;
    data['group_name'] = this.groupName;
    data['service_type'] = this.serviceType;
    return data;
  }
}
