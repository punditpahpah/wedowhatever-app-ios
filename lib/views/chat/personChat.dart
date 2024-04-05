import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SingleUserChat extends StatefulWidget {
  String from, to, my_id, receiver_id, receiver_avatar, first_name, last_name;
  SingleUserChat(
      {required this.from,
      required this.to,
      required this.my_id,
      required this.receiver_id,
      required this.receiver_avatar,
      required this.first_name,
      required this.last_name,
      Key? key})
      : super(key: key);

  @override
  _SingleUserChatState createState() => _SingleUserChatState();
}

class _SingleUserChatState extends State<SingleUserChat> {
  late Timer _everySecond;

  @override
  void initState() {
    super.initState();
    //callApi();
    _everySecond = Timer.periodic(Duration(seconds: 2), (Timer t) {
      setState(() {
        if (_controller.hasClients) {
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        }
      });
    });
  }

  final _controller = ScrollController();

  TextEditingController messageController = new TextEditingController();

  Future Greet(String message) async {
    //ProgressDialog dialog = new ProgressDialog(context);
    // dialog.style(message: 'Please wait...');
    //await dialog.show();
    var url = Uri.parse(Constants.base_url + "send_greetings.php");
    var response = await http.post(url, body: {
      "sender_id": widget.my_id,
      "receiver_id": widget.receiver_id,
      "content": message,
      "auth_key": Constants.auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      if (_controller.hasClients) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
      //ShowResponse("Greetings sent");

      //await dialog.hide();
    } else if (code == "0") {
      ShowResponse("Error while sending message");
    } else {
      // ShowResponse(response.body.toString());
    }
    //await dialog.hide();
  }

  ShowResponse(String Response) {
    var snackBar = SnackBar(content: Text(Response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<List<Items>> GetFriends() async {
    var url = Uri.parse(Constants.base_url +
        "get_messages.php?user_id=${widget.from}&receiver_id=${widget.to}&auth_key=" +
        Constants.auth_key);
    var Users = await http.get(url);
    var JsonData = json.decode(Users.body);
    final List<Items> rows = [];
    //nechy jb future builder wala functions jo hoga listview m os m if snapshot.freindship_status=="accpted" then text would Friends
    // if snapshot.following_status=="1" then text would be Following
    for (var u in JsonData) {
      Items item = Items(u["from"], u["to"], u["content"], u["time"], u["code"]);
      rows.add(item);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: CustomColors.DarkBlueColour,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                  text: widget.first_name + " " + widget.last_name,
                  fontsize: 0.025,
                  isbold: true,
                  color: CustomColors.DarkBlueColour,
                  textalign: TextAlign.start),
              // CustomTextWidget(
              //     text: 'Online',
              //     fontsize: 0.02,
              //     isbold: true,
              //     color: CustomColors.DarkBlueColour,
              //     textalign: TextAlign.start)
            ],
          ),
        ),
      ),
      body: Container(
        color: CustomColors.GreyColour,
        child: Column(
          children: [
            //header(),
            Expanded(
              flex: 10,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                  future: GetFriends(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.data[0].code == "0") {
                      return Container(
                        child: Center(
                            child:
                                Text("No Chats! SAY HI FROM FRIENDS PROFILE")),
                      );
                    } else {
                      return ListView.builder(
                        controller: _controller,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              if (snapshot.data[index].to == widget.to &&
                                  snapshot.data[index].from == widget.from)
                                leftChatMsg(
                                    content: snapshot.data[index].content,time: snapshot.data[index].time),
                              if (snapshot.data[index].from == widget.to &&
                                  snapshot.data[index].to == widget.from)
                                RightchatMsg(
                                    content: snapshot.data[index].content,time: snapshot.data[index].time),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),

            // SizedBox(
            //   height: 10,
            // )
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(5),
              //height: size.height * 0.045,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: CustomColors.DarkBlueColour),
              child: TextField(
                controller: messageController,
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
                        if (messageController.text != "") {
                          Greet(messageController.text.toString());
                          messageController.text = "";
                          _controller.animateTo(
                            _controller.position.maxScrollExtent,
                            duration: Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                      },
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    labelText: 'Message....',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      // floatingActionButton: Container(
      //   margin: EdgeInsets.only(top: 10),
      //   padding: EdgeInsets.all(5),
      //   //height: size.height * 0.045,
      //   width: size.width * 0.9,
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.all(Radius.circular(20)),
      //       color: CustomColors.DarkBlueColour),
      //   child: TextField(
      //     controller: message,
      //     textInputAction: TextInputAction.newline,
      //     keyboardType: TextInputType.multiline,
      //     minLines: null,
      //     maxLines: null, //
      //     cursorColor: Colors.white,
      //     style: TextStyle(color: Colors.white, fontSize: 18),
      //     decoration: InputDecoration(
      //         suffixIcon: IconButton(
      //           icon: Icon(Icons.send),
      //           onPressed: () {
      //             setState(() {
      //               message.text="";
      //             });
      //           },
      //         ),
      //         floatingLabelBehavior: FloatingLabelBehavior.never,
      //         border: InputBorder.none,
      //         focusedBorder: InputBorder.none,
      //         labelText: 'Message....',
      //         labelStyle: TextStyle(color: Colors.white, fontSize: 18)),
      //   ),
      // ),
    );
  }
}

class leftChatMsg extends StatelessWidget {
  String content,time;
  leftChatMsg({
    required this.content,
    required this.time,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 250,
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: CustomColors.darkGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                color: Colors.white,
                fontsize: 0.025,
                isbold: false,
                text: content,
                textalign: TextAlign.start,
              ),
              SizedBox(height: 5,),
              CustomTextWidget(
                color: Colors.white,
                fontsize: 0.015,
                isbold: false,
                text: time,
                textalign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class RightchatMsg extends StatelessWidget {
  String content,time;
  RightchatMsg({
    required this.content,required this.time,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 250,
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: CustomColors.darkGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomTextWidget(
                color: Colors.white,
                fontsize: 0.025,
                isbold: false,
                text: content,
                textalign: TextAlign.end
              ),
              SizedBox(height: 5,),
              CustomTextWidget(
                color: Colors.white,
                fontsize: 0.015,
                isbold: false,
                text: time,
                textalign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class header extends StatelessWidget {
  const header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                  child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                          'assets/images/user.jpg',
                        )),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 4,
                //padding: const EdgeInsets.only(top:10.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                          text: 'Alice',
                          fontsize: 0.025,
                          isbold: true,
                          color: CustomColors.darkGreyColor,
                          textalign: TextAlign.start),
                      CustomTextWidget(
                          text: 'Online Now',
                          fontsize: 0.02,
                          isbold: true,
                          color: CustomColors.darkGreyColor,
                          textalign: TextAlign.start)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class Items {
  final String from;
  final String to;
  final String content;
  final String time;
  final String code;
  Items(this.from, this.to, this.content,this.time, this.code);
}
