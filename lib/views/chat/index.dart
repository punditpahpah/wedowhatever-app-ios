import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatever_ios/routes/app_pages.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/views/chat/personChat.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class chat extends StatefulWidget {
  String from;
  chat({required this.from, Key? key}) : super(key: key);

  @override
  _chatState createState() => _chatState();
}

class _chatState extends State<chat> {
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id').toString();
    // user_lastname = prefs.getString('user_lastname');
    // user_firstname = prefs.getString('user_firstname');
    // email = prefs.getString('email');
    setState(() {});
  }

  String user_id = "";

  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  Future<List<Items>> GetFriends() async {
    var url = Uri.parse(Constants.base_url +
        "get_chats.php?user_id=$user_id&auth_key=" +
        Constants.auth_key);
    var Users = await http.get(url);
    var JsonData = json.decode(Users.body);
    final List<Items> rows = [];
    //nechy jb future builder wala functions jo hoga listview m os m if snapshot.freindship_status=="accpted" then text would Friends
    // if snapshot.following_status=="1" then text would be Following
    for (var u in JsonData) {
      Items item = Items(
          u["message_id"],
          u["from"],
          u["to"],
          u["owner"],
          u["content"],
          u["receiver_id"],
          u["first_name"],
          u["last_name"],
          u["receiver_avatar"],
          u["code"]);
      rows.add(item);
    }
    return rows;
  }

  Future<bool> _willPopCallback() async {
    if (widget.from == "bottom") {
      SystemNavigator.pop();
      return true;
    } else {
      Navigator.pop(context);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Material(
        child: Container(
          child: Column(
            children: [
              headerWidget(from: widget.from),
              Expanded(
                flex: 10,
                child: Container(
                  decoration: BoxDecoration(
                      color: CustomColors.GreyColour,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(size.height * 0.05),
                          topRight: Radius.circular(size.height * 0.05))),
                  padding: EdgeInsets.symmetric(horizontal: 25),
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
                              child: Text(
                                  "No Chats! SAY HI FROM FRIENDS PROFILE")),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return chatinfo(
                                message_id: snapshot.data[index].message_id,
                                from: snapshot.data[index].from,
                                to: snapshot.data[index].to,
                                my_id: user_id,
                                owner: snapshot.data[index].owner,
                                content: snapshot.data[index].content,
                                receiver_id: snapshot.data[index].receiver_id,
                                first_name: snapshot.data[index].first_name,
                                last_name: snapshot.data[index].last_name,
                                receiver_avatar:
                                    snapshot.data[index].receiver_avatar);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class chatinfo extends StatelessWidget {
  String message_id,
      from,
      to,
      my_id,
      owner,
      content,
      receiver_id,
      first_name,
      last_name,
      receiver_avatar;
  chatinfo({
    required this.message_id,
    required this.from,
    required this.to,
    required this.my_id,
    required this.owner,
    required this.content,
    required this.receiver_id,
    required this.first_name,
    required this.last_name,
    required this.receiver_avatar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => new SingleUserChat(
                  from: from,
                  to: to,
                  my_id: my_id,
                  receiver_id: receiver_id,
                  receiver_avatar: receiver_avatar,
                  first_name: first_name,
                  last_name: last_name));
          Navigator.of(context).push(route);
        },
        child: Row(
          children: [
            if (receiver_avatar == "Empty")
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              AssetImage("assets/images/default_avatar.png"))),
                ),
              ),
            if (receiver_avatar != "Empty")
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(receiver_avatar)),
                    color: CustomColors.DarkBlueColour,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                          text: first_name + " " + last_name,
                          fontsize: 0.025,
                          isbold: true,
                          color: CustomColors.darkGreyColor,
                          textalign: TextAlign.start),
                      CustomTextWidget(
                          text: content,
                          fontsize: 0.02,
                          isbold: true,
                          color: CustomColors.darkGreyColor.withOpacity(0.5),
                          textalign: TextAlign.start)
                    ],
                  ),
                )),
            Expanded(
                child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColors.DarkBlueColour))),
          ],
        ),
      ),
    );
  }
}

class headerWidget extends StatelessWidget {
  String from;
  headerWidget({
    required this.from,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    print(from);
                    if (from == "bottom") {
                      var snackBar = SnackBar(content: Text("Navigate using bottom bar OR press Home button to exit"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: CustomColors.DarkBlueColour,
                  )),
              CustomTextWidget(
                  text: 'Messages',
                  fontsize: 0.025,
                  isbold: true,
                  color: CustomColors.DarkBlueColour,
                  textalign: TextAlign.center),
              // InkWell(
              //   onTap: () {
              //     Navigator.pushNamed(context, AppRoutes.PROFILE);
              //   },
              //   child: Container(

              //     decoration: BoxDecoration(

              //       color: CustomColors.DarkBlueColour,
              //       shape: BoxShape.circle,
              //     ),
              //   ),
              // )
            ],
          ),
        ));
  }
}

class Items {
  final String message_id;
  final String from;
  final String to;
  final String owner;
  final String content;
  final String receiver_id;
  final String first_name;
  final String last_name;
  final String receiver_avatar;
  final String code;
  Items(
      this.message_id,
      this.from,
      this.to,
      this.owner,
      this.content,
      this.receiver_id,
      this.first_name,
      this.last_name,
      this.receiver_avatar,
      this.code);
}
