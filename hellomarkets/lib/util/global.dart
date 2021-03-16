import '../blocs/model/seller.dart';
import '../blocs/model/customer.dart';

class GlobalValue {
  static String token;
  static String userType;
  static Seller seller;
  static Customer customer;

  static set setToken(String token) {
    GlobalValue.token = token;
  }

  static String get getToken => GlobalValue.token;

  static set setUserType(String type) {
    GlobalValue.userType = type;
  }

  static String get getUserType => GlobalValue.userType;

  static set setSeller(Seller seller){
    GlobalValue.seller = seller;
  }

  static Seller get getSeller => GlobalValue.seller;

  static set setCustomer(Customer customer){
    GlobalValue.customer = customer;
  }

  static Customer get getCustomer => GlobalValue.customer;
}