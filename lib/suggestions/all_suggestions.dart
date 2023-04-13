import 'dart:ui';

import 'package:flutter/material.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

class AllSuggestions extends StatefulWidget {
  final Map<Object?, Object?> fullSuggestions;

  const AllSuggestions({Key? key, required this.fullSuggestions})
      : super(key: key);

  @override
  State<AllSuggestions> createState() => _AllSuggestionsState();
}

class _AllSuggestionsState extends State<AllSuggestions> {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Date Specific Suggestion!!',
        templateBody: viewAllSuggestions(),
        bgColor: ConstantColor.background1Color);
  }

  Widget viewAllSuggestions() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          buildDetails('Date', widget.fullSuggestions['date'].toString()),
          buildDetails('Is Read', widget.fullSuggestions['isread'].toString()),
          buildDetails('Time', widget.fullSuggestions['time'].toString()),
          const SizedBox(height: 30),
          buildMessage(),
        ],
      ),
    );
  }

  Widget buildDetails(String title, String val) {
    return Container(
      margin: const EdgeInsets.all(10),
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(3),
            },
            border: TableBorder.all(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white24,
              width: 2,
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: ConstantColor.background1Color,
                        fontSize: 17,
                        fontFamily: ConstantFonts.poppinsBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SelectableText(
                      val,
                      style: TextStyle(
                          color: ConstantColor.background1Color,
                          fontSize: 17,
                          fontFamily: ConstantFonts.poppinsMedium),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessage() {
    return Container(
      margin: const EdgeInsets.all(10),
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(3),
            },
            border: TableBorder.all(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white24,
              width: 2,
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Message:",
                      style: TextStyle(
                        color: ConstantColor.background1Color,
                        fontSize: 17,
                        fontFamily: ConstantFonts.poppinsBold,
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.blue,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SelectableText(
                      widget.fullSuggestions['message'].toString(),
                      style: TextStyle(
                        color: ConstantColor.background1Color,
                        fontSize: 17,
                        fontFamily: ConstantFonts.poppinsMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
