// ignore_for_file: prefer_const_constructors

import 'package:ecom_app/Controller/Admin/adminChatController.dart';
import 'package:ecom_app/View/Admin/DrawerData.dart';
import 'package:ecom_app/View/Admin/MessageScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListAdmin extends StatefulWidget {
  const ChatListAdmin({super.key});

  @override
  State<ChatListAdmin> createState() => _ChatListAdminState();
}

class _ChatListAdminState extends State<ChatListAdmin> {
  var adminChatController = Get.put(AdminChatController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      adminChatController.getAllChatsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerData(),
      ),
      appBar: AppBar(
        title: Text("Add To Card "),
      ),
      body: Obx(
        () {
          return ListView.builder(
              itemCount: adminChatController.UserChatList.length,
              itemBuilder: (context, index) {
                print(adminChatController.UserChatList[index]);
                return GestureDetector(
                  onTap: () async {
                    var cov_id = await adminChatController.createConservation(
                        adminChatController.UserChatList[index]["SenderId"], adminChatController.UserChatList[index]["SenderName"]);
                    print(cov_id.toString());
                    Get.to(MessageScreenAdmin(
                      recieverId: adminChatController.UserChatList[index]["SenderId"],
                    ));
                  },
                  child: Card(
                    elevation: 1,
                    child: ListTile(
                      title: Text(adminChatController.UserChatList[index]["SenderName"]),
                      subtitle: Text(
                        adminChatController.UserChatList[index]["lastMessage"],
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
