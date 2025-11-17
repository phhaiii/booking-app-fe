import 'package:flutter/material.dart';
import 'package:booking_app/response/booking_response.dart';
import 'package:booking_app/utils/constants/colors.dart';

class BookingCardActions extends StatelessWidget {
  final BookingRequestUI booking;
  final Function(BookingRequestUI)? onConfirm;
  final Function(BookingRequestUI)? onReject;
  final Function(BookingRequestUI) onShowDetails;

  const BookingCardActions({
    super.key,
    required this.booking,
    this.onConfirm,
    this.onReject,
    required this.onShowDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => onShowDetails(booking),
            style: OutlinedButton.styleFrom(
              foregroundColor: WColors.primary,
              side: const BorderSide(color: WColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Chi tiết'),
          ),
        ),
        if (onReject != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => onReject!(booking),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Từ chối'),
            ),
          ),
        ],
        if (onConfirm != null) ...[
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => onConfirm!(booking),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ],
    );
  }
}