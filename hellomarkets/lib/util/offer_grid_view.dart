import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../screen/add_offer_page.dart';
import '../screen/detail_offer_page.dart';
import '../theme/app_color.dart';
import '../blocs/data_bloc.dart';
import '../blocs/model/offer.dart';
import '../util/constants.dart';
import '../util/global.dart';

class OfferGridView extends StatelessWidget {
  final List<Offer> offerList;
  final DataBloc dataBloc;
  double screenWidth, screenHeight;

  OfferGridView({Key key, this.offerList, this.dataBloc}) : super(key: key);

  Widget gridItem(BuildContext context, Offer offer) {
    String img = "${Constants.OFFER_IMAGE_PATH}/${offer.photo}";
    return InkWell(
      onLongPress: GlobalValue.getUserType == "Seller" ? () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Choose an action what you want", style: TextStyle(color: darkBlueColor, fontSize: 15)),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete, color: redColor),
                  tooltip: "Delete",
                  onPressed: () {
                    dataBloc.deleteOffer(offer: offer);
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: blueColor),
                  tooltip: "Edit",
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddOfferPage(offer: offer)));
                  },
                )
              ],
            );
          }
        );
      } : null,
      onTap: GlobalValue.getUserType == "Customer" ? () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailOfferPage(offer)));
      } : null,
      child: Card(
          elevation: 1.5,
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: img,
                    width: 100,
                    height: 150,
                    fadeInDuration: Duration(milliseconds: 300),
                    fadeOutDuration: Duration(milliseconds: 300),
                    placeholder: (context, url) => Image.asset("assets/images/loading.gif", width: 100, height: 100),
                    fit: BoxFit.scaleDown,
                    placeholderFadeInDuration: Duration(milliseconds: 300),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(offer.name, style: TextStyle(color: blackColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                      new Text(offer.description, style: TextStyle(color: blackColor.withAlpha(0x80), fontSize: screenWidth * 0.03)),
                      new Text("SAR ${offer.priceAfter}", style: TextStyle(color: darkBlueColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          GridView.count(
            shrinkWrap: true,
            primary: true,
            crossAxisCount: 2,
            childAspectRatio: 0.80,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(offerList.length, (index) {
              return gridItem(context, offerList[index]);
            }),
          ),
        ],
      ),
    );
  }
}
