import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:toast/toast.dart';
import 'edit_profile_page.dart';
import 'add_offer_page.dart';
import 'login_page.dart';
import 'search_offer_page.dart';
import 'statistic_page.dart';
import 'contact_page.dart';
import 'saved_offer_page.dart';
import 'manage_keyword_page.dart';
import 'offer_view_page.dart';
import '../blocs/data_bloc.dart';
import '../blocs/model/category.dart' as cat;
import '../blocs/model/offer.dart';
import '../blocs/model/seller.dart';
import '../theme/app_color.dart';
import '../util/category_grid_view.dart';
import '../util/offer_grid_view.dart';
import '../util/global.dart';
import '../database/model/customer_saved_offer.dart';
import '../database/database_helper.dart';

import 'package:flutter/cupertino.dart';

DataBloc bloc;

class DashboardPage extends StatefulWidget {

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  List<cat.Category> categories = new List();
  bool isCollapsed = true;
  bool isEmptyList = false;
  bool isSearch = false;

  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  startTimer() {
    const oneSec = const Duration(seconds: 10);
    new Timer.periodic(oneSec, (Timer t) async {
      if(GlobalValue.getUserType == "Customer"){
        await bloc.getCustomerOffers();
        var db = new DatabaseHelper();
        List<Offer> serverSavedOffers = await bloc.getSavedOffers();
        List<CustomerSavedOffer> localSavedOffers = await db.getAll();
        if(localSavedOffers.length == 0 && serverSavedOffers != null){
          for(Offer offer in serverSavedOffers){
            await db.save(new CustomerSavedOffer(id: offer.id, price: offer.priceAfter, sellerId: offer.sellerId));
          }
        } else if(localSavedOffers.length != 0 && serverSavedOffers != null){
          if(serverSavedOffers.length > localSavedOffers.length){
            Offer newServerOffer = serverSavedOffers[serverSavedOffers.length - 1];
            await db.save(new CustomerSavedOffer(id: newServerOffer.id, price: newServerOffer.priceAfter, sellerId: newServerOffer.sellerId));
            List<String> keywords = await bloc.getSavedKeywords();
            for(String keyword in keywords){
              if(newServerOffer.name.contains(keyword)){
                Seller seller = await bloc.getSeller(sellerId: newServerOffer.sellerId);
                if(Platform.isAndroid){
                  await androidNotification("Updated price", "<b>${seller.name}</b> has been added the new offer <b>\"${newServerOffer.name}\"</b>");
                } else {
                  await iosNotification("Updated price", "<b>${seller.name}</b> has been added the new offer <b>\"${newServerOffer.name}\"</b>");
                }
              }
            }
          } else {
            for(Offer serverOffer in serverSavedOffers){
              int index = serverSavedOffers.indexOf(serverOffer);
              CustomerSavedOffer localOffer = localSavedOffers[index];
              if(serverOffer.priceAfter != localOffer.price){
                localOffer.price = serverOffer.priceAfter;
                await db.update(localOffer);
                Seller seller = await bloc.getSeller(sellerId: serverOffer.sellerId);
                if(Platform.isAndroid){
                  await androidNotification("Updated price", "<b>${seller.name}</b> has been changed the price about his offer <b>\"${serverOffer.name}\"</b>");
                } else {
                  await iosNotification("Updated price", "<b>${seller.name}</b> has been changed the price about his offer <b>\"${serverOffer.name}\"</b>");
                }
              }
            }
          }
        } else {

        }
      }
    });
  }

  logout() async {
    bool isLoggedOut = await bloc.logout();
    if(isLoggedOut){
      GlobalValue.setToken = null;
      GlobalValue.setUserType = null;
      GlobalValue.setCustomer = null;
      GlobalValue.setSeller = null;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      Toast.show("Failed log out!", context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    bloc = new DataBloc();
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    startTimer();
  }

  Future iosNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'hello',);
  }

