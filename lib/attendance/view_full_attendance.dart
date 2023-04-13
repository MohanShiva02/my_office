import 'dart:ui';

import 'package:flutter/material.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

class ViewAllAttendance extends StatefulWidget {
  final Map<Object?, Object?> fullViewAttendance;

  const ViewAllAttendance({Key? key, required this.fullViewAttendance})
      : super(key: key);

  @override
  State<ViewAllAttendance> createState() => _ViewAllAttendanceState();
}

class _ViewAllAttendanceState extends State<ViewAllAttendance> {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Attendance Details!!',
        templateBody: viewFullAttendancePage(),
        bgColor: ConstantColor.background1Color);
  }

  Widget viewFullAttendancePage() {
    return Column(
      children: [
        buildDetails(
          'Name',
          widget.fullViewAttendance['Name'].toString(),
        ),
        buildDetails(
          'Address',
          widget.fullViewAttendance['Address'].toString(),
        ),
        buildDetails(
          'Latitude',
          widget.fullViewAttendance['Latitude'].toString(),
        ),
        buildDetails(
          'Longitude',
          widget.fullViewAttendance['Longitude'].toString(),
        ),
        buildDetails(
          'Time',
          widget.fullViewAttendance['Time'].toString(),
        ),
      ],
    );
  }

  Widget buildDetails(String title, String val) {
    return Container(
      margin: const EdgeInsets.all(10),
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
}
