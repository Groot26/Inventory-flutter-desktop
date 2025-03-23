import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../data/models/product.dart';
import '../controllers/billing_controller.dart';

class BillingView extends GetView<BillingController> {
  final BillingController billingController = Get.put(BillingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Billing System")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Barcode Input Field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: billingController.barcodeController,
                    decoration: InputDecoration(
                      labelText: "Enter Barcode",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.qr_code_scanner),
                    ),
                    onSubmitted: (value) => billingController.fetchProduct(),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: billingController.fetchProduct,
                  child: Text("Search"),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Display Selected Product
            Obx(() {
              if (billingController.selectedProduct.value == null) {
                return SizedBox();
                  // Center(child: Text("No product selected", style: TextStyle(color: Colors.red)));
              }
              final Product product = billingController.selectedProduct.value!;
              return Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📌 Name: ${product.name}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("💰 Mrp: ₹${product.mrp}"),
                      Text("📦 Stock: ${product.stock}"),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: billingController.qtyController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Enter Quantity",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: billingController.addToBill,
                            icon: Icon(Icons.add),
                            label: Text("Add"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            SizedBox(height: 10),

            // Bill Summary Table
            Expanded(
              child: Obx(() {
                if (billingController.billedItems.isEmpty) {
                  return Center(child: Text("🛒 No items in the bill"));
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    border: TableBorder.all(),
                    columns: [
                      DataColumn(label: Text('SR No.', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('MRP (₹)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Total (₹)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: List.generate(billingController.billedItems.length, (index) {
                      final item = billingController.billedItems[index];
                      return DataRow(cells: [
                        DataCell(Text((index + 1).toString())),
                        DataCell(Text(item.name)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.red),
                                onPressed: () => billingController.updateQuantity(index, -1),
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.green),
                                onPressed: () => billingController.updateQuantity(index, 1),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text("₹${item.mrp.toStringAsFixed(2)}")),
                        DataCell(Text("₹${(item.mrp * item.quantity).toStringAsFixed(2)}")),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => billingController.removeFromBill(index),
                          ),
                        ),
                      ]);
                    }),
                  ),
                );
              }),
            ),

            // Billing Total
            Obx(() {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Total Amount: ₹${billingController.totalAmount.value.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }),

            // Checkout Button
            Center(
              child: ElevatedButton.icon(
                onPressed: billingController.generateBill,
                // icon: Icon(Icons.check),
                label: Text("Bill"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}