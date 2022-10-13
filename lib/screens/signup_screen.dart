import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intro/resources/auth_methods.dart';
import 'package:intro/screens/login_screen.dart';
import 'package:intro/utils/utils.dart';
import 'package:intro/widgets/text_field_input.dart';

import '../utils/colors.dart';
import 'home_screen.dart';

bool _isLoading = false;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List ?_image;

  @override
  void dispose() {
    //for disposing the controller
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im =  await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
    email: _emailController.text,
    password: _passwordController.text,
    username: _usernameController.text,
    file: _image!,
  );
    if(res == 'success'){
      // showSnackBar(res, context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    setState(() {
      _isLoading= false;
    });
}

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2,),
              Text('User Signup', style: TextStyle(fontSize: 25), ),
              const SizedBox(height: 64,),
              Stack(
                children: [
                  _image != null ?
                       CircleAvatar(
                      radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                  :const CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/images/default.jpg'),
                  ),
                  Positioned(
                    left: 80,
                    bottom: -10,
                    top: 80,
                    child: IconButton(
                        onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo),
                 ),
                  ),
                ],
              ),
              SizedBox(height: 24,),
              TextFieldInput(textEditingController: _usernameController, hintText: 'Enter your username', textInputType: TextInputType.text),
              SizedBox(height: 24,),
              TextFieldInput(textEditingController: _emailController, hintText: 'Enter your email', textInputType: TextInputType.emailAddress),
              SizedBox(height: 24,),
              TextFieldInput(textEditingController: _passwordController, hintText: 'Enter your password', textInputType: TextInputType.text, isPass: true,),
              SizedBox(height: 24,),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                    color: buttonColor,
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: primaryColor,),)
                      :const Text('Sign up'),
                ),
              ),
              SizedBox(height: 12,),
              Flexible(child: Container(), flex: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Already have an account? "),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: Text("Log in", style: TextStyle(fontWeight: FontWeight.bold),),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
