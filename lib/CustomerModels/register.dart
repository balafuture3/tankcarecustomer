class Register {
  bool status;
  List<String> messages;
  String alert;
  String uid;
  String utype;
  String accVerify;
  String token;

  Register(
      {this.status,
      this.messages,
      this.alert,
      this.uid,
      this.utype,
      this.accVerify,
      this.token});

  Register.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'].cast<String>();
    alert = json['alert'];
    uid = json['uid'];
    utype = json['utype'];
    accVerify = json['acc_verify'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messages'] = this.messages;
    data['alert'] = this.alert;
    data['uid'] = this.uid;
    data['utype'] = this.utype;
    data['acc_verify'] = this.accVerify;
    data['token'] = this.token;
    return data;
  }
}
