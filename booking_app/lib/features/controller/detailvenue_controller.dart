import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/models/venuedetail_response.dart';
import 'package:booking_app/models/comment.dart'; // ✅ SỬA: Import từ models
import 'package:booking_app/service/venue_service.dart';
import 'package:booking_app/service/api_constants.dart';

class DetailVenueController extends GetxController {
  // Observables
  var isLoading = true.obs;
  var isLoadingComments = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var venue = Rxn<VenueDetailResponse>();
  var comments = <Comment>[].obs; // ✅ SỬA: Sử dụng Comment từ models
  var isFavorite = false.obs;
  var selectedImageIndex = 0.obs;

  // Pagination for comments
  var currentPage = 0.obs;
  var totalPages = 0.obs;
  var hasMoreComments = true.obs;
  var isLoadingMoreComments = false.obs;

  // Current venue ID
  String? _currentVenueId;

  @override
  void onInit() {
    super.onInit();
    // Không auto load trong onInit
  }

  @override
  void onClose() {
    // Clean up resources
    comments.clear();
    super.onClose();
  }

  // Load venue details với proper error handling
  Future<void> loadVenueDetails(String venueId) async {
    if (venueId.isEmpty) {
      hasError.value = true;
      errorMessage.value = 'ID venue không hợp lệ';
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      _currentVenueId = venueId;

      print('🔄 Loading venue details for ID: $venueId');

      // Load venue details
      final venueData = await VenueService.getVenueDetails(venueId);

      if (venueData != null) {
        venue.value = venueData;

        // Update favorite status from venue data
        isFavorite.value = venueData.isFavorite;

        print('✅ Venue loaded: ${venueData.title}');
        print(
            '📊 Rating: ${venueData.rating}, Reviews: ${venueData.reviewCount}');

        // Load initial comments
        await loadComments(venueId, isRefresh: true);
      } else {
        hasError.value = true;
        errorMessage.value = 'Không tìm thấy thông tin venue';

        Get.snackbar(
          'Không tìm thấy',
          'Venue không tồn tại hoặc đã bị xóa',
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange.shade700,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.warning_amber, color: Colors.orange),
        );
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Lỗi kết nối: ${e.toString()}';

      print('❌ Error in loadVenueDetails: $e');

      Get.snackbar(
        'Lỗi kết nối',
        'Không thể tải thông tin venue. Vui lòng kiểm tra kết nối mạng.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load comments với proper pagination
  Future<void> loadComments(String venueId, {bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 0;
        hasMoreComments.value = true;
        isLoadingComments.value = true;
        comments.clear();
      } else if (currentPage.value == 0) {
        isLoadingComments.value = true;
      } else {
        isLoadingMoreComments.value = true;
      }

      print(
          '🔄 Loading comments for venue: $venueId, page: ${currentPage.value}');

      // Call API với proper response structure
      final response = await VenueService.getVenueComments(
        venueId,
        page: currentPage.value,
        size: 10,
      );

      if (response != null && response['comments'] != null) {
        // ✅ SỬA: Convert VenueComment từ API sang Comment model
        final List<VenueComment> venueComments =
            (response['comments'] as List).cast<VenueComment>();

        final List<Comment> uiComments =
            venueComments.map((vc) => _convertToUIComment(vc)).toList();

        final int total = response['totalPages'] ?? 0;
        final double avgRating = (response['averageRating'] ?? 0.0).toDouble();

        if (isRefresh || currentPage.value == 0) {
          comments.assignAll(uiComments);
        } else {
          comments.addAll(uiComments);
        }

        totalPages.value = total;

        print('✅ Loaded ${uiComments.length} comments');
        print('📊 Average rating: $avgRating');

        // Check if there are more comments
        if (currentPage.value + 1 >= total) {
          hasMoreComments.value = false;
        } else {
          currentPage.value++;
        }

        // Update venue rating if available
        if (venue.value != null && avgRating > 0) {
          venue.value = venue.value!.copyWith(
            rating: avgRating,
            reviewCount: response['totalElements'] ?? comments.length,
          );
        }
      } else {
        if (currentPage.value == 0) {
          comments.clear();
        }
        hasMoreComments.value = false;

        print('ℹ️ No comments found');
      }
    } catch (e) {
      print('❌ Error loading comments: $e');

      Get.snackbar(
        'Lỗi',
        'Không thể tải bình luận',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoadingComments.value = false;
      isLoadingMoreComments.value = false;
    }
  }

  // ✅ SỬA: Helper method to convert VenueComment to Comment model
  Comment _convertToUIComment(VenueComment venueComment) {
    return Comment(
      id: venueComment.id,
      userId: venueComment.userId,
      userName: venueComment.userName,
      userAvatar: venueComment.userAvatar ?? '',
      rating: venueComment.rating,
      content: venueComment.content,
      images: venueComment.images,
      likes: venueComment.likeCount,
      createdAt: venueComment.createdAt,
      updatedAt: venueComment.updatedAt ?? venueComment.createdAt,
    );
  }

  // Load more comments (pagination)
  Future<void> loadMoreComments() async {
    if (!hasMoreComments.value ||
        isLoadingMoreComments.value ||
        _currentVenueId == null) {
      print('⚠️ Cannot load more comments');
      return;
    }

    print('🔄 Loading more comments...');
    await loadComments(_currentVenueId!);
  }

  // Toggle favorite với proper API call
  Future<void> toggleFavorite() async {
    if (_currentVenueId == null) {
      Get.snackbar(
        'Lỗi',
        'Không tìm thấy thông tin venue',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
      return;
    }

    try {
      // Optimistic update
      final previousState = isFavorite.value;
      isFavorite.value = !isFavorite.value;

      print('🔄 Toggling favorite for venue: $_currentVenueId');

      // Call API với proper response
      final result = await VenueService.toggleFavorite(_currentVenueId!);

      if (result['success'] == true) {
        final bool newFavoriteState = result['isFavorite'] ?? !previousState;
        isFavorite.value = newFavoriteState;

        print('✅ Favorite toggled: $newFavoriteState');

        Get.snackbar(
          newFavoriteState
              ? '❤️ Đã thêm vào yêu thích'
              : '💔 Đã xóa khỏi yêu thích',
          venue.value?.title ?? '',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: newFavoriteState
              ? Colors.red.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          colorText: newFavoriteState ? Colors.red : Colors.grey.shade700,
          duration: const Duration(seconds: 2),
          icon: Icon(
            newFavoriteState ? Icons.favorite : Icons.favorite_border,
            color: newFavoriteState ? Colors.red : Colors.grey,
          ),
        );
      } else {
        // Revert on failure
        isFavorite.value = previousState;

        print('❌ Failed to toggle favorite');

        Get.snackbar(
          'Lỗi',
          result['message'] ?? 'Không thể cập nhật trạng thái yêu thích',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.error_outline, color: Colors.red),
        );
      }
    } catch (e) {
      // Revert on error
      isFavorite.value = !isFavorite.value;

      print('❌ Error toggling favorite: $e');

      Get.snackbar(
        'Lỗi kết nối',
        'Không thể kết nối đến server',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    }
  }

  // Add comment với proper API call
  Future<void> addComment({
    required String content,
    required double rating,
    List<String>? imagePaths,
  }) async {
    if (_currentVenueId == null) {
      Get.snackbar(
        'Lỗi',
        'Không tìm thấy thông tin venue',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Validate input
    if (content.trim().isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng nhập nội dung đánh giá',
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange.shade700,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (rating < 1 || rating > 5) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng chọn số sao đánh giá (1-5)',
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange.shade700,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      // Show loading dialog
      Get.dialog(
        PopScope(
          canPop: false,
          child: const Center(
            child: Card(
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Đang gửi đánh giá...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      print('🔄 Adding comment for venue: $_currentVenueId');
      print('⭐ Rating: $rating, Content length: ${content.length}');

      final newVenueComment = await VenueService.addComment(
        _currentVenueId!,
        content: content,
        rating: rating,
        imagePaths: imagePaths,
      );

      Get.back(); // Close loading dialog

      if (newVenueComment != null) {
        // Convert to Comment model and add to list
        final newComment = _convertToUIComment(newVenueComment);
        comments.insert(0, newComment);

        print('✅ Comment added successfully');

        // Update venue rating and review count
        if (venue.value != null) {
          final currentReviewCount = venue.value!.reviewCount;
          final currentRating = venue.value!.rating;
          final newReviewCount = currentReviewCount + 1;

          // Calculate new average rating
          final newAverageRating =
              ((currentRating * currentReviewCount) + rating) / newReviewCount;

          venue.value = venue.value!.copyWith(
            rating: newAverageRating,
            reviewCount: newReviewCount,
          );

          print(
              '📊 Updated rating: $newAverageRating ($newReviewCount reviews)');
        }

        Get.snackbar(
          '✅ Thành công',
          'Đánh giá của bạn đã được gửi',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.check_circle, color: Colors.green),
          duration: const Duration(seconds: 3),
        );

        // Refresh comments to sync with server
        Future.delayed(const Duration(seconds: 1), () {
          if (_currentVenueId != null) {
            loadComments(_currentVenueId!, isRefresh: true);
          }
        });
      } else {
        print('❌ Failed to add comment');

        Get.snackbar(
          'Lỗi',
          'Không thể gửi đánh giá. Vui lòng thử lại.',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.error_outline, color: Colors.red),
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog

      print('❌ Error adding comment: $e');

      Get.snackbar(
        'Lỗi kết nối',
        'Không thể gửi đánh giá. Vui lòng kiểm tra kết nối mạng.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    }
  }

  // Refresh all data (pull to refresh)
  Future<void> refreshData() async {
    if (_currentVenueId != null) {
      print('🔄 Refreshing venue data...');
      await loadVenueDetails(_currentVenueId!);
    }
  }

  // Update selected image index for gallery
  void updateImageIndex(int index) {
    if (venue.value?.images != null &&
        index >= 0 &&
        index < venue.value!.images.length) {
      selectedImageIndex.value = index;
      print('🖼️ Image index updated: $index');
    }
  }

  // Get full image URL with proper base URL
  String getImageUrl(String imagePath) {
    if (imagePath.isEmpty) {
      return '';
    }

    // Already full URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Remove leading slash if present
    final cleanPath =
        imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;

    return '${ApiConstants.imageBaseUrl}/$cleanPath';
  }

  // Get venue images with proper URLs
  List<String> get venueImages {
    if (venue.value?.images != null && venue.value!.images.isNotEmpty) {
      return venue.value!.images
          .map((image) => getImageUrl(image))
          .where((url) => url.isNotEmpty)
          .toList();
    }
    return [];
  }

  // Get current selected image URL
  String? get currentSelectedImageUrl {
    if (venue.value?.images != null &&
        selectedImageIndex.value >= 0 &&
        selectedImageIndex.value < venue.value!.images.length) {
      return getImageUrl(venue.value!.images[selectedImageIndex.value]);
    }
    return null;
  }

  // Check if venue has images
  bool get hasImages =>
      venue.value?.images != null && venue.value!.images.isNotEmpty;

  // Get formatted price
  String get formattedPrice {
    if (venue.value?.price != null) {
      final price = venue.value!.price;

      if (price >= 1000000) {
        final millions = price / 1000000;
        if (millions == millions.toInt()) {
          return '${millions.toInt()} triệu VNĐ';
        } else {
          return '${millions.toStringAsFixed(1)} triệu VNĐ';
        }
      }

      return '${price.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )} VNĐ';
    }
    return 'Liên hệ';
  }

  // Get star rating display
  String get starRatingDisplay {
    if (venue.value?.rating != null) {
      final rating = venue.value!.rating.toStringAsFixed(1);
      final count = venue.value!.reviewCount;
      return '⭐ $rating ($count đánh giá)';
    }
    return 'Chưa có đánh giá';
  }

  // Get comments count
  int get commentsCount => comments.length;

  // Get average rating from comments
  double get averageRating {
    if (comments.isEmpty) return 0.0;

    final sum = comments.fold<double>(
      0.0,
      (prev, comment) => prev + comment.rating,
    );

    return sum / comments.length;
  }

  // Check if has favorite status
  bool get hasFavorite => isFavorite.value;

  // Get venue status
  String get venueStatus {
    if (isLoading.value) return 'Đang tải...';
    if (hasError.value) return 'Lỗi';
    if (venue.value == null) return 'Không có dữ liệu';
    return 'Đã tải';
  }
}
