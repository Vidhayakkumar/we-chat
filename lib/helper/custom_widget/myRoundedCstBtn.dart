import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/helper/custom_widget/helper.dart';
import 'package:we_chat/helper/dimension.dart';

class MyRoundedCstBtn extends StatelessWidget {
  
  final String text;
  final IconData? icon;
  final double width;
  final double height;
  final Color? color;
  final Color? iconColor;
  
  MyRoundedCstBtn({
    required this.text,
    this.width=0,
    this.height =0,
    this.icon,
    this.color,
    this.iconColor
});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width==0? AppDimension.width310:width,
      height: height== 0? AppDimension.height45: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimension.radius20),
        color: color == null? Color(0xff2B8761):color
      ),
      child: Center(
        child: icon == null? Text(text,style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: AppDimension.font15
        ),):Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,color: iconColor,),
            SizedBox(width: AppDimension.width5,),
            Text(text,style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: AppDimension.font15
            ),)
          ],
        ),
      ),
    );
  }
}
