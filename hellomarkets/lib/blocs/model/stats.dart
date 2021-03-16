import '../model/offer.dart';
import '../model/seller.dart';
import '../../util/constants.dart';

class Stats {
  int customerNum;
  int sellerNum;
  int offerNum;
  Offer bestOffer;
  Seller bestSeller;

  Stats({this.customerNum, this.sellerNum, this.offerNum, this.bestOffer, this.bestSeller});

  factory Stats.fromJSON(Map<String, dynamic> map) => Stats(
    customerNum: map[Constants.NUMBERS_OF_CUSTOMERS],
    sellerNum: map[Constants.NUMBERS_OF_SELLERS],
    offerNum: map[Constants.NUMBERS_OF_OFFERS],
    bestOffer: map[Constants.BEST_OFFER],
    bestSeller: map[Constants.BEST_SELLER]
  );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map[Constants.NUMBERS_OF_CUSTOMERS] = customerNum;
    map[Constants.NUMBERS_OF_SELLERS] = sellerNum;
    map[Constants.NUMBERS_OF_OFFERS] = offerNum;
    map[Constants.BEST_OFFER] = bestOffer;
    map[Constants.BEST_SELLER] = bestSeller;
    return map;
  }
}