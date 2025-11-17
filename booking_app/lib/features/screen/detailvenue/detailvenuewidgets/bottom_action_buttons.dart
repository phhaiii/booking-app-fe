import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomActionButtons extends StatelessWidget {
  final dynamic venue;
  final VoidCallback onChatPressed;
  final VoidCallback onBookingPressed;

  const BottomActionButtons({
    super.key,
    required this.venue,
    required this.onChatPressed,
    required this.onBookingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onChatPressed,
                icon: const Icon(Iconsax.message, size: 20),
                label: const Text(
                  'Chat',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: WColors.primary,
                  side: const BorderSide(color: WColors.primary, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: onBookingPressed,
                icon: const Icon(Iconsax.calendar, size: 20),
                label: const Text(
                  'Đặt lịch xem',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
