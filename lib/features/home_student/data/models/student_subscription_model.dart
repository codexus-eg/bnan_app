class StudentSubscriptionModel {
  final String id;
  final SubscriptionStudentModel student;
  final SubscriptionPackageModel package;
  final String packageType;
  final int purchasedHours;
  final int remainingHours;
  final num paidPrice;
  final String status;
  final String startDate;
  final String createdAt;
  final String updatedAt;
  final bool isActive;

  const StudentSubscriptionModel({
    required this.id,
    required this.student,
    required this.package,
    required this.packageType,
    required this.purchasedHours,
    required this.remainingHours,
    required this.paidPrice,
    required this.status,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory StudentSubscriptionModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return StudentSubscriptionModel(
      id: data['id'] ?? '',
      student: SubscriptionStudentModel.fromJson(data['student'] ?? {}),
      package: SubscriptionPackageModel.fromJson(data['package'] ?? {}),
      packageType: data['packageType'] ?? '',
      purchasedHours: data['purchasedHours'] ?? 0,
      remainingHours: data['remainingHours'] ?? 0,
      paidPrice: data['paidPrice'] ?? 0,
      status: data['status'] ?? '',
      startDate: data['startDate'] ?? '',
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      isActive: data['isActive'] ?? false,
    );
  }

  factory StudentSubscriptionModel.placeholder() {
    return const StudentSubscriptionModel(
      id: '',
      student: SubscriptionStudentModel(
        fullName: 'اسم الطالب',
      ),
      package: SubscriptionPackageModel(
        id: '',
        name: '8 Hours Package',
        type: 'hours',
        hours: 8,
        price: 1000,
      ),
      packageType: 'hours',
      purchasedHours: 8,
      remainingHours: 8,
      paidPrice: 1000,
      status: 'active',
      startDate: '',
      createdAt: '',
      updatedAt: '',
      isActive: true,
    );
  }

  bool get isHoursPackage => packageType == 'hours';

  bool get isDaysPackage => packageType == 'days';

  int get usedHours {
    final used = purchasedHours - remainingHours;
    return used < 0 ? 0 : used;
  }

  double get progress {
    if (purchasedHours == 0) return 0;
    return usedHours / purchasedHours;
  }

  bool get hasActiveSubscription {
    return isActive && status == 'active';
  }

  String get studentName => student.fullName;

  String get packageName => package.name;

  int get totalHours => purchasedHours;
}

class SubscriptionStudentModel {
  final String fullName;

  const SubscriptionStudentModel({
    required this.fullName,
  });

  factory SubscriptionStudentModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionStudentModel(
      fullName: json['fullName'] ?? '',
    );
  }
}

class SubscriptionPackageModel {
  final String id;
  final String name;
  final String type;
  final int hours;
  final num price;

  const SubscriptionPackageModel({
    required this.id,
    required this.name,
    required this.type,
    required this.hours,
    required this.price,
  });

  factory SubscriptionPackageModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPackageModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      hours: json['hours'] ?? 0,
      price: json['price'] ?? 0,
    );
  }
}