class Constants {
  ///////////////// CUSTOMER APIS ////////////////////////
  static const String API_CUSTOMER_POST_LOGIN = "http://10.0.2.2:8000/api/customer/login";
  static const String API_CUSTOMER_POST_LOGOUT = "http://10.0.2.2:8000/api/customer/logout";
  static const String API_CUSTOMER_POST_REGISTER = "http://10.0.2.2:8000/api/customer/register";
  static const String API_CUSTOMER_PUT_UPDATE = "http://10.0.2.2:8000/api/customer/update";
  static const String API_CUSTOMER_DEL_DELETE = "http://10.0.2.2:8000/api/customer/delete";
  static const String API_CUSTOMER_GET_ALL_CATEGORIES = "http://10.0.2.2:8000/api/customer/categories";
  static const String API_CUSTOMER_GET_ALL_OFFERS = "http://10.0.2.2:8000/api/customer/offers";
  static const String API_CUSTOMER_POST_RATE_SELLER = "http://10.0.2.2:8000/api/customer/rate_seller";
  static const String API_CUSTOMER_POST_RATE_OFFER = "http://10.0.2.2:8000/api/customer/rate_offer";
  static const String API_CUSTOMER_GET_OFFER = "http://10.0.2.2:8000/api/customer/offers";
  static const String API_CUSTOMER_GET_SIMILAR_OFFERS = "http://10.0.2.2:8000/api/customer/similars";
  static const String API_CUSTOMER_GET_SELLER = "http://10.0.2.2:8000/api/customer/sellers";
  static const String API_CUSTOMER_GET_STATISTICS = "http://10.0.2.2:8000/api/customer/stats";
  static const String API_CUSTOMER_POST_SAVE_OFFER = "http://10.0.2.2:8000/api/customer/offer";
  static const String API_CUSTOMER_GET_SAVED_OFFERS = "http://10.0.2.2:8000/api/customer/offer";
  static const String API_CUSTOMER_POST_SAVE_KEYWORD = "http://10.0.2.2:8000/api/customer/keyword";
  static const String API_CUSTOMER_GET_SAVED_KEYWORDS = "http://10.0.2.2:8000/api/customer/keyword";
  static const String API_CUSTOMER_POST_CONTACT_US = "http://10.0.2.2:8000/api/customer/contact_us";

  ///////////////// SELLER APIS //////////////////////////
  static const String API_SELLER_POST_LOGIN = "http://10.0.2.2:8000/api/seller/login";
  static const String API_SELLER_POST_LOGOUT = "http://10.0.2.2:8000/api/seller/logout";
  static const String API_SELLER_POST_ADD_OFFER = "http://10.0.2.2:8000/api/seller/offer";
  static const String API_SELLER_GET_ALL_CATEGORIES = "http://10.0.2.2:8000/api/seller/categories";
  static const String API_SELLER_GET_ALL_OFFERS = "http://10.0.2.2:8000/api/seller/all_offers";
  static const String API_SELLER_GET_HIS_OFFERS = "http://10.0.2.2:8000/api/seller/my_offers";
  static const String API_SELLER_GET_ALL_SELLERS = "http://10.0.2.2:8000/api/seller/sellers";
  static const String API_SELLER_GET_SELLER = "http://10.0.2.2:8000/api/seller/sellers";
  static const String API_SELLER_PUT_EDIT_OFFER = "http://10.0.2.2:8000/api/seller/offer";
  static const String API_SELLER_DEL_DELETE_OFFER = "http://10.0.2.2:8000/api/seller/offer";
  static const String API_SELLER_POST_CONTACT_US = "http://10.0.2.2:8000/api/seller/contact_us";
  static const String API_SELLER_GET_STATISTICS = "http://10.0.2.2:8000/api/seller/stats";
  static const String OFFER_IMAGE_PATH = "http://10.0.2.2:8000/images/offers";
  static const String CATEGORY_IMAGE_PATH = "http://10.0.2.2:8000/images/";
  static const String SELLER_IMAGE_PATH = "http://10.0.2.2:8000/images/sellers";

  ///////////////// PREFERENCE KEYS ////////////////////////
  static const String PREF_USER_TOKEN_KEY = "user_token_key";
  static const String AUTHORIZATION_BEARER_HEADER = "Bearer";

  ///////////////// JSON OBJECT KEYS ///////////////////////

  static const String SUCCESS = "success";
  static const String TOKEN = "token";
  static const String CUSTOMER = "customer";
  static const String SELLER = "seller";
  static const String OFFER = "offer";
  static const String OFFERS = "offers";
  static const String CATEGORIES = "categories";
  static const String NUMBERS_OF_CUSTOMERS = "numbers_of_customers";
  static const String NUMBERS_OF_SELLERS = "numbers_of_sellers";
  static const String NUMBERS_OF_OFFERS = "numbers_of_offers";
  static const String BEST_OFFER = "best_offer";
  static const String BEST_SELLER = "best_seller";

  static const String ID = "id";
  static const String NAME = "name";
  static const String EMAIL = "email";
  static const String PASSWORD = "password";
  static const String PHONE = "phone";
  static const String STATS = "stats";
  static const String PHOTO = "photo";
  static const String RATE = "rate";
  static const String SEARCH = "search";
  static const String SELLER_ID = "seller_id";
  static const String OFFER_ID = "offer_id";
  static const String CATEGORY_ID = "category_id";
  static const String MESSAGE = "message";
  static const String KEYWORD = "keyword";
  static const String KEYWORDS = "keywords";
  static const String DESCRIPTION = "description";
  static const String PRICE_BEFORE = "priceBefore";
  static const String PRICE_AFTER = "priceAfter";
  static const String WEBSITE = "website";
  static const String CALORIES = "calories";
  static const String DATE_START = "dateStart";
  static const String DATE_END = "dateEnd";
  static const String BARCODE = "barCode";

}