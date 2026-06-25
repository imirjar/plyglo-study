import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/ui/pages/user/view/user_body.dart';
import 'package:poliglotim/app/ui/pages/user/view_models/user_viewmodel.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final AuthViewModel _viewModel = Get.find<AuthViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        widget.screenWidth < 600 ? 16 : 10,
        0,
        widget.screenWidth < 600 ? 16 : 10,
        24,
      ),
      child: UserBody(viewModel: _viewModel),
    );
  }
}
