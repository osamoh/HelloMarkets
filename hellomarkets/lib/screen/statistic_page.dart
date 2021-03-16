import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import '../theme/app_color.dart';
import '../blocs/data_bloc.dart';
import '../blocs/model/stats.dart';
import '../blocs/model/offer.dart';
import '../blocs/model/seller.dart';
import '../util/global.dart';
import '../util/constants.dart';

DataBloc dataBloc;

class StatisticPage extends StatefulWidget {

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {

  double screenWidth, screenHeight;
  String flag;
  Stats stats;

  bool existCustomerNum, existSellerNum, existOfferNum, existBestOffer, existBestSeller;

  @override
  void initState() {
    super.initState();
    dataBloc = new DataBloc();
    getStats();
  }

  getStats() async {
    setState(() {
      flag = "fetching";
    });
    stats = await dataBloc.getStats();
    if(stats == null){
      setState(() {
        flag = "unavailable";
      });
    } else {
      setState(() {
        flag = "available";
        existCustomerNum = stats.customerNum != null;
        existSellerNum = stats.sellerNum != null;
        existOfferNum = stats.offerNum != null;
        existBestOffer = stats.bestOffer != null;
        existBestSeller = stats.bestSeller != null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        title: Text("Statistics"),
        elevation: 5,
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: <Widget>[
          Visibility(
            visible: flag == "fetching",
            child: Container(
              child: Center(
                child: Image.asset("assets/images/loading.gif", width: 100, height: 100),
              ),
            ),
          ),
          Visibility(
            visible: flag == "unavailable",
            child: Container(
              child: Center(
                child: Text("No any statistic data..", style: TextStyle(color: greyColor, fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
              ),
            )
          ),
          Visibility(
            visible: flag == "available",
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                width: screenWidth,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Visibility(
                        visible: GlobalValue.getUserType == "Seller",
                        child: Column(
                          children: <Widget>[
                            Text("Summary", style: TextStyle(color: blueColor, fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                border: TableBorder.all(color: greyColor),
                                children: [
                                  TableRow(
                                      decoration: BoxDecoration(
                                          color: Colors.green
                                      ),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Customers", style: TextStyle(color: whiteColor, fontSize: 15), textAlign: TextAlign.center),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Sellers", style: TextStyle(color: whiteColor, fontSize: 15), textAlign: TextAlign.center),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Offers", style: TextStyle(color: whiteColor, fontSize: 15), textAlign: TextAlign.center),
                                        )
                                      ]
                                  ),
                                  TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(stats == null ? "" : "${stats.customerNum}", textAlign: TextAlign.center),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(stats == null ? "" : "${stats.sellerNum}", textAlign: TextAlign.center),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(stats == null ? "" : "${stats.offerNum}", textAlign: TextAlign.center),
                                        )
                                      ]
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Text("Best Offers", style: TextStyle(color: blueColor, fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                      ),
                      Container(
                          width: screenWidth * 0.6,
                          height: 220,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              stats == null ? Image.asset("assets/images/default_user_avatar.png", width: 100, height: 100) : Image.network("${Constants.OFFER_IMAGE_PATH}/${stats.bestOffer.photo}", width: 100, height: 180),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(stats == null ? "" : stats.bestOffer.name, style: TextStyle(color: darkBlueColor, fontSize: 15)),
                                    Text(stats == null ? "" : stats.bestOffer.description, style: TextStyle(color: blueColor, fontSize: 13)),
                                    Text(stats == null ? "" : "${stats.bestOffer.priceAfter}", style: TextStyle(color: redColor, fontSize: 12))
                                  ],
                                ),
                              )
                            ],
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Text("Best Seller", style: TextStyle(color: blueColor, fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                      ),
                      Container(
                          width: screenWidth * 0.9,
                          height: 220,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              stats == null || stats.bestSeller.photo == null ? Image.asset("assets/images/default_product_image.png", width: 100, height: 180) : Image.network("${Constants.SELLER_IMAGE_PATH}/${stats.bestSeller.photo}", width: 100, height: 180),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(stats == null ? "" : stats.bestSeller.name, style: TextStyle(color: darkBlueColor, fontSize: 15)),
                                    Text(stats == null ? "" : stats.bestSeller.email, style: TextStyle(color: blueColor, fontSize: 13)),
                                    Text(stats == null ? "" : stats.bestSeller.phone, style: TextStyle(color: redColor, fontSize: 12))
                                  ],
                                ),
                              )
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
            )
          )
        ],
      )
    );
  }
}
