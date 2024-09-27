// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/Controller/userController/chatchatController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helper/global.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  ScrollController listScrollController = ScrollController();
  var chatController = Get.put(ChatController());

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      return 'Today, ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      DateTime yesterday = now.subtract(Duration(days: 1));
      if (dateTime.year == yesterday.year && dateTime.month == yesterday.month && dateTime.day == yesterday.day) {
        return 'Yesterday, ${DateFormat('h:mm a').format(dateTime)}';
      } else {
        return DateFormat('MMM d, h:mm a').format(dateTime);
      }
    }
  }

  var stream = FirebaseFirestore.instance
      .collection("message")
      .where("conversation_id", isEqualTo: currentconverstionid.toString())
      .where("status", isEqualTo: true)
      .orderBy("created_at", descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 22,
        ),
        child: Container(
          height: Get.height,
          decoration:
              BoxDecoration(color: Colors.white, border: Border.all(width: 1, color: Color(0xffDCDFE2)), borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: stream,
                      builder: (context, snapshot) {
                        return snapshot.connectionState == ConnectionState.waiting
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : snapshot.data == null
                                ? Text("No chat")
                                : ListView.builder(
                                    reverse: true,
                                    controller: listScrollController,
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      Timestamp? tym = snapshot.data!.docs[index].data()['created_at'];
                                      DateTime? convertedDateTime;
                                      var formattedTime;

                                      if (tym != null) {
                                        convertedDateTime = tym.toDate();
                                        formattedTime = formatDateTime(convertedDateTime);
                                      } else {
                                        formattedTime = 'Sending...';
                                      }
                                      return snapshot.data!.docs[index]["SenderId"] == userId
                                          ? Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              // mainAxisSize: MainAxi
                                              children: [
                                                Container(
                                                  child: Text(
                                                    '${snapshot.data!.docs[index]["message"]}',
                                                    style: TextStyle(color: const Color.fromARGB(255, 12, 12, 12), fontSize: 13),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(formattedTime.toString(), style: TextStyle(fontSize: 10)),
                                                )
                                              ],
                                            )
                                          : Container(
                                              width: Get.width,
                                              margin: EdgeInsets.only(right: 46, bottom: 20),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "NAME",
                                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red),
                                                        ),
                                                        Text(
                                                          '${snapshot.data!.docs[index]["message"]}',
                                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xff0F1033)),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text(formattedTime.toString(),
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                ))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                    },
                                  );
                      })),
              Container(
                width: Get.width,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  // vertical: 16
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 244, 234, 245),
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
                    border: Border.all(width: 1, color: Color(0xffDCDFE2)),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      maxLines: null,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      controller: chatController.message,
                      decoration: InputDecoration(
                          isCollapsed: true,
                          isDense: true,
                          contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 8),
                          border: InputBorder.none,
                          hintText: 'Type your message here...',
                          hintStyle: TextStyle(color: Color(0xffABABAB), fontSize: 13)),
                    )),
                    InkWell(
                        onTap: () async {
                          if (chatController.message.text.isNotEmpty) {
                            chatController.sendMessage(userId, "YF3wTFLNJpNKpw6keTGgWMlDMRI2", chatController.message.text);
                            chatController.message.clear();
                          }
                        },
                        child: Icon(Icons.send))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
