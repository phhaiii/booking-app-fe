import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/image_strings.dart';
import 'package:booking_app/utils/constants/text_strings.dart'; 
import 'package:booking_app/utils/constants/sizes.dart';  
import 'package:booking_app/utils/helpers/helpers.dart';  

class WLoginHeader extends StatelessWidget {
  const WLoginHeader({super.key,});


  @override
  Widget build(BuildContext context) {
    final dark = WHelpersFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          height: 150,
          image:
              AssetImage(dark ? WImages.lightlogo : WImages.darklogo),
        ),
        Text(
          WTexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: WSizes.small),
        Text(
          WTexts.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}