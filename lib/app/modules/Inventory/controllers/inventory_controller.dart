import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../data/models/product.dart';
import '../../../../data/repos/api_repo.dart';

class InventoryController extends GetxController {
  final RxList<Product> productList = <Product>[].obs;
  final ApiRepo apiRepo = ApiRepo();

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  void getProducts() {
    apiRepo.getAllProducts().listen((products) {
      productList.assignAll(products);
    });
  }

  Future<void> addProduct({
    required String name,
    required String barcode,
    required double mrp,
    required double price,
    required int stock,
  }) async {
    final newProduct = Product(
      id: '', // Firestore auto-generates ID
      name: name,
      barcode: barcode,
      mrp: mrp,
      price: price,
      stock: stock,
      createdAt: Timestamp.now(),
    );

    await apiRepo.addProduct(newProduct);
  }
}