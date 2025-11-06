import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/models/booking_response.dart';
import 'package:booking_app/utils/helpers/booking_helper.dart';

class BookingCardTime extends StatelessWidget {
  final BookingRequestUI booking;

  const BookingCardTime({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Iconsax.clock, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Tạo lúc: ${BookingHelper.formatCreatedTime(booking.createdAt)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
          if (booking.confirmedAt != null) ...[
            const Icon(Iconsax.tick_circle, size: 14, color: Colors.green),
            const SizedBox(width: 4),
            Text(
              'Xác nhận: ${BookingHelper.formatCreatedTime(booking.confirmedAt!)}',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}