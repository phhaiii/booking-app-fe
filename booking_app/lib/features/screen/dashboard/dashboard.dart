import 'package:booking_app/features/profile/proflie_screen.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/image_strings.dart';
import 'package:booking_app/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/utils/constants/text_strings.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(WTexts.wAppName,
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 20, top: 7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent),
              child: IconButton(
                  onPressed: () => Get.to(() => const ProfileScreen()),
                  icon: const Image(image: AssetImage(WImages.userProfile))),
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            //  Ô search nằm riêng
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: WSizes.defaultSpace),
              child: Container(
                width: WDeviceUtils.getScreenWidth(),
                padding: const EdgeInsets.all(WSizes.medium),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: WColors.grey)
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: WColors.grey),
                    const SizedBox(width: WSizes.spaceBtwItems),
                    Text(WTexts.search,style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
            const SizedBox(height: WSizes.spaceBtwSections),
            
            // Khung chứa nội dung
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      WTexts.dashBoardingTitle,
                      style: txtTheme.headlineMedium,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Image(
                    width: 750,
                    height: 250,
                    image: AssetImage(WImages.dashBoard1),
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Text(
                    WTexts.dashBoardingSubTitle,
                    style: txtTheme.bodySmall,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.transparent),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon( Icons.favorite, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    WTexts.dashBoardingTitle,
                    style: txtTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Image(
                    width: 750,
                    height: 250,
                    image: AssetImage(WImages.dashBoard2),
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Text(
                    WTexts.dashBoardingSubTitle1,
                    style: txtTheme.bodySmall,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon( Icons.favorite, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    WTexts.dashBoardingTitle2,
                    style: txtTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Image(
                    width: 750,
                    height: 250,
                    image: AssetImage(WImages.dashBoard2),
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Text(
                    WTexts.dashBoardingSubTitle2,
                    style: txtTheme.bodySmall,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon( Icons.favorite, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    WTexts.dashBoardingTitle3,
                    style: txtTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Image(
                    width: 750,
                    height: 250,
                    image: AssetImage(WImages.dashBoard3),
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Text(
                    WTexts.dashBoardingSubTitle3,
                    style: txtTheme.bodySmall,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon( Icons.favorite, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    WTexts.dashBoardingTitle4,
                    style: txtTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Image(
                    width: 750,
                    height: 250,
                    image: AssetImage(WImages.dashBoard4),
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Text(
                    WTexts.dashBoardingSubTitle4,
                    style: txtTheme.bodySmall,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon( Icons.favorite, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    WTexts.dashBoardingTitle5,
                    style: txtTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Image(
                    width: 750,
                    height: 250,
                    image: AssetImage(WImages.dashBoard5),
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Text(
                    WTexts.dashBoardingSubTitle5,
                    style: txtTheme.bodySmall,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon( Icons.favorite, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
