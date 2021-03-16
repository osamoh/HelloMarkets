import '../../util/constants.dart';

class Offer {
  int id;
  String name;
  String description;
  int priceBefore;
  int priceAfter;
  String website;
  int calories;
  String dateStart;
  String dateEnd;
  String barcode;
  String photo;
  int sellerId;
  int categoryId;
  int rate;

  Offer({this.id, this.name, this.description, this.priceBefore, this.priceAfter, this.website, this.calories, this.dateStart, this.dateEnd, this.barcode, this.photo, this.sellerId, this.categoryId, this.rate});

  factory Offer.fromJSON(Map<String, dynamic> dataObj) => Offer(
      id: dataObj[Constants.ID],
      name : dataObj[Constants.NAME],
      description : dataObj[Constants.DESCRIPTION],
      priceBefore : dataObj[Constants.PRICE_BEFORE],
      priceAfter : dataObj[Constants.PRICE_AFTER],
      website : dataObj[Constants.WEBSITE],
      calories : dataObj[Constants.CALORIES],
      dateStart : dataObj[Constants.DATE_START],
      dateEnd : dataObj[Constants.DATE_END],
      barcode : dataObj[Constants.BARCODE],
      photo : dataObj[Constants.PHOTO],
      sellerId: dataObj[Constants.SELLER_ID],
      categoryId: dataObj[Constants.CATEGORY_ID],
      rate: dataObj[Constants.RATE]
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[Constants.ID] = id;
    map[Constants.NAME] = name;
    map[Constants.DESCRIPTION] = description;
    map[Constants.PRICE_BEFORE] = priceBefore;
    map[Constants.PRICE_AFTER] = priceAfter;
    map[Constants.WEBSITE] = website;
    map[Constants.CALORIES] = calories;
    map[Constants.DATE_START] = dateStart;
    map[Constants.DATE_END] = dateEnd;
    map[Constants.BARCODE] = barcode;
    if(photo != null)
      map[Constants.PHOTO] = photo;
    map[Constants.SELLER_ID] = sellerId;
    map[Constants.CATEGORY_ID] = categoryId;
    if(rate != null)
      map[Constants.RATE] = rate;
    return map;
  }

}