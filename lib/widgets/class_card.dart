import 'package:face_net_authentication/models/class.dart';
import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final Class? data;
  final void Function()? onPress;
  final String? message;

  ClassCard({
    super.key,
    this.onPress,
    this.data,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    String status = '';
    if (data!.attendances!.length > 0) {
      if (data!.attendances!.last.status == 'open') {
        status = 'check-in';
      } else {
        status = '';
      }
    } else {
      status = '';
    }
    return GestureDetector(
      onTap: onPress, // Specify your onTap handler here
      child: Container(
        margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
        height: 122,
        decoration: ShapeDecoration(
          color: Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                // width: 49,
                // height: 49,
                margin: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset("assets/class.png").image,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(
                  left: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: " + data!.name),
                    SizedBox(height: 16.0),
                    Text("Description: " + data!.description),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
