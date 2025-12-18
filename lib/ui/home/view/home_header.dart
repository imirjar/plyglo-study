import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poliglotim/ui/core/ui/elements/buttons/circle_button.dart';
import 'package:poliglotim/ui/home/view_models/home_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.screenWidth, required this.horizontalPadding, required this.verticalPadding, required this.viewModel});

  final HomeViewModel viewModel;
  final double horizontalPadding;
  final double verticalPadding;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(

      // Адаптивные отступы вместо фиксированных
      margin: EdgeInsets.symmetric(
        
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Адаптивный логотип
          SizedBox(
            width: screenWidth < 550 ? 120 : 150, // Меняем размер на маленьких экранах
            child: SvgPicture.asset(
              Theme.of(context).brightness == Brightness.dark
                ? "assets/images/poliglotim_white.svg" 
                : "assets/images/poliglotim_black.svg",
              fit: BoxFit.contain,
            ),
          ),
          
          // Кнопка профиля
          CircleButton(
            onPressed: () => context.go("/user"), 
            icon: Icons.person,
            // size: screenWidth < 550 ? 40 : 48, // Меньшая кнопка на маленьких экранах
          )
        ]
      ),
    );
  }
}