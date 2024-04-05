//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/views/NewsFeed/postHeader.dart';
import 'package:whatever_ios/views/comments/comments.dart';
import 'package:whatever_ios/views/friends/viewProfile.dart';
import 'package:whatever_ios/views/viewPhotoVedios/vedioPlayer.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:whatever_ios/widgets/SmallButtonWidget.dart';
import 'package:whatever_ios/widgets/TextFormFieldWidget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:better_player/better_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class PostWidget extends StatefulWidget {
  final Size size;
  final int index;
  String isShared;
  String post_id,
      user_id,
      user_first_name,
      user_last_name,
      user_avatar,
      text,
      time,
      is_liked,
      post_image,
      post_video,
      post_audio,
      s_user_id,
      s_user_first_name,
      s_user_last_name,
      s_user_avatar,
      s_post_image,
      follow,
      likes,
      comments,
      code,
      logged_in_user_id;

  PostWidget({
    Key? key,
    required this.size,
    required this.index,
    required this.isShared,
    required this.post_id,
    required this.user_id,
    required this.user_first_name,
    required this.user_last_name,
    required this.user_avatar,
    required this.text,
    required this.time,
    required this.is_liked,
    required this.post_image,
    required this.post_video,
    required this.post_audio,
    required this.s_user_id,
    required this.s_user_first_name,
    required this.s_user_last_name,
    required this.s_user_avatar,
    required this.s_post_image,
    required this.follow,
    required this.likes,
    required this.comments,
    required this.code,
    required this.logged_in_user_id,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  TextEditingController room_name_controller = new TextEditingController();

  Future Share(String PostText, String post_id, String user_id) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    final uri = Uri.parse(Constants.base_url + "do_share.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['post_id'] = post_id;
    request.fields['user_id'] = user_id;
    request.fields['text'] = PostText;
    //request.fields['type'] = "profile";
    request.fields['auth_key'] = Constants.auth_key;

    var response = await request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.body == "uploaded") {
          dialog.hide();
          ShowResponse("Post Shared");
          setState(() {});
        } else if (response.body == "not uploaded") {
          dialog.hide();
          ShowResponse("Post not shared");
        } else {
          dialog.hide();
          ShowResponse(response.body);
        }
      });
    });
  }

  Future DoLike(String action) async {
    final uri = Uri.parse(Constants.base_url + "do_like.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['post_id'] = widget.post_id;
    request.fields['user_id'] = widget.logged_in_user_id;
    request.fields['action'] = action;
    request.fields['auth_key'] = Constants.auth_key;
    //request.fields['type'] = "profile";

    var response = await request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.body == "done") {
          ShowResponse("Liked");
          setState(() {});
        } else if (response.body == "done1") {
          ShowResponse("Disliked");
        }
      });
    });
  }

  ShowResponse(String Response) {
    var snackBar = SnackBar(content: Text(Response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String CurrentAudio = "";

  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      // decoration: BoxDecoration(
      //   gradient: new LinearGradient(
      //       stops: [0.01, 0.01],
      //       colors: [CustomColors.DarkBlueColour, Colors.white]),
      //   color: Colors.white,
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(10),
      //   ),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: PostHeader(
                post_id: widget.post_id,
                user_first_name: widget.user_first_name,
                user_last_name: widget.user_last_name,
                user_avatar: widget.user_avatar,
                time: widget.time,
                isShared: widget.isShared,
                s_user_first_name: widget.s_user_first_name,
                user_id: widget.user_id,
                logged_in_user_id: widget.logged_in_user_id,
                follow: widget.follow),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Divider(
              height: 2,
              color: CustomColors.GreyColour,
            ),
          ),
          if (widget.text != "empty")
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomTextWidget(
                  text: widget.text,
                  fontsize: 0.020,
                  isbold: true,
                  color: CustomColors.darkGreyColor,
                  textalign: TextAlign.start),
            ),
          if (widget.isShared == "yes")
            GestureDetector(
              onTap: () {
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new ViewProfile(
                          id: widget.s_user_id,
                          from: "friend",
                        ));
                Navigator.of(context).push(route);
              },
              child: Container(
                margin: EdgeInsets.all(20),
                color: CustomColors.GreyColour,
                child: Row(
                  children: [
                    if (widget.s_post_image != "empty")
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/loading.gif',
                              image: widget.s_post_image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        flex: 4,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                  text: widget.s_user_first_name +
                                      ' ' +
                                      widget.s_user_last_name +
                                      '\'s post',
                                  fontsize: 0.018,
                                  isbold: true,
                                  color: CustomColors.darkGreyColor,
                                  textalign: TextAlign.start),
                              Row(
                                children: [
                                  CustomTextWidget(
                                      text: 'view Post',
                                      fontsize: 0.015,
                                      isbold: true,
                                      color: Colors.redAccent,
                                      textalign: TextAlign.start),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          if (widget.post_image != "empty" && widget.isShared != "yes")
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/loading.gif',
                  image: widget.post_image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (widget.post_video != "empty" && widget.isShared != "yes")
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: GestureDetector(
                onTap: () {
                  var route = new MaterialPageRoute(
                      builder: (BuildContext context) => new VedioPlayer(
                            link: widget.post_video,
                          ));
                  Navigator.of(context).push(route);
                },
                child: Image.asset("assets/images/video-placeholder.jpg",
                    fit: BoxFit.cover),
              ),
            ),
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 10),
          //   child: AspectRatio(
          //     aspectRatio: 16 / 9,
          //     child: BetterPlayer.network(
          //       widget.post_video,
          //       betterPlayerConfiguration: BetterPlayerConfiguration(
          //         aspectRatio: 16 / 9,
          //       ),
          //     ),
          //   ),
          // ),
          if (widget.post_audio != "empty" && widget.isShared != "yes")
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  slider(),
                  GestureDetector(
                    onTap: () {
                      GetAudio(widget.post_audio);
                    },
                    child: Icon(
                      playing == false
                          ? Icons.play_circle_outline
                          : Icons.pause_circle_outline,
                      size: 100,
                      color: CustomColors.darkGreyColor,
                    ),
                  )
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.user_id != widget.logged_in_user_id)
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        CreateAlertDialog(BuildContext context) {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Enter Something"),
                                  content: TextField(
                                    controller: room_name_controller,
                                  ),
                                  actions: [
                                    MaterialButton(
                                      elevation: 5.0,
                                      child: Text("Continue"),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        Share(
                                            room_name_controller.text,
                                            widget.post_id,
                                            widget.logged_in_user_id);
                                      },
                                    )
                                  ],
                                );
                              });
                        }

                        CreateAlertDialog(context);
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: CustomColors.DarkBlueColour),
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.share,
                              color: CustomColors.DarkBlueColour,
                              size: 20,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            CustomTextWidget(
                                text: 'Share',
                                fontsize: 0.015,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center)
                          ],
                        ),
                      ),
                    ),
                  ),
                Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.is_liked == "Liked") {
                          DoLike("0");
                        } else {
                          DoLike("1");
                        }
                        if (widget.is_liked == "Like") {
                          setState(() {
                            widget.is_liked = "Liked";
                            var likes = int.parse(widget.likes) + 1;
                            widget.likes = likes.toString();
                          });
                        } else {
                          setState(() {
                            widget.is_liked = "Like";
                            var likes = int.parse(widget.likes) - 1;
                            widget.likes = likes.toString();
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2, color: CustomColors.DarkBlueColour),
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.thumb_up,
                              color: CustomColors.Darkblue,
                              size: 20,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            CustomTextWidget(
                                text: widget.is_liked,
                                fontsize: 0.015,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ],
                        ),
                      ),
                    )),
                Spacer(),
                Expanded(
                    flex: 5,
                    child: Container(
                      child: CustomTextWidget(
                        textalign: TextAlign.center,
                        fontsize: 0.018,
                        color: CustomColors.darkGreyColor.withOpacity(0.8),
                        isbold: false,
                        text: widget.likes +
                            ' likes -' +
                            widget.comments +
                            ' comments',
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new Comments(post_id: widget.post_id));
                    Navigator.of(context).push(route);
                  },
                  child: Container(
                    child: SmalllButtonWidget(
                        fontsize: 0.02,
                        height: 0.06,
                        text: 'Comments',
                        width: widget.size.width * 0.2,
                        size: widget.size),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget slider() {
    return Slider.adaptive(
        min: 0.0,
        value: position.inSeconds.toDouble(),
        max: duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            audioPlayer.seek(new Duration(seconds: value.toInt()));
          });
        });
  }

  void GetAudio(String url) async {
    // var snackBar = SnackBar(content: Text(playing.toString()));
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //var url="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
    //var res= await audioPlayer.play(url);

    if (CurrentAudio == "") {
      if (playing) {
        var res = await audioPlayer.pause();
        if (res == 1) {
          setState(() {
            playing = false;
          });
        }
      } else {
        var res = await audioPlayer.play(url);
        if (res == 1) {
          setState(() {
            playing = true;
          });
        }
      }
      audioPlayer.onDurationChanged.listen((Duration dd) {
        setState(() {
          duration = dd;
        });
      });
      audioPlayer.onAudioPositionChanged.listen((Duration dd) {
        setState(() {
          position = dd;
        });
      });
    } else {
      if (CurrentAudio == url) {
        if (playing) {
          var res = await audioPlayer.pause();
          if (res == 1) {
            setState(() {
              playing = false;
            });
          }
        } else {
          var res = await audioPlayer.resume();
          if (res == 1) {
            setState(() {
              playing = true;
            });
          }
        }
      } else {
        // var snackBar = SnackBar(content: Text("y"));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        var res = await audioPlayer.stop();
        if (res == 1) {
          setState(() {
            playing = false;
          });
          var res = await audioPlayer.play(url);
          if (res == 1) {
            setState(() {
              playing = true;
            });
          }
        }
      }
    }
  }
}
