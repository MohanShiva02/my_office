import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return MainTemplate(subtitle:'Financial Analyzing', templateBody: buildFinanceScreen(), bgColor: ConstantColor.background1Color,);

  }

  Widget buildFinanceScreen() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildButton(
              name: 'Income',
              image: Image.asset(
                'assets/income.png',
                scale: 3,
              ),
              page:  const IncomeScreen(),
            ),

            buildButton(
              name: 'Expense',
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
  Widget buildButton(
      {required String name, required Image image, required Widget page}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 10,sigmaX: 10),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 230,
            // width: 300,
            padding: const EdgeInsets.symmetric(vertical: 20.0),

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24,width: 2),
                gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(child: image),
                AutoSizeText(
                  name,
                  style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    color: ConstantColor.background1Color,
                  ),
                  minFontSize: 22,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
