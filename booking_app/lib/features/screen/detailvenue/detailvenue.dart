import 'package:booking_app/features/screen/detailvenue/commentbottomsheet.dart';
import 'package:booking_app/features/screen/detailvenue/menubottom_sheet.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenuewidgets/detail_venue_app_bar.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenuewidgets/state_widgets.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenuewidgets/image_gallery_section.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenuewidgets/basic_info_section.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenuewidgets/stats_section.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenuewidgets/description_section.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenuewidgets/amenities_section.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenuewidgets/services_section.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenuewidgets/reviews_section.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenuewidgets/contact_section.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenuewidgets/bottom_action_buttons.dart';
import 'package:booking_app/model/menu_model.dart';
import 'package:booking_app/features/controller/detailvenue_controller.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/features/screen/list/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailVenueScreen extends StatelessWidget {
  final String? venueId;

  const DetailVenueScreen({
    super.key,
    this.venueId,
  });

  @override
  Widget build(BuildContext context) {
    final String currentVenueId = venueId ??
        Get.arguments?['venueId']?.toString() ??
        Get.parameters['venueId']?.toString() ??
        '';

    final controller = Get.put(
      DetailVenueController(),
      tag: currentVenueId,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentVenueId.isNotEmpty) {
        controller.loadVenueDetails(currentVenueId);
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: DetailVenueAppBar(controller: controller),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingStateWidget();
        }

        if (controller.hasError.value) {
          return ErrorStateWidget(
            controller: controller,
            venueId: currentVenueId,
          );
        }

        if (currentVenueId.isEmpty) {
          return const EmptyIdStateWidget();
        }

        if (controller.venue.value == null) {
          return const NoDataStateWidget();
        }

        final venue = controller.venue.value!;

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: WColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ImageGallerySection(
                  images: venue.images,
                  controller: controller,
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BasicInfoSection(venue: venue),
                      const Divider(height: 1),
                      StatsSection(controller: controller),
                      const Divider(height: 1),
                      DescriptionSection(venue: venue),
                      const SizedBox(height: 12),
                      const Divider(height: 1, thickness: 8),
                      AmenitiesSection(venue: venue),
                      const Divider(height: 1, thickness: 8),
                      ServicesSection(
                        venue: venue,
                        onMenuTap: () => _showMenuBottomSheet(venue),
                      ),
                      const Divider(height: 1, thickness: 8),
                      ReviewsSection(
                        controller: controller,
                        onShowAllComments: () => _showAllComments(controller),
                        venueId: currentVenueId,
                      ),
                      const Divider(height: 1, thickness: 8),
                      ContactSection(venue: venue),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value ||
            controller.hasError.value ||
            controller.venue.value == null) {
          return const SizedBox.shrink();
        }
        return BottomActionButtons(
          venue: controller.venue.value!,
          onBookingPressed: () => _navigateToBooking(controller.venue.value!),
        );
      }),
    );
  }

  void _navigateToBooking(venue) {
    Get.to(
      () => const CalendarScreen(),
      arguments: {
        'venueId': venue.id,
        'venueTitle': venue.title,
        'venuePrice': venue.price,
        'venueCapacity': venue.capacity,
      },
      transition: Transition.rightToLeft,
    );
  }

  void _showMenuBottomSheet(venue) async {
    final selectedMenu = await Get.bottomSheet<MenuModel>(
      MenuBottomSheet(venue: venue),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if (selectedMenu != null) {
      Get.to(() => const CalendarScreen(), arguments: {
        'venueId': venue.id,
        'venueTitle': venue.title,
        'venuePrice': venue.price,
        'venueCapacity': venue.capacity,
        'selectedMenu': selectedMenu.toJson(),
      });
    }
  }

  void _showAllComments(DetailVenueController controller) {
    Get.bottomSheet(
      CommentBottomSheet(
        venueId: controller.venue.value?.id.toString() ?? '',
        onCommentAdded: (content, rating, images) {
          controller.addComment(
            content: content,
            rating: rating,
            imagePaths: images,
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
