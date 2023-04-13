import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final ref = FirebaseDatabase.instance.ref();

  TextEditingController textEditingController = TextEditingController();

  List listOfProd = [];

  var s;

  Future<void> getProducts() async {
    ref.child('inventory_management').once().then((value) {
      for (var a in value.snapshot.children) {
        // print(a.key);
        setState(() {
          s = a.value;
          listOfProd.add(s['name']);
          // print(listOfProd);
        });
      }
    });
  }

  String? productName;
  String? price;
  var setval;

  Future<void> getProductsDetails() async {
    // print('hi');
    ref.child('inventory_management').once().then((value) {
      for (var a in value.snapshot.children) {
        // print(a.value);
        if(a.value.toString().contains(selectedVal.toString())){
          print(a.value);
          setval = a.value;
          setState(() {
            productName = setval['name'];
            price = setval['max_price'];
          });

        }
      }
    });
  }

  String? _chosenValue;

  String? selectedVal;

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(
            height: 300,
            child: ListView.builder(
                itemCount: listOfProd.length,
                itemBuilder: (BuildContext context, int i) {
                  return GestureDetector(
                    onTap: () {
                      // print(listOfProd[i]);
                      selectedVal = listOfProd[i];
                      setState(() {
                        getProductsDetails();
                      });
                    },
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        height: 50,
                        color: Colors.amber,
                        child: Center(child: Text(listOfProd[i]))),
                  );
                }),
          ),
          DropdownButton<String>(
            focusColor:Colors.white,
            value: _chosenValue,
            //elevation: 5,
            style: TextStyle(color: Colors.white),
            iconEnabledColor:Colors.black,
            items: listOfProd.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,style:TextStyle(color:Colors.black),),
              );
            }).toList(),
            hint:Text(
              "Please choose a langauage",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            onChanged: (value) {
              setState(() {
                _chosenValue = value;
              });
            },
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {

              },
              child: Text('get'),
            ),
          ),
          Text(productName.toString()),
          Text(price.toString()),
        ],
      ),
    );
  }
}
