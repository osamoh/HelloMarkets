import '../../util/constants.dart';

class Category {
  int id;
  String name;
  String photo;

  Category({this.id, this.name, this.photo});

  factory Category.fromJSON(Map<String, dynamic> dataObj) => Category(
    id: dataObj[Constants.ID],
    name: dataObj[Constants.NAME],
    photo: dataObj[Constants.PHOTO]
  );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map[Constants.ID] = id;
    map[Constants.NAME] = name;
    map[Constants.PHOTO] = photo;
    return map;
  }
}