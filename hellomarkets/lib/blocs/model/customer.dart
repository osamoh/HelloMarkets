import '../../util/constants.dart';

class Customer {
  String name;
  String email;
  String phone;
  String password;

  Customer({this.name, this.email, this.phone, this.password});

  factory Customer.fromJSON(Map<String, dynamic> map) => Customer(
    name: map[Constants.NAME],
    email: map[Constants.EMAIL],
    phone: map[Constants.PHONE],
    password: map[Constants.PASSWORD]
  );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map[Constants.NAME] = name;
    map[Constants.EMAIL] = email;
    map[Constants.PHONE] = phone;
    if(password != null)
      map[Constants.PASSWORD] = password;
    return map;
  }
}