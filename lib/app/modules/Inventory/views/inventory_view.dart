import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../data/models/product.dart';
import '../controllers/inventory_controller.dart';

class InventoryView extends GetView<InventoryController> {

  final InventoryController controller = Get.put(InventoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product List")),
      body: Obx(() {
        if (controller.productList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16.0,
            columns: const [
              DataColumn(label: Text("Sr No.")),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Barcode")),
              DataColumn(label: Text("MRP")),
              DataColumn(label: Text("Price")),
              DataColumn(label: Text("Stock")),
              DataColumn(label: Text("Actions")),
            ],
            rows: List.generate(controller.productList.length, (index) {
              final product = controller.productList[index];

              return DataRow(cells: [
                DataCell(Text("${index + 1}")),
                DataCell(Text(product.name)),
                DataCell(Text(product.barcode)),
                DataCell(Text("₹${product.mrp}")),
                DataCell(Text("₹${product.price}")),
                DataCell(Text("${product.stock}")),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          controller.showEditProductDialog(product);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          controller.deleteProduct(product.id);
                        },
                      ),
                    ],
                  ),
                ),
              ]);
            }),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.showAddProductDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}