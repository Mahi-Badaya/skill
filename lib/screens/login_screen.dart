import 'package:flutter/material.dart';
import 'package:intro/resources/auth_methods.dart';
import 'package:intro/screens/home_screen.dart';
import 'package:intro/screens/signup_screen.dart';
import 'package:intro/utils/utils.dart';
import 'package:intro/widgets/text_field_input.dart';
import 'package:intro/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    //for disposing the controller
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser()async {
    setState(() {
      _isLoading = true;
    });
      String res= await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);
      if(res == "success"){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      }else{
        showSnackBar(res, context);
      }
      setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SignupScreen()));
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
              Image.asset('assets/images/propzing.png'),
              const SizedBox(height: 64,),
              Text('User Login', style: TextStyle(fontSize: 25), ),
              const SizedBox(height: 64,),
              TextFieldInput(textEditingController: _emailController, hintText: 'Enter your email', textInputType: TextInputType.emailAddress),
              SizedBox(height: 24,),
              TextFieldInput(textEditingController: _passwordController, hintText: 'Enter your password', textInputType: TextInputType.text, isPass: true,),
              SizedBox(height: 24,),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading
                      ? Center(child: const CircularProgressIndicator(color: primaryColor,))
                 : const Text('Log in'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                    color: buttonColor,
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Flexible(child: Container(), flex: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have any account? "),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.bold),),
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
