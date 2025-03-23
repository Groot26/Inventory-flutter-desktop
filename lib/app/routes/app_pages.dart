import 'package:get/get.dart';

import '../modules/Dashboard/bindings/dashboard_binding.dart';
import '../modules/Dashboard/views/dashboard_view.dart';
import '../modules/Inventory/bindings/inventory_binding.dart';
import '../modules/Inventory/views/inventory_view.dart';
import '../modules/billing/bindings/billing_binding.dart';
import '../modules/billing/views/billing_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.HOME,
          page: () => HomeView(),
          binding: HomeBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.INVENTORY,
      page: () => InventoryView(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: _Paths.BILLING,
      page: () => BillingView(),
      binding: BillingBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () =>  HistoryView(),
      binding: HistoryBinding(),
    ),
  ];
}
