import 'package:booking_app/features/controller/userbooking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/features/screen/userbooking/widgets/step_header_widget.dart';
import 'package:booking_app/features/screen/userbooking/widgets/venue_selector_widget.dart';
import 'package:booking_app/features/screen/userbooking/widgets/datetime_picker_widget.dart';
import 'package:booking_app/features/screen/userbooking/widgets/guest_count_selector_widget.dart';
import 'package:booking_app/features/screen/userbooking/widgets/menu_selector_widget.dart';
import 'package:booking_app/features/screen/userbooking/widgets/special_requests_widget.dart';
import 'package:booking_app/features/screen/userbooking/widgets/booking_confirm_dialog.dart';

class CreateBookingScreen extends StatelessWidget {
  const CreateBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserBookingController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đặt lịch mới',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: WColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(WSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepHeaderWidget(step: '1', title: 'Chọn địa điểm tổ chức'),
              const SizedBox(height: WSizes.spaceBtwItems),
              VenueSelectorWidget(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              const StepHeaderWidget(step: '2', title: 'Chọn ngày & giờ'),
              const SizedBox(height: WSizes.spaceBtwItems),
              DateTimePickerWidget(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              const StepHeaderWidget(step: '3', title: 'Số lượng khách'),
              const SizedBox(height: WSizes.spaceBtwItems),
              GuestCountSelectorWidget(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              const StepHeaderWidget(step: '4', title: 'Chọn menu (tùy chọn)'),
              const SizedBox(height: WSizes.spaceBtwItems),
              MenuSelectorWidget(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              const StepHeaderWidget(step: '5', title: 'Yêu cầu đặc biệt'),
              const SizedBox(height: WSizes.spaceBtwItems),
              SpecialRequestsWidget(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              _buildConfirmButton(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildConfirmButton(UserBookingController controller) {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () => BookingConfirmDialog.show(controller),
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Xác nhận đặt lịch',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ));
  }
}
