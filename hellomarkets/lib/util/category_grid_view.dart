import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../theme/app_color.dart';
import '../screen/offer_view_page.dart';
import '../blocs/data_bloc.dart';
import '../blocs/model/category.dart' as cat;
import '../util/constants.dart';

class CategoryGridView extends StatelessWidget {
  final List<cat.Category> categoryList;
  final DataBloc dataBloc;
  double screenWidth, screenHeight;

  CategoryGridView({Key key, this.categoryList, this.dataBloc}) : super(key: key);

  Widget gridItem(BuildContext context, cat.Category category) {
    String img = "${Constants.CATEGORY_IMAGE_PATH}/${category.photo}";
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => OfferViewPage(category)));
      },
      child: Card(
          elevation: 1.5,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          margin: EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: img,
                    width: double.infinity,
                    height: double.infinity,
                    fadeInDuration: Duration(milliseconds: 300),
                    fadeOutDuration: Duration(milliseconds: 300),
                    placeholder: (context, url) => Image.asset("assets/images/loading.gif", width: double.infinity, height: double.infinity),
                    fit: BoxFit.fill,
                    placeholderFadeInDuration: Duration(milliseconds: 300),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1],
                      colors: [greyColor.withAlpha(0xee), greyColor.withAlpha(0xdd), greyColor.withAlpha(0xcc), greyColor.withAlpha(0xbb),
                          greyColor.withAlpha(0xaa), greyColor.withAlpha(0x99), greyColor.withAlpha(0x88), greyColor.withAlpha(0x77),
                          greyColor.withAlpha(0x66), greyColor.withAlpha(0x55)]
                    )
                  ),
                  child: Text(category.name, style: TextStyle(color: whiteColor, fontSize: screenWidth * 0.04), textAlign: TextAlign.center),
                )
              ],
            ),
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
            children: List.generate(categoryList.length, (index) {
              return gridItem(context, categoryList[index]);
            }),
          ),
        ],
      ),
    );
  }
}
