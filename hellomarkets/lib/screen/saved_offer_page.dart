import 'package:flutter/material.dart';
import '../blocs/model/offer.dart';
import '../blocs/data_bloc.dart';
import '../util/offer_grid_view.dart';
import '../theme/app_color.dart';

class SavedOfferPage extends StatelessWidget {

  DataBloc dataBloc;

  SavedOfferPage(this.dataBloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: darkBlueColor,
        title: Text("Saved Offers"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: FutureBuilder<List<Offer>>(
          future: dataBloc.getSavedOffers(),
          builder: (context, AsyncSnapshot<List<Offer>> snapshot) {
            if(snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new OfferGridView(offerList: snapshot.data, dataBloc: dataBloc)
                : Center(child: Image.asset("assets/images/loading.gif"));
          },
        ),
      ),
    );
  }
}
