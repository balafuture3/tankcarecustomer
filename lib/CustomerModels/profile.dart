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

  Data({this.uname, this.ucode, this.urole});

  Data.fromJson(Map<String, dynamic> json) {
    uname = json['uname'];
    ucode = json['ucode'];
    urole = json['urole'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uname'] = this.uname;
    data['ucode'] = this.ucode;
    data['urole'] = this.urole;
    return data;
  }
}
