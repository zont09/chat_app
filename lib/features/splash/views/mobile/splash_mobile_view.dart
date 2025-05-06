import 'package:chat_app/features/splash/bloc/splash_cubit.dart';
import 'package:chat_app/utils/resizable_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashMobileView extends StatelessWidget {
  const SplashMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, bool>(
      builder: (context, s) {
        var cubit = context.read<SplashCubit>();

        // Start navigation when view is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          cubit.navigateBasedOnAuth(context);
        });

        return Material(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: Resizable.size(context, 120),
                  height: Resizable.size(context, 120),
                ),
                SizedBox(height: Resizable.size(context, 24)),

                // App Name
                Text(
                  'Real Chat',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),

                SizedBox(height: Resizable.size(context, 48)),

                // Loading indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
