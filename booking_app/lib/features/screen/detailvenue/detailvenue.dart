import 'package:booking_app/features/screen/detailvenue/clothesbottom_sheet.dart';
import 'package:booking_app/features/screen/detailvenue/commentbottomsheet.dart';
import 'package:booking_app/features/screen/detailvenue/menubottom_sheet.dart';
import 'package:booking_app/features/screen/detailvenue/photobottom_sheet.dart';
import 'package:booking_app/models/comment.dart';
import 'package:booking_app/features/controller/detailvenue_controller.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/features/screen/chat/chat_ui.dart';
import 'package:booking_app/features/screen/list/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DetailVenueScreen extends StatelessWidget {
  final String? venueId;

  const DetailVenueScreen({
    super.key,
    this.venueId,
  });

  @override
  Widget build(BuildContext context) {
    final String currentVenueId =
        venueId ?? Get.arguments?['venueId'] ?? Get.parameters['venueId'] ?? '';

    final controller = Get.put(
      DetailVenueController(),
      tag: currentVenueId,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentVenueId.isNotEmpty) {
        controller.loadVenueDetails(currentVenueId);
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        if (controller.hasError.value) {
          return _buildErrorState(context, controller, currentVenueId);
        }

        if (currentVenueId.isEmpty) {
          return _buildEmptyIdState(context);
        }

        if (controller.venue.value == null) {
          return _buildNoDataState(context);
        }

        final venue = controller.venue.value!;

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: WColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Image Gallery Section
                _buildImageGallery(venue.images, controller),

                // Content Container
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info Section
                      _buildBasicInfoSection(context, venue),
                      const Divider(height: 1),

                      // Stats Section
                      _buildStatsSection(venue),
                      const Divider(height: 1),

                      // Description Section
                      _buildDescriptionSection(context, venue),
                      const SizedBox(height: 12),
                      const Divider(height: 1, thickness: 8),

                      // Amenities Section
                      _buildAmenitiesSection(context, venue),
                      const Divider(height: 1, thickness: 8),

                      // Services Section
                      _buildServicesSection(venue),
                      const Divider(height: 1, thickness: 8),

                      // Reviews Section (Google Maps Style)
                      _buildReviewsSection(controller),
                      const Divider(height: 1, thickness: 8),

                      // Contact Section
                      _buildContactSection(context, venue),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value ||
            controller.hasError.value ||
            controller.venue.value == null) {
          return const SizedBox.shrink();
        }
        return _buildBottomActionButtons(context, controller);
      }),
    );
  }

  // ============================================================================
  // APP BAR
  // ============================================================================

  PreferredSizeWidget _buildAppBar(DetailVenueController controller) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: WColors.primary),
          onPressed: () => Get.back(),
          padding: EdgeInsets.zero,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(() => IconButton(
                icon: Icon(
                  controller.isFavorite.value ? Iconsax.heart5 : Iconsax.heart,
                  color: controller.isFavorite.value
                      ? Colors.red
                      : WColors.primary,
                ),
                onPressed: controller.toggleFavorite,
                padding: EdgeInsets.zero,
              )),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ============================================================================
  // LOADING & ERROR STATES
  // ============================================================================

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: WColors.primary),
          const SizedBox(height: 16),
          Text(
            'Đang tải thông tin venue...',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, DetailVenueController controller, String venueId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Có lỗi xảy ra',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.loadVenueDetails(venueId),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: WColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyIdState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber, size: 64, color: Colors.orange.shade400),
            const SizedBox(height: 16),
            Text(
              'Thiếu thông tin venue',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Không tìm thấy ID venue',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: WColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy thông tin venue',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: WColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // IMAGE GALLERY
  // ============================================================================

  Widget _buildImageGallery(
      List<String> images, DetailVenueController controller) {
    if (images.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey.shade300,
        child: Center(
          child: Icon(Icons.image_not_supported,
              size: 80, color: Colors.grey.shade400),
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: controller.updateImageIndex,
            itemBuilder: (context, index) {
              return Image.network(
                controller.getImageUrl(images[index]),
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: CircularProgressIndicator(color: WColors.primary),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported,
                        size: 50, color: Colors.grey),
                  );
                },
              );
            },
          ),
          if (images.length > 1) ...[
            // Image counter
            Positioned(
              bottom: 16,
              right: 16,
              child: Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${controller.selectedImageIndex.value + 1}/${images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
            ),
            // Dots indicator
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.asMap().entries.map((entry) {
                      return Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              controller.selectedImageIndex.value == entry.key
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                        ),
                      );
                    }).toList(),
                  )),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================================
  // BASIC INFO SECTION
  // ============================================================================

  Widget _buildBasicInfoSection(BuildContext context, venue) {
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

  // ============================================================================
  // STATS SECTION
  // ============================================================================

  Widget _buildStatsSection(venue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Iconsax.star1,
              label: '${venue.rating ?? 0}',
              sublabel: '${venue.reviewCount ?? 0} đánh giá',
              color: Colors.orange,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          Expanded(
            child: _buildStatItem(
              icon: Iconsax.people,
              label: '${venue.capacity ?? 0}',
              sublabel: 'Sức chứa',
              color: Colors.blue,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          Expanded(
            child: _buildStatItem(
              icon: Iconsax.money,
              label: _formatPrice(venue.price ?? 0),
              sublabel: 'Giá/bàn',
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),
        Text(
          sublabel,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // DESCRIPTION SECTION
  // ============================================================================

  Widget _buildDescriptionSection(BuildContext context, venue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mô tả',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            venue.description ?? 'Không có mô tả',
            style: TextStyle(
              height: 1.6,
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // AMENITIES SECTION
  // ============================================================================

  Widget _buildAmenitiesSection(BuildContext context, venue) {
    final amenities = venue.amenities ?? [];

    if (amenities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiện ích & Dịch vụ',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: amenities.map<Widget>((amenity) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: WColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: WColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getAmenityIcon(amenity),
                      size: 14,
                      color: WColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      amenity,
                      style: const TextStyle(
                        color: WColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // SERVICES SECTION
  // ============================================================================

  Widget _buildServicesSection(venue) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dịch vụ đi kèm',
            style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildServiceCard(
                  icon: Iconsax.receipt_edit,
                  label: 'Menu',
                  color: Colors.green,
                  onTap: () => _showMenuBottomSheet(venue),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildServiceCard(
                  icon: Iconsax.camera,
                  label: 'Chụp ảnh',
                  color: Colors.purple,
                  onTap: () => _showPhotographyBottomSheet(venue),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildServiceCard(
                  icon: Iconsax.user_octagon,
                  label: 'Thuê váy',
                  color: Colors.orange,
                  onTap: () => _showClothesBottomSheet(venue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // REVIEWS SECTION (GOOGLE MAPS STYLE)
  // ============================================================================

  Widget _buildReviewsSection(DetailVenueController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đánh giá và nhận xét',
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => _showAllComments(controller),
                style: TextButton.styleFrom(
                  foregroundColor: WColors.primary,
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Obx(() {
            if (controller.isLoadingComments.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: WColors.primary),
                ),
              );
            }

            if (controller.comments.isEmpty) {
              return _buildEmptyReviews();
            }

            return Column(
              children: [
                // Rating Summary
                _buildRatingSummaryCard(controller.venue.value!),
                const SizedBox(height: 16),

                // Reviews List
                ...controller.comments
                    .take(3)
                    .map((comment) => _buildReviewCard(comment)),

                // Show More Button
                if (controller.comments.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: OutlinedButton(
                      onPressed: () => _showAllComments(controller),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: WColors.primary,
                        side: const BorderSide(color: WColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Xem thêm ${controller.comments.length - 3} đánh giá',
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyReviews() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Iconsax.star, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Chưa có đánh giá nào',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hãy là người đầu tiên đánh giá!',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAllComments(
                Get.find<DetailVenueController>(tag: venueId)),
            icon: const Icon(Iconsax.edit, size: 18),
            label: const Text('Viết đánh giá'),
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummaryCard(venue) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Left side - Overall rating
          Column(
            children: [
              Text(
                '${venue.rating ?? 0}',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: WColors.primary,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (venue.rating ?? 0).floor()
                        ? Iconsax.star5
                        : Iconsax.star,
                    size: 16,
                    color: Colors.orange,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '${venue.reviewCount ?? 0} đánh giá',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),

          // Right side - Rating breakdown
          Expanded(
            child: Column(
              children: [
                _buildRatingRow(5, 0.6),
                _buildRatingRow(4, 0.3),
                _buildRatingRow(3, 0.1),
                _buildRatingRow(2, 0.0),
                _buildRatingRow(1, 0.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Iconsax.star5, size: 12, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info & rating
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: WColors.primary.withOpacity(0.1),
                backgroundImage: comment.userAvatar.isNotEmpty
                    ? NetworkImage(comment.userAvatar)
                    : null,
                child: comment.userAvatar.isEmpty
                    ? Text(
                        comment.userName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: WColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      comment.formattedDate,
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
          const SizedBox(height: 12),

          // Stars
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < comment.rating.floor() ? Iconsax.star5 : Iconsax.star,
                size: 14,
                color: Colors.orange,
              );
            }),
          ),
          const SizedBox(height: 8),

          // Review content
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),

          // Review images
          if (comment.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: comment.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        comment.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, size: 32),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Like button (optional - Google Maps style)
          const SizedBox(height: 8),
          Row(
            children: [
              InkWell(
                onTap: () {
                  // Handle like
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.like_1,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${comment.likes}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // CONTACT SECTION
  // ============================================================================

  Widget _buildContactSection(BuildContext context, venue) {
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
                  child: const Icon(Iconsax.call_calling,
                      size: 24, color: WColors.primary),
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
                        'Hotline: ${venue.contact?.phone ?? 'Đang cập nhật'}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
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

  // ============================================================================
  // BOTTOM ACTION BUTTONS
  // ============================================================================

  Widget _buildBottomActionButtons(
      BuildContext context, DetailVenueController controller) {
    final venue = controller.venue.value!;

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
                onPressed: () => _navigateToChat(venue),
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
                onPressed: () => _navigateToBooking(venue),
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

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  String _formatPrice(double price) {
    if (price >= 1000000) {
      double millions = price / 1000000;
      if (millions == millions.toInt()) {
        return '${millions.toInt()}tr';
      } else {
        return '${millions.toStringAsFixed(1)}tr';
      }
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k';
    }
    return '${price.toStringAsFixed(0)}đ';
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'bãi đỗ xe':
      case 'bãi đỗ xe 200 chỗ':
      case 'valet parking':
        return Iconsax.car;
      case 'wifi miễn phí':
        return Iconsax.wifi;
      case 'điều hòa':
        return Iconsax.wind_2;
      case 'âm thanh chuyên nghiệp':
      case 'âm thanh led 5d':
        return Iconsax.volume_high;
      case 'ánh sáng led':
      case 'led ceiling':
        return Iconsax.lamp_1;
      case 'phòng thay đồ':
      case 'phòng cô dâu vip':
        return Iconsax.home_1;
      case 'trang trí miễn phí':
      case 'trang trí luxury':
        return Iconsax.brush_1;
      case 'mc chuyên nghiệp':
        return Iconsax.microphone;
      case 'phục vụ rượu':
      case 'menu cao cấp':
        return Iconsax.cup;
      default:
        return Iconsax.tick_circle;
    }
  }

  void _navigateToChat(venue) {
    Get.to(
      () => const ChatUIScreen(),
      arguments: {
        'venueId': venue.id,
        'venueTitle': venue.title,
        'ownerId': venue.owner?.id ?? '',
      },
      transition: Transition.rightToLeft,
    );
  }

  void _navigateToBooking(venue) {
    Get.to(
      () => const CalendarScreen(),
      arguments: {
        'venueId': venue.id,
        'venueTitle': venue.title,
      },
      transition: Transition.rightToLeft,
    );
  }

  void _showMenuBottomSheet(venue) {
    Get.bottomSheet(
      MenuBottomSheet(venue: venue),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showPhotographyBottomSheet(venue) {
    Get.bottomSheet(
      PhotographyBottomSheet(venue: venue),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showClothesBottomSheet(venue) {
    Get.bottomSheet(
      ClothesBottomSheet(venue: venue),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showAllComments(DetailVenueController controller) {
    Get.bottomSheet(
      CommentBottomSheet(
        venueId: controller.venue.value?.id ?? '',
        onCommentAdded: (content, rating, images) {
          controller.addComment(
            content: content,
            rating: rating,
            imagePaths: images,
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}