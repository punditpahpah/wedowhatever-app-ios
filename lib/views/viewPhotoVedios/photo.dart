import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/views/NewsFeed/postBody.dart';
import 'package:whatever_ios/views/viewPhotoVedios/pic_view.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Photo extends StatelessWidget {
  Photo({required this.user_id, Key? key}) : super(key: key);
  String user_id;

  Future<List<Items>> GetFriends() async {
    var url = Uri.parse(Constants.base_url +
        "get_all_photos.php?user_id=$user_id&auth_key=" +
        Constants.auth_key);
    var Photos = await http.get(url);
    var JsonData = json.decode(Photos.body);
    final List<Items> rows = [];
    //nechy jb future builder wala functions jo hoga listview m os m if snapshot.freindship_status=="accpted" then text would Friends
    // if snapshot.following_status=="1" then text would be Following
    for (var u in JsonData) {
      Items item = Items(u["photo_url"], u["code"]);
      rows.add(item);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context).size;
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
          text: 'Photos',
          textalign: TextAlign.start,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: GetFriends(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(child: Text("Loading...")),
              );
            } else if (snapshot.data[0].code == "0") {
              return Container(
                child: Center(child: Text("No Photos")),
              );
            } else {
              return StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: GestureDetector(
                      onTap: () {
                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) => new PicView(
                                  link: "https://wedowhatever.com/" +
                                      snapshot.data[index].photo_url,
                                ));
                        Navigator.of(context).push(route);
                      },
                      child: Image.network(
                          "https://wedowhatever.com/" +
                              snapshot.data[index].photo_url,
                          fit: BoxFit.cover),
                    ),
                  );
                },
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              );
            }
          },
        ),
      ),
    );
  }
}

class Items {
  final String photo_url;
  final String code;
  Items(this.photo_url, this.code);
}
