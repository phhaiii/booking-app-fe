import 'package:flutter/material.dart';
import 'package:booking_app/features/controller/userbooking_controller.dart';

class SpecialRequestsWidget extends StatelessWidget {
  final UserBookingController controller;

  const SpecialRequestsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Nhập yêu cầu đặc biệt (nếu có)...',
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
          borderSide: const BorderSide(color: Color(0xFF6200EE)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) => controller.specialRequests.value = value,
    );
  }
}
