import 'package:code_scanner/data/repos/api_repo.dart';
import 'package:get/get.dart';

import '../../../../data/models/bills.dart';

class HistoryController extends GetxController {


  RxList<Bill> bills = <Bill>[].obs;

  @override
  void onInit() {
    super.onInit();
     fetchBills();
  }

  void fetchBills() {
   ApiRepo().getAllBills().listen((billList) {
     bills.assignAll(billList);
   });
  }


}