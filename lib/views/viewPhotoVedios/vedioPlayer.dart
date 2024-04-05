import 'package:better_player/better_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class VedioPlayer extends StatelessWidget {
  VedioPlayer({required this.link, Key? key}) : super(key: key);
  String link;
  @override
  Widget build(BuildContext context) {
    ShowResponse(String Response) {
      var snackBar = SnackBar(content: Text(Response));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

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
          text: 'Video Player',
          textalign: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.download,
                color: CustomColors.DarkBlueColour,
              ),
              onPressed: () {
                // getimg();
                ShowResponse("Loading. Donot leave page until video opens");
                openFile(url: link);
              }),
        ],
      ),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer.network(
          link,
          betterPlayerConfiguration: BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
    Future openFile({required  String url, String? fileName}) async{
    final name= fileName ?? url.split('/').last;
    final file = await downloadFile(url, name);
    if(file==null){
      
      return;
    }   
    
    print('path: ${file.path}');
    OpenFile.open(file.path);
  }
  Future<File?> downloadFile(String url, String name) async{
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try{
    final response = await Dio().get(
       url, 
       options: Options(
         responseType : ResponseType.bytes,
         followRedirects: false,
         receiveTimeout: 0,
       ),
    );
    final raf = file.openSync(
      mode: FileMode.write
    );
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
    }
    catch (e){
      return null;
    }
  }

}
