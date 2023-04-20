import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/util/main_template.dart';

import '../Constant/colors/constant_colors.dart';

class SuggestionScreen extends StatefulWidget {
  final String uid;
  final String name;

  const SuggestionScreen({Key? key, required this.uid, required this.name})
      : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  TextEditingController suggestionsController = TextEditingController();
  int characterCount = 0;

  @override
  void initState() {
    suggestionsController.addListener(() {
      setState(() {
        characterCount = suggestionsController.text.length;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    suggestionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MainTemplate(
        subtitle: 'Throw some Suggestions!!',
        templateBody: suggestions(height,width),
        bgColor: ConstantColor.background1Color);
  }

  Widget suggestions(double height, double width) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          buildNeumorphic(
            width,height, TextField(
              textInputAction: TextInputAction.done,
              controller: suggestionsController,
              scrollPhysics: const BouncingScrollPhysics(),
              maxLines: 10,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: ConstantFonts.poppinsRegular),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Your Suggestion',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                filled: true,
                fillColor: Color(0xffDDE6E8),
                contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ConstantColor.blackColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text('Character count : $characterCount',style: const TextStyle(color: ConstantColor.blackColor),),
          ),
          SizedBox(height: height*0.25),
          // Container(
          //   height: 60,
          //   width: 150,
          //   padding: const EdgeInsets.all(8.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       addSuggestionToDatabase();
          //     },
          //     style: ElevatedButton.styleFrom(
          //       elevation: 10,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //       backgroundColor: const Color(0xff8355B7),
          //       // fixedSize: Size(250, 50),
          //     ),
          //     child: Text(
          //       "Submit",
          //       style: TextStyle(
          //         fontSize: 17,
          //         fontWeight: FontWeight.w500,
          //         fontFamily: ConstantFonts.poppinsMedium,
          //       ),
          //     ),
          //   ),
          // ),
          GestureDetector(
            onTap: (){
              setState(() {
                addSuggestionToDatabase();
              });
            },
            child: buildNeumorphic(
              width,height, Container(
                height: height * 0.07,
                width: width * 0.9,
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        fontFamily: ConstantFonts.poppinsMedium,
                        fontSize: height * 0.025,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addSuggestionToDatabase() async {
    if (suggestionsController.text.trim().isEmpty) {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          'Suggestions should not be empty!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // print('no data');
    } else if (suggestionsController.text.length < 20) {
      final snackBar = SnackBar(
        content: Text(
          'Too short for a Suggestion',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      DateTime now = DateTime.now();
      var timeStamp = DateFormat('yyyy-MM-dd_kk:mm:ss').format(now);
      final ref = FirebaseDatabase.instance.ref();
      ref.child('suggestion/$timeStamp').update(
        {
          'date': DateFormat('yyyy-MM-dd').format(now),
          'message': suggestionsController.text.trim(),
          'time': DateFormat('kk:mm').format(now),
          'isread': false,
        },
      );
      suggestionsController.clear();
      final snackBar = SnackBar(
        content: Text(
          'Suggestions has been submitted',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
