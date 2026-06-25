import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/ui/pages/exam/view/exam_body.dart';
import 'package:poliglotim/app/ui/pages/exam/view_models/exam_viewmodel.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late final ExamViewModel _viewModel = Get.find<ExamViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.loadExam();
  }

  @override
  Widget build(BuildContext context) {
    return ExamBody(
      screenWidth: widget.screenWidth,
      viewModel: _viewModel,
    );
  }
}
