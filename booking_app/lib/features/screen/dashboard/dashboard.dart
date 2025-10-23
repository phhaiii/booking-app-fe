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
      body: RefreshIndicator(
        onRefresh: controller.refreshVenues,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Search Box
              _buildSearchBox(context, controller, searchController),

              const SizedBox(height: WSizes.spaceBtwItems),   

              // Loading indicator
              Obx(() => controller.isLoading.value
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(WSizes.defaultSpace),
                        child:
                            CircularProgressIndicator(color: WColors.primary),
                      ),
                    )
                  : const SizedBox.shrink()),

              // Venues list
              Obx(() => controller.venues.isEmpty && !controller.isLoading.value
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.venues.length,
                      itemBuilder: (context, index) {
                        final venue = controller.venues[index];
                        return DashboardCard(
                          venue: venue,
                          onFavoritePressed: () =>
                              controller.toggleFavorite(venue.venueId),
                          onCardPressed: () =>
                              controller.navigateToVenueDetail(venue.venueId),
                        );
                      },
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox(
    BuildContext context,
    DashboardController controller,
    TextEditingController searchController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: WSizes.defaultSpace),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          if (value.isEmpty) {
            controller.clearSearch();
          } else {
            controller.searchVenues(value);
          }
        },
        decoration: InputDecoration(
          hintText: WTexts.search,
          prefixIcon: Icon(Iconsax.search_normal, color: Colors.grey.shade600),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: searchController,
            builder: (context, value, child) {
              return value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Iconsax.close_circle),
                      onPressed: () {
                        searchController.clear();
                        controller.clearSearch();
                      },
                    )
                  : const SizedBox.shrink();
            },
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
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
            borderSide: const BorderSide(color: WColors.primary),
          ),
        ),
      ),
    );
  }
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(WSizes.defaultSpace * 2),
      child: Column(
        children: [
          Icon(
            Iconsax.search_normal,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: WSizes.spaceBtwItems),
          Text(
            'Không tìm thấy địa điểm nào',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: WSizes.spaceBtwItems / 2),
          Text(
            'Thử tìm kiếm với từ khóa khác',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      ),
    );
  }
}
