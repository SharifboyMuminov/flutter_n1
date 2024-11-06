class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  UserModel({
    required this.phoneNumber,
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phoneNumber: json["phone"] as String? ?? "",
      id: json["id"] as int? ?? 0,
      firstName: json["firstName"] as String? ?? "",
      lastName: json["lastName"] as String? ?? "",
    );
  }

  UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) {
    return UserModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  factory UserModel.initial() {
    return UserModel(
      id: 0,
      firstName: "",
      lastName: "",
      phoneNumber: "",
    );
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {"firstName": firstName, "lastName": lastName, "phone": phoneNumber};
  }
}

// m() {
//   UserModel userModel = UserModel(
//     phoneNumber: "",
//     id: 0,
//     firstName: "",
//     lastName: "",
//   );
//
//   UserModel updateUser = UserModel(
//     phoneNumber: "asdf",
//     id: userModel.id,
//     firstName: userModel.firstName,
//     lastName: userModel.lastName,
//   );
//
//   userModel = userModel.copyWith(phoneNumber: "asdfasdf");
// }
