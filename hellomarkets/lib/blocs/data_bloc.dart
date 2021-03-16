import 'dart:async';
import 'package:meta/meta.dart';
import '../blocs/repository/data_repository.dart';
import '../blocs/model/category.dart';
import '../blocs/model/offer.dart';
import '../blocs/model/stats.dart';
import '../blocs/model/customer.dart';
import '../blocs/model/seller.dart';

class DataBloc {
  String searchWord;
  int sellerId;

  final dataRepository = new DataRepository();

  StreamController<List<Offer>> _offersController = StreamController<List<Offer>>.broadcast();
  Stream<List<Offer>> get offers => _offersController.stream;

  StreamController<List<String>> _keywordsController = StreamController<List<String>>.broadcast();
  Stream<List<String>> get keywords => _keywordsController.stream;

  Future<Map<String, dynamic>> login({@required String userType, @required String email, @required String password}) async => await dataRepository.login(userType: userType, email: email, password: password);

  Future<bool> register({@required String name, @required String email, @required String phone, @required String password}) async => await dataRepository.register(name: name, email: email, phone: phone, password: password);

  Future<bool> logout() async => await dataRepository.logout();

  addOffer({@required Offer offer}) async {
    await dataRepository.addOffer(offer: offer);
    getSellerOffers();
  }

  Future<List<Category>> getAllCategories() async {
    return dataRepository.getAllCategories();
  }

  Future<List<Offer>> getCustomerOffers({String searchWord, int categoryId}) async {
    List<Offer> offerList = await dataRepository.getCustomerOffers(searchWord: searchWord, categoryId: categoryId);
    _offersController.sink.add(offerList);
    return offerList;
  }

  Future<List<Offer>> getSellerOffers({String searchWord, int sellerId}) async {
    List<Offer> offerList = await dataRepository.getSellerOffers(searchWord: searchWord, sellerId: sellerId);
    _offersController.sink.add(offerList);
    return offerList;
  }

  Future<List<Offer>> getSimilarOffers({@required int offerId}) async {
    return await dataRepository.getSimilarOffers(offerId: offerId);
  }

  Future<Seller> getSeller({@required int sellerId}) async {
    return await dataRepository.getSeller(sellerId: sellerId);
  }

  updateOffer({@required Offer offer}) async {
    await dataRepository.updateOffer(offer: offer);
    getSellerOffers();
  }

  deleteOffer({@required Offer offer}) async {
    await dataRepository.deleteOffer(offer: offer);
    getSellerOffers();
  }

  Future<bool> rateOffer({@required int offerId, @required int rate, @required String comment}) async {
    return await dataRepository.rateOffer(offerId: offerId, rate: rate, comment: comment);
  }

  Future<bool> rateSeller({@required int sellerId, @required int rate}) async {
    return await dataRepository.rateSeller(sellerId: sellerId, rate: rate);
  }

  Future<bool> saveOffer({@required int offerId}) async {
    return await dataRepository.saveOffer(offerId: offerId);
  }

  Future<List<Offer>> getSavedOffers() async {
    return await dataRepository.getSavedOffers();
  }

  Future<bool> saveKeyword({@required String keyword}) async {
    bool success = await dataRepository.saveKeyword(keyword: keyword);
    getSavedKeywords();
    return success;
  }

  Future<List<String>> getSavedKeywords() async {
    List<String> keywords = await dataRepository.getSavedKeywords();
    _keywordsController.sink.add(keywords);
    return keywords;
  }

  Future<Stats> getStats() async => await dataRepository.getStats();

  Future<int> updateCustomer({@required Customer customer}) async => await dataRepository.updateCustomer(customer: customer);

  Future<int> deleteCustomer() async => await dataRepository.deleteCustomer();

  Future<bool> sendMessage({@required String message}) async => await dataRepository.sendMessage(message: message);

  dispose() {
    _offersController.close();
    _keywordsController.close();
  }
}