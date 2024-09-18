import 'package:ardent_chat/common/constants/routes.dart';
import 'package:ardent_chat/common/helpers/auth_helper.dart';
import 'package:ardent_chat/common/widgets/dynamic_form_field.dart';
import 'package:ardent_chat/common/widgets/theme_switch.dart';
import 'package:flutter/material.dart';

import '../../common/constants/regex_validation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late Color myColor;
  late Color darkBlueColor;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    myColor = const Color(0xFF703eff);
    darkBlueColor = const Color(0xFF090057);

    return Scaffold(
      backgroundColor: myColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTop(),
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.asset(
              "assets/images/Logo2-Transparent-FullLight.png",
              height: 250,
              width: 250,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 32.0, left: 32.0, right: 32.0, bottom: 48.5),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Create Account",
                  style: TextStyle(
                    color: darkBlueColor,
                    fontSize: 32,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
          _buildGreyText("Sign up with your information"),
          ThemeSwitch(), // TODO: Remove after testing dark mode
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreyText("Username"),
                DynamicFormField(
                    controller: usernameController,
                    isPassword: false,
                    validator: _nameValidator),
                const SizedBox(height: 20),
                _buildGreyText("Email"),
                DynamicFormField(
                    controller: emailController,
                    isPassword: false,
                    validator: _emailValidator),
                const SizedBox(height: 20),
                _buildGreyText("Password"),
                DynamicFormField(
                  controller: passwordController,
                  isPassword: true,
                  validator: _passwordValidator,
                ),
                const SizedBox(height: 20),
                _buildGreyText("Confirm Password"),
                DynamicFormField(
                  controller: confirmPasswordController,
                  isPassword: true,
                  validator: _confirmPasswordValidator,
                ),
                const SizedBox(height: 35),
                _buildSignUpButton(),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?   ",
                      style: TextStyle(
                        color: darkBlueColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Quicksand",
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.loginScreen);
                      },
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          color: darkBlueColor,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
        fontFamily: "Quicksand",
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          AuthHelper.signUp(
            username: usernameController.text,
            email: emailController.text,
            password: passwordController.text,
            context: context,
          ).onError(
            (error, stackTrace) {
              
            },
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 10,
        shadowColor: myColor,
        backgroundColor: myColor,
        minimumSize: const Size.fromHeight(60),
      ),
      child: Text(
        "SIGN UP",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid Email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (!passwordRegex.hasMatch(value)) {
      return "Password must include one uppercase letter,\none lowercase letter,"
          " one digit, one special\ncharacter (!@#\$&*~),"
          " and be at least 8 characters.";
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
