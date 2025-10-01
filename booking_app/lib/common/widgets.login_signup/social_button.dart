import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/image_strings.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/utils/constants/colors.dart';


class WSocialButton extends StatelessWidget {
  const WSocialButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: WColors.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: WSizes.iconSizeMedium,
              height: WSizes.iconSizeMedium,
              image: AssetImage(WImages.googleLogo),
            ),
          ),
        ),
        const SizedBox(width: WSizes.spaceBtwItems),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: WColors.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: WSizes.iconSizeMedium,
              height: WSizes.iconSizeMedium,
              image: AssetImage(WImages.facebookLogo),
            ),
          ),
        ),
      ],
    );
  }
}