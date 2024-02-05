// ignore_for_file: unused_local_variable, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';

class TimeFormatter {
  static String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String period = dateTime.hour < 12 ? 'AM' : 'PM';
    int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";

    //return '$formattedDate at $hour:$minute $period';
    return '$formattedDate';
  }
}
