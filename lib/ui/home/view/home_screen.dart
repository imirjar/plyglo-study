import 'package:flutter/material.dart';
import 'package:poliglotim/ui/home/view/home_body.dart';
import 'package:poliglotim/ui/home/view/home_header.dart';
import 'package:poliglotim/ui/home/view_models/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel.getCourses();
    return LayoutBuilder(
      
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final horizontalPadding = screenWidth < 550 ? 16.0 : 64.0;
        final verticalPadding = screenWidth < 550 ? 8.0 : 32.0;
        
        // Определяем количество колонок в зависимости от ширины экрана
        int crossAxisCount;
        if (screenWidth < 550) {
          crossAxisCount = 1;
        } else if (screenWidth < 800) {
          crossAxisCount = 2; // Мобильные устройства
        } else if (screenWidth < 1150) {
          crossAxisCount = 3; // Планшеты
        } else if (screenWidth < 1300) {
          crossAxisCount = 4; // Небольшие десктопы
        } else {
          crossAxisCount = 5; // Большие экраны
        }
        return Scaffold(
          body: Column(
            children: [
              // Заголовок
              HomeHeader(
                viewModel: viewModel,
                screenWidth: screenWidth,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
              ),
              
              // Тело с прокруткой
              Expanded(
                child: HomeBody(
                  crossAxisCount: crossAxisCount,
                  viewModel: viewModel,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}