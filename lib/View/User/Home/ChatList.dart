// ignore_for_file: prefer_const_constructors

import 'package:ecom_app/Controller/userController/chatchatController.dart';
import 'package:ecom_app/View/User/Home/MessageScreen.dart';
import 'package:ecom_app/View/User/Home/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  var chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerData(),
      ),
      appBar: AppBar(
        title: Text("Add To Card "),
      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                var cov_id = await chatController.createConservation("YF3wTFLNJpNKpw6keTGgWMlDMRI2", "admin");
                print(cov_id.toString());
                Get.to(MessageScreen());
              },
              child: Card(
                elevation: 1,
                child: ListTile(
                  title: Text("Admin Chat"),
                ),
              ),
            );
          }),
    );
  }
}
