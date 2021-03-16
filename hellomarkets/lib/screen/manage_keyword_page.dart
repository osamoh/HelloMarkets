import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';
import '../blocs/data_bloc.dart';
import '../theme/app_color.dart';

class ManageKeywordPage extends StatefulWidget {

  DataBloc dataBloc;

  ManageKeywordPage(this.dataBloc);

  @override
  _ManageKeywordPageState createState() => _ManageKeywordPageState();
}

class _ManageKeywordPageState extends State<ManageKeywordPage> {

  double screenWidth, screenHeight;
  SlidableController slidableController;
  TextEditingController keywordCT;

  bool isSavingKeyword = false;

  @override
  void initState() {
    super.initState();
    slidableController = new SlidableController();
    keywordCT = new TextEditingController();
    widget.dataBloc.getSavedKeywords();
  }

  saveKeyword(BuildContext context) async {

    if(keywordCT.text.isEmpty){
      Toast.show("Add your keyword!", context);
      return;
    }

    setState(() {
      isSavingKeyword = true;
    });

    bool isSavedSuccessed = await widget.dataBloc.saveKeyword(keyword: keywordCT.text);
    if(isSavedSuccessed){
      Toast.show("Successed save keyword!", context);
      Navigator.of(context).pop(context);
    } else {
      setState(() {
        isSavingKeyword = false;
      });
      Toast.show("Failed save keyword!", context);
    }
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
        title: Text("Manage keyword"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 30),
                          Text("Saving keyword", style: TextStyle(color: darkBlueColor, fontSize: 17, fontWeight: FontWeight.bold)),
                          SizedBox(height: 30),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: TextField(
                              controller: keywordCT,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none
                                  ),
                                  filled: true,
                                  fillColor: greyColor.withAlpha(0x50),
                                  hintText: "Type your keyword",
                                  hintStyle: TextStyle(color: blackColor.withAlpha(0x80), fontSize: 15)
                              ),
                              maxLines: 1,
                              maxLength: 20,
                              style: TextStyle(color: blackColor, fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 30),
                          Visibility(
                            visible: !isSavingKeyword,
                            child: InkWell(
                              onTap: () {
                                saveKeyword(context);
                              },
                              child: Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: greenColor,
                                    borderRadius: BorderRadius.circular(40)
                                ),
                                child: Center(
                                  child: Text("Save", style: TextStyle(color: whiteColor, fontSize: 15, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            replacement: CircularProgressIndicator(),
                          ),
                          SizedBox(height: 40)
                        ],
                      ),
                    );
                  }
              );
            },
            icon: Icon(Icons.add, color: whiteColor),
          )
        ],
      ),
      body: StreamBuilder<List<String>>(
        stream: widget.dataBloc.keywords,
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData && snapshot.data != null
              ? gridView(snapshot.data)
              : Center(child: Image.asset("assets/images/loading.gif"));
        },
      ),
    );
  }

  Widget gridView(List<String> keywords) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: keywords.length,
        itemBuilder: (context, index) {
          return Slidable(
              key: ValueKey(index),
              controller: slidableController,
              actionPane: SlidableBehindActionPane(),
              actionExtentRatio: 0.25,
              closeOnScroll: true,
              actions: <Widget>[
                IconSlideAction(
                  caption: "Delete",
                  color: redColor,
                  icon: Icons.delete_sweep,
                  onTap: () {

                  },
                )
              ],
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(0x30),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(1, 1)
                    )
                  ],
                ),
                child: ListTile(
                  title: Text(keywords[index], style: TextStyle(color: blueColor, fontSize: screenWidth * 0.05)),
                )
              )
          );
        },
      ),
    );
  }
}