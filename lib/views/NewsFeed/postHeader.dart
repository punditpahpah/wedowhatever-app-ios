import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/views/friends/viewProfile.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class PostHeader extends StatefulWidget {
  String post_id,
      user_first_name,
      user_last_name,
      user_avatar,
      time,
      isShared,
      s_user_first_name,
      user_id,
      logged_in_user_id,
      follow;
  PostHeader({
    required this.post_id,
    required this.user_first_name,
    required this.user_last_name,
    required this.user_avatar,
    required this.time,
    required this.isShared,
    required this.s_user_first_name,
    required this.user_id,
    required this.logged_in_user_id,
    required this.follow,
    Key? key,
  }) : super(key: key);

  @override
  _PostHeaderState createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
  Future Delete() async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    final uri = Uri.parse(Constants.base_url + "delete_post.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['post_id'] = widget.post_id;
    //request.fields['type'] = "profile";
    request.fields['auth_key'] = Constants.auth_key;

    var response = await request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.body == "uploaded") {
          dialog.hide();
          ShowResponse("Post Deleted");
          setState(() {});
        } else if (response.body == "not uploaded") {
          dialog.hide();
          ShowResponse("Post not Deleted");
        } else {
          dialog.hide();
          ShowResponse(response.body);
        }
      });
    });
  }

  Future DoFollow(String action) async {
    final uri = Uri.parse(Constants.base_url + "do_follow.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = widget.user_id;
    request.fields['l_user_id'] = widget.logged_in_user_id;
    request.fields['action'] = action;
    request.fields['auth_key'] = Constants.auth_key;
    //request.fields['type'] = "profile";

    var response = await request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.body == "done") {
          
          ShowResponse("Followed");
          setState(() {});
        } else if (response.body == "done1") {
          
          ShowResponse("Un Followed");
        }
      });
    });
  }

  ShowResponse(String Response) {
    var snackBar = SnackBar(content: Text(Response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new ViewProfile(
                        id: widget.user_id,
                        from: "friend",
                      ));
              Navigator.of(context).push(route);
            },
            child: Container(
              width: 50.0,
              height: 50.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.user_avatar),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
            flex: 6,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isShared == "yes")
                    CustomTextWidget(
                        text: widget.user_first_name +
                            " " +
                            widget.user_last_name +
                            ' shared ' +
                            widget.s_user_first_name +
                            '\'s post',
                        fontsize: 0.025,
                        isbold: true,
                        color: Colors.black,
                        textalign: TextAlign.start),
                  if (widget.isShared == "no")
                    CustomTextWidget(
                        text: widget.user_first_name +
                            " " +
                            widget.user_last_name,
                        fontsize: 0.025,
                        isbold: true,
                        color: Colors.black,
                        textalign: TextAlign.start),
                  CustomTextWidget(
                      text: 'Posted ' + widget.time,
                      fontsize: 0.015,
                      isbold: true,
                      color: CustomColors.darkGreyColor.withOpacity(0.7),
                      textalign: TextAlign.start),
                ],
              ),
            )),
        if (widget.user_id != widget.logged_in_user_id)
          Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  if (widget.follow == "Follow") {
                    DoFollow("1");
                    setState(() {
                      widget.follow = "Un Follow";
                    });
                  } else {
                    DoFollow("0");
                    setState(() {
                      widget.follow = "Follow";
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(
                          color: CustomColors.darkGreyColor.withOpacity(0.7),
                          width: 1.5)),
                  child: Center(
                    child: CustomTextWidget(
                        text: widget.follow,
                        fontsize: 0.015,
                        isbold: true,
                        color: Colors.black,
                        textalign: TextAlign.center),
                  ),
                ),
              )),
        if (widget.user_id == widget.logged_in_user_id)
          Expanded(
              flex: 0,
              child: GestureDetector(
                onTap: () {
                  if (widget.follow == "Follow") {
                    setState(() {
                      widget.follow = "Un Follow";
                    });
                  } else {
                    setState(() {
                      widget.follow = "Follow";
                    });
                  }
                },
                child: Container(
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        Delete();
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.black,
                    ),
                  ),
                ),
              )),
      ],
    );
  }
}
