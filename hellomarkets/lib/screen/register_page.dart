import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';
import '../util/constants.dart';
import '../blocs/data_bloc.dart';

DataBloc dataBloc;

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  TextEditingController nameCT, emailCT, phoneCT, passCT;
  String userType;
  bool isRegistering = false;

  @override
  void initState() {
    super.initState();
    userType = "Customer";
    nameCT = new TextEditingController();
    emailCT = new TextEditingController();
    phoneCT = new TextEditingController();
    passCT = new TextEditingController();
    dataBloc = new DataBloc();
  }

  Future<void> _register() async {

    setState(() {
      isRegistering = true;
    });
    String name = nameCT.text;
    String email = emailCT.text;
    String phone = phoneCT.text;
    String password = passCT.text;
    bool isRegisterSuccessed = await dataBloc.register(name: name, email: email, phone: phone, password: password);

    if(!isRegisterSuccessed){
      setState(() {
        isRegistering = false;
      });
      Toast.show("Failed register!", context);
    } else {
      Toast.show("Successed register!", context);
      Navigator.of(context).pop(true);
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

    return Center(
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              width: screenWidth * 0.9,
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.only(top: 50, bottom: 30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10
                  )]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Register", style: TextStyle(color: Colors.blueAccent, fontSize: 30, fontWeight: FontWeight.bold)),
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
                    visible: !isRegistering,
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
                        if(passCT.text.isEmpty){
                          Toast.show("Please enter your password!", context);
                          return;
                        }
                        _register();
                      },
                      child: Container(
                        width: screenWidth * 0.5,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text("REGISTER", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    replacement: CircularProgressIndicator(),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 30,
                      child: Center(
                        child: Text("Already have? Please log in", style: TextStyle(color: Colors.blue, fontSize: 15)),
                      ),
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