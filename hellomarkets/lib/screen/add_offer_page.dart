
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hellomarkets/screen/dashboard_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import '../theme/app_color.dart';
import '../util/image_helper.dart';
import '../util/constants.dart';
import '../blocs/model/offer.dart';
import '../blocs/model/category.dart' as cat;


class AddOfferPage extends StatefulWidget {

  Offer offer;

  AddOfferPage({this.offer});

  @override
  _AddOfferPageState createState() => _AddOfferPageState();
}

class _AddOfferPageState extends State<AddOfferPage> {

  List<cat.Category> categories = new List();

  TextEditingController nameCT = new TextEditingController();
  TextEditingController descriptionCT = new TextEditingController();
  TextEditingController priceBFCT = new TextEditingController();
  TextEditingController priceAFCT = new TextEditingController();
  TextEditingController websiteCT = new TextEditingController();
  TextEditingController caloriesCT = new TextEditingController();
  TextEditingController barcodeCT = new TextEditingController();

  double screenWidth, screenHeight;
  String name, description, priceBefore, priceAfter, website, calories, startDate, endDate, barCode, imageBase64Data;
  int category_id;
  String category_str;

  bool isImageLoading = false;
  bool isSubmitting = false;

  getImageDataFromCamera() async {
    setState(() {
      isImageLoading = true;
    });
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    String imgResult = await ImageHelper.imageToBase64(image);
    setState(() {
      imageBase64Data = imgResult;
      isImageLoading = false;
    });
  }

