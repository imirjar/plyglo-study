import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:poliglotim/ui/auth/view_models/login_viewmodel.dart';
import 'package:poliglotim/ui/core/ui/elements/buttons/circle_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white30,
                    offset: Offset(-4, -4),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(4, 4),
                    blurRadius: 12,
                  ),
                ]),
            width: 400,
            height: 450,
            padding: const EdgeInsets.all(24),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => context.go("/"),
                    child: SvgPicture.asset(
                      "assets/images/poliglotim_white.svg",
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Войдите через Poliglotim ID',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  CircleButton(
                    onPressed: widget.viewModel.login.execute,
                    icon: Icons.arrow_upward_outlined,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
