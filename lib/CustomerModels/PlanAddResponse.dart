class PlanAddResponse {
  bool status;
  List<String> messages;
  String alert;
  String pplanId;

  PlanAddResponse({this.status, this.messages, this.alert, this.pplanId});

  PlanAddResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'].cast<String>();
    alert = json['alert'];
    pplanId = json['pplan_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['alert'] = this.alert;
    data['pplan_id'] = this.pplanId;
    return data;
  }
}