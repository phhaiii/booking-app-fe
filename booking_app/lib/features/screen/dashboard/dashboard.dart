import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/utils/constants/text_strings.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.black),
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
                  onPressed: () {},
                  icon: const Image(image: AssetImage(WImages.userProfile)))),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //  Ô search nằm riêng
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: WSizes.spaceBtwItems),
                  Text(
                    WTexts.search,
                    style: txtTheme.headlineMedium
                        ?.apply(color: Colors.grey.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
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
                   Text(
                    WTexts.dashBoardingTitle,
                    style: txtTheme.headlineMedium,
                    textAlign: TextAlign.left,
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
                          border: Border.all(color: WColors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.heart_broken_rounded),
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
                          border: Border.all(color: WColors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.heart_broken_rounded),
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
                          border: Border.all(color: WColors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.heart_broken_rounded),
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
                          border: Border.all(color: WColors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.heart_broken_rounded),
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
                          border: Border.all(color: WColors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.heart_broken_rounded),
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
                          border: Border.all(color: WColors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.heart_broken_rounded),
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
