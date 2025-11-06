import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booking_app/models/booking_response.dart';
import 'booking_empty_state.dart';
import 'booking_card.dart';

class BookingListWidget extends StatelessWidget {
  final RxList<BookingRequestUI> bookings;
  final String emptyMessage;
  final IconData emptyIcon;
  final Color emptyColor;
  final bool showActions;
  final Function(BookingRequestUI)? onConfirm;
  final Function(BookingRequestUI)? onReject;
  final Function(BookingRequestUI) onShowDetails;

  const BookingListWidget({
    super.key,
    required this.bookings,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.emptyColor,
    required this.showActions,
    this.onConfirm,
    this.onReject,
    required this.onShowDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bookings.isEmpty) {
        return BookingEmptyState(
          message: emptyMessage,
          icon: emptyIcon,
          color: emptyColor,
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return BookingCard(
            booking: bookings[index],
            showActions: showActions,
            onConfirm: onConfirm,
            onReject: onReject,
            onShowDetails: onShowDetails,
          );
        },
      );
    });
  }
}