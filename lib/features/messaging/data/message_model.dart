import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Message {
  final String sender;
  final String receiver;
  final String message;
  FieldValue  timestamp;
  final String photoUrl;
  final int  type;  // 0 - Plain text message, 1 - Image, 2 - Image with text
  Message({
   @required this.sender,
   @required this.receiver,
   @required this.message,
   @required this.timestamp,
   @required this.type,
    this.photoUrl
  });
  
  

}
