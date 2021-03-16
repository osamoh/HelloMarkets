import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hellomarkets/screen/seller_info_page.dart';
import 'package:share/share.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/model/offer.dart';
import '../blocs/model/seller.dart';
import '../blocs/data_bloc.dart';
import '../theme/app_color.dart';
import '../util/constants.dart';

DataBloc dataBloc;

class DetailOfferPage extends StatefulWidget {

  Offer offer;

  DetailOfferPage(this.offer);

  @override
  _DetailOfferPageState createState() => _DetailOfferPageState();
}

class _DetailOfferPageState extends State<DetailOfferPage> {

  double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    dataBloc = new DataBloc();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border, color: whiteColor),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  content: Text("Do you want to save this offer as favorite?", style: TextStyle(color: darkBlueColor, fontSize: screenWidth * 0.05)),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("No", style: TextStyle(color: blackColor))
                    ),
                    FlatButton(
                      onPressed: () async {
                        bool isSavedOffer = await dataBloc.saveOffer(offerId: widget.offer.id);
                        if(isSavedOffer){
                          Toast.show("Saved this offer as favorite!", context);
                          Navigator.pop(context);
                        } else {
                          Toast.show("Failed saving this offer as favorite!", context);
                        }
                      },
                      child: Text("Yes", style: TextStyle(color: blueColor)),
                    )
                  ],
                )
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.stars, color: whiteColor),
            onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: CustomRatingDialog(widget.offer.id),
                );
              }
            ),
          ),
          IconButton(
            icon: Icon(Icons.share, color: whiteColor),
            onPressed: () async {
              if(widget.offer.website.contains("http://") || widget.offer.website.contains("https://")){
                final RenderBox box = context.findRenderObject();
                Share.share(widget.offer.website,
                    sharePositionOrigin:
                    box.localToGlobal(Offset.zero) &
                    box.size);
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      content: Text("There is no sharing link"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Ok", style: TextStyle(color: blueColor))
                        )
                      ],
                    );
                  }
                );
              }
            }
          )
        ],
        title: Text(widget.offer.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              buildCard(),
              buildSellerInfo(),
              buildDescription(),
              buildWebsite(),
              buildDate(),
              buildSimilarOffers(widget.offer.id)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard() {
    return Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.5,
        decoration: BoxDecoration(
          color: Color(0xffdddddd),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: CachedNetworkImage(
                  imageUrl: "${Constants.OFFER_IMAGE_PATH}/${widget.offer.photo}",
                  width: screenWidth - 80,
                  fadeInDuration: Duration(milliseconds: 300),
                  fadeOutDuration: Duration(milliseconds: 300),
                  placeholder: (context, url) => Image.asset("assets/images/loading.gif", width: 100, height: 100),
                  fit: BoxFit.scaleDown,
                  placeholderFadeInDuration: Duration(milliseconds: 300),
                ),
                padding: EdgeInsets.all(20),
              ),
              flex: 6,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child: Text("\$${widget.offer.priceAfter}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white)),
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xff36004f),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            SizedBox(width: 10),
                            Text("SAR ${widget.offer.priceBefore}", style: TextStyle(color: blackColor.withAlpha(0x80), decoration: TextDecoration.lineThrough))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: starRatingView(widget.offer.rate),
                  ),
                ],
              ),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget buildSellerInfo() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            color: whiteColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SellerInfoPage(widget.offer.sellerId)));
            },
            child: Text("See seller info", style: TextStyle(color: blueColor, fontSize: screenWidth * 0.03, decoration: TextDecoration.underline)),
          )
        ],
      ),
    );
  }

  Widget buildDescription() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Description", style: TextStyle(color: darkBlueColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          SizedBox(height: 5),
          Text(widget.offer.description)
        ],
      ),
    );
  }

  Widget buildWebsite() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Website", style: TextStyle(color: darkBlueColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          SizedBox(height: 5),
          Visibility(
            visible: widget.offer.website != "" && (widget.offer.website.contains("http://") || widget.offer.website.contains("https://")),
            child: GestureDetector(
              child: Text(widget.offer.website, style: TextStyle(color: blueColor, fontSize: screenWidth * 0.03, decoration: TextDecoration.underline)),
              onTap: () async {
                if(await canLaunch(widget.offer.website)){
                  await launch(Uri.encodeFull(widget.offer.website));
                } else {
                  throw 'Could not launch this url!';
                }
              },
            ),
            replacement: Text("Coming soon..", style: TextStyle(color: greyColor, fontSize: screenWidth * 0.03)),
          )
        ],
      ),
    );
  }

  Widget buildDate() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Date", style: TextStyle(color: darkBlueColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          SizedBox(height: 5),
          Text("${widget.offer.dateStart} ~ ${widget.offer.dateEnd}", style: TextStyle(color: blueColor, fontSize: screenWidth * 0.03, decoration: TextDecoration.underline))
        ],
      ),
    );
  }

  Widget buildSimilarOffers(int offerId) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Similar offers", style: TextStyle(color: darkBlueColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          FutureBuilder(
            future: dataBloc.getSimilarOffers(offerId: offerId),
            builder: (context, AsyncSnapshot<List<Offer>> snapshot) {

              if(snapshot.hasError) print(snapshot.error);

              return snapshot.hasData && snapshot.data.length != 0 ? Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  addAutomaticKeepAlives: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {

                    Offer similarOffer = snapshot.data[index];

                    return InkWell(
                      onTap: () {},
                      child: Container(
                        width: screenWidth * 0.3,
                        child: Card(
                          elevation: 1.5,
                          child: new Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: "${Constants.OFFER_IMAGE_PATH}/${similarOffer.photo}",
                                    width: 70,
                                    height: 120,
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
                                      new Text(similarOffer.name, style: TextStyle(color: blackColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                                      new Text(similarOffer.description, style: TextStyle(color: blackColor.withAlpha(0x80), fontSize: screenWidth * 0.03)),
                                      new Text("SAR ${similarOffer.priceAfter}", style: TextStyle(color: darkBlueColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                    );
                  }
                )
              ) : Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.3,
                child: Center(
                  child: Text("No any similar offer", style: TextStyle(color: greyColor, fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),
                ),
              );
            }
          ),
        ],
      ),
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

class CustomRatingDialog extends StatefulWidget {

  int offerId;

  CustomRatingDialog(this.offerId);

  @override
  _CustomRatingDialogState createState() => _CustomRatingDialogState();
}

class _CustomRatingDialogState extends State<CustomRatingDialog> {

  double screenWidth, screenHeight;
  double rating = 0;
  TextEditingController commentCT;
  bool isRating = false;

  @override
  void initState() {
    super.initState();
    commentCT = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 20),
          Text("Rating this offer", style: TextStyle(color: darkBlueColor, fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),
          SizedBox(height: screenHeight * 0.05),
          SmoothStarRating(
            allowHalfRating: false,
            onRatingChanged: (v) {
              setState(() {
                rating = v;
              });
            },
            starCount: 5,
            rating: rating,
            size: 35.0,
            color: blueLightColor,
            borderColor: blueLightColor,
            spacing: 0.0
          ),
          SizedBox(height: screenHeight * 0.05),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: commentCT,
              decoration: InputDecoration(
                filled: true,
                fillColor: greyColor.withAlpha(0x30),
                hintText: "Add a comment",
                hintStyle: TextStyle(color: blackColor.withAlpha(0x80), fontSize: screenWidth * 0.03),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none
                )
              ),
              maxLines: 2,
              style: TextStyle(color: darkBlueColor, fontSize: screenWidth * 0.04),
            ),
          ),
          SizedBox(height: screenHeight * 0.07),
          Visibility(
            visible: !isRating,
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () async {
                if(commentCT.text.isEmpty){
                  Toast.show("Enter a comment!", context);
                  return;
                }

                setState(() {
                  isRating = true;
                });

                bool isRateSuccessed = await dataBloc.rateOffer(offerId: widget.offerId, rate: rating.toInt(), comment: commentCT.text);
                if(isRateSuccessed){
                  Toast.show("Rated this offer successfully!", context);
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
                  child: Text("Submit", style: TextStyle(color: whiteColor, fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            replacement: CircularProgressIndicator(),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}

