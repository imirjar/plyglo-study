import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/pages/user/view/user_header.dart';
import 'package:poliglotim/app/pages/user/view/user_body.dart';
import 'package:poliglotim/app/pages/user/view_models/user_viewmodel.dart';

class UserScreen extends StatefulWidget {
  late final AuthViewModel viewModel = Get.find<AuthViewModel>();
  UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final horizontalPadding = screenWidth < 600 ? 16.0 : 32.0;
        final verticalPadding = screenWidth < 600 ? 16.0 : 24.0;

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Column(
                    children: [
                      UserHeader(
                        viewModel: widget.viewModel,
                        screenWidth: screenWidth,
                      ),
                      const SizedBox(height: 24),
                      Expanded(child: UserBody(viewModel: widget.viewModel)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
