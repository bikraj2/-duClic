import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sikshya/core/common/widgets/gaps.dart';
import 'package:sikshya/core/extenions/context_extensions.dart';
import 'package:sikshya/core/res/app_colours.dart';
import 'package:sikshya/src/on_boarding/domain/page_content.dart';
import 'package:sikshya/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({super.key, required this.pageContent});
  final PageContent pageContent;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            pageContent.image,
            height: context.height / 2,
          ),
          Padding(
            padding: const EdgeInsets.all(20).copyWith(bottom: 0),
            child: Column(
              children: [
                Text(
                  pageContent.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w700),
                ),
                verticalGap(20),
                Text(
                  pageContent.desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                verticalGap(20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colours.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      context.read<OnBoardingCubit>().cacheFirstTimer();
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
