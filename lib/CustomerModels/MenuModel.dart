class MenuList {
  final List<Menu> list;

  MenuList({
    this.list,
  });

  factory MenuList.fromJson(List<dynamic> parsedJson) {
    List<Menu> lists = new List<Menu>();
    lists = parsedJson.map((i) => Menu.fromJson(i)).toList();

    return new MenuList(list: lists);
  }
}

class Menu {
  String title;
  String menuId;
  String link;
  String icon;
  String img;
  String rrMenuCheck;
  String rrCreate;
  String rrRead;
  String rrUpdate;
  String rrDelete;
  List<Children> children;

  Menu(
      {this.title,
      this.menuId,
      this.link,
      this.icon,
      this.img,
      this.rrMenuCheck,
      this.rrCreate,
      this.rrRead,
      this.rrUpdate,
      this.rrDelete,
      this.children});

  Menu.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    menuId = json['menu_id'];
    link = json['link'];
    icon = json['icon'];
    img = json['img'];
    rrMenuCheck = json['rr_menu_check'];
    rrCreate = json['rr_create'];
    rrRead = json['rr_read'];
    rrUpdate = json['rr_update'];
    rrDelete = json['rr_delete'];
    if (json['children'] != null) {
      children = new List<Children>();
      json['children'].forEach((v) {
        children.add(new Children.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['menu_id'] = this.menuId;
    data['link'] = this.link;
    data['icon'] = this.icon;
    data['img'] = this.img;
    data['rr_menu_check'] = this.rrMenuCheck;
    data['rr_create'] = this.rrCreate;
    data['rr_read'] = this.rrRead;
    data['rr_update'] = this.rrUpdate;
    data['rr_delete'] = this.rrDelete;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Children {
  String title;
  String menuId;
  String link;
  String icon;
  Null img;
  String rrMenuCheck;
  String rrCreate;
  String rrRead;
  String rrUpdate;
  String rrDelete;

  Children(
      {this.title,
      this.menuId,
      this.link,
      this.icon,
      this.img,
      this.rrMenuCheck,
      this.rrCreate,
      this.rrRead,
      this.rrUpdate,
      this.rrDelete});

  Children.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    menuId = json['menu_id'];
    link = json['link'];
    icon = json['icon'];
    img = json['img'];
    rrMenuCheck = json['rr_menu_check'];
    rrCreate = json['rr_create'];
    rrRead = json['rr_read'];
    rrUpdate = json['rr_update'];
    rrDelete = json['rr_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['menu_id'] = this.menuId;
    data['link'] = this.link;
    data['icon'] = this.icon;
    data['img'] = this.img;
    data['rr_menu_check'] = this.rrMenuCheck;
    data['rr_create'] = this.rrCreate;
    data['rr_read'] = this.rrRead;
    data['rr_update'] = this.rrUpdate;
    data['rr_delete'] = this.rrDelete;
    return data;
  }
}
