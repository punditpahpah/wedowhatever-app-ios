import 'package:flutter/material.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:whatever_ios/widgets/SmallButtonWidget.dart';

class AddNewPostWidget extends StatefulWidget {
  final Size size;

  const AddNewPostWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  _AddNewPostWidget createState() => _AddNewPostWidget();
}

class _AddNewPostWidget extends State<AddNewPostWidget>{
  

  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: widget.size.width * 0.95,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
              text: 'Status Update',
              fontsize: 0.025,
              isbold: true,
              color: Colors.black.withOpacity(0.7),
              textalign: TextAlign.start),
          TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
                hintText: "Whats in your mind today?",
                hintStyle: TextStyle(color: Colors.grey)),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.photo_camera,
                          color: Colors.black,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.theaters,
                          color: Colors.black,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.mic,
                          color: Colors.black,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.attachment,
                          color: Colors.black,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                        child: SmalllButtonWidget(
                            fontsize: 0.02,
                            height: widget.size.height * 0.0001,
                            text: 'Post Update',
                            width: widget.size.width * 0.2,
                            size: widget.size))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

