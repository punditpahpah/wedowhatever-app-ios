import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/views/friends/viewProfile.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';

class Friends extends StatelessWidget {
  Friends({required this.user_id, required this.from, required this.context,Key? key}) : super(key: key);
  String user_id,from;
  Future<List<Items>> GetFriends() async {
    var url = Uri.parse(Constants.base_url +
        "get_conntected_freinds.php?user_id=$user_id&auth_key=" +
        Constants.auth_key);
    var Friends = await http.get(url);
    var JsonData = json.decode(Friends.body);
    final List<Items> rows = [];
    //nechy jb future builder wala functions jo hoga listview m os m if snapshot.freindship_status=="accpted" then text would Friends
    // if snapshot.following_status=="1" then text would be Following
    for (var u in JsonData) {
      Items item = Items(
          u["freind_id"],
          u["freindship_status"],
          u["following_status"],
          u["friend_first_name"],
          u["friend_last_name"],
          u["friend_profile_img"],
          u["code"]);
      rows.add(item);
    }
    return rows;
  }

  BuildContext context;
  Future<bool> _willPopCallback() async {
    if(from=="bottom"){
      SystemNavigator.pop();
      return true;
    }
    else{
      Navigator.pop(context);
      return false;
    }
   
    // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: CustomColors.DarkBlueColour,
            ),
            onPressed: () {
              if (from == "bottom") {
                var snackBar = SnackBar(
                    content: Text(
                        "Navigate using bottom bar OR press Home button to exit"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else{
                Navigator.pop(context);
              }
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: CustomTextWidget(
            color: CustomColors.DarkBlueColour,
            fontsize: 0.025,
            isbold: true,
            text: 'Friends & Following',
            textalign: TextAlign.start,
          ),
        ),
        body: Container(
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
                  child: Center(child: Text("No Friends")),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          if (snapshot.data[index].friend_profile_img ==
                              "Empty")
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: 95,
                                height: 65,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/default_avatar.png"))),
                              ),
                            ),
                          if (snapshot.data[index].friend_profile_img !=
                              "Empty")
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: 95,
                                height: 65,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(snapshot
                                            .data[index].friend_profile_img))),
                              ),
                            ),
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
                                        text: snapshot
                                                .data[index].friend_first_name +
                                            " " +
                                            snapshot
                                                .data[index].friend_last_name,
                                        fontsize: 0.025,
                                        isbold: true,
                                        color: Colors.black,
                                        textalign: TextAlign.start),
                                    CustomTextWidget(
                                        text: snapshot
                                                .data[index].freindship_status +
                                            " " +
                                            snapshot
                                                .data[index].following_status,
                                        fontsize: 0.02,
                                        isbold: true,
                                        color: CustomColors.DarkBlueColour,
                                        textalign: TextAlign.start),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // Get.to(ViewProfile(
                                            //   id: snapshot.data[index].freind_id,
                                            //   from: "friend",
                                            // )); // if you simply call another page you can pass arguments in it...
                                            var route = new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new ViewProfile(
                                                          id: snapshot
                                                              .data[index]
                                                              .freind_id,
                                                          from: "friend",
                                                        ));
                                            Navigator.of(context).push(route);
                                          },
                                          child: CustomTextWidget(
                                              text: 'View Profile',
                                              fontsize: 0.02,
                                              isbold: true,
                                              color:
                                                  CustomColors.DarkBlueColour,
                                              textalign: TextAlign.end),
                                        ),
                                      ],
                                    ),
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
      ),
    );
  }
}

// class FriendWidget extends StatelessWidget {
//   const FriendWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 5),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Container(
//               width: 95,
//               height: 65,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: AssetImage('assets/images/user.jpg'))),
//             ),
//           ),
//           Expanded(
//               flex: 5,
//               child: Container(
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                     color: CustomColors.GreyColour,
//                     borderRadius: BorderRadius.all(Radius.circular(15))),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomTextWidget(
//                         text: 'Josep Fors',
//                         fontsize: 0.025,
//                         isbold: true,
//                         color: Colors.black,
//                         textalign: TextAlign.start),
//                     CustomTextWidget(
//                         text: 'Friends Following',
//                         fontsize: 0.02,
//                         isbold: true,
//                         color: CustomColors.DarkBlueColour,
//                         textalign: TextAlign.start),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Get.to(ViewProfile(
//                               id: "friend_id",
//                               from: "friend",
//                             )); // if you simply call another page you can pass arguments in it...
//                           },
//                           child: CustomTextWidget(
//                               text: 'View Profile',
//                               fontsize: 0.02,
//                               isbold: true,
//                               color: CustomColors.DarkBlueColour,
//                               textalign: TextAlign.end),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ))
//         ],
//       ),
//     );
//   }
// }

class Items {
  final String freind_id;
  final String freindship_status;
  final String following_status;
  final String friend_first_name;
  final String friend_last_name;
  final String friend_profile_img;
  final String code;
  Items(
      this.freind_id,
      this.freindship_status,
      this.following_status,
      this.friend_first_name,
      this.friend_last_name,
      this.friend_profile_img,
      this.code);
}
