import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:poliglotim/app/pages/auth/view_models/login_viewmodel.dart';
import 'package:poliglotim/app/pages/core/themes/neumorphic.dart';
import 'package:poliglotim/app/pages/core/ui/elements/buttons/circle_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel viewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Container(
                decoration: Neumorphic.panel(context),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => Get.offAllNamed('/'),
                        child: SvgPicture.asset(
                          "assets/images/poliglotim_white.svg",
                          height: 88,
                          width: 88,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Войдите через Poliglotim ID',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      CircleButton(
                        onPressed: () async {
                          await viewModel.login.execute();
                          if (viewModel.login.completed) {
                            Get.offAllNamed('/');
                          }
                        },
                        icon: Icons.arrow_upward_outlined,
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
