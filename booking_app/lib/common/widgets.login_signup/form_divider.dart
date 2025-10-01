import 'package:flutter/material.dart';
import 'package:booking_app/utils/helpers/helpers.dart';
import 'package:booking_app/utils/constants/colors.dart';


class WFormDivider extends StatelessWidget {
  const WFormDivider({super.key, required this.dividerText});

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    final dark = WHelpersFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Divider(color: dark ? WColors.darkGrey : WColors.grey,thickness: 0.5,indent: 60,endIndent: 5)),
        Text(dividerText,style: Theme.of(context).textTheme.labelMedium),
        Flexible(child: Divider(color: dark ? WColors.darkGrey : WColors.grey,thickness: 0.5,indent: 5,endIndent: 60)),
      ],
    );
  }
}

