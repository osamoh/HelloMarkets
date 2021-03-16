import '../../util/constants.dart';

class Seller {
  int id;
  String name;
  String photo;
  String email;
  String phone;
  int rate;

  Seller({this.id, this.name, this.photo, this.email, this.phone, this.rate});

  factory Seller.fromJSON(Map<String, dynamic> map) => Seller(
    id: map[Constants.ID],
    name: map[Constants.NAME],
    photo: map[Constants.PHOTO],
    email: map[Constants.EMAIL],
    phone: map[Constants.PHONE],
    rate: map[Constants.RATE]
  );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map[Constants.ID] = id;
    map[Constants.NAME] = name;
    map[Constants.PHOTO] = photo;
    map[Constants.EMAIL] = email;
    map[Constants.PHONE] = phone;
    map[Constants.RATE] = rate;
    return map;
  }
}