import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../theme/app_color.dart';
import '../util/global.dart';
import '../blocs/data_bloc.dart';

DataBloc dataBloc;

class ContactPage extends StatefulWidget {

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  double screenWidth, screenHeight;

  String userEmail;

  TextEditingController messageCT;

  bool isSendingMessage = false;

  sendMessage() async {
    if(messageCT.text.isEmpty){
      Toast.show("Enter your message", context);
      return;
    }

    setState(() {
      isSendingMessage = true;
    });

    bool isSuccessed = await dataBloc.sendMessage(message: messageCT.text);
    if(isSuccessed){
      setState(() {
        isSendingMessage = false;
      });
      Toast.show("Successed send message!", context);
    } else {
      setState(() {
        isSendingMessage = false;
      });
      Toast.show("Failed send message!", context);
    }
  }

  @override
  void initState() {
    super.initState();
    userEmail = GlobalValue.getUserType == "Customer" ? GlobalValue.getCustomer.email : GlobalValue.getSeller.email;
    messageCT = new TextEditingController();
    dataBloc = new DataBloc();
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: darkBlueColor,
        title: Text("Contact to admin"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("From", style: TextStyle(color: blueColor, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)),
                SizedBox(width: 10),
                Container(
                  width: screenWidth * 0.7,
                  height: 40,
                  decoration: BoxDecoration(
                    color: greyColor.withAlpha(0x20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(userEmail, style: TextStyle(color: darkBlueColor, fontSize: 13)),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("To", style: TextStyle(color: blueColor, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)),
                SizedBox(width: 25),
                Container(
                  width: screenWidth * 0.7,
                  height: 40,
                  decoration: BoxDecoration(
                    color: greyColor.withAlpha(0x20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text("Admin", style: TextStyle(color: darkBlueColor, fontSize: 13)),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Message", style: TextStyle(color: blueColor, fontSize: 15, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)),
                SizedBox(width: 10),
                Container(
                  width: screenWidth * 0.7,
                  height: 100,
                  child: TextField(
                    maxLines: 10,
                    textAlignVertical: TextAlignVertical.top,
                    controller: messageCT,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      filled: true,
                      fillColor: greyColor.withAlpha(0x20),
                      hintText: "Type your message",
                      hintStyle: TextStyle(color: greyColor, fontSize: 12)
                    ),
                    style: TextStyle(color: blackColor, fontSize: 13),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Visibility(
              visible: !isSendingMessage,
              child: InkWell(
                onTap: sendMessage,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: screenWidth * 0.5,
                  height: 50,
                  decoration: BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: Text("Send message", style: TextStyle(color: whiteColor)),
                  ),
                ),
              ),
              replacement: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
