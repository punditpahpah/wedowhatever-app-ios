import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatever_ios/routes/app_pages.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/views/friends/index.dart';
import 'package:whatever_ios/views/update_profile/update_profile.dart';
import 'package:whatever_ios/views/viewPhotoVedios/cover_preview.dart';
import 'package:whatever_ios/views/viewPhotoVedios/photo.dart';
import 'package:whatever_ios/views/viewPhotoVedios/photo_preview.dart';
import 'package:whatever_ios/views/viewPhotoVedios/vedio.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';

class ViewProfile extends StatefulWidget {
  ViewProfile({required this.id, required this.from, Key? key})
      : super(key: key);
  String id, from;

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

var user_id, l_id, user_firstname, user_lastname, email;

String user_first_name = "";
String user_last_name = "";
String user_email = "";
String user_profile_image = "";
String user_phone = "";
String user_state = "";
String user_gender = "";
String user_company = "";
String user_cover_image = "";
String user_status = "";
String user_visibility = "";
String user_about = "";
String no_of_friends = "";
String no_of_photos = "";
String no_of_videos = "";
String joined = "";

class _ViewProfileState extends State<ViewProfile> {
  Future GetProfileData() async {
    var Users = await http.get(Uri.parse(Constants.base_url +
        "get_profile_data.php?user_id=" +
        user_id +
        "&auth_key=" +
        Constants.auth_key));

    var data = json.decode(Users.body);

    print("data iss" + data[0]['user_first_name']);

    user_first_name = data[0]['user_first_name'];
    user_last_name = data[0]['user_last_name'];
    user_email = data[0]['user_email'];
    user_profile_image = data[0]['user_profile_image'];
    user_phone = data[0]['user_phone'];
    user_state = data[0]['user_state'];
    user_gender = data[0]['user_gender'];
    user_company = data[0]['user_company'];
    user_cover_image = data[0]['user_cover_image'];
    user_status = data[0]['user_status'];
    user_visibility = data[0]['user_visibility'];
    user_about = data[0]['user_about'];
    no_of_friends = data[0]['no_of_friends'].toString();
    no_of_photos = data[0]['no_of_photos'].toString();
    no_of_videos = data[0]['no_of_videos'].toString();
    joined = data[0]['joined'].toString();
    setState(() {
      visible = true;
    });
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    user_lastname = prefs.getString('user_lastname');
    user_firstname = prefs.getString('user_firstname');
    email = prefs.getString('email');
    GetProfileData();
    setState(() {});
  }

  StringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    l_id = prefs.getString('user_id');
    setState(() {});
  }

  @override
  void initState() {
    StringValuesSF();

    if (widget.from == "friend") {
      user_id = widget.id;
      GetProfileData();
    } else {
      getStringValuesSF();
    }
    super.initState();
  }

  bool visible = false;

  //Login Function End
  //Show Response Functions Start

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
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: CustomTextWidget(
          color: CustomColors.DarkBlueColour,
          fontsize: 0.025,
          isbold: true,
          text: 'Profile',
          textalign: TextAlign.start,
        ),
      ),
      body: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: Duration(milliseconds: 1000),
        child: Container(
          width: size.width * 1,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              UpperWidget(
                size: size,
                from: widget.from,
                id: widget.id,
              ),
              Expanded(
                  flex: 7,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconWidget(
                                  text: 'Friends',
                                  value: no_of_friends,
                                  iconData: Icons.group_outlined),
                              IconWidget(
                                  text: 'Photos',
                                  value: no_of_photos,
                                  iconData: Icons.photo),
                              IconWidget(
                                  text: 'Videos',
                                  value: no_of_videos,
                                  iconData: Icons.video_label),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextWidget(
                              text: 'About',
                              fontsize: 0.03,
                              isbold: true,
                              color: CustomColors.DarkBlueColour,
                              textalign: TextAlign.start),
                          SizedBox(
                            height: 10,
                          ),
                          InfoTextWidget(
                            label: 'Name:',
                            value: user_first_name + " " + user_last_name,
                          ),
                          InfoTextWidget(label: 'Status:', value: user_status),
                          InfoTextWidget(
                              label: 'Visibility:', value: user_visibility),
                          InfoTextWidget(
                            label: 'Company:',
                            value: user_company,
                          ),
                          InfoTextWidget(
                            label: 'Email:',
                            value: user_email,
                          ),
                          InfoTextWidget(
                            label: 'Phone:',
                            value: user_phone,
                          ),
                          InfoTextWidget(
                            label: 'Gender:',
                            value: user_gender,
                          ),
                          InfoTextWidget(
                            label: 'Lives in:',
                            value: user_state,
                          ),
                          InfoTextWidget(
                            label: 'Joined:',
                            value: joined,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextWidget(
                              text: 'Description',
                              fontsize: 0.03,
                              isbold: true,
                              color: CustomColors.DarkBlueColour,
                              textalign: TextAlign.start),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextWidget(
                              text: user_about,
                              fontsize: 0.025,
                              isbold: true,
                              color: Colors.black,
                              textalign: TextAlign.start),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoTextWidget extends StatelessWidget {
  InfoTextWidget({
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);
  String label, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          CustomTextWidget(
              text: label,
              fontsize: 0.023,
              isbold: true,
              color: Colors.black,
              textalign: TextAlign.start),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: CustomTextWidget(
                text: value,
                fontsize: 0.022,
                isbold: true,
                color: Colors.black,
                textalign: TextAlign.start),
          )
        ],
      ),
    );
  }
}

