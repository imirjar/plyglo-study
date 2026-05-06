import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/pages/core/ui/elements/buttons/circle_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poliglotim/app/pages/user/view_models/user_viewmodel.dart';

class UserHeader extends StatelessWidget {
  const UserHeader(
      {super.key, required this.screenWidth, required this.viewModel});

  final AuthViewModel viewModel;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.offAllNamed('/'),
            child: SizedBox(
              width: screenWidth < 550 ? 128 : 156,
              child: SvgPicture.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? "assets/images/poliglotim_white.svg"
                    : "assets/images/poliglotim_black.svg",
                fit: BoxFit.contain,
              ),
            ),
          ),
          CircleButton(
            onPressed: () => Get.toNamed('/user'),
            icon: Icons.person,
          )
        ],
      ),
    );
  }
}
