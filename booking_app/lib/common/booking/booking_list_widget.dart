import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/response/booking_response.dart';
import 'package:intl/intl.dart';

class BookingListWidget extends StatelessWidget {
  final List<BookingResponse> bookings;
  final String emptyMessage;
  final IconData emptyIcon;
  final Color emptyColor;
  final bool showActions;
  final Function(BookingResponse)? onConfirm;
  final Function(BookingResponse)? onReject;
  final Function(BookingResponse)? onShowDetails;

  const BookingListWidget({
    super.key,
    required this.bookings,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.emptyColor,
    this.showActions = false,
    this.onConfirm,
    this.onReject,
    this.onShowDetails,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ DEBUG: Log để kiểm tra
    print('🎯 BookingListWidget.build:');
    print('   bookings.length: ${bookings.length}');
    print('   showActions: $showActions');
    print('   onConfirm: ${onConfirm != null ? "NOT NULL" : "NULL"}');
    print('   onReject: ${onReject != null ? "NOT NULL" : "NULL"}');

    // ✅ FIX: Kiểm tra empty
    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(emptyIcon, size: 64, color: emptyColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            emptyMessage,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BookingResponse booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onShowDetails?.call(booking),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStatusBadge(booking.statusEnum),
                  const Spacer(),
                  Text(
                    DateFormat('dd/MM/yyyy').format(booking.requestedDate),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                booking.customerName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                booking.serviceName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Iconsax.call, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    booking.customerPhone,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              // Hiển thị lý do từ chối
              if (booking.isRejected && booking.rejectionReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.info_circle,
                          size: 14, color: Colors.red.shade700),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Lý do: ${booking.rejectionReason}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Hiển thị lý do hủy
              if (booking.isCancelled &&
                  booking.cancellationReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.info_circle,
                          size: 14, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Lý do: ${booking.cancellationReason}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (showActions && booking.isPending) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => onConfirm?.call(booking),
                        icon: const Icon(Iconsax.tick_circle, size: 18),
                        label: const Text('Xác nhận'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => onReject?.call(booking),
                        icon: const Icon(Iconsax.close_circle, size: 18),
                        label: const Text('Từ chối'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade800,
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BookingStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case BookingStatus.pending:
        color = Colors.orange;
        text = 'Chờ duyệt';
        icon = Iconsax.clock;
        break;
      case BookingStatus.confirmed:
        color = Colors.green;
        text = 'Đã duyệt';
        icon = Iconsax.tick_circle;
        break;
      case BookingStatus.rejected:
        color = Colors.red;
        text = 'Từ chối';
        icon = Iconsax.close_circle;
        break;
      case BookingStatus.cancelled:
        color = Colors.grey.shade600;
        text = 'Đã hủy';
        icon = Iconsax.slash;
        break;
      case BookingStatus.completed:
        color = Colors.blue;
        text = 'Hoàn thành';
        icon = Iconsax.tick_square;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
