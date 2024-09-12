import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Color myColor;
  late Color darkBlueColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;
  bool _obscurePassword = true; // State to toggle password visibility

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
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
            )),
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0, bottom: 48.5),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Welcome",
                style: TextStyle(
                  color: darkBlueColor,
                  fontSize: 32,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
        _buildGreyText("Login with your information"),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreyText("Email"),
              _buildInputField(emailController),
              const SizedBox(height: 50),
              _buildGreyText("Password"),
              _buildInputField(passwordController, isPassword: true),
              const SizedBox(height: 35),
              _buildLoginButton(),
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't have an account?   ",
                    style: TextStyle(
                      color: darkBlueColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Quicksand",
                    ),
                  ),
                  InkWell(
                    onTap: () {

                    },
                    child: Text(
                      "Sign Up",
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
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        )
            : null,
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        debugPrint("Email : ${emailController.text}");
        debugPrint("Password : ${passwordController.text}");
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 10,
        shadowColor: myColor,
        backgroundColor: myColor,
        minimumSize: const Size.fromHeight(60),
      ),
      child: Text(
        "LOGIN",
        style: TextStyle(
          color: Theme.of(context).scaffoldBackgroundColor,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
