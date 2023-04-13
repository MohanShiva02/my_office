import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Account/account_screen.dart';
import '../Constant/fonts/constant_font.dart';

class MainTemplate extends StatefulWidget {
  final Widget templateBody;
  final String subtitle;
  final Color bgColor;
  final Widget? bottomImage;

  const MainTemplate(
      {Key? key,
      required this.subtitle,
      required this.templateBody,
      required this.bgColor,
      this.bottomImage})
      : super(key: key);

  @override
  State<MainTemplate> createState() => _MainTemplateState();
}

class _MainTemplateState extends State<MainTemplate> {
  final HiveOperations _hiveOperations = HiveOperations();
  StaffModel? staffInfo;

  void getStaffDetail() async {
    final data = await _hiveOperations.getStaffDetail();
    setState(() {
      staffInfo = data;
    });
  }

  SharedPreferences? preferences;

  String preferencesImageUrl = '';

  // String preferencesImageUrl2 = '';

  Future getImageUrl() async {
    preferences = await SharedPreferences.getInstance();
    // String? image = preferences?.getString('imageValue');
    String? imageNet = preferences?.getString('imageValueNet');
    if (imageNet == null) return;
    setState(() {
      // preferencesImageUrl = image.toString();
      preferencesImageUrl = imageNet;
      // print(preferencesImageUrl2);
    });
  }

  @override
  void initState() {
    getStaffDetail();
    getImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 5));
        if (!mounted) return;
        setState(() {
          _pageLoadController();
        });
      },
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Positioned(
                top: 0,
                child: Container(
                  height: height * 1,
                  width: width,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top * 1.1),
                  decoration: const BoxDecoration(
                    image:  DecorationImage(
                        image: AssetImage(
                            // "https://img.freepik.com/premium-photo/abstract-mixed-paint-background_692702-9722.jpg?w=900",
                          "assets/243168667616.jpg"
                        ),
                      // image: NetworkImage(
                      //       "https://img.freepik.com/premium-vector/vector-abstract-background-bright-gradient-colors_106427-417.jpg?w=740"),
                        fit: BoxFit.cover,),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaY: 5,sigmaX: 5),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                        colors: [Colors.white.withOpacity(0), Colors.white.withOpacity(0.3)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight
                                    ),
                                  border: Border.all(color: Colors.white24,width: 2)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Name and subtitle
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          staffInfo == null
                                              ? 'Hi'
                                              : 'Hi ${staffInfo!.name}',
                                          style: TextStyle(
                                            fontFamily: ConstantFonts.poppinsMedium,
                                            fontSize: 24.0,
                                            color: Colors.white.withOpacity(0.8)                                          ),
                                        ),
                                        Text(
                                          widget.subtitle,
                                          style: TextStyle(
                                            fontFamily: ConstantFonts.poppinsMedium,
                                            fontSize: 14.0,
                                              color: Colors.white.withOpacity(0.8)
                                          ),
                                        ),
                                      ],
                                    ),

                                    //Profile icon
                                    GestureDetector(
                                      onTap: () {
                                        // getImageUrl();
                                        HapticFeedback.mediumImpact();
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => AccountScreen(
                                                staffDetails: staffInfo!)));
                                      },
                                      child: SizedBox(
                                        height: height * 0.08,
                                        width: height * 0.08,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: preferencesImageUrl == ''
                                                ? const Icon(Iconsax.user)
                                                : Image.network(
                                                    preferencesImageUrl,
                                                    fit: BoxFit.cover,
                                                  )
                                            // : Image.file(
                                            //     File(preferencesImageUrl).absolute,
                                            //     fit: BoxFit.cover,
                                            //   ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        //Custom widget section
                        Expanded(child: widget.templateBody),
                      ],
                    ),
                  ),
                ),
              ),
              //Illustration at the bottom
              if (widget.bottomImage != null) widget.bottomImage!,
            ],
          ),
        ),
      ),
    );
  }

  Future _pageLoadController() async {
    setState(() {
      getImageUrl();
    });
  }
}
