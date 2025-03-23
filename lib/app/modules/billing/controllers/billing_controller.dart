import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../data/models/bill.dart';
import '../../../../data/models/product.dart';
import '../../../../services/firestore_service.dart';

class BillingController extends GetxController {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var selectedProduct = Rx<Product?>(null);
  var billedItems = <BillItem>[].obs;
  var totalAmount = 0.0.obs;

  void fetchProduct() async {
    String barcode = barcodeController.text.trim();
    if (barcode.isEmpty) {
      Get.snackbar("Error", "Please enter a barcode");
      return;
    }

    QuerySnapshot snapshot = await firestore
        .collection('products')
        .where('barcode', isEqualTo: barcode)
        .get();

    if (snapshot.docs.isEmpty) {
      Get.snackbar("Not Found", "No product found with this barcode");
      selectedProduct.value = null;
      return;
    }

    var doc = snapshot.docs.first;
    selectedProduct.value = Product.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

  void addToBill() {
    if (selectedProduct.value == null) return;
    int quantity = int.tryParse(qtyController.text.trim()) ?? 1;
    if (quantity <= 0) return;

    final Product product = selectedProduct.value!;
    billedItems.add(BillItem(
      name: product.name,
      mrp: product.mrp,
      quantity: quantity,
      barcode: product.barcode,
    ));

    totalAmount.value += product.mrp * quantity;

    barcodeController.clear();
    qtyController.clear();
    selectedProduct.value = null;
  }



  void updateQuantity(int index, int change) {
    if (billedItems[index].quantity + change > 0) {
      billedItems[index] = BillItem(
        name: billedItems[index].name,
        mrp: billedItems[index].mrp,
        quantity: billedItems[index].quantity + change,
        barcode: billedItems[index].barcode,
      );
      totalAmount.value += billedItems[index].mrp * change;
    }
  }


  void removeFromBill(int index) {
    totalAmount.value -= billedItems[index].mrp * billedItems[index].quantity;
    billedItems.removeAt(index);
  }

  void generateBill() async {
    if (billedItems.isEmpty) return;

    WriteBatch batch = firestore.batch();

    for (var item in billedItems) {
      var productQuery = await firestore
          .collection("products")
          .where("barcode", isEqualTo: item.barcode)
          .get();

      if (productQuery.docs.isNotEmpty) {
        var productDoc = productQuery.docs.first;
        int currentStock = productDoc["stock"];
        int newStock = currentStock - item.quantity;

        batch.update(productDoc.reference, {"stock": newStock});
      }
    }

    Map<String, dynamic> billData = {
      "items": billedItems.map((e) => e.toJson()).toList(),
      "total": totalAmount.value,
      "timestamp": Timestamp.now(),
    };

    await firestore.collection("bills").add(billData);
    await batch.commit();

    // Get.to(() => BillPreview(billData));
    billedItems.clear();
    totalAmount.value = 0.0;
  }


}