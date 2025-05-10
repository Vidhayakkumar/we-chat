import 'dart:core';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/helper/custom_widget/app_apis.dart';
import 'package:we_chat/helper/custom_widget/chat_card_view.dart';
import 'package:we_chat/model/chat_user_model.dart';
import 'package:we_chat/screens/chat_section.dart';
import 'package:we_chat/screens/profile_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<ChatUserModel> _userList = [];
  final List<ChatUserModel> _searchList = [];

  bool _isSearching =false;

  @override
  void initState() {
    super.initState();
    AppApis.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if(_isSearching){
           setState(() {
             _isSearching = !_isSearching;
           });
           return Future.value(true);
          }else{
            return Future.value(false);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: _isSearching?TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search here.....',
                border: InputBorder.none
              ),

              onChanged: (val){
                _searchList.clear();
                for(var i in _userList){
                  if(i.name.toLowerCase().contains(val.toLowerCase())||
                     i.email.toLowerCase().contains(val.toLowerCase())){
                    _searchList.add(i);
                  }
                }

                setState(() {
                  _searchList;
                });

              },

            ) :Text("We Chat"),
            leading: const Icon(CupertinoIcons.home),
            actions: [
              IconButton(
                onPressed: () {
                  //  Search functionality
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: _isSearching?Icon(Icons.clear):Icon(Icons.search),
              ),
              IconButton(onPressed: (){
               Navigator.pushReplacement(context, MaterialPageRoute(builder: ((_)=>ProfileScreen(chatUser: AppApis.me,))));
              }, icon: Icon(Icons.more_vert))
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
            stream: AppApis.getAllUser(),
            builder: (context, snapshot) {
              // Handle loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                final data = snapshot.data?.docs;
                _userList = data!
                    .map((e) =>
                        ChatUserModel.fromJson(e.data() as Map<String, dynamic>))
                    .toList();
                 if(_userList.isNotEmpty){
                   return ListView.builder(
                     itemCount: _isSearching ? _searchList.length:_userList.length,
                     itemBuilder: (context, index) {
                       return InkWell(
                           onTap: (){
                             Navigator.push(context,
                                 MaterialPageRoute(builder: (_)=>ChatSection(userList: _userList[index])));
                           },
                           child: ChatCardView(userModel: _isSearching? _searchList[index]: _userList[index]));
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
        ),
      ),
    );
  }
}
