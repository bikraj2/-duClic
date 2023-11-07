import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sikshya/core/common/views/loading_screen.dart';
import 'package:sikshya/core/common/widgets/gradient_background.dart';
import 'package:sikshya/core/res/app_colours.dart';
import 'package:sikshya/core/res/media_res.dart';
import 'package:sikshya/core/services/injection_container.dart';
import 'package:sikshya/src/on_boarding/domain/page_content.dart';
import 'package:sikshya/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:sikshya/src/on_boarding/presentation/widgets/on_boarding_body.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});
  static const routeName = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    super.initState();

    context.read<OnBoardingCubit>().checkIfUserFirstTimer();
  }

  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) => {
          if (state is OnBoardingStatus && !state.isFirstTimer)
            {context.push('/home')}
          // ignore: inference_failure_on_collection_literal
          else if (state is UserCached)
            {
              // TODO(User-Cached-Handler): Push to the appopriate screen
            }
        },
        builder: (context, state) {
          if (state is CheckingIfUserFirstTimer || state is CachingFirstTimer) {
            return const LoadingView();
          } else if (state is OnBoardingInitial) {
            return const LoadingView();
          }
          return GradientBackground(
            img: MediaRes.gradientBackground,
            child: Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: const [
                    OnBoardingBody(pageContent: PageContent.first()),
                    OnBoardingBody(pageContent: PageContent.second()),
                    OnBoardingBody(pageContent: PageContent.third()),
                  ],
                ),
                Align(
                  alignment: const Alignment(
                    0,
                    .04,
                  ),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    onDotClicked: (index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                      );
                    },
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Colours.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
