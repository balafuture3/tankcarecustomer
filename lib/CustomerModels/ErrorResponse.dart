class ErrorResponse {
  bool status;
  String messages;
  String alert;

  ErrorResponse({this.status, this.messages, this.alert});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'];
    alert = json['alert'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['alert'] = this.alert;
    return data;
  }
}