import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/helper/custom_widget/app_apis.dart';
import 'package:we_chat/helper/custom_widget/chat_card_view.dart';
import 'package:we_chat/model/chat_user_model.dart';
import 'package:we_chat/screens/chat_section.dart';

import '../helper/routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<ChatUserModel> userList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("We Chat"),
        leading: const Icon(CupertinoIcons.home),
        actions: [
          IconButton(
            onPressed: () {
              // Optional: Search functionality
            },
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
              } else if (value == 'settings') {
                //Navigator.pushNamed(context, AppRoutes.settingsPage);
              } else if (value == 'about') {
                showAboutDialog(
                  context: context,
                  applicationName: 'We Chat',
                  applicationVersion: '1.0.0',
                  children: [Text('This is a Flutter chat app built using Firebase.')],
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              PopupMenuItem(
                value: 'about',
                child: Text('About'),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],

      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_comment_rounded),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: AppApis.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            final data = snapshot.data?.docs;
            userList = data!
                .map((e) =>
                    ChatUserModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();
             if(userList.isNotEmpty){
               return ListView.builder(
                 itemCount: userList.length,
                 itemBuilder: (context, index) {
                   return InkWell(
                       onTap: (){
                         Navigator.push(context,
                             MaterialPageRoute(builder: (_)=>ChatSection(userList: userList[index])));
                       },
                       child: ChatCardView(userModel: userList[index]));
                 },
               );
             }else{
               return Center(child: Text('Data Not found',style: TextStyle(
                 fontSize: 20
               ),),);
             }
          } else{
            return Center(child: Text("Something find error"),);
          }


        },
      ),
    );
  }
}
