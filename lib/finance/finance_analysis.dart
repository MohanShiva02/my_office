import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/util/main_template.dart';
import '../util/screen_template.dart';
import 'expense.dart';
import 'income.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MainTemplate(subtitle:'Financial Analyzing', templateBody: buildFinanceScreen(width,height), bgColor: ConstantColor.background1Color,);

  }

  Widget buildFinanceScreen(double width,double height) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildButton(
             width,height, name: 'Income',
              image: Image.asset(
                'assets/income.png',
                scale: 3,
              ),
              page:  const IncomeScreen(),
            ),

            buildButton(
              width,height,name: 'Expense',
              image: Image.asset(
                'assets/expense.png',
                scale: 3,
              ),
              page:  const ExpenseScreen(),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildButton(double width,double height,
      {required String name, required Image image, required Widget page}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: buildNeumorphic(
         width,height,Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 230,
          // width: 300,
          padding: const EdgeInsets.symmetric(vertical: 20.0),

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(child: image),
              AutoSizeText(
                name,
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium,
                  color: ConstantColor.blackColor,
                ),
                minFontSize: 22,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNeumorphic(double width, double height, Widget widget) {
    return Neumorphic(
      margin: const EdgeInsets.symmetric(vertical: 10),
      style: NeumorphicStyle(
        depth: 3,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(20),
        ),
      ),
      child: widget,
    );
  }

}
