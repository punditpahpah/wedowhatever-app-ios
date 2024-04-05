import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:whatever_ios/widgets/SmallButtonWidget.dart';

class Feeds extends StatefulWidget {
  Feeds({Key? key}) : super(key: key);

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.GreyColour,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          SizedBox(
            width: 10,
          ),
          Image.asset(
            'assets/images/whatever_banner.png',
            width: 100,
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
            color: Colors.black,
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: BetterPlayer.network(
                        "https://media.istockphoto.com/videos/rack-focus-shot-of-a-covid19-driveup-testing-sign-in-the-foreground-video-id1254924259",
                        betterPlayerConfiguration: BetterPlayerConfiguration(
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
