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
// Add this to manage button state for enabled and disable btn
  bool isButtonEnabled = false;

  bool isLoading = false; // for the loading indicator

  final _formKey = GlobalKey<FormState>(); // Add a global key for the form

  @override
  void initState() {
    super.initState();
    // Listen to changes in both email and password fields to make btn states works when it has value
    emailController.addListener(_checkFormValidity);
    passwordController.addListener(_checkFormValidity);
  }

  // Method to check if the button should be enabled
  void _checkFormValidity() {
    setState(() {
      isButtonEnabled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.only(
              // Contianer layout
              top: 32.0,
              left: 32.0,
              right: 32.0,
              bottom: 100),
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
                    // Handling dark mode
                    color: Theme.of(context).colorScheme.primary,

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
                      "Don't have an account?   ",
                      style: TextStyle(
                        // handling dark mode
                        color: Theme.of(context).colorScheme.primary,
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
                          // handling dark mode
                          color: Theme.of(context).colorScheme.primary,
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

    return null;
  }

//   Widget _buildLoginButton() {
//     return ElevatedButton(
//       onPressed: isButtonEnabled && !isLoading
//           ? () {
//               if (_formKey.currentState?.validate() ?? false) {
//                 debugPrint("Email : ${emailController.text}");
//                 debugPrint("Password : ${passwordController.text}");
//                 AuthHelper.logIn(
//                   email: emailController.text,
//                   password: passwordController.text,
//                   context: context,
//                 );
//               }
//             }
//           : null, // Disable the button if isButtonEnabled is false

//       style: ElevatedButton.styleFrom(
//         shape: const StadiumBorder(),
//         elevation: 10,
//         shadowColor: Theme.of(context).colorScheme.primary,
//         backgroundColor: isButtonEnabled
//             ? Theme.of(context).colorScheme.primary
//             : Colors.grey, // Change button color when disabled
//         minimumSize: const Size.fromHeight(60),
//       ),
//       child: Text(
//         "LOGIN",
//         style: TextStyle(
//           color: isButtonEnabled
//               ? Theme.of(context).colorScheme.onPrimary
//               : Colors.white, // Adjust text color when disabled
//           fontFamily: "Quicksand",
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
// }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: isButtonEnabled && !isLoading
          ? () async {
              if (_formKey.currentState?.validate() ?? false) {
                debugPrint("Email : ${emailController.text}");
                debugPrint("Password : ${passwordController.text}");
                setState(() {
                  // Show indicator
                  isLoading = true;
                });

                try {
                  await AuthHelper.logIn(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context,
                  );
                  //  show success
                  debugPrint("Login was successful");

                  //  success snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Login Successful!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Optionally navigate to another screen after login success
                } catch (e) {
                  debugPrint("Login failed: $e");

                  // Handle login failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sign-up failed: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } finally {
                  setState(() {
                    // Hide loading indicator
                    isLoading = false;
                  });
                }
              }
            }
          : null, // Disable the button if isButtonEnabled is false or loading

      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 10,
        shadowColor: Theme.of(context).colorScheme.primary,
        backgroundColor: isButtonEnabled
            ? Theme.of(context).colorScheme.primary
            // Change button color when disabled (for the disaable btn)
            : Colors.grey,
        minimumSize: const Size.fromHeight(60),
      ),
      child: isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Text(
              "LOGIN",
              style: TextStyle(
                color: isButtonEnabled
                    ? Theme.of(context).colorScheme.onPrimary
                    //  text color login btn when disabled
                    : Colors.red,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
