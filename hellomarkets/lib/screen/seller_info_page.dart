import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';
import '../theme/app_color.dart';
import '../blocs/data_bloc.dart';
import '../blocs/model/seller.dart';
import '../util/constants.dart';

DataBloc dataBloc;

class SellerInfoPage extends StatefulWidget {

  int sellerId;

  SellerInfoPage(this.sellerId);

  @override
  _SellerInfoPageState createState() => _SellerInfoPageState();
}

class _SellerInfoPageState extends State<SellerInfoPage> {

  double screenWidth, screenHeight;
  String flag;
  double rating = 0;
  Seller seller;
  bool isRating = false;

  getSeller() async {
    setState(() {
      flag = "fetching";
    });
    seller = await dataBloc.getSeller(sellerId: widget.sellerId);
    if(seller == null){
      setState(() {
        flag = "unavailable";
      });
    } else {
      setState(() {
        flag = "available";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dataBloc = new DataBloc();
    getSeller();
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        automaticallyImplyLeading: true,
        title: Text("Seller Info"),
      ),
      body: bodyContent()
    );
  }

  Widget bodyContent() {
    return Stack(
      children: <Widget>[
        Visibility(
          visible: flag == "fetching",
          child: Center(
            child: Image.asset("assets/images/loading.gif", width: 200, height: 200),
          ),
        ),
        Visibility(
          visible: flag == "unavailable",
          child: Center(
            child: Text("No seller info", style: TextStyle(color: greyColor, fontSize: screenWidth * 0.07, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          ),
        ),
        Visibility(
          visible: flag == "available",
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05, top: screenHeight * 0.05),
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle
                    ),
                    child: seller == null ? null : seller.photo == null
                        ? Image.asset("assets/images/default_user_avatar.png", fit: BoxFit.contain)
                        : CachedNetworkImage(
                            imageUrl: "${Constants.OFFER_IMAGE_PATH}/${seller.photo}",
                            fadeInDuration: Duration(milliseconds: 300),
                            fadeOutDuration: Duration(milliseconds: 300),
                            placeholder: (context, url) => Image.asset("assets/images/loading.gif", width: 100, height: 100),
                            fit: BoxFit.contain,
                            placeholderFadeInDuration: Duration(milliseconds: 300),
                          ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      starRatingView(seller == null ? 0 : seller.rate),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Name : ", style: TextStyle(color: blueColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                      Text(seller == null ? "" : seller.name, style: TextStyle(color: blackColor, fontSize: screenWidth * 0.04))
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Email : ", style: TextStyle(color: blueColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                      Text(seller == null ? "" : seller.email, style: TextStyle(color: blackColor, fontSize: screenWidth * 0.04))
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Phone Number : ", style: TextStyle(color: blueColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                      Text(seller == null ? "" : seller.phone, style: TextStyle(color: blackColor, fontSize: screenWidth * 0.04))
                    ],
                  ),
                  SizedBox(height: 30),
                  SmoothStarRating(
                      allowHalfRating: false,
                      onRatingChanged: (v) {
                        setState(() {
                          rating = v;
                        });
                      },
                      starCount: 5,
                      rating: rating,
                      size: screenWidth * 0.1,
                      color: blueLightColor,
                      borderColor: blueLightColor,
                      spacing: 0.0
                  ),
                  SizedBox(height: 40),
                  Visibility(
                    visible: !isRating,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () async {

                        setState(() {
                          isRating = true;
                        });

                        bool isRateSuccessed = await dataBloc.rateSeller(sellerId: widget.sellerId, rate: rating.toInt());
                        if(isRateSuccessed){
                          Toast.show("Rated this seller successfully!", context);
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            isRating = false;
                          });
                          Toast.show("Failed rating!", context);
                        }
                      },
                      child: Container(
                        width: screenWidth * 0.5,
                        height: 40,
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Center(
                          child: Text("Rate seller", style: TextStyle(color: whiteColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    replacement: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget starRatingView(int rate) {
    switch(rate){
      case 0:
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  )
                ],
              ),
            ),
          ],
        );
      case 1:
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  )
                ],
              ),
            ),
          ],
        );
      case 2:
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  )
                ],
              ),
            ),
          ],
        );
      case 3:
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  )
                ],
              ),
            ),
          ],
        );
      case 4:
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star_border,
                    color: darkBlueColor,
                  )
                ],
              ),
            ),
          ],
        );
      case 5:
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  ),
                  Icon(
                    Icons.star,
                    color: darkBlueColor,
                  )
                ],
              ),
            ),
          ],
        );
      default:
        return null;
    }
  }
}
