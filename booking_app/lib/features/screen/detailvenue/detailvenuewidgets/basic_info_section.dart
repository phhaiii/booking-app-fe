import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BasicInfoSection extends StatelessWidget {
  final dynamic venue;

  const BasicInfoSection({
    super.key,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            venue.title ?? 'Không có tiêu đề',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Iconsax.location, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  venue.location ?? 'Không có địa chỉ',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
