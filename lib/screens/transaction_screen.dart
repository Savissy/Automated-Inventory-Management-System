import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/screens/product_module.dart';
import 'package:inventory_management/screens/maintenance_module.dart'; // Changed import
import 'package:inventory_management/utils/custom_appbar.dart';
import 'package:inventory_management/utils/flutter_toast.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(255, 154, 209, 235),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customAppbar(),
              ListTile(
                title: Container(
                  color: const Color.fromARGB(255, 2, 52, 94),
                  child: const Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text(
                            '     No',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            'Date',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 6,
                          child: Text(
                            'Description',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded( // Changed from 'Type' to 'Asset'
                          flex: 2,
                          child: Text(
                            'Asset',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            'Amount',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('transactions')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No Data'));
                  }
                  final fetchedData = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: fetchedData.length,
                    itemBuilder: (context, index) {
                      final info = fetchedData[index];
                      return Card(
                        elevation: 3,
                        color: const Color.fromARGB(255, 192, 188, 188),
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    '     ${index + 1}',
                                    style: const TextStyle(color: Colors.black),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    DateFormat('dd MMM, yyyy').format(
                                        (info['date'] as Timestamp).toDate()),
                                    style: const TextStyle(color: Colors.black),
                                  )),
                              Expanded(
                                  flex: 6,
                                  child: Text(
                                    info['desc'],
                                    style: const TextStyle(color: Colors.black),
                                  )),
                              Expanded( // Changed from 'type' to 'asset'
                                  flex: 2,
                                  child: Text(
                                    info['asset'],
                                    style: const TextStyle(color: Colors.black),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    info['amount'],
                                    style: const TextStyle(color: Colors.black),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 2, 52, 94),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '  Manage Maintenance', // Changed from Transaction to Maintenance
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'Product_page_to_module',
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MaintenanceModule(), // Changed to MaintenanceModule
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade800, Colors.blue.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
