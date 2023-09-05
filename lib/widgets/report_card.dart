import 'package:face_net_authentication/models/report.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ReportCard extends StatelessWidget {
  final Report rp;
  final void Function()? onPressed;

  ReportCard({
    super.key,
    required this.rp,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        
          await launchUrl(Uri.parse(rp.link), mode: LaunchMode.externalApplication);
       
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/report.png',
              width: 30,
              height: 30,
            ),
            Text(rp.check_in_date.toLocal().toString()),
          ],
        ),
      ),
    );
  }
}
