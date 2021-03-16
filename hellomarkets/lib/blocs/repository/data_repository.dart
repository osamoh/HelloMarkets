import 'package:meta/meta.dart';
import '../client/api_client.dart';
import '../model/category.dart';
import '../model/offer.dart';
import '../model/customer.dart';
import '../model/seller.dart';
import '../model/stats.dart';

class DataRepository {
  final ApiClient apiClient = new ApiClient();

  Future<Map<String, dynamic>> login({@required String userType, @required String email, @required String password}) async => await apiClient.login(userType: userType, email: email, password: password);

  Future<bool> register({@required String name, @required String email, @required String phone, @required String password}) async => await apiClient.register(name: name, email: email, phone: phone, password: password);

  Future<bool> logout() async => await apiClient.logout();

  Future addOffer({@required Offer offer}) async {
    await apiClient.addOffer(offer: offer);
  }

  Future updateOffer({@required Offer offer}) async {
    await apiClient.updateOffer(offer: offer);
  }

  Future deleteOffer({@required Offer offer}) async {
    await apiClient.deleteOffer(offer: offer);
  }

  Future<bool> rateOffer({@required int offerId, @required int rate, @required String comment}) async {
    return await apiClient.rateOffer(offerId: offerId, rate: rate, comment: comment);
  }

  Future<bool> rateSeller({@required int sellerId, @required int rate}) async {
    return await apiClient.rateSeller(sellerId: sellerId, rate: rate);
  }

  Future<bool> saveOffer({@required int offerId}) async {
    return await apiClient.saveOffer(offerId: offerId);
  }

  Future<List<Offer>> getSavedOffers() async {
    return await apiClient.getSavedOffers();
  }

  Future<bool> saveKeyword({@required String keyword}) async {
    return await apiClient.saveKeyword(keyword: keyword);
  }

  Future<List<String>> getSavedKeywords() async {
    return await apiClient.getSavedKeywords();
  }

  Future<List<Category>> getAllCategories() async {
    return await apiClient.getAllCategories();
  }

  Future<List<Offer>> getCustomerOffers({String searchWord, int categoryId}) async {
    return await apiClient.getCustomerOffers(categoryId: categoryId, searchWord: searchWord);
  }

  Future<List<Offer>> getSellerOffers({String searchWord, int sellerId}) async {
    return await apiClient.getSellerOffers(searchWord: searchWord, sellerId: sellerId);
  }

  Future<List<Offer>> getSimilarOffers({@required int offerId}) async {
    return await apiClient.getSimilarOffers(offerId: offerId);
  }

  Future<Seller> getSeller({@required int sellerId}) async {
    return await apiClient.getSeller(sellerId: sellerId);
  }

  Future<Stats> getStats() async => await apiClient.getStats();

  Future<int> updateCustomer({@required Customer customer}) async => await apiClient.updateCustomer(customer: customer);

  Future<int> deleteCustomer() async => await apiClient.deleteCustomer();

  Future<bool> sendMessage({@required String message}) async => await apiClient.sendMessage(message: message);
}