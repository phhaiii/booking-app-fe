import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/features/screen/chat/chat_ui.dart'; 
import 'package:booking_app/features/screen/list/calendar_screen.dart'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DetailVenueScreen extends StatefulWidget {
  final String venueId;
  final String title;
  final String imagePath;
  final String description;
  final String location;
  final double price;
  final List<String> amenities;
  final double rating;
  final int reviewCount;

  const DetailVenueScreen({
    super.key,
    required this.venueId,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.location,
    required this.price,
    required this.amenities,
    required this.rating,
    required this.reviewCount,
  });

  @override
  State<DetailVenueScreen> createState() => _DetailVenueScreenState();
}

class _DetailVenueScreenState extends State<DetailVenueScreen> {
  bool isFavorite = false;
  int selectedImageIndex = 0;

  // Mock data cho multiple images
  late List<String> venueImages;

  @override
  void initState() {
    super.initState();
    venueImages = [
      widget.imagePath,
      // Thêm các ảnh khác nếu có
      'assets/images/venues/venue_2.jpg',
      'assets/images/venues/venue_3.jpg',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar với image slider
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: WColors.primary,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Iconsax.arrow_left, color: WColors.primary),
                onPressed: () => Get.back(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Iconsax.heart5 : Iconsax.heart,
                    color: isFavorite ? Colors.red : WColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    Get.snackbar(
                      isFavorite
                          ? 'Đã thêm vào yêu thích'
                          : 'Đã xóa khỏi yêu thích',
                      widget.title,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image Slider
                  PageView.builder(
                    itemCount: venueImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        selectedImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(
                        venueImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      );
                    },
                  ),

                  // Image indicators
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: venueImages.asMap().entries.map((entry) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedImageIndex == entry.key
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(WSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: WColors.primary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Iconsax.location,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.location,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: WColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Iconsax.star1,
                                size: 16, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.rating}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: WColors.primary,
                              ),
                            ),
                            Text(
                              ' (${widget.reviewCount})',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: WSizes.spaceBtwSections),

                  // Price - Cập nhật cho wedding context
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: WColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: WColors.primary.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chi phí tiệc cưới',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _formatWeddingPrice(widget.price),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: WColors.primary,
                                    ),
                              ),
                              TextSpan(
                                text: ' / tiệc',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: WSizes.spaceBtwSections),

                  // Description
                  Text(
                    'Mô tả',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          color: Colors.grey.shade700,
                        ),
                  ),

                  const SizedBox(height: WSizes.spaceBtwSections),

                  // Amenities
                  Text(
                    'Dịch vụ & Tiện ích',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: WSizes.spaceBtwItems),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.amenities.map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: WColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: WColors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getAmenityIcon(amenity),
                              size: 16,
                              color: WColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              amenity,
                              style: const TextStyle(
                                color: WColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: WSizes.spaceBtwSections),

                  // Contact Section - CHỈ CÒN PHẦN NÀY
                  _buildContactSection(context),

                  const SizedBox(height: 120), // Space for bottom buttons
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Action Buttons
      bottomNavigationBar: _buildBottomActionButtons(context),
    );
  }

  // Contact Section Widget
  Widget _buildContactSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: WColors.primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hotline: 1900 8386',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Để được tư vấn chi tiết về venue và các gói dịch vụ, vui lòng liên hệ trực tiếp với chúng tôi hoặc đặt lịch hẹn.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  // Bottom Action Buttons
  Widget _buildBottomActionButtons(BuildContext context) {
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
      child: Row(
        children: [
          // Chat Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _navigateToChat(),
              icon: const Icon(Iconsax.message, size: 20),
              label: const Text(
                'Chat tư vấn',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: WColors.primary,
                side: const BorderSide(color: WColors.primary, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Booking Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _navigateToBooking(),
              icon: const Icon(Iconsax.calendar, size: 20),
              label: const Text(
                'Đặt lịch xem',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: WColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navigate to Chat Screen
 void _navigateToChat() {
  Get.to(
    () => const ChatUIScreen(),
    transition: Transition.rightToLeft,
    duration: const Duration(milliseconds: 300),
  );
}
  // Navigate to Booking Screen (Calendar)
  void _navigateToBooking() {
    Get.to(
      () => const CalendarScreen(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Format wedding price
  String _formatWeddingPrice(double price) {
    if (price >= 1000000) {
      double millions = price / 1000000;
      if (millions == millions.toInt()) {
        return '${millions.toInt()} triệu';
      } else {
        return '${millions.toStringAsFixed(1)} triệu';
      }
    }
    return '${price.toStringAsFixed(0)}';
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      // Wedding specific amenities
      case 'sảnh lớn 1000 khách':
      case 'sảnh lớn 800 khách':
      case 'sảnh 600 khách':
      case 'sảnh 500 khách':
      case 'sảnh 400 khách':
      case 'sảnh 700 khách':
      case 'sảnh 250 khách':
        return Iconsax.people;

      case 'âm thanh led 5d':
      case 'âm thanh ánh sáng':
      case 'âm thanh':
      case 'led ceiling':
        return Iconsax.volume_high;

      case 'trang trí miễn phí':
      case 'trang trí luxury':
      case 'thiết kế hàn quốc':
        return Iconsax.brush_1;

      case 'bãi đỗ xe 200 chỗ':
      case 'bãi đỗ xe':
      case 'valet parking':
        return Iconsax.car;

      case 'phòng cô dâu vip':
      case 'phòng cô dâu':
      case 'villa nghỉ dưỡng':
        return Iconsax.home_1;

      case 'menu cao cấp':
      case 'menu quốc tế':
      case 'menu michelin':
      case 'menu hoàng gia':
      case 'menu cung đình':
      case 'menu farm-to-table':
      case 'menu fusion':
      case 'menu hà nội xưa':
      case 'organic catering':
        return Iconsax.cup;

      case 'view toàn thành phố':
      case 'view 360 độ':
      case 'view hồ tây':
        return Iconsax.eye;

      case 'wedding planner':
      case 'butler riêng':
      case 'butler service':
        return Iconsax.user_tag;

      case 'helicopter landing':
        return Iconsax.airplane;

      case 'vườn hoa sen':
      case 'vườn lavender':
      case 'vườn xanh':
      case 'vườn cổ':
      case '1000 loài hoa':
        return Iconsax.tree;

      case 'thuyền rồng':
        return Iconsax.ship;

      case 'kiến trúc pháp cổ':
      case 'kiến trúc cổ':
      case 'kiến trúc truyền thống':
        return Iconsax.building_4;

      case 'sảnh lịch sử':
      case 'phòng opera':
      case 'di tích lịch sử':
        return Iconsax.medal_star;

      case 'spa cô dâu':
        return Iconsax.heart;

      case 'công nghệ hologram':
      case 'robot phục vụ':
        return Iconsax.cpu;

      case 'nhã nhạc cung đình':
      case 'live band':
      case 'live acoustic':
        return Iconsax.music;

      case 'photographer':
      case 'photo booth tự nhiên':
        return Iconsax.camera;

      case 'eco-wedding':
     

      case 'tea corner':
      case 'cocktail bar':
        return Iconsax.coffee;

      case 'trang phục cổ trang':
        return Iconsax.crown;

      case 'lễ tea ceremony':
        return Iconsax.cup;

      default:
        return Iconsax.tick_circle;
    }
  }
}
