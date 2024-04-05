import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class PhotoPreview extends StatefulWidget {
  PhotoPreview({required this.user_id, Key? key}) : super(key: key);
  String user_id;
  @override
  _PhotoPreviewState createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  File? image;

  Future getimg() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (img == null) {
      return;
    }

    setState(() {
      image = File(img.path);
    });

    if (image != null) {
      
      ProgressDialog dialog = new ProgressDialog(context);
      dialog.style(message: 'Please wait...');
      await dialog.show();
      final uri = Uri.parse(Constants.base_url + "update_profile_img.php");
      var request = http.MultipartRequest('POST', uri);
      request.fields['user_id'] = widget.user_id;
      request.fields['type'] = "profile";
      request.fields['auth_key'] = Constants.auth_key;
      if (image == null) {
        return;
      }
      var pic = await http.MultipartFile.fromPath("image", File(img.path).path);
      request.files.add(pic);

      var response = await request.send().then((result) async {
        http.Response.fromStream(result).then((response) {
          if (response.body == "uploaded") {
            dialog.hide();
            ShowResponse("Profile updated");
            setState(() {
              GetProfileData();
            });
            
          } else if (response.body == "not uploaded") {
            dialog.hide();
            ShowResponse("not uploaded");
          } else {
            dialog.hide();
            ShowResponse(response.body);
          }
          image = null;
        });
      });
    }
  }

  ShowResponse(String Response) {
    var snackBar = SnackBar(content: Text(Response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String user_profile = "https://i.stack.imgur.com/y9DpT.jpg";
  Future GetProfileData() async {
    var ProfilePhoto = await http.get(Uri.parse(Constants.base_url +
        "get_profile_data.php?user_id=" +
        widget.user_id +
        "&auth_key=" +
        Constants.auth_key));

    var data = json.decode(ProfilePhoto.body);

    user_profile = data[0]['user_profile_image'];
    setState(() {});
  }

  @override
  void initState() {
    GetProfileData();

    super.initState();
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
          text: 'Profile',
          textalign: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.edit,
                color: CustomColors.DarkBlueColour,
              ),
              onPressed: () {
                getimg();
              }),
        ],
      ),
      body: Center(
        
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/loading.gif',
            image: user_profile != "Empty"?user_profile :"https://i.stack.imgur.com/y9DpT.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
