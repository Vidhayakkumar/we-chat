import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/model/chat_model.dart';
import 'package:we_chat/model/chat_user_model.dart';

class AppApis {
  static FirebaseAuth auth = FirebaseAuth.instance;

  // instance of firebase storage
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // to return current user
  static get user => auth.currentUser!;
  static late ChatUserModel me;

  // for checking user exits or not?
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // store self Info
  static Future<void> getSelfInfo()async{
     await firestore.collection('users').doc(user.uid).get().then((user) async {

       if(user.exists){
         me = ChatUserModel.fromJson(user.data()!);
       }else{
        //await createUser().then((value)=>getSelfInfo());
       }

     });
  }

  // for creating a new user
  static Future<void> createUser(String name) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUserModel(
        id: user.uid,
        name: name,
        email: user.email.toString(),
        createAt: time,
        lastActive: time,
        image: '',
        pushToken: '',
        about: 'Hy');
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //useful for getting conversionId
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // get all user list

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser(){
    return   firestore.collection('users').where('id',isNotEqualTo: user.uid).snapshots();
  }

  // for getting all messages of a specific conversion from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUserModel chatModel) {
    return firestore
        .collection('chat/${getConversationID(chatModel.id)}/messages')
        .snapshots();
  }

  //for sending messages
  static Future<void> sendMessage(ChatUserModel chatModel, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final ChatModel message = ChatModel(
        toId: chatModel.id,
        msg: msg,
        fromId: user.uid,
        sent: time,
        read: '',
        type: Type.text);

    final ref = firestore
        .collection('chat/${getConversationID(chatModel.id)}/messages');
    ref.doc(time).set(message.toJson());
  }
  
  
  // update profile 
  
  static Future<void> updateProfile()async{
    await   firestore.collection('users').doc(user.uid).update({
      'name' : me.name,
      'about' : me.about
    });
    
  }

  // update readStatusTime
  static Future<void> updateMessageReadStatus(ChatModel message) async {
    try {
      final docRef = firestore
          .collection('chat/${getConversationID(message.fromId!)}/messages')
          .doc(message.sent);

      final docSnap = await docRef.get();

      if (docSnap.exists) {
        await docRef
            .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
      } else {
        print(
            "⚠️ Cannot update 'read' status — message not found in Firestore.");
      }
    } catch (e, st) {
      print("🔥 Error while updating read status: $e\n$st");
    }
  }

  // get only last message for specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUserModel chatUser) {
    return firestore
        .collection('chat/${getConversationID(chatUser.id)}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // get lastMessageTime


}
