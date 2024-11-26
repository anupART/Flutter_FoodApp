class FoodModel {
  User? user;
  List<Reports>? reports;

  FoodModel({this.user, this.reports});

  FoodModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['reports'] != null) {
      reports = <Reports>[];
      json['reports'].forEach((v) {
        reports!.add(new Reports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.reports != null) {
      data['reports'] = this.reports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  Null? image;
  int? isPhoneVerified;
  Null? emailVerifiedAt;
  Null? emailVerificationToken;
  String? cmFirebaseToken;
  String? createdAt;
  String? updatedAt;
  int? status;
  int? orderCount;
  String? empId;
  int? departmentId;
  int? isVeg;
  int? isSatOpted;
  String? deviceId;
  int? isInvalidDevice;
  int? isBreakfast;
  int? isLunch;
  int? isDinner;

  User(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.image,
        this.isPhoneVerified,
        this.emailVerifiedAt,
        this.emailVerificationToken,
        this.cmFirebaseToken,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.orderCount,
        this.empId,
        this.departmentId,
        this.isVeg,
        this.isSatOpted,
        this.deviceId,
        this.isInvalidDevice,
        this.isBreakfast,
        this.isLunch,
        this.isDinner});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    emailVerificationToken = json['email_verification_token'];
    cmFirebaseToken = json['cm_firebase_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    orderCount = json['order_count'];
    empId = json['emp_id'];
    departmentId = json['department_id'];
    isVeg = json['is_veg'];
    isSatOpted = json['is_sat_opted'];
    deviceId = json['device_id'];
    isInvalidDevice = json['is_invalid_device'];
    isBreakfast = json['is_breakfast'];
    isLunch = json['is_lunch'];
    isDinner = json['is_dinner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['image'] = this.image;
    data['is_phone_verified'] = this.isPhoneVerified;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['email_verification_token'] = this.emailVerificationToken;
    data['cm_firebase_token'] = this.cmFirebaseToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['order_count'] = this.orderCount;
    data['emp_id'] = this.empId;
    data['department_id'] = this.departmentId;
    data['is_veg'] = this.isVeg;
    data['is_sat_opted'] = this.isSatOpted;
    data['device_id'] = this.deviceId;
    data['is_invalid_device'] = this.isInvalidDevice;
    data['is_breakfast'] = this.isBreakfast;
    data['is_lunch'] = this.isLunch;
    data['is_dinner'] = this.isDinner;
    return data;
  }
}

class Reports {
  String? date;
  OptIns? optIns;

  Reports({this.date, this.optIns});

  Reports.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    optIns =
    json['opt_ins'] != null ? new OptIns.fromJson(json['opt_ins']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.optIns != null) {
      data['opt_ins'] = this.optIns!.toJson();
    }
    return data;
  }
}

class OptIns {
  String? breakfast;
  String? lunch;
  String? dinner;

  OptIns({this.breakfast, this.lunch, this.dinner});

  OptIns.fromJson(Map<String, dynamic> json) {
    breakfast = json['breakfast'];
    lunch = json['lunch'];
    dinner = json['dinner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['breakfast'] = this.breakfast;
    data['lunch'] = this.lunch;
    data['dinner'] = this.dinner;
    return data;
  }
}