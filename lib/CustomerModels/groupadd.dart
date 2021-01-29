class GroupAdd {
  bool status;
  String messages;
  String alert;
  int groupId;

  GroupAdd({this.status, this.messages, this.alert, this.groupId});

  GroupAdd.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'].cast<String>();
    alert = json['alert'];
    groupId = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['alert'] = this.alert;
    data['group_id'] = this.groupId;
    return data;
  }
}
