import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/features/controller/userbooking_controller.dart';

class GuestCountSelectorWidget extends StatefulWidget {
  final UserBookingController controller;

  const GuestCountSelectorWidget({
    super.key,
    required this.controller,
  });

  @override
  State<GuestCountSelectorWidget> createState() =>
      _GuestCountSelectorWidgetState();
}

class _GuestCountSelectorWidgetState extends State<GuestCountSelectorWidget> {
  late final TextEditingController _guestCountController;

  @override
  void initState() {
    super.initState();
    _guestCountController = TextEditingController();
  }

  @override
  void dispose() {
    _guestCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.people, color: WColors.primary),
              const SizedBox(width: 12),
              const Text(
                'Số lượng khách',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: WColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _guestCountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Nhập số lượng khách',
              prefixIcon: const Icon(Iconsax.user, color: WColors.primary),
              suffixText: 'khách',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: WColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              final count = int.tryParse(value) ?? 0;
              if (count >= 0) {
                widget.controller.updateGuestCount(count);
              }
            },
          ),
        ],
      ),
    );
  }
}
