import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/helper/dimension.dart';

class MyRoundedCstBtn extends StatelessWidget {
  
  final String text;
  
  MyRoundedCstBtn({
    required this.text
});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimension.height45,
      width: AppDimension.width310,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimension.radius20),
        color: Color(0xff2B8761)
      ),
      child: Center(
        child: Text(text,style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: AppDimension.font15
        ),),
      ),
    );
  }
}
