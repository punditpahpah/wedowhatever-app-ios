import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:whatever_ios/widgets/SmallButtonWidget.dart';
import 'package:whatever_ios/widgets/TextFormFieldWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class UpdateProfile extends StatefulWidget {
  UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _FirstNameController = TextEditingController();
  final _LastNameController = TextEditingController();
  final _EmailController = TextEditingController();
  final _CPassController = TextEditingController();
  final _NPassController = TextEditingController();
  final _CNPassController = TextEditingController();
  final _CompanyController = TextEditingController();
  final _PhoneController = TextEditingController();
  final _AddressController = TextEditingController();
  final _CityController = TextEditingController();
  final _PostCodeController = TextEditingController();
  final _StateController = TextEditingController();
  final _CountryController = TextEditingController();
  final _AboutController = TextEditingController();
  final _StatusController = TextEditingController();
  final _ShowStatusController = TextEditingController();
  final _GenderController = TextEditingController();

  var pref_user_id,
      pref_user_firstname,
      pref_user_lastname,
      pref_user_email,
      pref_user_password;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pref_user_id = prefs.getString('user_id');
    pref_user_lastname = prefs.getString('user_lastname');
    pref_user_firstname = prefs.getString('user_firstname');
    pref_user_email = prefs.getString('email');
    pref_user_password = prefs.getString('user_password');
    setState(() {});
    GetProfileData();
  }

  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  Future GetProfileData() async {
    var User = await http.get(Uri.parse(Constants.base_url +
        "get_all_data.php?user_id=" +
        pref_user_id +
        "&auth_key=" +
        Constants.auth_key));

    var data = json.decode(User.body);

    _FirstNameController.text = data[0]['user_first_name'];
    _LastNameController.text = data[0]['user_last_name'];
    _EmailController.text = data[0]['user_email'];
    //user_profile_image = data[0]['user_profile_image'];
    _PhoneController.text = data[0]['user_phone'];
    _AddressController.text = data[0]['user_address'];
    _CityController.text = data[0]['user_city'];
    _PostCodeController.text = data[0]['user_zip'];
    _StateController.text = data[0]['user_state'];
    //user_gender = data[0]['user_gender'];
    _CompanyController.text = data[0]['user_company'];
    //user_phone = data[0]['user_status'];
    //user_phone = data[0]['user_settings_status'];
    //user_cover_image = data[0]['user_cover_image'];
    //user_status = data[0]['user_status'];
    //user_visibility = data[0]['user_visibility'];
    _AboutController.text = data[0]['user_about'];
    _StatusController.text = data[0]['user_status'];
    _ShowStatusController.text = data[0]['user_settings_status'];
    _GenderController.text = data[0]['user_gender'];
    setState(() {});
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  //Register Function Start
  Future Update(
      String first_name,
      String last_name,
      String email,
      String c_pass,
      String n_pass,
      String company,
      String phone,
      String address,
      String city,
      String post_code,
      String state,
      String country,
      String about,
      String status,
      String show_status,
      String gender) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(Constants.base_url + "update_profile.php");
    var response = await http.post(url, body: {
      "user_id": pref_user_id,
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "c_password": c_pass,
      "new_pass": n_pass,
      "company": company,
      "phone": phone,
      "address": address,
      "city": city,
      "post_code": post_code,
      "state": state,
      "country": country,
      "about": about,
      "status": status,
      "show_status": show_status,
      "gender": gender,
      "auth_key": Constants.auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      ShowResponse("Updated Successfully");
    } else if (code == "0") {
      ShowResponse("Current password does not match");
    } else {
      ShowResponse(response.body.toString());
    }
    await dialog.hide();
  }

  //Register Function End
  //Show Response Functions Start
  ShowResponse(String Response) {
    var snackBar = SnackBar(content: Text(Response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
          text: 'Update Profile',
          textalign: TextAlign.start,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              TextFieldWidget(
                  Tcontroller: _FirstNameController,
                  labeltext: 'First Name',
                  obscure: false,
                  lines: 1,
                  enabled: true),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _LastNameController,
                labeltext: 'Last Name',
                obscure: false,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  Tcontroller: _EmailController,
                  labeltext: 'Email',
                  obscure: false,
                  lines: 1,
                  enabled: false),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _CPassController,
                labeltext: 'Current Password',
                obscure: true,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _NPassController,
                labeltext: 'New Password',
                obscure: true,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _CNPassController,
                labeltext: 'Confirm New Password',
                obscure: true,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _CompanyController,
                labeltext: 'Company',
                obscure: false,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _PhoneController,
                labeltext: 'Phone Number',
                obscure: false,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _AddressController,
                labeltext: 'Address',
                obscure: false,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _CityController,
                labeltext: 'City',
                obscure: false,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _PostCodeController,
                labeltext: 'Post Code',
                obscure: false,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _StateController,
                labeltext: 'State',
                obscure: false,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _CountryController,
                labeltext: 'Country',
                obscure: false,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                Tcontroller: _AboutController,
                labeltext: 'About',
                obscure: false,
                lines: 1,
                enabled: true,
              ),
              SizedBox(
                height: 20,
              ),
              DropDownField(
                controller: _GenderController,
                required: true,
                strict: true,
                enabled: true,
                labelText: 'Gender',
                icon: Icon(Icons.person),
                items: genderList,
                setter: (dynamic newValue) {
                  _GenderController.text = newValue;
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropDownField(
                controller: _StatusController,
                required: true,
                strict: true,
                enabled: true,
                labelText: 'Status',
                icon: Icon(Icons.select_all),
                items: statusList,
                setter: (dynamic newValue) {
                  _StatusController.text = newValue;
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropDownField(
                controller: _ShowStatusController,
                required: true,
                strict: true,
                enabled: true,
                labelText: 'Show Online Status',
                icon: Icon(Icons.select_all),
                items: showStatusList,
                setter: (dynamic newValue) {
                  _ShowStatusController.text = newValue;
                },
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  var _first_name = _FirstNameController.text;
                  var _last_name = _LastNameController.text;
                  var _email = _EmailController.text;
                  var _c_password = _CPassController.text;
                  var _n_password = _NPassController.text;
                  var _cn_password = _CNPassController.text;
                  var _company = _CompanyController.text;
                  var _phone = _PhoneController.text;
                  var _address = _AddressController.text;
                  var _city = _CityController.text;
                  var _post_code = _PostCodeController.text;
                  var _state = _StateController.text;
                  var _country = _CountryController.text;
                  var _about = _AboutController.text;
                  var _status = _StatusController.text;
                  var _show_status = _ShowStatusController.text;
                  var _gender = _GenderController.text;

                  if (_n_password != _cn_password) {
                    ShowResponse("Password does not match");
                  } else if (_c_password.length < 1) {
                    ShowResponse("Enter current password to update");
                  }
                  else if(_first_name.length<3){
                    ShowResponse("Enter At least 3 characters in First Name");
                  }
                  else if(_last_name.length<3){
                    ShowResponse("Enter Atleast 3 characters in Last Name");
                  }
                  else if(_n_password.length>0){
                    if(_n_password.length<8){
                      ShowResponse("New Password must be 8 characters long");
                    }
                  }
                  else if(_status!="Online" && _status!="Offline" || _show_status!="On" && _show_status!="Off" || _gender!="Male" && _gender!="Female"){
                    ShowResponse("Invalid dropdown value");
                  }
                   else {
                    Update(
                        _first_name,
                        _last_name,
                        _email,
                        _c_password,
                        _n_password,
                        _company,
                        _phone,
                        _address,
                        _city,
                        _post_code,
                        _state,
                        _country,
                        _about,
                        _status,
                        _show_status,
                        _gender);
                  }
                },
                child: SmalllButtonWidget(
                    fontsize: 0.025,
                    height: 0.06,
                    text: 'UPDATE',
                    width: 0.9,
                    size: size),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> statusList = ["Online", "Offline"];
List<String> showStatusList = ["On", "Off"];
List<String> genderList = ["Male", "Female"];
