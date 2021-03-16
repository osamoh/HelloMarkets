class CustomerSavedOffer {

  static String TABLE_NAME = "`customer_saved_offer`";

  static String COLUMN_ID = "_id";
  static String COLUMN_PRICE = "_price";
  static String COLUMN_SELLERID = "_sellerId";

  static String CREATE_TABLE_QUERY = "CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " ("
      + COLUMN_ID + "	INTEGER, "
      + COLUMN_PRICE + " INTEGER, "
      + COLUMN_SELLERID + " INTEGER"
      + ")";

  int id;
  int price;
  int sellerId;

  CustomerSavedOffer({this.id, this.price, this.sellerId});

  factory CustomerSavedOffer.fromDB(Map<String, dynamic> obj) => CustomerSavedOffer(
    id: obj[COLUMN_ID],
    price: obj[COLUMN_PRICE],
    sellerId: obj[COLUMN_SELLERID]
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[COLUMN_ID] = id;
    map[COLUMN_PRICE] = price;
    map[COLUMN_SELLERID] = sellerId;
    return map;
  }

}