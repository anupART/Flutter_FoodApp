class FoodModel {
  final User user;
  final List<Report> reports;

  FoodModel({required this.user, required this.reports});

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      user: json['user'] != null
          ? User.fromJson(json['user'])
          : User.empty(),
      reports: json['reports'] != null
          ? (json['reports'] as List)
          .map((report) => Report.fromJson(report))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'reports': reports.map((report) => report.toJson()).toList(),
    };
  }
}

class User {
  final int id;
  final String fName;
  final String lName;
  final String phone;
  final String email;
  final String? image;
  final int? isPhoneVerified;
  final String? cmFirebaseToken;
  final int? status;
  final int? orderCount;
  final String? empId;
  final int? departmentId;
  final int? isVeg;
  final int? isSatOpted;

  User({
    required this.id,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.email,
    this.image,
    this.isPhoneVerified,
    this.cmFirebaseToken,
    this.status,
    this.orderCount,
    this.empId,
    this.departmentId,
    this.isVeg,
    this.isSatOpted,
  });

  // Factory constructor for creating an empty/default User
  factory User.empty() {
    return User(
      id: 0,
      fName: '',
      lName: '',
      phone: '',
      email: '',
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      fName: json['f_name'] ?? '',
      lName: json['l_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      isPhoneVerified: json['is_phone_verified'],
      cmFirebaseToken: json['cm_firebase_token'],
      status: json['status'],
      orderCount: json['order_count'],
      empId: json['emp_id'],
      departmentId: json['department_id'],
      isVeg: json['is_veg'],
      isSatOpted: json['is_sat_opted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'f_name': fName,
      'l_name': lName,
      'phone': phone,
      'email': email,
      'image': image,
      'is_phone_verified': isPhoneVerified,
      'cm_firebase_token': cmFirebaseToken,
      'status': status,
      'order_count': orderCount,
      'emp_id': empId,
      'department_id': departmentId,
      'is_veg': isVeg,
      'is_sat_opted': isSatOpted,
    };
  }
}

class Report {
  final String date;
  final OptIns optIns;

  Report({required this.date, required this.optIns});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      date: json['date'] ?? '',
      optIns: json['opt_ins'] != null && json['opt_ins'] is Map<String, dynamic>
          ? OptIns.fromJson(json['opt_ins'])
          : OptIns.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'opt_ins': optIns,
    };
  }
}
class OptIns {
  final String? breakfast;
  final String? lunch;
  final String? dinner;

  OptIns({
    this.breakfast,
    this.lunch,
    this.dinner
  });

  factory OptIns.empty() {
    return OptIns();
  }

  factory OptIns.fromJson(Map<String, dynamic> json) {
    return OptIns(
        breakfast: json['breakfast'],
        lunch: json['lunch'],
        dinner: json['dinner']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner
    };
  }
}
