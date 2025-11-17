import 'package:flutter/material.dart';
import 'package:booking_app/response/booking_response.dart';
import 'booking_card_header.dart';
import 'booking_card_details.dart';
import 'booking_card_message.dart';
import 'booking_card_time.dart';
import 'package:booking_app/common/booking/booking_card_action.dart';

class BookingCard extends StatelessWidget {
  final BookingRequestUI booking;
  final bool showActions;
  final Function(BookingRequestUI)? onConfirm;
  final Function(BookingRequestUI)? onReject;
  final Function(BookingRequestUI) onShowDetails;

  const BookingCard({
    super.key,
    required this.booking,
    required this.showActions,
    this.onConfirm,
    this.onReject,
    required this.onShowDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingCardHeader(booking: booking),
            const SizedBox(height: 16),
            BookingCardDetails(booking: booking),
            if (booking.message != null && booking.message!.isNotEmpty) ...[
              const SizedBox(height: 12),
              BookingCardMessage(message: booking.message!),
            ],
            const SizedBox(height: 12),
            BookingCardTime(booking: booking),
            if (showActions) ...[
              const SizedBox(height: 16),
              BookingCardActions(
                booking: booking,
                onConfirm: onConfirm,
                onReject: onReject,
                onShowDetails: onShowDetails,
              ),
            ],
          ],
        ),
      ),
    );
  }
}