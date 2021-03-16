import 'package:flutter/material.dart';
import '../blocs/data_bloc.dart';
import '../blocs/model/offer.dart';
import '../blocs/model/category.dart' as cat;
import '../theme/app_color.dart';
import '../util/global.dart';
import '../util/offer_grid_view.dart';
import 'search_offer_page.dart';

DataBloc bloc;

class OfferViewPage extends StatefulWidget {

  cat.Category category;

  OfferViewPage(this.category);

  @override
  _OfferViewPageState createState() => _OfferViewPageState();
}

class _OfferViewPageState extends State<OfferViewPage> {

  double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    bloc = new DataBloc();
    bloc.getCustomerOffers(categoryId: widget.category.id);
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        title: Text(widget.category.name, style: TextStyle(color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: whiteColor),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchOfferPage(categoryId: widget.category.id)));
            },
          )
        ],
      ),
      body: StreamBuilder<List<Offer>>(
        stream: bloc.offers,
        builder: (context, AsyncSnapshot<List<Offer>> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new OfferGridView(offerList: snapshot.data, dataBloc: bloc)
              : Center(child: Image.asset("assets/images/loading.gif"));
        },
      ),
    );
  }
}
