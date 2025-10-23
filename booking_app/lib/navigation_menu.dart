import 'package:booking_app/features/screen/chat/chat_ui.dart';
import 'package:booking_app/features/screen/list/list.dart';
import 'package:booking_app/features/screen/dashboard/dashboard.dart';
import 'package:booking_app/utils/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/features/screen/notification/notification_screen.dart';
import 'package:booking_app/features/screen/user/customer.dart';


class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = WHelpersFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.activity), label: 'Chat'),
            NavigationDestination(icon: Icon(Iconsax.notification), label: 'Notifications'),
            NavigationDestination(icon: Icon(Iconsax.category), label: 'Check list'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Mine'),

          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const DashboardScreen(),
    const ChatUIScreen(),
    const NotificationScreen(),
    const ListScreen(),
    const CustomerOrdersScreen(orders: []),
  ];
}
