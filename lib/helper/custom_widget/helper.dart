import 'package:flutter/material.dart';
import 'package:we_chat/helper/dimension.dart';

InputDecoration getInputTextFieldDecoration({
  required String hint
}) {
  return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimension.radius10),
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimension.radius10),
          borderSide: BorderSide(color: Colors.grey)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimension.radius10),
          borderSide: BorderSide(color: Colors.grey)));
}

mSpacer({double width = 0, double height = 0}) => SizedBox(
      width: width == 0 ? AppDimension.width10 : width,
      height: height == 0 ? AppDimension.height10 : height,
    );


void showSnackBar(BuildContext context, String msg){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg,style: TextStyle(
    color: Colors.white
  ),),
    backgroundColor: Colors.blueGrey,
    behavior: SnackBarBehavior.floating,
  ));
}

void showProgressBar(BuildContext context){
  showDialog(context: context, builder: (_)=>Center(child: CircularProgressIndicator()));
}