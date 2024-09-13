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
  late Size mediaSize;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    myColor = const Color(0xFF703eff);
    darkBlueColor = const Color(0xFF090057);
    mediaSize = MediaQuery.of(context).size;
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
      width: mediaSize.width,
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
      width: mediaSize.width,
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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreyText("Name"),
                _buildInputField(nameController,
                    isPassword: false, validator: _nameValidator),
                const SizedBox(height: 20),
                _buildGreyText("Email"),
                _buildInputField(emailController,
                    isPassword: false, validator: _emailValidator),
                const SizedBox(height: 20),
                _buildGreyText("Password"),
                _buildInputField(passwordController,
                    isPassword: true, validator: _passwordValidator),
                const SizedBox(height: 20),
                _buildGreyText("Confirm Password"),
                _buildInputField(confirmPasswordController,
                    isPassword: true, validator: _confirmPasswordValidator),
                const SizedBox(height: 35),
                _buildSignUpButton(),
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

  Widget _buildInputField(TextEditingController controller,
      {required bool isPassword,
      required String? Function(String?) validator}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPassword
                      ? (_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility)
                      : (_obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                ),
                onPressed: () {
                  setState(() {
                    if (isPassword) {
                      _obscurePassword = !_obscurePassword;
                    } else {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    }
                  });
                },
              )
            : null,
      ),
      validator: validator,
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
      return "Password must include one uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters.";
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          // Perform sign-up action
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
          color: Theme.of(context).scaffoldBackgroundColor,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
