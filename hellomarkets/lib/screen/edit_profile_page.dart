import 'package:flutter/material.dart';
import 'package:hellomarkets/screen/login_page.dart';
import 'package:toast/toast.dart';
import '../blocs/data_bloc.dart';
import '../blocs/model/customer.dart';
import '../theme/app_color.dart';
import '../util/constants.dart';
import '../util/global.dart';

DataBloc dataBloc;

class EditProfilePage extends StatefulWidget {

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  TextEditingController nameCT, emailCT, phoneCT, passCT;
  bool isUpdating = false;
  bool isDeleting = false;

  Future<void> _updateInfo() async {
    setState(() {
      isUpdating = true;
    });

    Customer customer = GlobalValue.getCustomer;

    customer.name = nameCT.text;
    customer.email = emailCT.text;
    customer.phone = phoneCT.text;

    int successNum = await dataBloc.updateCustomer(customer: customer);
    if(successNum == 1){
      setState(() {
        isUpdating = false;
      });
      GlobalValue.setCustomer = customer;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text("Successed"),
            content: Text("To use this updated account, you need to log in again!"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route route) => false),
                  child: Text("OK", style: TextStyle(color: blueColor))
              )
            ],
          )
      );
    } else {
      setState(() {
        isUpdating = false;
      });
      Toast.show("Failed update!", context);
    }
  }

  Future<void> _deleteInfo() async {
    setState(() {
      isDeleting = true;
    });

    int successNum = await dataBloc.deleteCustomer();
    if(successNum == 1){
      setState(() {
        isDeleting = false;
      });
      Toast.show("Successed delete!", context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route route) => false);
    } else {
      setState(() {
        isDeleting = false;
      });
      Toast.show("Failed delete!", context);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    nameCT = new TextEditingController();
    emailCT = new TextEditingController();
    phoneCT = new TextEditingController();
    dataBloc = new DataBloc();
  }

  @override
  Widget build(BuildContext context) {

    nameCT.text = GlobalValue.getCustomer.name;
    emailCT.text = GlobalValue.getCustomer.email;
    phoneCT.text = GlobalValue.getCustomer.phone;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        automaticallyImplyLeading: true,
        title: Text("Edit profile"),
      ),
      body: bodyContent(context),
    );
  }

  Widget bodyContent(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                  labelText: "Name"
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: screenWidth * 0.7,
            height: 50,
            child: TextField(
              controller: emailCT,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  labelText: "Email"
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: screenWidth * 0.7,
            height: 50,
            child: TextField(
              controller: phoneCT,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  labelText: "Phone"
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
//          SizedBox(height: 20),
//          Container(
//            width: screenWidth * 0.7,
//            height: 50,
//            child: TextField(
//              controller: passCT,
//              obscureText: true,
//              decoration: InputDecoration(
//                  border: OutlineInputBorder(
//                      borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid),
//                      borderRadius: BorderRadius.circular(20)
//                  ),
//                  labelText: "Password"
//              ),
//              keyboardType: TextInputType.visiblePassword,
//            ),
//          ),
          SizedBox(height: 30),
          Visibility(
            visible: !isUpdating,
            child: InkWell(
              onTap: () {
                if(nameCT.text.isEmpty){
                  Toast.show("Please enter your name!", context);
                  return;
                }
                if(emailCT.text.isEmpty){
                  Toast.show("Please enter your email address!", context);
                  return;
                }
                if(phoneCT.text.isEmpty){
                  Toast.show("Please add your phone number!", context);
                  return;
                }
                _updateInfo();
              },
              child: Container(
                width: screenWidth * 0.5,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text("Update", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            replacement: CircularProgressIndicator(),
          ),
          SizedBox(height: 10),
          Visibility(
            visible: !isDeleting,
            child: InkWell(
              onTap: () {
                _deleteInfo();
              },
              child: Container(
                width: screenWidth * 0.5,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text("Delete", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            replacement: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}
