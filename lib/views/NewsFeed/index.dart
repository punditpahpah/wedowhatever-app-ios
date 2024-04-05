import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:whatever_ios/widgets/SmallButtonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'AddNewPost.dart';
import 'postBody.dart';
import 'postHeader.dart';

class NewsFeed extends StatefulWidget {
  String from;
  NewsFeed({required this.from, Key? key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  late ScrollController _controller;

  File? image;
  File? video;
  File? audio;
  var img;
  var vid;
  var aud;

  Future getimg() async {
    img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (img == null) {
      return;
    }

    setState(() {
      image = File(img.path);
    });
  }

  Future SelectFile() async {
    vid = await FilePicker.platform
        .pickFiles(allowMultiple: false, allowCompression: true);
    if (vid == null) {
      return;
    }

    final path = vid.files.single.path!;

    setState(() {
      video = File(path);
    });
  }

  Future SelectAudio() async {
    aud = await FilePicker.platform
        .pickFiles(allowMultiple: false, allowCompression: true);
    if (aud == null) {
      return;
    }

    final path1 = aud.files.single.path!;

    setState(() {
      audio = File(path1);
    });
  }

  Future DoPost(String PostText) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    final uri = Uri.parse(Constants.base_url + "do_post.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = user_id;
    request.fields['text'] = PostText;
    //request.fields['type'] = "profile";
    request.fields['auth_key'] = Constants.auth_key;
    if (image != null) {
      var pic = await http.MultipartFile.fromPath("image", File(img.path).path);
      //var video = await http.MultipartFile.fromPath("video", File(vid.path).path);
      request.files.add(pic);
      //request.files.add(video);
    }
    if (video != null) {
      var video = await http.MultipartFile.fromPath(
          "video", File(vid.files.single.path!).path);

      request.files.add(video);
    }
    if (audio != null) {
      var audio = await http.MultipartFile.fromPath(
          "audio", File(aud.files.single.path!).path);

      request.files.add(audio);
    }

    var response = await request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.body == "uploaded") {
          dialog.hide();
          ShowResponse("Status updated");
          setState(() {});
        } else if (response.body == "not uploaded") {
          dialog.hide();
          ShowResponse("Status not updated");
        } else {
          dialog.hide();
          ShowResponse(response.body);
        }
        image = null;
        video = null;
        audio = null;
      });
    });
  }

  ShowResponse(String Response) {
    var snackBar = SnackBar(content: Text(Response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<List<Items>> GetPosts() async {
    var url = Uri.parse(Constants.base_url +
        "get_posts.php?user_id=$user_id&auth_key=" +
        Constants.auth_key);
    var Posts = await http.get(url);
    var JsonData = json.decode(Posts.body);
    final List<Items> rows = [];
    //nechy jb future builder wala functions jo hoga listview m os m if snapshot.freindship_status=="accpted" then text would Friends
    // if snapshot.following_status=="1" then text would be Following
    for (var u in JsonData) {
      Items item = Items(
          u["post_id"],
          u["user_id"],
          u["user_first_name"],
          u["user_last_name"],
          u["user_avatar"],
          u["text"],
          u["s_user_avatar"],
          u["time"],
          u["is_liked"],
          u["post_image"],
          u["post_video"],
          u["post_audio"],
          u["s_user_id"],
          u["s_user_first_name"],
          u["s_user_last_name"],
          u["s_post_image"],
          u["follow"],
          u["likes"],
          u["comments"],
          u["is_shared"],
          u["code"]);
      rows.add(item);
    }
    return rows;
  }

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
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    getStringValuesSF();
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        maxPosts = maxPosts + 10;
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        if (maxPosts > 10) {
          maxPosts = maxPosts - 10;
        }
      });
    }
  }

  int maxPosts = 10;

  TextEditingController post_text = new TextEditingController();

  Future<bool> _willPopCallback() async {
    if (widget.from == "bottom") {
        ShowResponse("Navigate using bottom bar OR press Home button to exit");
      return false;
    } else {
      Navigator.pop(context);
      return true;
    }

    // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: CustomColors.GreyColour,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            SizedBox(
              width: 10,
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: CustomColors.DarkBlueColour,
              ),
              onPressed: () {
                 _willPopCallback();
              },
            ),
            SizedBox(
              width: 10,
            ),
            Image.asset(
              'assets/images/whatever_banner.png',
              width: 100,
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh),
              color: Colors.black,
            )
          ],
        ),
        body: Container(
          child: ListView(
            controller: _controller,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    if (widget.from != "bottom")
                      Container(
                        padding: EdgeInsets.all(10),
                        width: size.width * 0.95,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                                text: 'Status Update',
                                fontsize: 0.025,
                                isbold: true,
                                color: Colors.black.withOpacity(0.7),
                                textalign: TextAlign.start),
                            TextFormField(
                              controller: post_text,
                              maxLines: 3,
                              decoration: InputDecoration(
                                  hintText: "Whats in your mind today?",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          child: IconButton(
                                            onPressed: () {
                                              getimg();
                                            },
                                            icon: Icon(
                                              Icons.photo_camera,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: IconButton(
                                          onPressed: () {
                                            SelectFile();
                                          },
                                          icon: Icon(
                                            Icons.theaters,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: IconButton(
                                          onPressed: () {
                                            SelectAudio();
                                          },
                                          icon: Icon(
                                            Icons.mic,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: IconButton(
                                          onPressed: () {
                                            CreateAlertDialog(
                                                BuildContext context) {
                                              TextEditingController
                                                  room_name_controller =
                                                  new TextEditingController();
                                              return showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text("Paste link"),
                                                      content: TextField(
                                                        controller:
                                                            room_name_controller,
                                                      ),
                                                      actions: [
                                                        MaterialButton(
                                                          elevation: 5.0,
                                                          child:
                                                              Text("Continue"),
                                                          onPressed: () {
                                                            bool _validURL =
                                                                Uri.parse(room_name_controller
                                                                        .text)
                                                                    .isAbsolute;
                                                            if (_validURL) {
                                                              post_text.text += "" +
                                                                  room_name_controller
                                                                      .text;
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Link is not valid",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }

                                            CreateAlertDialog(context);
                                          },
                                          icon: Icon(
                                            Icons.attachment,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        DoPost(post_text.text);
                                      },
                                      child: Container(
                                        child: SmalllButtonWidget(
                                            fontsize: 0.018,
                                            height: 0.06,
                                            text: 'Post Update',
                                            width: size.width * 0.2,
                                            size: size),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: FutureBuilder(
                        future: GetPosts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (snapshot.data[0].code == "0") {
                            return Container(
                              child: Center(
                                  child: Text(
                                'No Posts',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                            );
                          } else {
                            return ListView.builder(
                              physics:
                                  const NeverScrollableScrollPhysics(), // these two statements are for never scroolable physics coz it is already in listview
                              shrinkWrap: true,
                              itemCount: maxPosts,

                              itemBuilder: (BuildContext context, int index) {
                                return PostWidget(
                                    size: size,
                                    index: index,
                                    isShared: snapshot.data[index].is_shared,
                                    post_id: snapshot.data[index].post_id,
                                    user_id: snapshot.data[index].user_id,
                                    user_first_name:
                                        snapshot.data[index].user_first_name,
                                    user_last_name:
                                        snapshot.data[index].user_last_name,
                                    user_avatar:
                                        snapshot.data[index].user_avatar,
                                    text: snapshot.data[index].text,
                                    time: snapshot.data[index].time,
                                    is_liked: snapshot.data[index].is_liked,
                                    post_image: snapshot.data[index].post_image,
                                    post_video: snapshot.data[index].post_video,
                                    post_audio: snapshot.data[index].post_audio,
                                    s_user_id: snapshot.data[index].s_user_id,
                                    s_user_first_name:
                                        snapshot.data[index].s_user_first_name,
                                    s_user_last_name:
                                        snapshot.data[index].s_user_last_name,
                                    s_user_avatar:
                                        snapshot.data[index].s_user_avatar,
                                    s_post_image:
                                        snapshot.data[index].s_post_image,
                                    follow: snapshot.data[index].follow,
                                    likes: snapshot.data[index].likes,
                                    comments: snapshot.data[index].comments,
                                    code: snapshot.data[index].code,
                                    logged_in_user_id: user_id);
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Items {
  final String post_id;
  final String user_id;
  final String user_first_name;
  final String user_last_name;
  final String user_avatar;
  final String text;
  final String s_user_avatar;
  final String time;
  final String is_liked;
  final String post_image;
  final String post_video;
  final String post_audio;
  final String s_user_id;
  final String s_user_first_name;
  final String s_user_last_name;
  final String s_post_image;
  final String follow;
  final String likes;
  final String comments;
  final String is_shared;
  final String code;
  Items(
      this.post_id,
      this.user_id,
      this.user_first_name,
      this.user_last_name,
      this.user_avatar,
      this.text,
      this.s_user_avatar,
      this.time,
      this.is_liked,
      this.post_image,
      this.post_video,
      this.post_audio,
      this.s_user_id,
      this.s_user_first_name,
      this.s_user_last_name,
      this.s_post_image,
      this.follow,
      this.likes,
      this.comments,
      this.is_shared,
      this.code);
}
