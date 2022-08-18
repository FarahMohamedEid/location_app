class UserModel {
  String? name;
  String? phone;
  String? uId;

  UserModel({
     this.name,
     this.phone,
     this.uId,

  });


  UserModel.fromJson(Map<String, dynamic> json)
  {
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'name':name,
      'phone':phone,
      'uId':uId,
    };
  }
}