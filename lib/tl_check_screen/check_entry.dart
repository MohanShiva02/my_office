import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_entry_model.dart';
import 'package:my_office/tl_check_screen/staff_entry_check.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';
import '../util/screen_template.dart';

class CheckEntryScreen extends StatefulWidget {
  final String userId;
  final String staffName;

  const CheckEntryScreen(
      {Key? key, required this.userId, required this.staffName})
      : super(key: key);

  @override
  State<CheckEntryScreen> createState() => _CheckEntryScreenState();
}

class _CheckEntryScreenState extends State<CheckEntryScreen> {
  List<StaffAttendanceModel> adminStaffNames = [];
  List<String> attendanceTime = [];
  DateTime dateTime = DateTime.now();
  bool isLoading = true;
  final ref = FirebaseDatabase.instance.ref();
  final fingerPrint = FirebaseDatabase.instance.ref();
  final virtualAttendance = FirebaseDatabase.instance.ref();

  Future<void> staffDetails() async {
    adminStaffNames.clear();
    List<StaffAttendanceModel> fullEntry = [];
    await ref.child('staff_details').once().then((staffEntry) async {
      for (var data in staffEntry.snapshot.children) {
        var entry = data.value as Map<Object?, Object?>;
        final staffEntry = StaffAttendanceModel(
          uid: data.key.toString(),
          department: entry['department'].toString(),
          name: entry['name'].toString(),
        );
        fullEntry.add(staffEntry);
        if (staffEntry.department == "MEDIA" ||
            staffEntry.department == "WEB" ||
            staffEntry.department == "APP" ||
            staffEntry.department == "RND" ||
            staffEntry.department == "PR") {
          adminStaffNames.add(staffEntry);
        }
      }
      for (var admin in adminStaffNames) {
        final time = await entryCheck(admin.uid);
        adminStaffNames
            .firstWhere((element) => element.uid == admin.uid)
            .entryTime = time;
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<String> entryCheck(String uid) async {
    String entryTime = '';
    var dateFormat = DateFormat('yyyy-MM-dd').format(dateTime);
    await fingerPrint
        .child('fingerPrint/$uid/$dateFormat')
        .once()
        .then((entry) async {
      if (entry.snapshot.value != null) {
        final data = entry.snapshot.value as Map<Object?, Object?>;
          entryTime = data.keys.last.toString();
      } else {
        entryTime = await checkVirtualAttendance(uid);
      }
    });
    return entryTime;
  }

  Future<String> checkVirtualAttendance(String uid) async {
    var yearFormat = DateFormat('yyyy').format(dateTime);
    var monthFormat = DateFormat('MM').format(dateTime);
    var dateFormat = DateFormat('yyyy-MM-dd').format(dateTime);
    String attendTime = '';
    await virtualAttendance
        .child(
            'virtualAttendance/$uid/$yearFormat/$monthFormat/$dateFormat')
        .once()
        .then((virtual) {
      try {
        final data = virtual.snapshot.value as Map<Object?, Object?>;
        attendTime = data['Time'].toString();
      } catch (e) {
        log('error is $e');
      }
    });
    return attendTime;
  }

  @override
  void initState() {
    staffDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Check-in time',
        templateBody: checkEntry(),
        bgColor: ConstantColor.background1Color);
  }

  Widget checkEntry() {
    return isLoading
        ? Column(
          children: [
            Center(
                child: Lottie.asset(
                  "assets/animations/id_entry.json",
                ),
              ),
            Text('Please wait.. Fetching data⌛',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsRegular,
              fontWeight: FontWeight.w600,
              color: ConstantColor.blackColor,
              fontSize: 17
            ),)
          ],
        )
        : widget.staffName == 'Nikhil Deepak' ||
        widget.staffName == 'Devendiran' ||
        widget.staffName == 'Anitha' ||
        widget.staffName == 'Prem Kumar' ||
        widget.staffName == 'Koushik Romel'
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: adminStaffNames.length,
                                itemBuilder: (ctx, i) {
                                  return Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: ConstantColor.background1Color,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: const Offset(-0.0, 5.0),
                                          blurRadius: 8,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: Center(
                                      child: ListTile(
                                        onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                StaffEntryCheckScreen(
                                              staffDetail: adminStaffNames[i],
                                            ),
                                          ),
                                        ),
                                        leading: const CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              ConstantColor.backgroundColor,
                                          child: Icon(Icons.person),
                                        ),
                                        title: Text(
                                          adminStaffNames[i].name,
                                          style: TextStyle(
                                              fontFamily:
                                                  ConstantFonts.poppinsMedium,
                                              color: ConstantColor.blackColor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.020),
                                        ),
                                        trailing: Text(
                                          adminStaffNames[i]
                                                  .entryTime
                                                  .toString()
                                                  .isEmpty
                                              ? 'Absent'
                                              : adminStaffNames[i]
                                                  .entryTime
                                                  .toString(),
                                          style: TextStyle(
                                              fontFamily:
                                                  ConstantFonts.poppinsMedium,
                                              color: adminStaffNames[i]
                                                      .entryTime
                                                      .toString()
                                                      .isEmpty
                                                  ? Colors.red
                                                  : ConstantColor.blackColor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.020),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Column(
                              children: [
                                Lottie.asset('assets/animations/new_loading', height: 300),
                                Center(
                                    child: Text(
                                      'No Entry Registered!!!',
                                      style: TextStyle(
                                        color: ConstantColor.backgroundColor,
                                        fontSize: 20,
                                        fontFamily: ConstantFonts.poppinsRegular,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            );
  }
}