class IconWidget extends StatelessWidget {
  IconWidget({
    required this.text,
    required this.value,
    required this.iconData,
    Key? key,
  }) : super(key: key);

  String text;
  String value;
  IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      child: InkWell(
        onTap: () {
          if (text == "Photos") {
            var route = new MaterialPageRoute(
                builder: (BuildContext context) => new Photo(user_id: user_id));
            Navigator.of(context).push(route);
          } else if (text == "Friends") {
            var route = new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new Friends(user_id: user_id,from:"top", context: context));
            Navigator.of(context).push(route);
          } else if (text == "Videos") {
            var route = new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new Videos(user_id: user_id));
            Navigator.of(context).push(route);
          }
        },
        child: Column(
          children: [
            Icon(
              iconData,
              size: 35,
            ),
            CustomTextWidget(
                text: text + ' (' + value + ')',
                fontsize: 0.02,
                isbold: true,
                color: Colors.black,
                textalign: TextAlign.center)
          ],
        ),
      ),
    ));
  }
}

class UpperWidget extends StatelessWidget {
  Future Greet() async {
    //ProgressDialog dialog = new ProgressDialog(context);
    // dialog.style(message: 'Please wait...');
    //await dialog.show();
    var url = Uri.parse(Constants.base_url + "send_greetings.php");
    var response = await http.post(url, body: {
      "sender_id": l_id,
      "receiver_id": id,
      "auth_key": Constants.auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      ShowResponse("Greetings sent");

      //await dialog.hide();
    } else if (code == "0") {
      //ShowResponse("Not sent");
    } else {
      // ShowResponse(response.body.toString());
    }
    //await dialog.hide();
  }

  ShowResponse(String Response) {
    Fluttertoast.showToast(
        msg: "Greetings sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CustomColors.darkGreyColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  UpperWidget({
    Key? key,
    required this.size,
    required this.id,
    required this.from,
  }) : super(key: key);

  Size size;
  String id, from;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 5,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      flex: 5,
                      child: GestureDetector(
                        onTap: () {
                          if (from != "friend") {
                            var route = new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new CoverPreview(user_id: user_id));
                            Navigator.of(context).push(route);
                          }
                        },
                        child: Container(
                          width: size.width * 1,
                          child: Stack(
                            children: [
                              Container(
                                width: size.width * 1,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  child: CachedNetworkImage(
                                    imageUrl: user_cover_image,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              id == "logged_in_user_id"
                                  ? Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          var route = new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new UpdateProfile());
                                          Navigator.of(context).push(route);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color:
                                                  CustomColors.DarkBlueColour,
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          Greet();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: CustomColors.DarkBlueColour,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                          ),
                                          child: CustomTextWidget(
                                            color: Colors.white,
                                            fontsize: 0.025,
                                            isbold: false,
                                            text: 'SAY HI',
                                            textalign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      )),
                  Expanded(flex: 2, child: Container())
                ],
              ),
              Column(
                children: [
                  Expanded(flex: 2, child: Container()),
                  Expanded(
                      flex: 2,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            if (user_profile_image == "Empty")
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (from != "friend") {
                                      var route = new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new PhotoPreview(
                                                  user_id: user_id));
                                      Navigator.of(context).push(route);
                                    }
                                  },
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "assets/images/default_avatar.png"))),
                                  ),
                                ),
                              ),
                            if (user_profile_image != "Empty")
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (from != "friend") {
                                      var route = new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new PhotoPreview(
                                                  user_id: user_id));
                                      Navigator.of(context).push(route);
                                    }
                                  },
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                user_profile_image))),
                                  ),
                                ),
                              ),
                            Expanded(child: Container()),
                          ],
                        ),
                      )),
                  CustomTextWidget(
                      text: user_first_name + " " + user_last_name,
                      fontsize: 0.03,
                      isbold: true,
                      color: Colors.black,
                      textalign: TextAlign.center),
                ],
              )
            ],
          ),
        ));
  }
}
