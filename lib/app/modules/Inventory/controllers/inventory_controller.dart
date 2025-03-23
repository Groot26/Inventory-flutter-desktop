import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/product.dart';
import '../../../../data/repos/api_repo.dart';

class InventoryController extends GetxController {
  // final RxList<Product> productList = <Product>[].obs;
  // final ApiRepo apiRepo = ApiRepo();
  //
  // @override
  // void onInit() {
  //   super.onInit();
  //   getProducts();
  // }
  //
  // void getProducts() {
  //   apiRepo.getAllProducts().listen((products) {
  //     productList.assignAll(products);
  //   });
  // }
  //
  // Future<void> addProduct({
  //   required String name,
  //   required String barcode,
  //   required double mrp,
  //   required double price,
  //   required int stock,
  // }) async {
  //   final newProduct = Product(
  //     id: '', // Firestore auto-generates ID
  //     name: name,
  //     barcode: barcode,
  //     mrp: mrp,
  //     price: price,
  //     stock: stock,
  //     createdAt: Timestamp.now(),
  //   );
  //
  //   await apiRepo.addProduct(newProduct);
  // }


  RxList<Product> productList = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }


  void getProducts() {
    ApiRepo().getAllProducts().listen((products) {
      productList.assignAll(products);
    });
  }


  void showAddProductDialog() {
    showProductDialog(isEditing: false);
  }


  void showEditProductDialog(Product product) {
    showProductDialog(isEditing: true, product: product);
  }


  void showProductDialog({required bool isEditing, Product? product}) {
    TextEditingController nameController = TextEditingController(text: product?.name ?? '');
    TextEditingController barcodeController = TextEditingController(text: product?.barcode ?? '');
    TextEditingController mrpController = TextEditingController(text: product?.mrp.toString() ?? '');
    TextEditingController priceController = TextEditingController(text: product?.price.toString() ?? '');
    TextEditingController stockController = TextEditingController(text: product?.stock.toString() ?? '');

    Get.dialog(
      AlertDialog(
        title: Text(isEditing ? "Edit Product" : "Add Product"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Product Name")),
            TextField(controller: barcodeController, decoration: InputDecoration(labelText: "Barcode")),
            TextField(controller: mrpController, decoration: InputDecoration(labelText: "MRP"), keyboardType: TextInputType.number),
            TextField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            TextField(controller: stockController, decoration: InputDecoration(labelText: "Stock"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (isEditing) {
                updateProduct(
                  id: product!.id,
                  name: nameController.text,
                  barcode: barcodeController.text,
                  mrp: double.parse(mrpController.text),
                  price: double.parse(priceController.text),
                  stock: int.parse(stockController.text),
                );
              } else {
                addProduct(
                  name: nameController.text,
                  barcode: barcodeController.text,
                  mrp: double.parse(mrpController.text),
                  price: double.parse(priceController.text),
                  stock: int.parse(stockController.text),
                );
              }
              Get.back();
            },
            child: Text(isEditing ? "Update" : "Add"),
          ),
        ],
      ),
    );
  }


  Future<void> addProduct({
    required String name,
    required String barcode,
    required double mrp,
    required double price,
    required int stock,
  }) async {
    await ApiRepo().addProduct(
      Product(
        id: '',
        name: name,
        barcode: barcode,
        mrp: mrp,
        price: price,
        stock: stock,
        createdAt: Timestamp.now(),
      ),
    );
  }


  Future<void> updateProduct({
    required String id,
    required String name,
    required String barcode,
    required double mrp,
    required double price,
    required int stock,
  }) async {
    await ApiRepo().updateProduct(
      Product(
        id: id,
        name: name,
        barcode: barcode,
        mrp: mrp,
        price: price,
        stock: stock,
        createdAt: Timestamp.now(),
      ),
    );
  }


  Future<void> deleteProduct(String id) async {
    await ApiRepo().deleteProduct(id);
  }
}