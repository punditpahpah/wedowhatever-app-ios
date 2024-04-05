import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:open_file/open_file.dart';


class PicView extends StatefulWidget {
  PicView({required this.link, Key? key}) : super(key: key);
  String link;
  @override
  _PicViewState createState() => _PicViewState();
}

class _PicViewState extends State<PicView> {
  // File? image;

  // Future getimg() async {
  //   final img = await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (img == null) {
  //     return;
  //   }

  //   setState(() {
  //     image = File(img.path);
  //   });

  //   if (image != null) {

  //     ProgressDialog dialog = new ProgressDialog(context);
  //     dialog.style(message: 'Please wait...');
  //     await dialog.show();
  //     final uri = Uri.parse(Constants.base_url + "update_profile_img.php");
  //     var request = http.MultipartRequest('POST', uri);
  //     request.fields['user_id'] = widget.user_id;
  //     request.fields['type'] = "profile";
  //     request.fields['auth_key'] = Constants.auth_key;
  //     if (image == null) {
  //       return;
  //     }
  //     var pic = await http.MultipartFile.fromPath("image", File(img.path).path);
  //     request.files.add(pic);

  //     var response = await request.send().then((result) async {
  //       http.Response.fromStream(result).then((response) {
  //         if (response.body == "uploaded") {
  //           dialog.hide();
  //           ShowResponse("Profile updated");
  //           setState(() {
  //             GetProfileData();
  //           });

  //         } else if (response.body == "not uploaded") {
  //           dialog.hide();
  //           ShowResponse("not uploaded");
  //         } else {
  //           dialog.hide();
  //           ShowResponse(response.body);
  //         }
  //         image = null;
  //       });
  //     });
  //   }
  // }

  // ShowResponse(String Response) {
  //   var snackBar = SnackBar(content: Text(Response));
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  String user_profile = "https://i.stack.imgur.com/y9DpT.jpg";
  // Future GetProfileData() async {
  //   var ProfilePhoto = await http.get(Uri.parse(Constants.base_url +
  //       "get_profile_data.php?user_id=" +
  //       widget.user_id +
  //       "&auth_key=" +
  //       Constants.auth_key));

  //   var data = json.decode(ProfilePhoto.body);

  //   user_profile = data[0]['user_profile_image'];
  //   setState(() {});
  // }

  @override
  void initState() {
    //GetProfileData();

    super.initState();
  }

  Future<String> _getPathToDownload() async {
    return ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
  }

  // Future<String> downloadFile() async {
  //   HttpClient httpClient = new HttpClient();
  //   File file;
  //   String filePath = '';
  //   String myUrl = '';
  //   final String path = await _getPathToDownload();
  //   try {
  //     myUrl = widget.link + '/' + 'assad';
  //     var request = await httpClient.getUrl(Uri.parse(myUrl));
  //     var response = await request.close();
  //     if (response.statusCode == 200) {
  //       var bytes = await consolidateHttpClientResponseBytes(response);
  //       filePath = '$path/Assad';
  //       file = File(filePath);
  //       await file.writeAsBytes(bytes);
  //     } else
  //       filePath = 'Error code: ' + response.statusCode.toString();
  //   } catch (ex) {
  //     filePath = 'Can not fetch url';
  //   }

  //   return filePath;
  // }

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
          text: 'Image Viewer',
          textalign: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.download,
                color: CustomColors.DarkBlueColour,
              ),
              onPressed: () {
                ShowResponse("Loading. Donot leave page until photo opens");
                openFile(url:widget.link);
                
                
              }),
        ],
      ),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/loading.gif',
            image: widget.link,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  ShowResponse(String Response) {
    var snackBar = SnackBar(content: Text(Response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
