// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  TextEditingController message = TextEditingController();
  createConservation(recieverId, name) async {
    var data = await FirebaseFirestore.instance.collection("conversations").get();
    var p = data.docs;
    var con_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("uid");
    var name = prefs.getString("name");

    for (var i = 0; i < p.length; i++) {
      if (p[i]["recieverId"] == recieverId && p[i]["SenderId"] == userId) {
        con_id = p[i].id;
      }
    }

    if (con_id == "") {
      var id = FirebaseFirestore.instance.collection('conversations').doc().id;
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(id)
          .set({"recieverId": recieverId, "recieverName": "Admin", "lastMessage": "", "SenderId": userId, "SenderName": name, "conversation_id": id});
      con_id = id;
    }
    currentconverstionid = con_id;
    return currentconverstionid;
  }

  sendMessage(senderid, receiverid, message) async {
    var messageid = FirebaseFirestore.instance.collection('message').doc().id;
    await FirebaseFirestore.instance.collection('message').doc(messageid).set({
      "message": message,
      "SenderId": senderid,
      "recieverId": receiverid,
      "message_key": messageid,
      "conversation_id": currentconverstionid,
      "status": true,
      "created_at": FieldValue.serverTimestamp(),
    });
  }
}
