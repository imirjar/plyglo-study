// user_profile_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poliglotim/ui/user/view_models/user_viewmodel.dart';

class UserBody extends StatelessWidget {
  final AuthViewModel viewModel;

  const UserBody({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile photo/profile info/balance
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/chineese-girl.svg",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Пурумпочкина Елизавета Павловна",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Баланс: 0\$",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          //Courses available/can buy/archived
          Container(
            padding: const EdgeInsets.all(24),
             decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: const[
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
            ]
          ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Мои курсы",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(0.5),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(1),
                  },
                  children: const [
                    // Заголовок таблицы
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "#",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Название",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Прогресс",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    // Данные
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "1",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Английский язык"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "68%",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "2",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Китайский язык"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "18%",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}