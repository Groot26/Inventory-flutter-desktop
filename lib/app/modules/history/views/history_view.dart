import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../data/models/bills.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  final HistoryController historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Billing History")),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Obx(() {
          if (historyController.bills.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // ✅ Horizontal scrolling for large tables
            child: DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Total Amount")),
                DataColumn(label: Text("Action")),
              ],
              rows: historyController.bills.map((bill) {
                return DataRow(cells: [
                  DataCell(Text(
                    bill.createdAt.toDate().toString().split('.')[0], // ✅ Format timestamp
                  )),
                  DataCell(Text("₹ ${bill.totalAmount.toStringAsFixed(2)}")),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        _showBillDetails(context, bill);
                      },
                      child: Text("View"),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
        }),
      ),
    );
  }

  void _showBillDetails(BuildContext context, Bill bill) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Bill Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Total Amount: ₹ ${bill.totalAmount.toStringAsFixed(2)}"),
              SizedBox(height: 10),
              Text("Items:"),
              Column(
                children: bill.items.map((item) {
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("Qty: ${item.quantity} x ₹${item.price}"),
                    trailing: Text("₹${(item.quantity * item.price).toStringAsFixed(2)}"),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}