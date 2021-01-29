class Otp {
  bool status;
  String alert;

  Otp({this.status, this.alert});

  Otp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    alert = json['alert'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['alert'] = this.alert;
    return data;
  }
}
