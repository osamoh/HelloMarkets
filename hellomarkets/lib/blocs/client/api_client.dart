import 'dart:convert';
import 'dart:io';

import 'package:hellomarkets/util/global.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import '../model/offer.dart';
import '../model/customer.dart';
import '../model/seller.dart';
import '../model/category.dart';
import '../model/stats.dart';
import '../../util/constants.dart';

class ApiClient {

  Future<Map<String, dynamic>> login({@required String userType, @required String email, @required String password}) async {
    Map map = {
      Constants.EMAIL : email,
      Constants.PASSWORD : password
    };
    var response =  await http.post(userType == "Customer" ? Constants.API_CUSTOMER_POST_LOGIN : Constants.API_SELLER_POST_LOGIN, body: utf8.encode(json.encode(map)), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
    });

    var result = jsonDecode(response.body);
    if(result[Constants.SUCCESS] == null){
      return null;
    } else {
      if(result[Constants.SUCCESS]){
        Map<String, dynamic> map = new Map();
        map["userToken"] = result[Constants.TOKEN];
        map["userInfo"] = userType == "Customer" ? Customer.fromJSON(result[Constants.CUSTOMER]) : Seller.fromJSON(result[Constants.SELLER]);
        return map;
      } else {
        return null;
      }
    }
  }

  Future<bool> register({@required String name, @required String email, @required String phone, @required String password}) async {
    Map map = {
      Constants.NAME : name,
      Constants.EMAIL : email,
      Constants.PHONE : phone,
      Constants.PASSWORD : password
    };
    var response = await http.post(Constants.API_CUSTOMER_POST_REGISTER, body: utf8.encode(json.encode(map)), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json"
    });

    var result = jsonDecode(response.body);
    return result[Constants.SUCCESS];
  }

  Future<bool> logout() async {
    var response = await http.post(GlobalValue.getUserType == "Customer" ? Constants.API_CUSTOMER_POST_LOGOUT : Constants.API_SELLER_POST_LOGOUT, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    });

    var result = jsonDecode(response.body);
    return result[Constants.SUCCESS];
  }

  Future<List<Category>> getAllCategories() async {
    List<Category> categories;
    var response =  await http.get(GlobalValue.getUserType == "Customer" ? Constants.API_CUSTOMER_GET_ALL_CATEGORIES : Constants.API_SELLER_GET_ALL_CATEGORIES, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.authorizationHeader: "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
      },
    );

    var jsonResult = jsonDecode(response.body);
    if(jsonResult[Constants.SUCCESS] == null){
      categories = new List();
    } else {
      if(jsonResult[Constants.SUCCESS]){
        print(jsonResult[Constants.CATEGORIES]);
        List<dynamic> jsons = jsonResult[Constants.CATEGORIES];
        categories = jsons.map((item) => Category.fromJSON(item)).toList();
      } else {
        categories = new List();
      }
    }

    return categories;
  }

  Future<List<Offer>> getCustomerOffers({String searchWord, int categoryId}) async {
    List<Offer> offers;
    var response = await http.get(
      searchWord == null && categoryId == null
          ? Constants.API_CUSTOMER_GET_ALL_OFFERS
          : (searchWord != null && categoryId == null ? "${Constants.API_CUSTOMER_GET_ALL_OFFERS}?${Constants.SEARCH}=$searchWord"
          : (searchWord == null && categoryId != null ? "${Constants.API_CUSTOMER_GET_ALL_OFFERS}?${Constants.SELLER_ID}=$categoryId"
          : "${Constants.API_CUSTOMER_GET_ALL_OFFERS}?${Constants.SEARCH}=$searchWord&${Constants.SELLER_ID}=$categoryId")),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.authorizationHeader: "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
      },
    );

    var jsonResult = jsonDecode(response.body);
    if(jsonResult[Constants.SUCCESS] == null){
      offers = new List();
    } else {
      if(jsonResult[Constants.SUCCESS]){
        print(jsonResult[Constants.OFFERS]);
        List<dynamic> jsonOffers = jsonResult[Constants.OFFERS];
        offers = jsonOffers.map((item) => Offer.fromJSON(item)).toList();
      } else {
        offers = new List();
      }
    }

    return offers;

  }

  Future<List<Offer>> getSellerOffers({String searchWord, int sellerId}) async {
    List<Offer> offers;
    var response =  await http.get(
      searchWord == null && sellerId == null
          ? Constants.API_SELLER_GET_HIS_OFFERS
          : (searchWord != null && sellerId == null ? "${Constants.API_SELLER_GET_HIS_OFFERS}?${Constants.SEARCH}=$searchWord"
          : (searchWord == null && sellerId != null ? "${Constants.API_SELLER_GET_HIS_OFFERS}?${Constants.SELLER_ID}=$sellerId"
          : "${Constants.API_SELLER_GET_HIS_OFFERS}?${Constants.SEARCH}=$searchWord&${Constants.SELLER_ID}=$sellerId")),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.authorizationHeader: "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
      },
    );

    var jsonResult = jsonDecode(response.body);
    if(jsonResult[Constants.SUCCESS] == null){
      offers = new List();
    } else {
      if(jsonResult[Constants.SUCCESS]){
        print(jsonResult[Constants.OFFERS]);
        List<dynamic> jsonOffers = jsonResult[Constants.OFFERS];
        offers = jsonOffers.map((item) => Offer.fromJSON(item)).toList();
      } else {
        offers = new List();
      }
    }

    return offers;

  }

  Future<List<Offer>> getSimilarOffers({@required int offerId}) async {

    var response = await http.get("${Constants.API_CUSTOMER_GET_SIMILAR_OFFERS}/$offerId", headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    });

    var result = jsonDecode(response.body);
    List<Offer> offers = new List();
    if(result[Constants.SUCCESS]){
      List<dynamic> jsonOffers = result[Constants.OFFERS];
      offers = jsonOffers.map((item) => Offer.fromJSON(item)).toList();
      return offers;
    } else {
      return null;
    }

  }

  Future<Seller> getSeller({@required int sellerId}) async {
    var response = await http.get("${Constants.API_CUSTOMER_GET_SELLER}/$sellerId", headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    });

    var result = jsonDecode(response.body);
    if(result[Constants.SUCCESS]){
      return Seller.fromJSON(result[Constants.SELLER]);
    } else {
      return null;
    }
  }

  Future<void> addOffer({@required Offer offer}) async {
     await http.post(Constants.API_SELLER_POST_ADD_OFFER, headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    }, body: utf8.encode(json.encode(offer.toMap())));

    await Future.delayed(Duration(seconds: 1));
  }
  
  Future<void> updateOffer({@required Offer offer}) async {
    var response = await http.put("${Constants.API_SELLER_PUT_EDIT_OFFER}/${offer.id}", headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    }, body: utf8.encode(json.encode(offer.toMap())));

    print(response.body);

    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> deleteOffer({@required Offer offer}) async {
    await http.delete("${Constants.API_SELLER_DEL_DELETE_OFFER}/${offer.id}", headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    });

    await Future.delayed(Duration(seconds: 1));
  }

  Future<bool> rateOffer({@required int offerId, @required int rate, @required String comment}) async {
    Map map = {
      Constants.MESSAGE : comment,
      Constants.RATE : rate,
      Constants.OFFER_ID : offerId
    };

    var response = await http.post(Constants.API_CUSTOMER_POST_RATE_OFFER, headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    }, body: utf8.encode(json.encode(map)));

    var result = jsonDecode(response.body);
    return result[Constants.SUCCESS] != null;
  }

  Future<bool> rateSeller({@required int sellerId, @required int rate}) async {
    Map map = {
      Constants.RATE : rate,
      Constants.SELLER_ID : sellerId
    };

    var response = await http.post(Constants.API_CUSTOMER_POST_RATE_SELLER, headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    }, body: utf8.encode(json.encode(map)));

    var result = jsonDecode(response.body);
    return result[Constants.SUCCESS] != null;

  }

  Future<bool> saveOffer({@required int offerId}) async {
    Map map = {
      Constants.OFFER_ID : offerId
    };

    var response = await http.post(Constants.API_CUSTOMER_POST_SAVE_OFFER, headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    }, body: utf8.encode(json.encode(map)));

    var result = jsonDecode(response.body);
    return result[Constants.SUCCESS];
  }

  Future<bool> saveKeyword({@required String keyword}) async {
    Map map = {
      Constants.KEYWORD : keyword
    };

    var response = await http.post(Constants.API_CUSTOMER_POST_SAVE_KEYWORD, headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    }, body: utf8.encode(json.encode(map)));

    var result = jsonDecode(response.body);
    return result[Constants.SUCCESS];
  }

  Future<List<Offer>> getSavedOffers() async {
    var response = await http.get(Constants.API_CUSTOMER_GET_SAVED_OFFERS, headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    });

    var result = jsonDecode(response.body);
    List<Offer> offers = new List();
    if(result[Constants.SUCCESS]){
      List<dynamic> jsonOffers = result[Constants.OFFERS];
      offers = jsonOffers.map((item) => Offer.fromJSON(item)).toList();
      return offers;
    } else {
      return null;
    }
  }

  Future<List<String>> getSavedKeywords() async {
    var response = await http.get(Constants.API_CUSTOMER_GET_SAVED_KEYWORDS, headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    });

    var result = jsonDecode(response.body);
    List<String> keywords = new List();
    if(result[Constants.SUCCESS]){
      List<dynamic> jsonKeywords = result[Constants.KEYWORDS];
      for(Map<String, dynamic> map in jsonKeywords){
        keywords.add(map[Constants.KEYWORD]);
      }
      return keywords;
    } else {
      return null;
    }
  }

  Future<Stats> getStats() async {
    var response = await http.get(GlobalValue.getUserType == "Customer" ? Constants.API_CUSTOMER_GET_STATISTICS : Constants.API_SELLER_GET_STATISTICS, headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    });

    await Future.delayed(Duration(seconds: 1));

    var result = jsonDecode(response.body);
    if(result[Constants.SUCCESS] == null){
      return null;
    } else {
      if(result[Constants.SUCCESS]){
        try {
          int customerNum = result[Constants.STATS][Constants.NUMBERS_OF_CUSTOMERS];
          int sellerNum = result[Constants.STATS][Constants.NUMBERS_OF_SELLERS];
          int offerNum = result[Constants.STATS][Constants.NUMBERS_OF_OFFERS];
          Offer offer = Offer.fromJSON(result[Constants.STATS][Constants.BEST_OFFER][Constants.OFFER]);
          Seller seller = Seller.fromJSON(result[Constants.STATS][Constants.BEST_SELLER][Constants.SELLER]);
          return Stats(customerNum: customerNum, sellerNum: sellerNum, offerNum: offerNum, bestOffer: offer, bestSeller: seller);
        } catch (e) {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  Future<int> updateCustomer({@required Customer customer}) async {
    var response = await http.put(Constants.API_CUSTOMER_PUT_UPDATE, headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    }, body: utf8.encode(json.encode(customer.toMap())));

    await Future.delayed(Duration(seconds: 1));

    var result = jsonDecode(response.body);
    return result[Constants.SUCCESS];
  }

  Future<int> deleteCustomer() async {
    var response = await http.put(Constants.API_CUSTOMER_DEL_DELETE, headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    });

    await Future.delayed(Duration(seconds: 1));

    var result = jsonDecode(response.body);
    return result[Constants.SUCCESS];
  }

  Future<bool> sendMessage({@required String message}) async {
    Map map = {
      Constants.MESSAGE : message
    };
    var response = await http.post(GlobalValue.getUserType == "Customer" ? Constants.API_CUSTOMER_POST_CONTACT_US : Constants.API_SELLER_POST_CONTACT_US, headers: {
      HttpHeaders.contentTypeHeader : "application/json",
      HttpHeaders.acceptHeader : "application/json",
      HttpHeaders.authorizationHeader : "${Constants.AUTHORIZATION_BEARER_HEADER} ${GlobalValue.getToken}"
    }, body: utf8.encode(json.encode(map)));

    var result = jsonDecode(response.body);
    return result[Constants.SUCCESS];
  }

}