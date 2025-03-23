import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../data/models/product.dart';
import '../controllers/inventory_controller.dart';

class InventoryView extends GetView<InventoryController> {
  // final controller controller = Get.put(controller());

  final InventoryController controller = Get.put(InventoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (controller.productList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: TableBorder.all(),
              columns: const [
                DataColumn(label: Text('SR No.', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Barcode', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('MRP (₹)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Price (₹)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Stock', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: List.generate(controller.productList.length, (index) {
                final Product product = controller.productList[index];
                return DataRow(cells: [
                  DataCell(Text((index + 1).toString())), // SR No.
                  DataCell(Text(product.name)), // Name
                  DataCell(Text(product.barcode)), // Barcode
                  DataCell(Text(product.mrp.toStringAsFixed(2))), // MRP
                  DataCell(Text(product.price.toStringAsFixed(2))), // Price
                  DataCell(Text(product.stock.toString())), // Stock
                ]);
              }),
            ),
          );
        }),
      ),

      // Floating Action Button to Add Product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  // Function to show the "Add Product" popup
  void _showAddProductDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController barcodeController = TextEditingController();
    final TextEditingController mrpController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Product"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, "Product Name"),
                _buildTextField(barcodeController, "Barcode"),
                _buildTextField(mrpController, "MRP (₹)", isNumber: true),
                _buildTextField(priceController, "Price (₹)", isNumber: true),
                _buildTextField(stockController, "Stock", isNumber: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Add product to Firestore
                await controller.addProduct(
                  name: nameController.text.trim(),
                  barcode: barcodeController.text.trim(),
                  mrp: double.tryParse(mrpController.text) ?? 0.0,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  stock: int.tryParse(stockController.text) ?? 0,
                );

                Navigator.pop(context); // Close dialog after adding
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Function to create a text field
  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
