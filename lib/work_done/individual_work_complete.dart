import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:my_office/util/main_template.dart';
import 'package:my_office/util/screen_template.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class IndividualWorkDone extends StatefulWidget {
  final String employeeName;
  final List<dynamic> workDetails;

  const IndividualWorkDone(
      {Key? key, required this.workDetails, required this.employeeName})
      : super(key: key);

  @override
  State<IndividualWorkDone> createState() => _IndividualWorkDoneState();
}

class _IndividualWorkDoneState extends State<IndividualWorkDone> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MainTemplate(
        subtitle: 'Work history of ${widget.employeeName}',
        templateBody: workDetailsContainer(height, width),
        bgColor: ConstantColor.background1Color);

    // ScreenTemplate(
    //   bodyTemplate: workDetailsContainer(height, width),
    //   title: widget.employeeName);
  }

  Widget workDetailsContainer(double height, double width) {
    // print(widget.workDetails.length.bitLength);

    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.workDetails.length,
      itemBuilder: (BuildContext context, int ind) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildNeumorphic(
            width,height, Container(
              height: height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: height * 0.02,
                          horizontal: width * 0.02),
                      padding: const EdgeInsets.all(8),
                      height: height * 0.1,
                      width: width * 0.88,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: textWidget(
                          height,
                          widget.workDetails[ind]['workDone'],
                          height * 0.010,
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: percentIndicator(
                        height * 2,
                        double.parse(widget.workDetails[ind]
                                    ['workPercentage']
                                .replaceAll(RegExp(r'.$'), "")) /
                            100,
                        widget.workDetails[ind]['workPercentage'],
                        double.parse(widget.workDetails[ind]
                                        ['workPercentage']
                                    .replaceAll(RegExp(r'.$'), "")) <
                                50
                            ? Colors.black
                            : ConstantColor.background1Color,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        textWidget(
                            height,
                            'Start : ${widget.workDetails[ind]['from']}',
                            height * 0.010),
                        textWidget(
                            height,
                            'End : ${widget.workDetails[ind]['to']}',
                            height * 0.010),
                        textWidget(
                            height,
                            'Duration : ${widget.workDetails[ind]['time_in_hours']}',
                            height * 0.010),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget percentIndicator(
      double height, double percent, String val, Color color) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1000,
      lineHeight: height * 0.013,
      percent: percent,
      backgroundColor: Colors.black.withOpacity(0.05),
      // progressColor: Colors.cyan,
      linearGradient:
          const LinearGradient(colors: [Color(0xff21d4fd), Color(0xffb721ff)]),
      center: Text(
        val,
        style: TextStyle(
            fontFamily: ConstantFonts.poppinsMedium,
            color: color,
            fontSize: height * 0.010,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget textWidget(double height, String name, double size) {
    return AutoSizeText(
      name,
      style: TextStyle(
          fontSize: size * 2,
          fontFamily: ConstantFonts.poppinsMedium,
          color: ConstantColor.blackColor),
    );
  }

  Widget buildNeumorphic(double width, double height, Widget widget) {
    return Neumorphic(
      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
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
