import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sikshya/core/common/views/loading_screen.dart';
import 'package:sikshya/core/common/widgets/gaps.dart';
import 'package:sikshya/core/common/widgets/gradient_background.dart';
import 'package:sikshya/core/extenions/context_extensions.dart';
import 'package:sikshya/core/res/app_colours.dart';
import 'package:sikshya/core/res/fonts.dart';
import 'package:sikshya/core/res/media_res.dart';
import 'package:sikshya/core/utils/core_utils.dart';
import 'package:sikshya/src/auth/data/models/user_model.dart';
import 'package:sikshya/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:sikshya/src/auth/presentation/bloc/widgets/sign_up_forms.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        img: MediaRes.gradientBackground,
        child: BlocConsumer<AuthBloc, AuthState>(
          builder: (_, state) {
            if (state is AuthError) {
              Future.delayed(
                Duration.zero,
                () => CoreUtils.showSnackBar(context, state.message),
              );
            } else if (state is SignedUp) {
              context.read<AuthBloc>().add(
                    SignInEvent(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ),
                  );
            }
            return Center(
              child: ListView(
                shrinkWrap: true,
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
                  SignUpForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    fullNameController: fullNameController,
                    authKey: formKey,
                  ),
                  verticalGap(20),
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
                      ),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                SignUpEvent(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  fullName: fullNameController.text.trim(),
                                ),
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
            );
          },
          listener: (context, state) {
            if (state is SignedIn) {
              context.userProvider.initUser(state.user as LocalUserModel);
              context.pushReplacement('/dashboard');
            }
          },
        ),
      ),
    );
  }
}
