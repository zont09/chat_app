import 'package:chat_app/features/splash/bloc/splash_cubit.dart';
import 'package:chat_app/features/splash/views/mobile/splash_mobile_view.dart';
import 'package:chat_app/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(),
      child: const ResponsiveLayout(
        mobile: SplashMobileView(),
        tablet: SplashMobileView(),
        desktop: SplashMobileView(),
      ),
    );
  }
}
