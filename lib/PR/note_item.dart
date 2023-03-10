import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Constant/fonts/constant_font.dart';

class NoteItem extends StatefulWidget {
  final String updatedStaff;
  final String updatedTime;
  final String updatedDate;
  final String note;

  const NoteItem({
    Key? key,
    required this.note,
    required this.updatedDate,
    required this.updatedStaff,
    required this.updatedTime,
  }) : super(key: key);

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
   var firebaseRef  = FirebaseDatabase.instance.ref().child('customer/');
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.3), blurRadius: 5.0)
          ],
          color: Colors.white),
      child: Column(
        children: [
          //heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Staff name
              Text(
                widget.updatedStaff,
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 13.0,
                ),
              ),

              //updated datetime
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.updatedDate,
                    style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    widget.updatedTime,
                    style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              )
            ],
          ),
          const Divider(height: 0.0),
          //body

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              widget.note,
              style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
