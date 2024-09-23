import 'package:ardent_chat/common/helpers/auth_helper.dart';
import 'package:ardent_chat/common/widgets/dynamic_form_field.dart';
import 'package:flutter/material.dart';

import '../../common/constants/regex_validation.dart';
import '../../common/constants/routes.dart';
import '../../common/widgets/theme_switch.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Color myColor;
  late Color darkBlueColor;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;

  final _formKey = GlobalKey<FormState>(); // Add a global key for the form

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    darkBlueColor = const Color(0xFF090057);

    return Scaffold(
      // backgroundColor: Theme.of(context).brightness == Brightness.dark
      //     ? myColor // Use black in dark mode
      //     : myColor,
      backgroundColor: Theme.of(context).colorScheme.primary,
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
        // color: myColor,
        // color: Theme.of(context).brightness == Brightness.dark
        //     ? Colors.black // Use black in dark mode
        //     : Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 32.0, left: 32.0, right: 32.0, bottom: 100),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey, // Assign the global key to the Form widget
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Welcome",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white // White in dark mode
                        : darkBlueColor,
                    fontSize: 32,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
          _buildGreyText("Login with your information"),
          ThemeSwitch(), // TODO: Remove after testing dark mode
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreyText("Email"),
                DynamicFormField(
                  controller: emailController,
                  isPassword: false,
                  validator: _emailValidator,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                ),
                const SizedBox(height: 50),
                _buildGreyText("Password"),
                DynamicFormField(
                  controller: passwordController,
                  isPassword: true,
                  validator: _passwordValidator,
                ),
                const SizedBox(height: 35),
                _buildLoginButton(),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't have an account?   ",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white // White in dark mode
                            : darkBlueColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Quicksand",
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.signUpScreen);
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // White in dark mode
                              : darkBlueColor,
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

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          debugPrint("Email : ${emailController.text}");
          debugPrint("Password : ${passwordController.text}");
          AuthHelper.logIn(
            email: emailController.text,
            password: passwordController.text,
            context: context,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 10,
        shadowColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: const Size.fromHeight(60),
      ),
      child: Text(
        "LOGIN",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
