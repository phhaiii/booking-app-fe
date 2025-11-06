import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/features/controller/createpost_controller.dart';
import 'package:booking_app/common/createpost/poststatus_card.dart';
import 'package:booking_app/common/createpost/basicinfo_section.dart';
import 'package:booking_app/common/createpost/image_section.dart';
import 'package:booking_app/common/createpost/details_section.dart';
import 'package:booking_app/common/createpost/content_section.dart';
import 'package:booking_app/common/createpost/amenities_section.dart';
import 'package:booking_app/common/createpost/menu_section.dart';
import 'package:booking_app/common/createpost/settings_section.dart';
import 'package:booking_app/common/createpost/bottomactions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreatePostController());

    return Scaffold(
      appBar: _buildAppBar(controller),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(WSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostStatusCard(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              BasicInfoSection(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              ImagesSection(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              DetailsSection(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              ContentSection(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),

              // ✅ THÊM: Menu Section
              MenuSection(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),

              AmenitiesSection(controller: controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              SettingsSection(controller: controller),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomActions(controller: controller),
    );
  }

  AppBar _buildAppBar(CreatePostController controller) {
    return AppBar(
      title: const Text(
        'Tạo Bài Viết',
        style: TextStyle(
          color: WColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left, color: WColors.primary),
        onPressed: () => Get.back(),
      ),
    );
  }
}
