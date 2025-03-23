import 'package:code_scanner/data/repos/api_repo.dart';
import 'package:get/get.dart';

import '../../../../data/models/product.dart';


class HomeController extends GetxController {
  final RxList<Product> productList = <Product>[].obs;

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
}
