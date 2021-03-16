import 'package:flutter/material.dart';
import '../theme/app_color.dart';
import '../blocs/data_bloc.dart';
import '../blocs/model/offer.dart';
import '../util/offer_grid_view.dart';
import '../util/global.dart';

DataBloc dataBloc;

class SearchOfferPage extends StatefulWidget {

  int categoryId;

  SearchOfferPage({this.categoryId});

  @override
  _SearchOfferPageState createState() => _SearchOfferPageState();
}

class _SearchOfferPageState extends State<SearchOfferPage> {

  double screenWidth, screenHeight;

  Widget appBarTitle = new Text("Search Offers", style: TextStyle(color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold));
  Icon actionIcon = new Icon(Icons.search, color: whiteColor);
  TextEditingController _searchController = new TextEditingController();
  bool isSearching;
  String _searchText;

  _SearchOfferPageState() {
    _searchController.addListener((){
      if(_searchController.text.isEmpty){
        setState(() {
          isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          isSearching = true;
          _searchText = _searchController.text;
        });
      }
      if(GlobalValue.getUserType == "Customer"){
        dataBloc.getCustomerOffers(searchWord: _searchText, categoryId: widget.categoryId);
      } else {
        dataBloc.getSellerOffers(searchWord: _searchText);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isSearching = false;
  }

  @override
  Widget build(BuildContext context) {

    dataBloc = new DataBloc();
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: appBarTitle,
        backgroundColor: darkBlueColor,
        elevation: 5,
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if(this.actionIcon.icon == Icons.search){
                  this.actionIcon = new Icon(Icons.close, color: whiteColor);
                  this.appBarTitle = new TextField(
                    controller: _searchController,
                    style: new TextStyle(
                      color: whiteColor
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: whiteColor),
                      hintText: "Search...",
                      hintStyle: TextStyle(color: greyColor)
                    ),
                  );
                  isSearching = true;
                } else {
                  this.actionIcon = new Icon(Icons.search, color: whiteColor);
                  this.appBarTitle = new Text("Search Offer", style: TextStyle(color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold));
                  isSearching = false;
                  _searchController.clear();
                }
              });
            }
          )
        ],
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: whiteColor,
        child: FutureBuilder<List<Offer>>(
          future: GlobalValue.getUserType == "Customer" ? dataBloc.getCustomerOffers(searchWord: _searchText, categoryId: widget.categoryId) : dataBloc.getSellerOffers(searchWord: _searchText),
          builder: (context, AsyncSnapshot<List<Offer>> snapshot) {
            if(snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new OfferGridView(offerList: snapshot.data)
                : Center(child: Image.asset("assets/images/loading.gif"));
          },
        ),
      ),
    );
  }
}
