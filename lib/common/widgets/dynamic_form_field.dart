import 'package:flutter/material.dart';

class DynamicFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const DynamicFormField({
    super.key,
    required this.controller,
    required this.isPassword,
    this.validator,
    this.autovalidateMode,
  });

  @override
  _DynamicFormFieldState createState() => _DynamicFormFieldState();
}

class _DynamicFormFieldState extends State<DynamicFormField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
