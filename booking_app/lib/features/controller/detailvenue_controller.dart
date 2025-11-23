import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/response/venuedetail_response.dart';
import 'package:booking_app/model/commentmodel.dart';
import 'package:booking_app/service/venue_service.dart';
import 'package:booking_app/service/api_constants.dart';
import 'package:booking_app/service/menu_service.dart';
import 'package:booking_app/service/comment_service.dart';
import 'package:booking_app/model/menu_model.dart';

class DetailVenueController extends GetxController {
  // Observables
  var isLoading = true.obs;
  var isLoadingComments = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var venue = Rxn<VenueDetailResponse>();
  var comments = <Comment>[].obs;
  var isFavorite = false.obs;
  var selectedImageIndex = 0.obs;

  // Pagination for comments
  var currentPage = 0.obs;
  var totalPages = 0.obs;
  var hasMoreComments = true.obs;
  var isLoadingMoreComments = false.obs;

  // ✅ THÊM: Rating statistics từ backend
  var backendAverageRating = Rxn<double>();
  var backendTotalComments = Rxn<int>();

  // Current venue ID
  String? _currentVenueId;

  // Menus
  var menus = <MenuModel>[].obs;
  var isLoadingMenus = false.obs;

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

      print('═══════════════════════════════════════');
      print('🔄 Loading venue details for ID: $venueId');
      print('═══════════════════════════════════════');

      // 🔄 Clear existing venue data to force fresh load
      venue.value = null;
      selectedImageIndex.value = 0;

      // Load venue details
      final venueData = await VenueService.getVenueDetail(venueId);

