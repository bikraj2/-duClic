import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sikshya/core/common/widgets/gaps.dart';
import 'package:sikshya/core/common/widgets/gradient_background.dart';
import 'package:sikshya/core/extenions/context_extensions.dart';
import 'package:sikshya/core/res/app_colours.dart';
import 'package:sikshya/core/res/fonts.dart';
import 'package:sikshya/core/res/media_res.dart';
import 'package:sikshya/core/utils/core_utils.dart';
import 'package:sikshya/src/auth/data/models/user_model.dart';
import 'package:sikshya/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:sikshya/src/auth/presentation/bloc/widgets/sign_in_froms.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthError) {
              Future.delayed(
                Duration.zero,
                () => CoreUtils.showSnackBar(context, state.message),
              );
              ;
            } else if (state is SignedIn) {
              Future.delayed(Duration.zero, () {
                context.userProvider.initUser(state.user as LocalUserModel);
                context.go('/dashboard');
              });
            }
            return GradientBackground(
              img: MediaRes.gradientBackground,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      'Find what you are meant to Learn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: Fonts.aeonik,
                          fontSize: 32,
                          fontWeight: FontWeight.w800),
                    ),
                    verticalGap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/signUp'),
                          child: Text(
                            'Register now',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colours.primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    SignInForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      authKey: formKey,
                    ),
                    verticalGap(20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colours.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          context.go('/forgetPassword');
                        },
                      ),
                    ),
                    if (state is AuthLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: Colours.primaryColor,
                        ),
                      )
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colours.primaryColor,
                            foregroundColor: Colours.primaryColor),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SignInEvent(
                                      email: emailController.text,
                                      password: passwordController.text),
                                );
                          }
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: Fonts.aeonik,
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          },
          listener: (context, state) {},
        ));
  }
}
