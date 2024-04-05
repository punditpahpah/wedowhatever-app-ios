import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/views/friends/viewProfile.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';

class Comments extends StatefulWidget {
  String post_id;
  Comments({required this.post_id, Key? key}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController CommentController = new TextEditingController();

  var l_user_id;

  Future<List<Items>> GetFriends() async {
    var url = Uri.parse(Constants.base_url +
        "get_comments.php?post_id=" +
        widget.post_id +
        "&auth_key=" +
        Constants.auth_key);
    var Comments = await http.get(url);
    var JsonData = json.decode(Comments.body);
    final List<Items> rows = [];
    //nechy jb future builder wala functions jo hoga listview m os m if snapshot.freindship_status=="accpted" then text would Friends
    // if snapshot.following_status=="1" then text would be Following
    for (var u in JsonData) {
      Items item = Items(u["comment_id"], u["user_id"], u["text"],
          u["user_first_name"], u["code"]);
      rows.add(item);
    }
    return rows;
  }

  Future SendComment(String _text) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(Constants.base_url + "send_comment.php");
    var response = await http.post(url, body: {
      "user_id": l_user_id,
      "post_id": widget.post_id,
      "text": _text,
      "auth_key": Constants.auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      ShowResponse("Comment sent");
      setState(() {});
      await dialog.hide();
    } else if (code == "0") {
      ShowResponse("Comment not sent");
    } else {
      ShowResponse(response.body.toString());
    }
    await dialog.hide();
  }

  ShowResponse(String Response) {
    var snackBar = SnackBar(content: Text(Response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    l_user_id = prefs.getString('user_id');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: CustomColors.DarkBlueColour,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: CustomTextWidget(
          color: CustomColors.DarkBlueColour,
          fontsize: 0.025,
          isbold: true,
          text: 'Comments',
          textalign: TextAlign.start,
        ),
      ),
      body: Container(
        height: size.height / 1.1,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: FutureBuilder(
          future: GetFriends(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.data[0].code == "0") {
              return Container(
                child: Center(child: Text("No Comments")),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: CustomColors.GreyColour,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextWidget(
                                      text:
                                          snapshot.data[index].user_first_name,
                                      fontsize: 0.025,
                                      isbold: true,
                                      color: Colors.black,
                                      textalign: TextAlign.start),
                                  CustomTextWidget(
                                      text: snapshot.data[index].text,
                                      fontsize: 0.02,
                                      isbold: true,
                                      color: CustomColors.DarkBlueColour,
                                      textalign: TextAlign.start),
                                ],
                              ),
                            ))
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(5),
        //height: size.height * 0.045,
        width: size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: CustomColors.DarkBlueColour),
        child: TextField(
          controller: CommentController,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          minLines: null,
          maxLines: null, //
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  var text = CommentController.text;
                  if (text != "") {
                    SendComment(text);
                    CommentController.text = "";
                  }
                },
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelText: 'Comment....',
              labelStyle: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }
}

class Items {
  final String comment_id;
  final String user_id;
  final String text;
  final String user_first_name;
  final String code;
  Items(this.comment_id, this.user_id, this.text, this.user_first_name,
      this.code);
}
