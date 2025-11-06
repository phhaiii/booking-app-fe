import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/colors.dart';

class BookingLoadingWidget extends StatelessWidget {
  const BookingLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: WColors.primary),
          SizedBox(height: 16),
          Text('Đang tải dữ liệu...'),
        ],
      ),
    );
  }
}