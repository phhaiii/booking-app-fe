import 'package:booking_app/features/screen/dashboard/dashboard_card.dart';
import 'package:booking_app/features/screen/profile/proflie_screen.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/utils/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/features/controller/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          WTexts.wAppName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: WColors.primary,
              ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: WSizes.defaultSpace),
            child: IconButton(
              onPressed: () => Get.to(() => const ProfileScreen()),
              icon: const Icon(
                Iconsax.profile_circle,
                size: 32,
                color: WColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        // ✅ LOADING STATE - First time loading
        if (controller.isLoading.value && controller.venues.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: WColors.primary),
                SizedBox(height: WSizes.spaceBtwItems),
                Text('Đang tải danh sách venue...'),
              ],
            ),
          );
        }

        // ✅ ERROR STATE
        if (controller.hasError && controller.venues.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(WSizes.defaultSpace),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.warning_2,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Text(
                    'Đã có lỗi xảy ra',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.red.shade700,
                        ),
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems / 2),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  ElevatedButton.icon(
                    onPressed: () => controller.loadVenues(isRefresh: true),
                    icon: const Icon(Iconsax.refresh),
                    label: const Text('Thử lại'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: WSizes.defaultSpace,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ EMPTY STATE (no venues)
        if (controller.venues.isEmpty && !controller.isLoading.value) {
          return RefreshIndicator(
            onRefresh: controller.refreshVenues,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(WSizes.defaultSpace),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.search_normal,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: WSizes.spaceBtwItems),
                        Text(
                          'Chưa có venue nào',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: WSizes.spaceBtwItems / 2),
                        Text(
                          controller.searchQuery.isEmpty
                              ? 'Hệ thống chưa có địa điểm nào.\nKéo xuống để làm mới.'
                              : 'Không tìm thấy venue phù hợp với\n"${controller.searchQuery.value}"',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade500,
                                  ),
                        ),
                        const SizedBox(height: WSizes.spaceBtwItems),
                        ElevatedButton.icon(
                          onPressed: () =>
                              controller.loadVenues(isRefresh: true),
                          icon: const Icon(Iconsax.refresh),
                          label: const Text('Tải lại'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // ✅ SUCCESS STATE - Show venues list
        return RefreshIndicator(
          onRefresh: controller.refreshVenues,
          color: WColors.primary,
          child: Column(
            children: [
              // ✅ Search Box
              _buildSearchBox(context, controller, searchController),

              const SizedBox(height: WSizes.spaceBtwItems),

              // ✅ Results Count
              if (controller.venues.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: WSizes.defaultSpace,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Tìm thấy ${controller.venues.length} địa điểm',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      if (controller.searchQuery.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            controller.searchQuery.value,
                            style: const TextStyle(fontSize: 12),
                          ),
                          deleteIcon:
                              const Icon(Iconsax.close_circle, size: 16),
                          onDeleted: () {
                            searchController.clear();
                            controller.clearSearch();
                          },
                          backgroundColor: WColors.primary.withOpacity(0.1),
                          labelStyle: const TextStyle(color: WColors.primary),
                        ),
                      ],
                    ],
                  ),
                ),

              const SizedBox(height: WSizes.spaceBtwItems / 2),

              // ✅ Venues List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: WSizes.defaultSpace,
                  ),
                  itemCount: controller.venues.length +
                      (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // ✅ Load more indicator at the end
                    if (index == controller.venues.length) {
                      // Auto load more when scrolling to end
                      if (controller.hasMore.value &&
                          !controller.isLoading.value) {
                        controller.loadMore();
                      }

                      return const Padding(
                        padding: EdgeInsets.all(WSizes.defaultSpace),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: WColors.primary,
                          ),
                        ),
                      );
                    }

                    final venue = controller.venues[index];

                    return DashboardCard(
                      venue: venue,
                      onCardPressed: () =>controller.navigateToVenueDetail(venue.id),
                    );
                  },
                ),
              ),

              // ✅ Loading indicator while loading more
              if (controller.isLoading.value && controller.venues.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(WSizes.spaceBtwItems),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: WColors.primary,
                        ),
                      ),
                      SizedBox(width: WSizes.spaceBtwItems),
                      Text('Đang tải thêm...'),
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  // ✅ Search Box Widget
  Widget _buildSearchBox(
    BuildContext context,
    DashboardController controller,
    TextEditingController searchController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: WSizes.defaultSpace),
      child: TextField(
        controller: searchController,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            controller.searchVenues(value);
          }
        },
        decoration: InputDecoration(
          hintText: WTexts.search,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(
            Iconsax.search_normal,
            color: Colors.grey.shade600,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: searchController,
            builder: (context, value, child) {
              return value.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Iconsax.close_circle,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        searchController.clear();
                        controller.clearSearch();
                      },
                    )
                  : IconButton(
                      icon: Icon(
                        Iconsax.filter,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        // TODO: Show filter dialog
                        _showFilterDialog(context, controller);
                      },
                    );
            },
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: WSizes.defaultSpace,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: WColors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  // ✅ Filter Dialog (Optional - for future use)
  void _showFilterDialog(BuildContext context, DashboardController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(WSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bộ lọc',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: WSizes.spaceBtwItems),

              // Price filter
              ListTile(
                leading: const Icon(Iconsax.money),
                title: const Text('Lọc theo giá'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.back();
                  // TODO: Show price filter
                },
              ),

              // Capacity filter
              ListTile(
                leading: const Icon(Iconsax.people),
                title: const Text('Lọc theo sức chứa'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.back();
                  // TODO: Show capacity filter
                },
              ),

              // Style filter
              ListTile(
                leading: const Icon(Iconsax.category),
                title: const Text('Lọc theo phong cách'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.back();
                  // TODO: Show style filter
                },
              ),

              const SizedBox(height: WSizes.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Đóng'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
