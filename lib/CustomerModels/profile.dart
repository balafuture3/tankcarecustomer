class Profile {
  bool status;
  Data data;

  Profile({this.status, this.data});

  Profile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String uname;
  String ucode;
  String urole;
  String chkgroup;

  Data({this.uname, this.ucode, this.urole, this.chkgroup});

  Data.fromJson(Map<String, dynamic> json) {
    uname = json['uname'];
    ucode = json['ucode'];
    urole = json['urole'];
    chkgroup = json['chkgroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uname'] = this.uname;
    data['ucode'] = this.ucode;
    data['urole'] = this.urole;
    data['chkgroup'] = this.chkgroup;
    return data;
  }
}