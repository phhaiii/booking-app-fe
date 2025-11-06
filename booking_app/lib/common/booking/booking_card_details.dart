import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/models/booking_response.dart';
import 'package:booking_app/utils/helpers/booking_helper.dart';
import 'booking_detail_row.dart';

class BookingCardDetails extends StatelessWidget {
  final BookingRequestUI booking;

  const BookingCardDetails({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BookingDetailRow(
          icon: Iconsax.user,
          label: 'Số điện thoại:',
          value: booking.customerPhone,
        ),
        BookingDetailRow(
          icon: Iconsax.sms,
          label: 'Email:',
          value: booking.customerEmail,
        ),
        BookingDetailRow(
          icon: Iconsax.calendar,
          label: 'Ngày mong muốn:',
          value: BookingHelper.formatDateTime(booking.requestedDate),
        ),
        if (booking.numberOfGuests != null)
          BookingDetailRow(
            icon: Iconsax.people,
            label: 'Số khách:',
            value: '${booking.numberOfGuests} người',
          ),
        if (booking.budget != null)
          BookingDetailRow(
            icon: Iconsax.money,
            label: 'Ngân sách:',
            value: '${BookingHelper.formatPrice(booking.budget!)} VNĐ',
          ),
      ],
    );
  }
}