import 'package:flutter/material.dart';
import 'package:poliglotim/ui/user/view/user_header.dart';
import 'package:poliglotim/ui/user/view/user_body.dart';
import 'package:poliglotim/ui/user/view_models/user_viewmodel.dart';

class UserScreen extends StatefulWidget {
  final UserViewModel viewModel;

  const UserScreen({super.key, required this.viewModel});

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
        final horizontalPadding = screenWidth < 550 ? 16.0 : 64.0;
        final verticalPadding = screenWidth < 550 ? 8.0 : 32.0;

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 220,
            flexibleSpace: UserHeader(
              viewModel: widget.viewModel,
              screenWidth: screenWidth,
              horizontalPadding: horizontalPadding,
              verticalPadding: verticalPadding,
            ),
          ),
          body: UserBody(viewModel: widget.viewModel),
        );
      },
    );
  }
}
