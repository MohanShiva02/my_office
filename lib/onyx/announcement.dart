import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:confetti/confetti.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _form = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xffDDE6E8),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text(
            'Points Calculations',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xffDDE6E8),
          elevation: 0,
        ),
        body: Form(
          key: _form,
          child: Stack(
           children:[
             Positioned(
               top: height *  0.01,
               left: width*  0.01,
               child: Stack(
                 alignment: Alignment.center,
                 children: [
                   //left container
                   ClayContainer(
                     parentColor: Color(0xffDDE6E8),
                     color: Color(0xffDDE6E8),
                     width: 170,
                     height: 170,
                     borderRadius: 200,
                     depth: 70,
                     spread: 0,

                     curveType: CurveType.convex,
                   ),

                   //left inside container1
                   ClayContainer(
                     parentColor: Color(0xffDDE6E8),
                     color: Color(0xffDDE6E8),
                     width: 140,
                     height: 140,
                     borderRadius: 200,
                     depth: -50,

                     curveType: CurveType.convex,
                   ),

                   //left inside container2
                   ClayContainer(
                     surfaceColor: Colors.orange,
                     color: Color(0xffDDE6E8),
                     width: 70,
                     height: 70,
                     borderRadius: 200,
                     depth: 70,
                     curveType: CurveType.convex,
                     spread: 23,
                   ),
                 ],
               ),
             ),
             Positioned(
               top: height *  0.3,
              right: width* - 0.33,
              // right: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  //Top right Container
                  ClayContainer(
                    color: Color(0xffDDE6E8),
                    width: 220,
                    height: 220,
                    borderRadius: 200,
                    depth: -50,
                    curveType: CurveType.convex,
                  ),

                  //top right inside1 container
                  ClayContainer(
                    parentColor: Color(0xffDDE6E8),
                    color: Color(0xffDDE6E8),
                    width: 180,
                    height: 180,
                    borderRadius: 200,
                    depth: 70,
                    spread: 5,

                  ),

                  ClayContainer(
                    color: Color(0xffDDE6E8),
                    width: 140,
                    height: 140,
                    borderRadius: 200,
                    depth: -50,

                    curveType: CurveType.convex,
                  ),

                  ClayContainer(
                    surfaceColor: Colors.orange.shade500,
                    color: Color(0xffDDE6E8),
                    width: 100,
                    height: 100,
                    borderRadius: 200,
                    depth: 70,
                  ),
                ],
              ),
            ),

             Positioned(
               left: width * - 0.04,
               bottom:height * - 0.05,
               child: Stack(
                 alignment: Alignment.topRight,
                 children: [
                   ClayContainer(
                     // child: Lottie.asset('assets/14982-smart-home.json'),
                     color: Colors.orange,
                     width: 180,
                     height: 180,
                     borderRadius: 200,
                     depth: 80,
                     spread: 5,
                     curveType: CurveType.convex,

                   ),
                   ClayContainer(
                     color: Color(0xffDDE6E8),
                     width: 60,
                     height: 60,
                     borderRadius: 200,
                     depth: -50,
                     spread: 0,

                     curveType: CurveType.convex,
                   ),

                 ],
               ),
             ),
          ],
          ),
        ),
    );
  }
}


