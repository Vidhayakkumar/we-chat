import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/auth/login_page.dart';
import 'package:we_chat/helper/custom_widget/app_apis.dart';
import 'package:we_chat/helper/custom_widget/helper.dart';
import 'package:we_chat/helper/custom_widget/myRoundedCstBtn.dart';
import 'package:we_chat/helper/dimension.dart';
import 'package:we_chat/model/chat_user_model.dart';
import 'package:we_chat/screens/HomeScreen.dart';

import '../main.dart';

class ProfileScreen extends StatefulWidget {
  
  final ChatUserModel chatUser;
  
 ProfileScreen({super.key,required this.chatUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: ((_)=>HomeScreen())));
          }, icon: Icon(Icons.arrow_back)),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width *.05),
              child: Column(
                children: [

                  SizedBox(width: mq.width, height: mq.height * .05,),

                  Stack(
                    children: [
                      
                      _image !=null?  ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: Image.file(
                          File(_image!),
                          width: mq.height * .2,
                          height: mq.height * .2,
                          fit: BoxFit.cover,
                        )
                      ):
                      Container(
                        width: AppDimension.width200,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: mq.height * .11,
                          child: Icon(CupertinoIcons.person,color: Colors.white,size: 60,),
                        ),
                      ),

                      Positioned(
                        right: -25,
                        bottom: 20,
                        child: MaterialButton(
                            shape: CircleBorder(),
                            color: Colors.white,
                            onPressed: (){
                              _showBottomSheet();
                            },
                            child: Icon(Icons.edit,color: Colors.blue,),
                        )
                        ,
                      )

                    ],
                  ),

                  mSpacer(),

                  Text(widget.chatUser.email,style: TextStyle(
                    fontSize: 20
                  ),),

                  mSpacer(height: AppDimension.height50),

                  TextFormField(
                    onSaved: (val) => AppApis.me.name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : 'Required field',
                    initialValue: widget.chatUser.name,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person,color: Colors.blue,),
                      focusColor: Colors.blue,
                      hoverColor: Colors.blue,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimension.radius10),
                        borderSide: BorderSide(
                          color: Colors.blue,
                           width: 2,
                        )
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimension.radius10)
                      ),
                      label: Text('Name',style: TextStyle(
                        color: Colors.blue
                      ),)
                    ),
                  ),

                  mSpacer(height: AppDimension.height20),

                  TextFormField(
                    initialValue: widget.chatUser.about ,
                    onSaved: (val) => AppApis.me.about == val,
                    validator: (val) => val != null && val.isNotEmpty? null: "Required filed",
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info_outline,color: Colors.blue,),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimension.radius10),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            )
                        ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimension.radius10)
                      ),
                      label: Text('About',style: TextStyle(
                        color: Colors.blue
                      ),)
                    ),
                  ),
                  mSpacer(height: AppDimension.height30),

                  GestureDetector(
                    onTap: (){
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        AppApis.updateProfile().then((v){
                          showSnackBar(context, 'profile updated successfully');
                        });
                      }
                    },
                    child: MyRoundedCstBtn(
                        width: AppDimension.width125,
                        color: Colors.blue,
                        height: AppDimension.height40,
                        text: 'UPDATE',
                        icon: Icons.edit,
                       iconColor: Colors.white,

                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: (){
            showProgressBar(context);
            AppApis.auth.signOut().then((value){
              Navigator.pop(context);

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginPage()));
            });
          },
          child: MyRoundedCstBtn(
              width: AppDimension.width125-AppDimension.width10,
              color: Colors.redAccent,
              height: AppDimension.height40,
              text: 'Logout',
              iconColor: Colors.white,
              icon: Icons.logout_outlined,
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(){
   showModalBottomSheet(
       context: context,
       backgroundColor: Colors.white,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.only(
           topLeft: Radius.circular(AppDimension.radius10),
           topRight: Radius.circular(AppDimension.radius10)
         )
       ),
       builder: (_){
      return ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding:  EdgeInsets.only(top: AppDimension.height10),
            child: Text('Pick Profile Picture',textAlign: TextAlign.center, style: TextStyle(
              fontSize: AppDimension.font20,
              fontWeight: FontWeight.bold
            ),),
          ),
          mSpacer(height: AppDimension.height20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: Colors.white,
                  fixedSize: Size(mq.width * .3, mq.height * .13)
                ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                    if(image != null){
                     _image= image.path;
                    }
                  },
                  child: Image.asset('assets/images/gallery.png',)
              ),

              ElevatedButton(onPressed: () async {

                final ImagePicker picker = ImagePicker();

                final XFile? image = await picker.pickImage(source:ImageSource.camera );

                if(image != null){
                 setState(() {
                   _image = image.path;
                 });
                }

              },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                    fixedSize: Size(mq.width * .3, mq.height * .13)
                  ),
                  child: Image.asset('assets/images/camara.png')
              ),
            ],
          ),
          mSpacer(height: AppDimension.height20)
        ],
      );
    });
  }

}
