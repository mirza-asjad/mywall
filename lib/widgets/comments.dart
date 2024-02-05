import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Comments extends StatelessWidget {
  final String message;
  final String user;
  final String time;
  const Comments(
      {super.key,
      required this.message,
      required this.user,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10,top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message,style: GoogleFonts.poppins(fontWeight: FontWeight.w600),),
              Row(
                children: [
                  Text(user),
                  const Text(' - '),
                  Text(time),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
