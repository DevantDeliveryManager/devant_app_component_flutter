import 'package:equatable/equatable.dart';

class HealerListModel extends Equatable {
  final List<HealerModel> healers;
  final HealerPaginationModel pagination;
  final String? message;

  const HealerListModel({
    this.healers = const [],
    this.pagination = const HealerPaginationModel(),
    this.message,
  });

  factory HealerListModel.fromJson(Map<String, dynamic> json) {
    return HealerListModel(
      healers: (json['healers'] as List<dynamic>?)
              ?.map((e) => HealerModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList() ??
          [],
      pagination: json['pagination'] is Map
          ? HealerPaginationModel.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : const HealerPaginationModel(),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'healers': healers.map((e) => e.toJson()).toList(),
        'pagination': pagination.toJson(),
        'message': message,
      };

  @override
  List<Object?> get props => [healers, pagination, message];
}

class HealerModel extends Equatable {
  final String? id;
  final HealerUserModel? user;
  final String? displayName;
  final String? profileImage;
  final String? headline;
  final int? yearsOfPractice;
  final List<HealerPracticeModel> practices;
  final HealerPackagesModel? packages;
  final DateTime? nextSessionAt;
  final num? fromPrice;
  final String? currency;

  const HealerModel({
    this.id,
    this.user,
    this.displayName,
    this.profileImage,
    this.headline,
    this.yearsOfPractice,
    this.practices = const [],
    this.packages,
    this.nextSessionAt,
    this.fromPrice,
    this.currency,
  });

  factory HealerModel.fromJson(Map<String, dynamic> json) {
    return HealerModel(
      id: json['_id'] as String?,
      user: json['user'] is Map
          ? HealerUserModel.fromJson(
              Map<String, dynamic>.from(json['user'] as Map),
            )
          : null,
      displayName: json['displayName'] as String?,
      profileImage: json['profileImage'] as String?,
      headline: json['headline'] as String?,
      yearsOfPractice: (json['yearsOfPractice'] as num?)?.toInt(),
      practices: (json['practices'] as List<dynamic>?)
              ?.map((e) => HealerPracticeModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList() ??
          [],
      packages: json['packages'] is Map
          ? HealerPackagesModel.fromJson(
              Map<String, dynamic>.from(json['packages'] as Map),
            )
          : null,
      nextSessionAt: DateTime.tryParse(
        json['nextSessionAt']?.toString() ?? '',
      ),
      fromPrice: json['fromPrice'] as num?,
      currency: json['currency'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user?.toJson(),
        'displayName': displayName,
        'profileImage': profileImage,
        'headline': headline,
        'yearsOfPractice': yearsOfPractice,
        'practices': practices.map((e) => e.toJson()).toList(),
        'packages': packages?.toJson(),
        'nextSessionAt': nextSessionAt?.toUtc().toIso8601String(),
        'fromPrice': fromPrice,
        'currency': currency,
      };

  @override
  List<Object?> get props => [
        id,
        user,
        displayName,
        profileImage,
        headline,
        yearsOfPractice,
        practices,
        packages,
        nextSessionAt,
        fromPrice,
        currency,
      ];
}

class HealerUserModel extends Equatable {
  final String? id;
  final String? userId;
  final String? mobile;
  final String? email;
  final bool? isHealer;
  final bool? isSeeker;
  final bool? profileHealerUpdated;
  final bool? profileSeekerUpdated;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  const HealerUserModel({
    this.id,
    this.userId,
    this.mobile,
    this.email,
    this.isHealer,
    this.isSeeker,
    this.profileHealerUpdated,
    this.profileSeekerUpdated,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory HealerUserModel.fromJson(Map<String, dynamic> json) {
    return HealerUserModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      isHealer: json['isHealer'] as bool?,
      isSeeker: json['isSeeker'] as bool?,
      profileHealerUpdated: json['profileHealerUpdated'] as bool?,
      profileSeekerUpdated: json['profileSeekerUpdated'] as bool?,
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ),
      updatedAt: DateTime.tryParse(
        json['updatedAt']?.toString() ?? '',
      ),
      version: (json['__v'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'mobile': mobile,
        'email': email,
        'isHealer': isHealer,
        'isSeeker': isSeeker,
        'profileHealerUpdated': profileHealerUpdated,
        'profileSeekerUpdated': profileSeekerUpdated,
        'createdAt': createdAt?.toUtc().toIso8601String(),
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
        '__v': version,
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        mobile,
        email,
        isHealer,
        isSeeker,
        profileHealerUpdated,
        profileSeekerUpdated,
        createdAt,
        updatedAt,
        version,
      ];
}

class HealerPracticeModel extends Equatable {
  final String? id;
  final String? name;

  const HealerPracticeModel({
    this.id,
    this.name,
  });

  factory HealerPracticeModel.fromJson(Map<String, dynamic> json) {
    return HealerPracticeModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name];
}

class HealerPackagesModel extends Equatable {
  final int? count;
  final List<String> types;

  const HealerPackagesModel({
    this.count,
    this.types = const [],
  });

  factory HealerPackagesModel.fromJson(Map<String, dynamic> json) {
    return HealerPackagesModel(
      count: (json['count'] as num?)?.toInt(),
      types: (json['types'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'count': count,
        'types': types,
      };

  @override
  List<Object?> get props => [count, types];
}

class HealerPaginationModel extends Equatable {
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;

  const HealerPaginationModel({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory HealerPaginationModel.fromJson(Map<String, dynamic> json) {
    return HealerPaginationModel(
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'page': page,
        'limit': limit,
        'totalPages': totalPages,
      };

  @override
  List<Object?> get props => [total, page, limit, totalPages];
}

class FavouriteList extends Equatable {
  final List<FavouriteHealer> favouriteHealers;
  final String? message;

  const FavouriteList({
    this.favouriteHealers = const [],
    this.message,
  });

  factory FavouriteList.fromJson(Map<String, dynamic> json) {
    return FavouriteList(
      favouriteHealers: (json['favouriteHealers'] as List<dynamic>?)
              ?.map((e) => FavouriteHealer.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'favouriteHealers': favouriteHealers.map((e) => e.toJson()).toList(),
        'message': message,
      };

  @override
  List<Object?> get props => [favouriteHealers, message];
}

class FavouriteHealer extends Equatable {
  final String? id;
  final String? userId;
  final String? healerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  const FavouriteHealer({
    this.id,
    this.userId,
    this.healerId,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory FavouriteHealer.fromJson(Map<String, dynamic> json) {
    return FavouriteHealer(
      id: json['_id'] as String?,
      userId: json['user_id'] as String?,
      healerId: json['healer_id'] as String?,
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ),
      updatedAt: DateTime.tryParse(
        json['updatedAt']?.toString() ?? '',
      ),
      version: (json['__v'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user_id': userId,
        'healer_id': healerId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': version,
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        healerId,
        createdAt,
        updatedAt,
        version,
      ];
}
