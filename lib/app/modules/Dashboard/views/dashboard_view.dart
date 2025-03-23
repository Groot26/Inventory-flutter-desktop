import 'package:code_scanner/app/modules/Inventory/views/inventory_view.dart';
import 'package:code_scanner/app/modules/billing/views/billing_view.dart';
import 'package:code_scanner/app/modules/history/views/history_view.dart';
import 'package:code_scanner/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({super.key});

  final List<Widget> pages = [
    HomeView(),
    InventoryView(),
    BillingView(),
    HistoryView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Colors.blueGrey[900],
            child: Column(
              children: [
                SizedBox(height: 50),
                SidebarItem(
                  title: 'Home',
                  icon: Icons.home,
                  index: 0,
                  controller: controller,
                ),
                SidebarItem(
                  title: 'Inventory',
                  icon: Icons.inventory_2_outlined,
                  index: 1,
                  controller: controller,
                ),
                SidebarItem(
                  title: 'Billing',
                  icon: Icons.monetization_on_outlined,
                  index: 2,
                  controller: controller,
                ),
                SidebarItem(
                  title: 'History',
                  icon: Icons.history,
                  index: 3,
                  controller: controller,
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Obx(() => pages[controller.selectedIndex.value]),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final int index;
  final DashboardController controller;

  SidebarItem({
    required this.title,
    required this.icon,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () => controller.changePage(index),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            color: controller.selectedIndex.value == index
                ? Colors.blueGrey[700]
                : Colors.transparent,
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 10),
                Text(title,
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
        ));
  }
}
