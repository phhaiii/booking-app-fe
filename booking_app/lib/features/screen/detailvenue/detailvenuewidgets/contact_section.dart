import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactSection extends StatelessWidget {
  final dynamic venue;

  const ContactSection({
    super.key,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    final vendorPhone = venue.vendor?.phoneNumber ??
        venue.contact?.phone ??
        venue.contact?.phoneNumber ??
        '';

    final vendorEmail = venue.vendor?.email ?? venue.contact?.email ?? '';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: WColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WColors.primary.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: WColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.call_calling,
                    size: 24,
                    color: WColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Liên hệ tư vấn',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: WColors.primary,
                                ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Hotline: $vendorPhone',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      if (vendorEmail.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Email: $vendorEmail',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Liên hệ ngay để được tư vấn chi tiết về venue và các gói dịch vụ đi kèm.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
