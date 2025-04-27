
import 'package:flutter/material.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:we_chat/data/models/auth/create_user_req.dart';
import 'package:we_chat/data/models/auth/signin_user_req.dart';
import 'package:we_chat/data/usecase/auth/signin.dart';
import 'package:we_chat/helper/custom_widget/app_apis.dart';
import 'package:we_chat/helper/routes.dart';

import '../helper/custom_widget/helper.dart';
import '../helper/custom_widget/myRoundedCstBtn.dart';
import '../helper/dimension.dart';
import '../main.dart';
import '../screens/HomeScreen.dart';
import '../service_locator.dart';


class LoginPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }}

class LoginState extends State<LoginPage>{

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  bool  _isAnimate=false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 500),(){
      _isAnimate=true;
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: mq.height * .08,left: mq.width * .03, right: mq.width *.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Login',style: TextStyle(
                  fontSize: mq.height * .03,
                  fontWeight: FontWeight.bold
              ),
              ),
        
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mSpacer(height: AppDimension.height20),
                  Text('Name',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimension.font15
                  ),),
                  TextField(
                    controller: nameController,
                    decoration: getInputTextFieldDecoration(hint: 'Enter name'),
                  ),
                  mSpacer(height: AppDimension.height20),
                  Text('Email',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimension.font15
                  ),),
                  TextField(
                    controller: emailController,
                    decoration: getInputTextFieldDecoration(hint: 'Enter email'),
                  ),
        
                  mSpacer(height: AppDimension.height20),
                  Text('Password',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimension.font15
                  ),),
                  TextField(
                    controller: passwordController,
                    decoration: getInputTextFieldDecoration(hint: '........'),
                  ),
        
                ],
              ),
        
              mSpacer(height: AppDimension.height70),

              isLoading ? Center(child: CircularProgressIndicator()):InkWell(
                onTap: ()async{
                  var name =nameController.text.trim();
                  var email = emailController.text.trim();
                  var password = passwordController.text.trim();
                  var result;

                  if(name.isNotEmpty && password.isNotEmpty && email.isNotEmpty){

                    setState(() {
                      isLoading= true;
                    });

                    result = await sl<SignInUseCase>().call(
                      params: SignInUserReq(email: email, password: password)
                    );
                  }else{
                    showSnackBar(context, 'Please enter email and password');
                  }
                  setState(() {
                    isLoading = false;
                  });

                  result.fold(
                      (L){
                        showSnackBar(context, L.toString());
                      },
                      (R) async {
                       if(await AppApis.userExist()){
                         Navigator.pushNamed(context, AppRoutes.homePage);
                       }else{
                         await AppApis.createUser(name).then((value){
                           Navigator.pushNamed(context, AppRoutes.homePage);
                         });
                       }
                      }
                  );

                },
                  child: MyRoundedCstBtn(text: 'Login')),
        
              mSpacer(height: AppDimension.height20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("I Don't have an account?. ",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimension.font15
                  ),),
                 InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.signUpPage);
                    },
                    child: Text('Register Now',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimension.font15,
                        color: Color(0xff2B8761)
                    ),),
                  ),
                ],
              ),
        
              mSpacer(height: AppDimension.height120),
              Container(
                height: AppDimension.height45,
                width: AppDimension.width310,
                decoration: BoxDecoration(
                    color: Color(0xff2B8761).withOpacity(.6),
                  borderRadius: BorderRadius.circular(AppDimension.radius20),
        
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/google.png',width: AppDimension.iconSize24,),
                    mSpacer(),
                    Text("Login With Google ",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimension.font15,
                        color: Colors.white.withOpacity(.5)
                    ),),
                  ],
                ),
              )
        
            ],
          ),
        
        ),
      )
    );
  }

}
