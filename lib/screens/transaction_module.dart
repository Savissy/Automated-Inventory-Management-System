import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/screens/product_screen.dart';
import 'package:inventory_management/screens/transaction_screen.dart';
import 'package:inventory_management/utils/custom_appbar.dart';
import 'package:inventory_management/utils/custom_dropdown.dart';

import 'package:inventory_management/utils/custome_button.dart';
import 'package:inventory_management/utils/flutter_toast.dart';
import 'package:inventory_management/utils/input_box.dart';

class MaintenanceModule extends StatefulWidget {
  const MaintenanceModule({super.key});

  @override
  State<MaintenanceModule> createState() => _MaintenanceModuleState();
}

class _MaintenanceModuleState extends State<MaintenanceModule> {
  TextEditingController productNameText = TextEditingController();

  TextEditingController assetText = TextEditingController(); // Changed from transactionType to assetText

  TextEditingController priceText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();

  TextEditingController categoryText = TextEditingController();

  String generateRandomID() {
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    final _rnd = Random();

    String getRandomString(int length) => String.fromCharCodes(
          Iterable.generate(
            length,
            (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
          ),
        );

    return getRandomString(4); // Generate a 4-letter random ID
  }

  void uploadToFirebase() async {
    if (assetText.text.isEmpty ||
        descriptionText.text.isEmpty ||
        priceText.text.isEmpty) {
      showToastMessage('Please input first', context, false);
      return;
    }
    print('Tapped');
    await FirebaseFirestore.instance.collection('transactions').add({
      'desc': descriptionText.text,
      'id': generateRandomID(),
      'asset': assetText.text, // Changed from 'type' to 'asset'
      'date': DateTime.now(),
      'amount': priceText.text
    });
    showToastMessage('Maintenance record has been added!', context, true); // Updated message

    if (context.mounted) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const TransactionPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 154, 209, 235),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customAppbar(),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 35,
                color: const Color.fromARGB(255, 240, 21, 5),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Maintenance Module', // Changed from 'Transaction Module' to 'Maintenance Module'
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  CustomInputBox(
                    controller: descriptionText,
                    title: ' Description',
                  ),
                  CustomInputBox( // Replaced CustomDropDown with CustomInputBox for 'Asset'
                    controller: assetText,
                    title: ' Asset', // Changed from 'Type' to 'Asset'
                  ),
                  CustomInputBox(
                    controller: priceText,
                    title: 'Amount',
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                    onTap: uploadToFirebase,
                    child: customButton(
                      title: 'Save',
                      startingColor: Colors.green.shade300,
                      endColor: Colors.green.shade900,
                    )),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: customButton(
                    title: 'Cancel',
                    startingColor: Colors.red.shade900,
                    endColor: Colors.red.shade300,
                  ),
                )
              ])
            ],
          ),
        ));
  }
}