  Future<void> androidNotification(String title, String body) async {
    var bigTextStyleInformation = BigTextStyleInformation(
        body,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        style: AndroidNotificationStyle.BigText,
        styleInformation: bigTextStyleInformation,
        priority: Priority.High);
    var platformChannelSpecifics =
    NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'Alarm', 'silent body', platformChannelSpecifics);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    Toast.show("Notification Clicked", context);
    /*Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: new Text(title),
            content: new Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text('Ok'),
                onPressed: () async {
//              Navigator.of(context, rootNavigator: true).pop();
                  Toast.show("Notification Clicked", context);
                },
              ),
            ],
          ),
    );
  }

  Future<Null> _refresh() async {
    categories.clear();
    List<cat.Category> list = await bloc.getAllCategories();
    setState(() {
      categories = list;
    });
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        title: Text("Hellomarkets", style: TextStyle(color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          Visibility(
            visible: GlobalValue.getUserType == "Seller",
            child: IconButton(
              icon: Icon(Icons.add_box, color: whiteColor),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddOfferPage()));
              },
            ),
          ),
          Visibility(
            visible: GlobalValue.getUserType == "Seller",
            child: IconButton(
              icon: Icon(Icons.search, color: whiteColor),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchOfferPage()));
              },
            ),
          )
        ],
      ),
      drawer: CustomDrawer(this),
      body: GlobalValue.getUserType == "Customer" ? RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: categories.length != 0
            ? Container(
              width: screenWidth,
              height: screenHeight,
              child: Column(
                children: List.generate(categories.length, (i) {
                  return ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => OfferViewPage(categories[i]))),
                    title: Text(categories[i].name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  );
                }),
              )
            )
            : Container()
      ) : StreamBuilder<List<Offer>>(
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

class CustomDrawer extends StatefulWidget {

  DashboardPageState parent;

  CustomDrawer(this.parent);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  bool isUserDetail = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [darkBlueColor, blueColor]),
              border: Border(bottom: BorderSide(color: greyColor)),
            ),
            accountName: Text(GlobalValue.getUserType == "Customer" ? GlobalValue.getCustomer.name : GlobalValue.getSeller.name),
            accountEmail: Text(GlobalValue.getUserType == "Customer" ? GlobalValue.getCustomer.email : GlobalValue.getSeller.email),
            currentAccountPicture: CircleAvatar(
              child: Image.asset("assets/images/default_user_avatar.png"),
            ),
            onDetailsPressed: () {
              setState(() {
                isUserDetail = !isUserDetail;
              });
            },
          ),
          Expanded(
            child: isUserDetail ? userDetailList() : drawerList(),
          )
        ],
      ),
    );
  }

  Widget userDetailList() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Name"),
          leading: Icon(Icons.account_circle, color: darkBlueColor),
          subtitle: Text(GlobalValue.getUserType == "Customer" ? GlobalValue.getCustomer.name : GlobalValue.getSeller.name),
        ),
        ListTile(
          title: Text("Email"),
          leading: Icon(Icons.email, color: darkBlueColor),
          subtitle: Text(GlobalValue.getUserType == "Customer" ? GlobalValue.getCustomer.email : GlobalValue.getSeller.email),
        ),
        ListTile(
            title: Text("Phone Number"),
            leading: Icon(Icons.phone, color: darkBlueColor),
            subtitle: Text(GlobalValue.getUserType == "Customer" ? GlobalValue.getCustomer.phone : GlobalValue.getSeller.phone)
        ),
        Visibility(
          visible: GlobalValue.getUserType == "Customer",
          child: ListTile(
            title: Text("Edit Profile", style: TextStyle(color: blueColor)),
            leading: Icon(Icons.mode_edit, color: blueColor),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfilePage()));
            },
          ),
        )
      ],
    );
  }

  Widget drawerList() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Statistics", style: TextStyle(color: darkBlueColor, fontSize: 15)),
          leading: Icon(Icons.equalizer, color: darkBlueColor, size: 25),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StatisticPage()));
          },
        ),
        ListTile(
          title: Text("Contact to admin", style: TextStyle(color: darkBlueColor, fontSize: 15)),
          leading: Icon(Icons.contact_mail, color: darkBlueColor, size: 25),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactPage()));
          },
        ),
        Visibility(
          visible: GlobalValue.getUserType == "Customer",
          child: ListTile(
            title: Text("Saved Offers", style: TextStyle(color: darkBlueColor, fontSize: 15)),
            leading: Icon(Icons.view_list, color: darkBlueColor, size: 25),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SavedOfferPage(bloc)));
            },
          ),
        ),
        Visibility(
          visible: GlobalValue.getUserType == "Customer",
          child: ListTile(
            title: Text("Manage keyword", style: TextStyle(color: darkBlueColor, fontSize: 15)),
            leading: Icon(Icons.settings_applications, color: darkBlueColor, size: 25),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManageKeywordPage(bloc)));
            },
          ),
        ),
        ListTile(
          title: Text("Log out", style: TextStyle(color: darkBlueColor, fontSize: 15)),
          leading: Icon(Icons.input, color: darkBlueColor, size: 25),
          onTap: () {
            widget.parent.logout();
          },
        )
      ],
    );
  }
}
