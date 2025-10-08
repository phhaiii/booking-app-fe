import 'package:booking_app/common/section_heading.dart';
import 'package:booking_app/features/profile/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/common/circularImage.dart';
import 'package:booking_app/utils/constants/image_strings.dart';
import 'package:booking_app/utils/theme/text_theme.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/text_strings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(WTexts.profile, style: TextStyle(color: WColors.primary)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(WSizes.defaultSpace),
        child: Column(
          children: [
            // Profile picture
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const WCircularImage(image: WImages.splash, width: 80, height: 80),
                  TextButton(onPressed: () {}, child: const Text('change Profile picture', style: TextStyle(color: WColors.primary))),
                ],
              ),
            ),
            const SizedBox(height: WSizes.spaceBtwItems/2),
            const Divider(),
            const SizedBox(height: WSizes.spaceBtwItems),

            // Profile info
            const WSectionHeading(title: 'Profile Info', showActionButton: false),
            const SizedBox(height: WSizes.spaceBtwItems),

            WProfileMenu(title: 'Name', value: 'WedBook', onPressed: (){}),
            WProfileMenu(title: 'Username', value: 'WedBook',icon: Iconsax.copy, onPressed: (){}),

            const SizedBox(height: WSizes.spaceBtwItems/2),
            const Divider(),
            const SizedBox(height: WSizes.spaceBtwItems),

            //Heading personal info
            const WSectionHeading(title: 'Personal Info', showActionButton: false),
            const SizedBox(height: WSizes.spaceBtwItems),

            WProfileMenu(title: 'UserID', value: '123456789',icon: Iconsax.copy, onPressed: (){}),
            WProfileMenu(title: 'Email', value: 'wedbook@example.com',icon: Iconsax.copy, onPressed: (){}),
            WProfileMenu(title: 'Phone', value: '+1234567890', onPressed: (){}),
            WProfileMenu(title: 'Gender', value: 'Male', onPressed: (){}),
            WProfileMenu(title: 'Date of Birth', value: '01/01/2000', onPressed: (){}),
            const Divider(),
            const SizedBox(height: WSizes.spaceBtwItems/2),

            Center(
              child: TextButton(
                onPressed: () => Get.back(),
                child: const Text('Close Account', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

