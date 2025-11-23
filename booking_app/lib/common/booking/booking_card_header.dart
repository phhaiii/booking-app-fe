import 'package:flutter/material.dart';
import 'package:booking_app/response/booking_response.dart';
import 'package:booking_app/utils/helpers/booking_helper.dart';
import 'booking_status_badge.dart';

class BookingCardHeader extends StatelessWidget {
  final BookingResponse booking;

  const BookingCardHeader({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: BookingHelper.getStatusColor(booking.statusEnum)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            BookingHelper.getServiceIcon(booking.serviceType),
            color: BookingHelper.getStatusColor(booking.statusEnum),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.customerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                booking.serviceName,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        BookingStatusBadge(status: booking.statusEnum),
      ],
    );
  }
}