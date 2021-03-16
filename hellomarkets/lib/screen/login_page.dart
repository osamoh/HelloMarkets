import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'dashboard_page.dart';
import 'register_page.dart';
import '../blocs/data_bloc.dart';
import '../util/global.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  DataBloc dataBloc;
  TextEditingController emailCT = new TextEditingController();
  TextEditingController passCT = new TextEditingController();
  String userType;
  bool isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    dataBloc = new DataBloc();
    userType = "Customer";
  }

  _login() async {

    setState(() {
      isLoggingIn = true;
    });

    Map<String, dynamic> loginInfo = await dataBloc.login(userType: userType, email: emailCT.text, password: passCT.text);
    if(loginInfo == null){
      setState(() {
        isLoggingIn = false;
      });
      Toast.show("Failed log in!", context);
    } else {
      Toast.show("Successed log in!", context);
      GlobalValue.setToken = loginInfo["userToken"];
      print(GlobalValue.getToken);
      GlobalValue.setUserType = userType;
      switch(userType){
        case "Customer":
          GlobalValue.setCustomer = loginInfo["userInfo"];
          break;
        case "Seller":
          GlobalValue.setSeller = loginInfo["userInfo"];
          break;
      }
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => DashboardPage()), (Route route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: bodyContent(context),
    );
  }

  Widget bodyContent(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.6,
            margin: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10
                )]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Log in", style: TextStyle(color: Colors.blueAccent, fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(width: 20,),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow(
                              color: Colors.blue[300],
                              blurRadius: 5
                          )]
                      ),
                      child: DropdownButton(
                        items: [
                          DropdownMenuItem(
                            value: "Customer",
                            child: Text("Customer"),
                          ),
                          DropdownMenuItem(
                            value: "Seller",
                            child: Text("Seller"),
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            userType = value;
                          });
                        },
                        value: userType,
                        elevation: 5,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ],
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
                    controller: passCT,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        labelText: "Password"
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                SizedBox(height: 30),
                Visibility(
                  visible: !isLoggingIn,
                  child: InkWell(
                    onTap: () {
                      if(emailCT.text.trim().isEmpty){
                        Toast.show("Please enter your email address!", context);
                        return;
                      }
                      if(passCT.text.trim().isEmpty){
                        Toast.show("Please enter your valid password!", context);
                        return;
                      }
                      _login();
                    },
                    child: Container(
                      width: screenWidth * 0.5,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("LOG IN", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  replacement: CircularProgressIndicator(),
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: userType == "Customer",
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage()));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 30,
                          child: Center(
                            child: Text("Don't have? Please register", style: TextStyle(color: Colors.blue, fontSize: 15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10
                )]
              ),
              child: Center(
                child: Image.asset("assets/images/app_icon.png", width: 60, height: 60),
              ),
            )
          )
        ],
      )
    );
  }
}