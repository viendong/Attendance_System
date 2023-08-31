import 'package:face_net_authentication/models/member.dart';
import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final void Function()? onPressed;
  final bool showDelete;

  MemberCard({
    super.key,
    required this.member,
    this.onPressed,
    this.showDelete = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(member.name + ' (' + member.email + ')'),
          if (showDelete)
            IconButton(
              onPressed: this.onPressed,
              icon: Icon(Icons.delete),
            ),
        ],
      ),
    );
  }
}
