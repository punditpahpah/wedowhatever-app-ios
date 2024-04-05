import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/views/friends/viewProfile.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Alerts extends StatefulWidget {
  Alerts({Key? key}) : super(key: key);

  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  var user_id;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    setState(() {});
  }

  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  Future<List<Items>> GetAlerts() async {
    var url = Uri.parse(Constants.base_url +
        "get_alerts.php?user_id=$user_id&auth_key=" +
        Constants.auth_key);
    var Alerts = await http.get(url);
    var JsonData = json.decode(Alerts.body);
    final List<Items> rows = [];
    //nechy jb future builder wala functions jo hoga listview m os m if snapshot.freindship_status=="accpted" then text would Friends
    // if snapshot.following_status=="1" then text would be Following
    for (var u in JsonData) {
      Items item = Items(u["sender_id"], u["text"], u["sender_first_name"],
          u["sender_last_name"], u["code"]);
      rows.add(item);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
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
          text: 'Alerts',
          textalign: TextAlign.start,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: FutureBuilder(
          future: GetAlerts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.data[0].code == "0") {
              return Container(
                child: Center(child: Text("No Alerts")),
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
                          flex: 2,
                          child: CircleAvatar(
                            child: Image.asset('assets/images/warning.png'),
                            backgroundColor: Colors.white,
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
                                              .data[index].sender_first_name +
                                          " " +
                                          snapshot.data[index].sender_last_name,
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
  final String sender_id;
  final String text;
  final String sender_first_name;
  final String sender_last_name;
  final String code;
  Items(this.sender_id, this.text, this.sender_first_name,
      this.sender_last_name, this.code);
}
