import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_management/screens/order_module.dart';
import 'package:inventory_management/utils/custom_appbar.dart';
import 'package:inventory_management/utils/generate_pdf.dart';
import 'package:inventory_management/utils/input_box.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController searchText = TextEditingController();

  Future<void> generateReport() async {
    // Fetch data from respective collections
    final totalClients = await getTotalClients();
    final totalAssets = await getTotalAssets();
    final maintenanceCost = await getOverallMaintenanceCost();
    final assetsCost = await getOverallAssetsCost();
    final tenderPerformance = maintenanceCost / assetsCost;

    final pdf = pw.Document();
    
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(level: 0, child: pw.Text('Inventory Management Report')),
            pw.Text('Total Number of Clients: $totalClients'),
            pw.Text('Total Number of Assets: $totalAssets'),
            pw.Text('Overall Maintenance Cost: \$${maintenanceCost.toStringAsFixed(2)}'),
            pw.Text('Overall Assets Cost: \$${assetsCost.toStringAsFixed(2)}'),
            pw.Text('Tender Performance: ${tenderPerformance.toStringAsPercentage()}'),
          ]
        );
      },
    ));

    // Save and launch the PDF
    await savePdfFile(pdf, 'Inventory_Report_${DateTime.now().toIso8601String()}.pdf');
  }

  Future<int> getTotalClients() async {
    // Implement actual client count from customer_screen.dart
    final snapshot = await FirebaseFirestore.instance.collection('customers').get();
    return snapshot.docs.length;
  }

  Future<int> getTotalAssets() async {
    // Implement actual asset count from product_screen.dart
    final snapshot = await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.length;
  }

  Future<double> getOverallMaintenanceCost() async {
    // Implement maintenance cost calculation from transaction_screen.dart
    final snapshot = await FirebaseFirestore.instance.collection('transactions').get();
    return snapshot.docs.fold(0.0, (sum, doc) => sum + (doc['maintenance_cost'] ?? 0.0));
  }

  Future<double> getOverallAssetsCost() async {
    // Implement assets cost calculation from product_screen.dart
    final snapshot = await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.fold(0.0, (sum, doc) => sum + (doc['price'] ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(255, 154, 209, 235),
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
                          flex: 1,
                          child: Text(
                            '     No',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            'ID',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            'Date',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Asset ID',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            'Asset Name',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            'Client ID',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 5,
                          child: Text(
                            'Client Name',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            'Quantity ',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            'Price',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            'Total Amount',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ),
              ),

              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('orders').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null) {
                    return Center(child: Text('No Data'));
                  }
                  final fetchedData = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: fetchedData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Column(
                        children: [
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  '     ${index + 1}',
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  fetchedData[index]['id'],
                                )),
                            const Expanded(
                                flex: 2,
                                child: Text(
                                  '3rd Dec',
                                )),
                            Expanded(
                                flex: 3,
                                child: Text(
                                  fetchedData[index]['product_id'],
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  fetchedData[index]['product_name'],
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  fetchedData[index]['customer_id'],
                                )),
                            Expanded(
                                flex: 5,
                                child: Text(
                                  fetchedData[index]['customer_name'],
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  fetchedData[index]['quantity'],
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  fetchedData[index]['price'],
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  fetchedData[index]['total'],
                                )),
                            const SizedBox(width: 10),
                            const Expanded(
                                flex: 2,
                                child: Text(
                                  'Delete',
                                )),
                          ]),
                          const Divider(
                            color: Color.fromARGB(255, 0, 0, 0),
                            height: 22.0,
                            thickness: 2.0,
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                        ],
                      ));
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: const Color.fromARGB(255, 2, 52, 94),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 10),
                  child: Text(
                    '  Manage',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        ' Search',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 250,
                        height: 30,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter ID to search',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: const Text('Quantity                     ',
                        style: TextStyle(color: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: const Text("  Total Amount",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order   :   ', style: TextStyle(color: Colors.white)),
                  Text('          120', style: TextStyle(color: Colors.white)),
                  Text("                                18490  ",
                      style: TextStyle(color: Colors.white))
                ],
              )
            ]),
            Row(
              children: [
                ElevatedButton(
                  onPressed: generateReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text('Generate Report', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderModule(),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
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
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension Percentage on double {
  String toStringAsPercentage() {
    return '${(this * 100).toStringAsFixed(2)}%';
  }
}
