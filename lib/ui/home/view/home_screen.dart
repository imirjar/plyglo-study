import 'package:flutter/material.dart';
import 'package:poliglotim/ui/home/view/home_body.dart';
import 'package:poliglotim/ui/home/view/home_header.dart';
import 'package:poliglotim/ui/home/view_models/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final horizontalPadding = screenWidth < 550 ? 16.0 : 64.0;
        final verticalPadding = screenWidth < 550 ? 8.0 : 32.0;

        int crossAxisCount;
        if (screenWidth < 550) {
          crossAxisCount = 1;
        } else if (screenWidth < 800) {
          crossAxisCount = 2;
        } else if (screenWidth < 1150) {
          crossAxisCount = 3;
        } else if (screenWidth < 1300) {
          crossAxisCount = 4;
        } else {
          crossAxisCount = 5;
        }

        return Scaffold(
          body: Column(
            children: [
              HomeHeader(
                viewModel: widget.viewModel,
                screenWidth: screenWidth,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
              ),
              Expanded(
                child: HomeBody(
                  crossAxisCount: crossAxisCount,
                  viewModel: widget.viewModel,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
