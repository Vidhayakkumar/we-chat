import 'package:flutter/material.dart';
import 'package:we_chat/data/models/auth/create_user_req.dart';
import 'package:we_chat/data/usecase/auth/signup.dart';
import 'package:we_chat/helper/custom_widget/helper.dart';
import 'package:we_chat/helper/custom_widget/myRoundedCstBtn.dart';
import 'package:we_chat/helper/dimension.dart';
import 'package:we_chat/helper/routes.dart';
import '../helper/custom_widget/app_apis.dart';
import '../service_locator.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Size? mq;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: mq!.height * .05,
              left: mq!.width * .03,
              right: mq!.width * .03),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back button
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: mq!.width * .11,
                        height: mq!.width * .11,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black.withOpacity(.5),
                        ),
                      ),
                    ),
                  ],
                ),

                // Title
                Text(
                  'Register',
                  style: TextStyle(
                      fontSize: mq!.height * .04, fontWeight: FontWeight.bold),
                ),

                // Form fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mSpacer(height: AppDimension.height20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('First Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppDimension.font15),
                              ),
                              SizedBox(
                                height: AppDimension.height50,
                                child: TextFormField(
                                  controller: fNameController,
                                  decoration: getInputTextFieldDecoration(hint: 'Enter name'),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter first name'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AppDimension.width10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Last Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppDimension.font15),
                              ),
                              SizedBox(
                                height: AppDimension.height50,
                                child: TextFormField(
                                  controller: lNameController,
                                  decoration: getInputTextFieldDecoration(
                                      hint: 'Enter last name'),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter last name'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    mSpacer(height: AppDimension.height20),
                    Text(
                      'E-mail',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimension.font15),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration:
                          getInputTextFieldDecoration(hint: 'Enter email'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter email';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    mSpacer(height: AppDimension.height20),
                    Text(
                      'Password',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimension.font15),
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration:
                          getInputTextFieldDecoration(hint: 'Enter password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter password';
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    Text(
                      'Must contain 8 char.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimension.font10),
                    ),
                    mSpacer(height: AppDimension.height20),
                    Text(
                      'Confirm password',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimension.font15),
                    ),
                    TextFormField(
                      controller: confirmPassController,
                      decoration: getInputTextFieldDecoration(hint: '........'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) return 'Please confirm password';
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    )
                  ],
                ),

                mSpacer(height: AppDimension.height100),

                // Sign Up Button
                _isLoading
                    ? CircularProgressIndicator()
                    : InkWell(
                        onTap: () async {
                          var firstName = fNameController.text.trim();
                          var lastName = lNameController.text.trim();
                          var email = emailController.text.trim();
                          var password = passwordController.text.trim();
                          var confirm = confirmPassController.text.trim();
                          var fullName = '$firstName $lastName'; // spacing added

                          if (firstName.isNotEmpty &&
                              lastName.isNotEmpty &&
                              email.isNotEmpty &&
                              password.isNotEmpty &&
                              confirm.isNotEmpty) {
                            if (password == confirm) {
                              setState(() => _isLoading = true);

                              final result = await sl<SignupUseCase>().call(
                                params: CreateUserReq(
                                  fullName: fullName,
                                  email: email,
                                  password: password,
                                ),
                              );

                              setState(() => _isLoading = false);

                              result.fold((failure) {
                                showSnackBar(context, failure.toString());
                              }, (success) async {
                                if (await AppApis.userExist()) {
                                  Navigator.pushNamed(
                                      context, AppRoutes.homePage);
                                } else {
                                  await AppApis.createUser(fullName).then((value) {
                                    Navigator.pushNamed(context, AppRoutes.homePage);
                                  });
                                }
                              });
                            } else {
                              showSnackBar(context, 'Passwords do not match');
                            }
                          } else {
                            showSnackBar(context, 'Please fill all required fields');
                          }
                        },
                        child: MyRoundedCstBtn(text: 'Create Account'),
                      ),

                mSpacer(height: AppDimension.height20),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('I have an account? ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimension.font15),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.loginPage),
                      child: Text('Login Now',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimension.font15,
                            color: Color(0xff2B8761)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
