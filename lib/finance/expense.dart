import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';
import '../util/screen_template.dart';
import 'expense_details.dart';
import 'expense_model.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  List<ExpenseModel> allExpense = [];
  bool isLoading = true;
  final today = DateTime.now();
  DatabaseReference expenseDetails =
  FirebaseDatabase.instance.ref('FinancialAnalyzing');

  DateTime now = DateTime.now();
  var formatterDate = DateFormat('yyyy-MM-dd');
  var formatterMonth = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  String? selectedDate;
  String? selectedMonth;
  String? selectedYear;

  datePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;
    setState(() {
      selectedDate = formatterDate.format(newDate);
      selectedMonth = formatterDate.format(newDate);
      selectedYear = formatterDate.format(newDate);
      checkExpenseDetails(
          today.year.toString(), today.month.toString());
    });
  }

  @override
  void initState() {
    selectedDate = formatterDate.format(now);
    selectedMonth = formatterMonth.format(now);
    selectedYear = formatterYear.format(now);
    checkExpenseDetails(
        today.year.toString(), today.month.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(subtitle: 'Expense', templateBody: buildExpenseScreen(), bgColor: ConstantColor.background1Color);

  }

  Widget buildExpenseScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  allExpense.clear();
                  datePicker();
                },
                child: Image.asset(
                  'assets/calender.png',
                  scale: 3,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                '$selectedDate',
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 17,
                  color: ConstantColor.background1Color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        allExpense.isNotEmpty
            ? Expanded(
          child: ListView.builder(
            itemCount: allExpense.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ExpenseDetails(
                        expenseDetails: allExpense[index],
                      ),
                    ),
                  );
                },
                leading: const CircleAvatar(
                  radius: 20,
                  backgroundColor: ConstantColor.background1Color,
                  child: Icon(Icons.receipt_long),
                ),
                title: Text(
                  allExpense[index].productName,
                  style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      color: ConstantColor.background1Color,
                      fontSize: 17),
                ),
              );
            },
          ),
        )
            : Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/no_data.json',
                    height: 200.0),
                Text(
                  'No Expense made!!',

        style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    color: ConstantColor.background1Color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  checkExpenseDetails(String year, String month) {

    var year = selectedDate.toString().split('-').first;
    var month = selectedDate.toString().split('-')[1];
    allExpense.clear();
    List<ExpenseModel> expenseCheck = [];
    expenseDetails.child('Expense/$year/$month').once().then((expense) {
      for (var check in expense.snapshot.children) {
        final data = check.value as Map<Object?, Object?>;
        final key = check.key.toString().split('_').first;
        if (key == selectedDate){
          final expenseDetails = ExpenseModel(
            amount: int.parse(data['Amount'].toString()),
            enteredBy: data['EnteredBy'].toString(),
            enteredDate: data['EnteredDate'].toString(),
            enteredTime: data['EnteredTime'].toString(),
            productName: data['ProductName'].toString(),
            purchasedDate: data['PurchasedDate'].toString(),
            purchasedFor: data['PurchasedFor'].toString(),
            purchasedTime: data['PurchasedTime'].toString(),
            service: data['Service'].toString(),
          );
          expenseCheck.add(expenseDetails);
          log('key is ${check.key}');
        }
      }
      setState(() {
        allExpense.addAll(expenseCheck);
      });
    });
  }
}
