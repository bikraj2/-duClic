import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sikshya/core/common/widgets/gaps.dart';
import 'package:sikshya/core/common/widgets/i_field.dart';
import 'package:sikshya/core/res/app_colours.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.emailController,
    required this.passwordController,
    required this.fullNameController,
    required this.authKey,
    super.key,
  });
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController fullNameController;
  final GlobalKey<FormState> authKey;
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscuretext = true;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.authKey,
        child: Column(
          children: [
            IField(
              overrideValidator: true,
              controller: widget.emailController,
              fillcolour: Colors.white,
              filled: true,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (p0) {
                if (p0 == '') {
                  return 'This Field is Required';
                }
                final bool = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(p0 ?? '');
                if (!bool) {
                  return 'Please provide a valid Email';
                }
              },
            ),
            verticalGap(20),
            IField(
              controller: widget.passwordController,
              hintText: 'Password',
              filled: true,
              obscureText: obscuretext,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscuretext = !obscuretext;
                  });
                },
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colours.primaryColor,
                ),
              ),
            ),
            verticalGap(20),
            IField(
              controller: widget.fullNameController,
              hintText: 'FullName',
              filled: true,
            )
          ],
        ));
  }
}