  void uploadOfferToServer() async {

    name = nameCT.text;
    description = descriptionCT.text;
    priceBefore = priceBFCT.text;
    priceAfter = priceAFCT.text;
    website = websiteCT.text;
    calories = caloriesCT.text;
    barCode = barcodeCT.text;

    if(name == "" || description == "" || priceBefore == "" || priceAfter == "" || website == "" || calories == "" || startDate == "" || endDate == "" || barCode == "" || imageBase64Data == "" || category_id == null){
      Toast.show("Fill all fields!", context);
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    if(widget.offer != null){

      Offer updateOffer = new Offer();
      updateOffer.id = widget.offer.id;
      updateOffer.name = name;
      updateOffer.description = description;
      updateOffer.priceBefore = int.parse(priceBefore);
      updateOffer.priceAfter = int.parse(priceAfter);
      updateOffer.website = website;
      updateOffer.calories = int.parse(calories);
      updateOffer.barcode = barCode;
      updateOffer.dateStart = startDate;
      updateOffer.dateEnd = endDate;
      updateOffer.categoryId = category_id;
      updateOffer.photo = imageBase64Data != null ? imageBase64Data : null;

      await bloc.updateOffer(offer: updateOffer);
      await bloc.getSellerOffers();

      setState(() {
        isSubmitting = false;
      });

      Navigator.of(context).pop(true);

    } else {
      Offer newOffer = new Offer(
          name: name,
          description: description,
          priceBefore: int.parse(priceBefore),
          priceAfter: int.parse(priceAfter),
          website: website,
          calories: int.parse(calories),
          dateStart: startDate,
          dateEnd: endDate,
          barcode: barCode,
          categoryId: category_id,
          photo: imageBase64Data
      );

      await bloc.addOffer(offer: newOffer);
      await bloc.getSellerOffers();

      setState(() {
        isSubmitting = false;
      });

      Navigator.of(context).pop(true);
    }
  }

  init() async {
    if(widget.offer != null){
      nameCT.text = widget.offer.name;
      descriptionCT.text = widget.offer.description;
      priceBFCT.text = widget.offer.priceBefore.toString();
      priceAFCT.text = widget.offer.priceAfter.toString();
      websiteCT.text = widget.offer.website;
      caloriesCT.text = widget.offer.calories.toString();
      barcodeCT.text = widget.offer.barcode;
      startDate = widget.offer.dateStart;
      endDate = widget.offer.dateEnd;
      category_id = widget.offer.categoryId;
    } else {
      name = "";
      description = "";
      priceBefore = "";
      priceAfter = "";
      website = "";
      calories = "";
      barCode = "";
      startDate = "";
      endDate = "";
      imageBase64Data = "";
      category_id = null;
    }

    categories = await bloc.getAllCategories();
    if(category_id != null){
      for(cat.Category category in categories){
        if(category.id == category_id){
          category_str = category.name;
        }
      }
    }
  }

  @override
  void initState() {
    imageBase64Data = null;
    init();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.offer != null ? "Update offer" : "Add offer"),
        backgroundColor: darkBlueColor,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30, left: 20, right: 20),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                bodyContent(context),
                SizedBox(height: 40),
                InkWell(
                  onTap: () => uploadOfferToServer(),
                  child: Container(
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                        child: Text("Submit", style: TextStyle(color: whiteColor, fontSize: 20),)
                    ),
                  ),
                ),
                SizedBox(height: 50)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bodyContent(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget> [
              FutureBuilder(
                future: Future.delayed(Duration(microseconds: 500)),
                builder: (context, i) {
                  if(widget.offer == null){
                    return imageBase64Data == ""
                        ? Image.asset("assets/images/default_product_image.png", width: 200, height: 200, fit: BoxFit.fill)
                        : new Image.memory(ImageHelper.base64ToImage(imageBase64Data), width: 200, height: 200, fit: BoxFit.fill);
                  } else {
                    return CachedNetworkImage(
                      imageUrl: "${Constants.OFFER_IMAGE_PATH}/${widget.offer.photo}",
                      width: 200,
                      height: 200,
                      fadeInDuration: Duration(milliseconds: 300),
                      fadeOutDuration: Duration(milliseconds: 300),
                      placeholder: (context, url) => Image.asset("assets/images/loading.gif", width: 100, height: 100),
                      fit: BoxFit.scaleDown,
                      placeholderFadeInDuration: Duration(milliseconds: 300),
                    );
                  }
                },
              ),
              Visibility(
                visible: isImageLoading,
                child: Image.asset("assets/images/loading.gif", width: 200, height: 200)
              ),
              FloatingActionButton(
                onPressed: () => getImageDataFromCamera(),
                child: Icon(Icons.camera_enhance, color: whiteColor),
              ),
            ],
          )
        ),
        SizedBox(height: 20),
        Container(
          width: screenWidth * 0.7,
          height: 50,
          child: TextField(
            controller: nameCT,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20)
                ),
                labelText: "Product Name"
            ),
            keyboardType: TextInputType.text,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: screenWidth * 0.7,
          height: 50,
          child: TextField(
            controller: descriptionCT,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20)
                ),
                labelText: "Description"
            ),
            keyboardType: TextInputType.text,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: screenWidth * 0.7,
          height: 50,
          child: TextField(
            controller: priceBFCT,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20)
                ),
                labelText: "Price Before"
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: screenWidth * 0.7,
          height: 50,
          child: TextField(
            controller: priceAFCT,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20)
                ),
                labelText: "Price After"
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: screenWidth * 0.7,
          height: 50,
          child: TextField(
            controller: websiteCT,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20)
                ),
                labelText: "Website Link"
            ),
            keyboardType: TextInputType.url,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: screenWidth * 0.7,
          height: 50,
          child: TextField(
            controller: caloriesCT,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: blueColor, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20)
                ),
                labelText: "Calories"
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: screenWidth * 0.7,
          height: 50,
          child: TextField(
              controller: barcodeCT,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: blueColor, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  labelText: "BarCode"
              ),
              keyboardType: TextInputType.text
          ),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => CategoryPickDialog(this)
            );
          },
          child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              width: screenWidth * 0.7,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: greyColor, style: BorderStyle.solid)
              ),
              child: Text(category_id == null ? "Category" : category_str, style: TextStyle(color: category_id == null ? greyColor : blackColor, fontSize: 15))
          ),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () async {
            DateTime picked = await showDatePicker(
                context: context,
                initialDate: new DateTime.now(),
                firstDate: new DateTime(1980),
                lastDate: new DateTime(2020)
            );
            if(picked != null) setState(() => startDate = picked.toString().split(" ")[0]);
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10),
            width: screenWidth * 0.7,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: greyColor, style: BorderStyle.solid)
            ),
            child: Text(startDate == "" ? "Start Date" : startDate, style: TextStyle(color: startDate == "" ? greyColor : blackColor, fontSize: 15))
          ),
        ),
        SizedBox(height: 10),
        Visibility(
          visible: !isSubmitting,
          child: InkWell(
            onTap: () async {
              DateTime picked = await showDatePicker(
                  context: context,
                  initialDate: new DateTime.now(),
                  firstDate: new DateTime(1980),
                  lastDate: new DateTime(2020)
              );
              if(picked != null) setState(() => endDate = picked.toString().split(" ")[0]);
            },
            child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                width: screenWidth * 0.7,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: greyColor, style: BorderStyle.solid)
                ),
                child: Text(endDate == "" ? "End Date" : endDate, style: TextStyle(color: endDate == "" ? greyColor : blackColor, fontSize: 15))
            ),
          ),
          replacement: CircularProgressIndicator(),
        ),
      ],
    );
  }
}

class CategoryPickDialog extends StatefulWidget {

  _AddOfferPageState parent;

  CategoryPickDialog(this.parent);

  @override
  _CategoryPickDialogState createState() => _CategoryPickDialogState();
}

class _CategoryPickDialogState extends State<CategoryPickDialog> {

  TextEditingController searchCT = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: Text('Choose category..', style: TextStyle(color: blackColor, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
//            Container(
//              height: 60,
//              child: TextField(
//                controller: searchCT,
//                decoration: InputDecoration(
//                    border: OutlineInputBorder(
//                        borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid),
//                        borderRadius: BorderRadius.circular(20)
//                    ),
//                    labelText: "Search....",
//                ),
//                maxLength: 15,
//                keyboardType: TextInputType.text,
//              ),
//            ),
            SizedBox(height: 10),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.parent.categories.length, (i) {
                  return ListTile(
                    onTap: () {
                      widget.parent.setState(() {
                        widget.parent.category_id = widget.parent.categories[i].id;
                        widget.parent.category_str = widget.parent.categories[i].name;
                      });
                      Navigator.of(context).pop(true);
                    },
                    title: Text(widget.parent.categories[i].name),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}