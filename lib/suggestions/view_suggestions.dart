import 'dart:developer';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import '../Constant/colors/constant_colors.dart';
import '../util/main_template.dart';
import 'all_suggestions.dart';

class ViewSuggestions extends StatefulWidget {
  final String uid;
  final String name;

  const ViewSuggestions({Key? key, required this.uid, required this.name})
      : super(key: key);

  @override
  State<ViewSuggestions> createState() => _ViewSuggestionsState();
}

class _ViewSuggestionsState extends State<ViewSuggestions> {
  List<Map<Object?, Object?>> allSuggestion = [];
  final viewSuggest = FirebaseDatabase.instance.ref('suggestion');

  finalViewSuggestion() {
    List<Map<Object?, Object?>> suggestions = [];
    viewSuggest.once().then((suggest) {
      for (var data in suggest.snapshot.children) {
        final newSuggestion = data.value as Map<Object?, Object?>;
        suggestions.add(newSuggestion);
      }
      suggestions
          .sort((a, b) => b['date'].toString().compareTo(a['date'].toString()));
      setState(() {
        allSuggestion = suggestions;
      });
    });
  }

  @override
  void initState() {
    finalViewSuggestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Check for Suggestions!!',
        templateBody: viewSuggestionsPage(),
        bgColor: ConstantColor.background1Color);
  }

  Widget viewSuggestionsPage() {
    return allSuggestion.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: allSuggestion.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24,width: 2),
                          gradient: LinearGradient(
                              colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight
                          )
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AllSuggestions(
                                  fullSuggestions: allSuggestion[index]),
                            ),
                          );
                        },
                        leading: const CircleAvatar(
                          radius: 20,
                          backgroundColor: ConstantColor.background1Color,
                          child: Icon(Icons.date_range),
                        ),
                        title: Text(
                          allSuggestion[index]['date'].toString(),
                          style: TextStyle(
                            color: ConstantColor.background1Color,
                            fontFamily: ConstantFonts.poppinsMedium,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