      if (venueData != null) {
        venue.value = venueData;

        // 🔍 DEBUG: Print loaded images
        print('📋 Loaded images (${venueData.images.length}):');
        for (int i = 0; i < venueData.images.length; i++) {
          print('   Image $i: ${venueData.images[i]}');
        }
        print('✅ Venue loaded: ${venueData.title}');
        print(
            '📊 Venue data - Rating: ${venueData.rating}, ReviewCount: ${venueData.reviewCount}, CommentCount: ${venueData.commentCount}');
        print('📊 Controller averageRating: $averageRating');
        print('📊 Controller totalReviewCount: $totalReviewCount');

        // Load statistics first để có rating ngay
        try {
          await loadCommentStatistics(venueId);
        } catch (e) {
          print('⚠️ Failed to load statistics: $e');
        }

        // Load initial comments - bỏ qua nếu lỗi, vẫn hiển thị venue
        try {
          await loadComments(venueId, isRefresh: true);
        } catch (e) {
          print('⚠️ Failed to load comments, but venue is still available: $e');
          // Không throw error, vẫn cho phép xem venue
        }

        // Load menus
        await loadMenus(venueId);
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

  Future<void> loadMenus(String venueId) async {
    try {
      isLoadingMenus.value = true;
      print('Loading menus for venue: $venueId');

      final loadedMenus = await MenuService.getMenusByPost(int.parse(venueId));
      menus.value = loadedMenus;

      print('Loaded ${loadedMenus.length} menus');
    } catch (e) {
      print('❌ Error loading menus: $e');
      menus.value = [];
    } finally {
      isLoadingMenus.value = false;
    }
  }

  // ✅ Load comment statistics separately
  Future<void> loadCommentStatistics(String venueId) async {
    try {
      print('🔄 Loading comment statistics for venue: $venueId');

      final stats = await CommentService.getCommentStatistics(postId: venueId);

      print('📦 Statistics response: $stats');
      print('📦 Statistics keys: ${stats.keys.toList()}');

      // Parse statistics from response - handle multiple formats
      Map<String, dynamic>? data;

      if (stats['data'] != null) {
        data = stats['data'] as Map<String, dynamic>;
        print('📦 Using data wrapper');
      } else {
        data = stats;
        print('📦 Using direct response');
      }

      print('📦 Data keys: ${data.keys.toList()}');
      print('📦 averageRating value: ${data['averageRating']}');
      print('📦 totalComments value: ${data['totalComments']}');

      if (data['averageRating'] != null) {
        backendAverageRating.value = (data['averageRating'] as num).toDouble();
        print('✅ Loaded averageRating: ${backendAverageRating.value}');
      } else {
        print('⚠️ No averageRating in response');
      }

      if (data['totalComments'] != null) {
        backendTotalComments.value = data['totalComments'] as int;
        print('✅ Loaded totalComments: ${backendTotalComments.value}');
      } else {
        print('⚠️ No totalComments in response');
      }
    } catch (e, stackTrace) {
      print('❌ Error loading comment statistics: $e');
      print('Stack trace: $stackTrace');
      // Don't throw - statistics is optional
    }
  }

  // Load comments with proper pagination
  Future<void> loadComments(String venueId, {bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 0; // Start from page 0 for Spring Boot pagination
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

      // Call CommentService to load comments (backend uses 0-based pagination)
      final response = await CommentService.getComments(
        postId: venueId,
        page: currentPage.value,
        size: 10,
      );

      print('📦 Comments response received');

      final loadedComments = response.comments;

      if (isRefresh || currentPage.value == 0) {
        comments.assignAll(loadedComments);
      } else {
        comments.addAll(loadedComments);
      }

      totalPages.value = response.totalPages;
      hasMoreComments.value = response.hasMore;

      // ✅ LƯU: Rating statistics từ backend
      if (response.averageRating != null) {
        backendAverageRating.value = response.averageRating;
        print('📊 Backend Average Rating: ${response.averageRating}');
      } else {
        print('⚠️ No averageRating in response');
      }

      if (response.totalComments != null) {
        backendTotalComments.value = response.totalComments;
        print('📊 Backend Total Comments: ${response.totalComments}');
      } else {
        print('⚠️ No totalComments in response');
      }

      if (response.hasMore) {
        currentPage.value++;
      }

      print('✅ Loaded ${loadedComments.length} comments');
      print(
          '   Current page: ${currentPage.value}, Total: ${response.totalCount}');
      print('   Has more: ${response.hasMore}');
    } catch (e, stackTrace) {
      print('❌ Error loading comments: $e');
      print('Stack trace: $stackTrace');
      if (isRefresh) {
        comments.clear();
      }
    } finally {
      isLoadingComments.value = false;
      isLoadingMoreComments.value = false;
    }
  }

  // Load more comments (pagination)
  Future<void> loadMoreComments() async {
    if (!hasMoreComments.value ||
        isLoadingMoreComments.value ||
        _currentVenueId == null) {
      print('Cannot load more comments');
      return;
    }

    print('Loading more comments...');
    await loadComments(_currentVenueId!);
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

      print('Adding comment for venue: $_currentVenueId');

      // Validate content
      print('Rating: $rating, Content length: ${content.length}');

      // Create comment
      await CommentService.createComment(
        postId: _currentVenueId!,
        content: content,
        rating: rating,
      );

      Get.back(); // Close loading

      // ✅ Reload venue data để cập nhật rating và reviewCount từ backend
      await loadVenueDetails(_currentVenueId!);

      Get.snackbar(
        '✅ Thành công',
        'Đánh giá của bạn đã được gửi',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.back(); // Close loading
      print('❌ Error adding comment: $e');

      // Extract user-friendly error message
      String errorMessage = 'Không thể gửi đánh giá';
      String errorString = e.toString();

      // Check for specific error cases
      if (errorString.contains('You have already commented on this post')) {
        errorMessage = 'Bạn đã đánh giá địa điểm này rồi';
      } else if (errorString.contains('Exception: ')) {
        // Extract message after "Exception: "
        errorMessage = errorString.substring(
            errorString.lastIndexOf('Exception: ') + 'Exception: '.length);
      }

      Get.snackbar(
        'Lỗi',
        errorMessage,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    }
  }

  // Refresh all data (pull to refresh)
  Future<void> refreshData() async {
    if (_currentVenueId != null) {
      print('Refreshing venue data...');
      await loadVenueDetails(_currentVenueId!);
    }
  }

  // ✅ Delete venue (VENDOR/ADMIN only)
  Future<void> deleteVenue() async {
    if (_currentVenueId == null || venue.value == null) {
      Get.snackbar(
        'Lỗi',
        'Không tìm thấy thông tin venue',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      // Show loading
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
                      'Đang xóa bài viết...',
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

      print('Deleting venue: $_currentVenueId');

      final vendorId = venue.value!.vendor.id.toString();
      final result = await VenueService.deleteVenue(
        _currentVenueId!,
        vendorId,
      );

      Get.back(); // Close loading

      if (result['success'] == true) {
        Get.snackbar(
          '✅ Thành công',
          result['message'] ?? 'Đã xóa bài viết thành công',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );

        // Navigate back after successful deletion
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(); // Go back to previous screen
      } else {
        Get.snackbar(
          'Lỗi',
          result['message'] ?? 'Không thể xóa bài viết',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.back(); // Close loading
      print('❌ Error deleting venue: $e');

      Get.snackbar(
        'Lỗi',
        'Đã xảy ra lỗi khi xóa bài viết',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Update selected image index for gallery
  void updateImageIndex(int index) {
    if (venue.value?.images != null &&
        index >= 0 &&
        index < venue.value!.images.length) {
      selectedImageIndex.value = index;
      print('Image index updated: $index');
    }
  }

  // ✅ FIX: Remove /api from image URLs
  String getImageUrl(String imagePath) {
    if (imagePath.isEmpty) {
      print('⚠️ Empty image path');
      return '';
    }

    print('Original path: $imagePath');

    // Already full URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      print('Full URL: $imagePath');
      return imagePath;
    }

    
    String fullUrl;
    if (imagePath.startsWith('/uploads/')) {
      // Path already has /uploads/
      fullUrl = '${ApiConstants.baseUrl}$imagePath';
    } else if (imagePath.startsWith('uploads/')) {
      // Path missing leading slash
      fullUrl = '${ApiConstants.baseUrl}/$imagePath';
    } else if (imagePath.startsWith('/')) {
      // Other absolute path
      fullUrl = '${ApiConstants.baseUrl}$imagePath';
    } else {
      // Relative path - assume it's just the filename
      fullUrl = '${ApiConstants.baseUrl}/uploads/$imagePath';
    }

    print('Full URL: $fullUrl');
    return fullUrl;
  }

  List<String> get venueImages {
    if (venue.value?.images == null || venue.value!.images.isEmpty) {
      print('No images in venue');
      return [];
    }

    print('═══════════════════════════════════════');
    print('PROCESSING VENUE IMAGES');
    print('Raw images: ${venue.value!.images}');

    final fullUrls =
        venue.value!.images.map((img) => getImageUrl(img)).toList();

    print('Full URLs: $fullUrls');
    print('═══════════════════════════════════════');

    return fullUrls;
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
      return '$rating ($count đánh giá)';
    }
    return 'Chưa có đánh giá';
  }

  // Get comments count
  int get commentsCount => comments.length;

  // ✅ Get average rating - ưu tiên backend statistics > tính từ comments > venue data
  double get averageRating {
    // 1. Ưu tiên: Rating từ comments statistics (backend tính toàn bộ)
    if (backendAverageRating.value != null && backendAverageRating.value! > 0) {
      print('📊 Using backend averageRating: ${backendAverageRating.value}');
      return backendAverageRating.value!;
    }

    // 2. Tính từ comments đã load (nếu có)
    if (comments.isNotEmpty) {
      final sum =
          comments.fold<double>(0.0, (prev, comment) => prev + comment.rating);
      final calculated = sum / comments.length;
      print(
          '📊 Calculated rating from ${comments.length} comments: $calculated');
      return calculated;
    }

    // 3. Fallback cuối: Rating từ venue data (có thể null từ backend)
    final venueRating = venue.value?.rating ?? 0.0;
    if (venueRating > 0) {
      print('📊 Using venue rating: $venueRating');
      return venueRating;
    }

    print('📊 No rating data available');
    return 0.0;
  }

  // ✅ Get total review count - ưu tiên backend statistics > commentCount > comments loaded
  int get totalReviewCount {
    // 1. Ưu tiên: Total từ comments statistics (backend count toàn bộ)
    if (backendTotalComments.value != null && backendTotalComments.value! > 0) {
      print('📊 Using backend totalComments: ${backendTotalComments.value}');
      return backendTotalComments.value!;
    }

    // 2. Fallback: CommentCount từ venue data (backend đang trả commentCount)
    final venueCommentCount = venue.value?.commentCount ?? 0;
    if (venueCommentCount > 0) {
      print('📊 Using venue commentCount: $venueCommentCount');
      return venueCommentCount;
    }

    // 3. Fallback: ReviewCount từ venue data (nếu có)
    final venueReviewCount = venue.value?.reviewCount ?? 0;
    if (venueReviewCount > 0) {
      print('📊 Using venue reviewCount: $venueReviewCount');
      return venueReviewCount;
    }

    // 4. Fallback cuối: Số comments đã load
    print('📊 Using loaded comments count: ${comments.length}');
    return comments.length;
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
