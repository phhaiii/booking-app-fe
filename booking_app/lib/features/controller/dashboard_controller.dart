import 'package:get/get.dart';
import 'package:booking_app/models/venuedetail_response.dart';
import 'package:booking_app/service/venue_service.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenue.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController {
  // Observable variables
  final venues = <VenueDetailResponse>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final errorMessage = ''.obs;

  // Pagination
  final currentPage = 0.obs;
  final totalPages = 0.obs;
  final totalElements = 0.obs;
  final hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadVenues();
  }

  // ✅ SỬA: Load venues với proper API response
  Future<void> loadVenues({bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        isLoading.value = true;
        currentPage.value = 0;
        venues.clear();
      }

      errorMessage.value = '';

      print('🔄 Loading venues, page: ${currentPage.value}');

      // ✅ Call API với proper response structure
      final response = await VenueService.getAllVenues(
        page: currentPage.value,
        size: 10,
        sortBy: 'createdAt',
        sortDir: 'desc',
      );

      if (response != null) {
        final List<VenueDetailResponse> venueList =
            response['venues'] as List<VenueDetailResponse>;

        if (isLoadMore) {
          venues.addAll(venueList);
        } else {
          venues.assignAll(venueList);
        }

        totalPages.value = response['totalPages'] ?? 0;
        totalElements.value = response['totalElements'] ?? 0;
        hasMore.value = response['hasNext'] ?? false;

        print('✅ Loaded ${venueList.length} venues');
        print(
            '📊 Page ${currentPage.value + 1}/$totalPages, Total: $totalElements');

        if (venueList.isNotEmpty && hasMore.value) {
          currentPage.value++;
        }
      } else {
        errorMessage.value = 'Không thể tải danh sách địa điểm';

        Get.snackbar(
          'Lỗi',
          'Không thể tải danh sách venue',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.error_outline, color: Colors.red),
        );
      }
    } catch (e) {
      print('❌ Error loading venues: $e');
      errorMessage.value = 'Lỗi kết nối: ${e.toString()}';

      Get.snackbar(
        'Lỗi kết nối',
        'Không thể tải danh sách venue. Vui lòng kiểm tra kết nối mạng.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load more venues
  Future<void> loadMoreVenues() async {
    if (!hasMore.value || isLoading.value) {
      print('⚠️ Cannot load more venues');
      return;
    }

    print('🔄 Loading more venues...');
    await loadVenues(isLoadMore: true);
  }

  // ✅ SỬA: Toggle favorite với proper API response
  Future<void> toggleFavorite(String venueId) async {
    try {
      final index = venues.indexWhere((venue) => venue.venueId == venueId);

      if (index == -1) {
        print('⚠️ Venue not found: $venueId');
        return;
      }

      // Optimistic update
      final currentFavorite = venues[index].isFavorite ?? false;
      venues[index] = venues[index].copyWith(
        isFavorite: !currentFavorite,
      );

      print('🔄 Toggling favorite for venue: $venueId');

      // Call API
      final result = await VenueService.toggleFavorite(venueId);

      if (result['success'] == true) {
        final bool newFavoriteState = result['isFavorite'] ?? !currentFavorite;

        venues[index] = venues[index].copyWith(
          isFavorite: newFavoriteState,
        );

        print('✅ Favorite toggled: $newFavoriteState');

        final venue = venues[index];
        Get.snackbar(
          newFavoriteState
              ? '❤️ Đã thêm vào yêu thích'
              : '💔 Đã xóa khỏi yêu thích',
          venue.title,
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
        // Revert if API call failed
        venues[index] = venues[index].copyWith(
          isFavorite: currentFavorite,
        );

        print('❌ Failed to toggle favorite');

        Get.snackbar(
          'Lỗi',
          result['message'] ?? 'Không thể cập nhật yêu thích',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('❌ Error toggling favorite: $e');

      Get.snackbar(
        'Lỗi kết nối',
        'Không thể cập nhật yêu thích',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ✅ SỬA: Navigate to venue detail với proper venueId
  void navigateToVenueDetail(String venueId) {
    if (venueId.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'ID venue không hợp lệ',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    print('🔄 Navigating to venue detail: $venueId');

    Get.to(
      () => DetailVenueScreen(venueId: venueId),
      arguments: {'venueId': venueId},
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // ✅ SỬA: Search venues với API call
  Future<void> searchVenues(String query) async {
    try {
      isLoading.value = true;
      searchQuery.value = query;
      currentPage.value = 0;
      venues.clear();

      print('🔍 Searching venues: "$query"');

      if (query.isEmpty) {
        await loadVenues();
        return;
      }

      // Call search API
      final response = await VenueService.searchVenues(
        query,
        page: 0,
        size: 20,
      );

      if (response != null) {
        final List<VenueDetailResponse> venueList =
            response['venues'] as List<VenueDetailResponse>;

        venues.assignAll(venueList);

        totalPages.value = response['totalPages'] ?? 0;
        totalElements.value = response['totalElements'] ?? 0;

        print('✅ Search results: ${venueList.length} venues found');

        if (venueList.isEmpty) {
          Get.snackbar(
            'Không tìm thấy',
            'Không có venue nào phù hợp với "$query"',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.withOpacity(0.1),
            colorText: Colors.orange.shade700,
            icon: const Icon(Icons.search_off, color: Colors.orange),
          );
        }
      }
    } catch (e) {
      print('❌ Error searching venues: $e');

      Get.snackbar(
        'Lỗi tìm kiếm',
        'Không thể tìm kiếm địa điểm',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ SỬA: Filter by price với API call
  Future<void> filterByPrice(double minPrice, double maxPrice) async {
    try {
      isLoading.value = true;
      currentPage.value = 0;
      venues.clear();

      print('💰 Filtering by price: $minPrice - $maxPrice');

      final response = await VenueService.filterByPriceRange(
        minPrice: minPrice,
        maxPrice: maxPrice,
        page: 0,
        size: 20,
      );

      if (response != null) {
        final List<VenueDetailResponse> venueList =
            response['venues'] as List<VenueDetailResponse>;

        venues.assignAll(venueList);

        totalPages.value = response['totalPages'] ?? 0;
        totalElements.value = response['totalElements'] ?? 0;

        print('✅ Filter results: ${venueList.length} venues found');

        Get.snackbar(
          'Kết quả lọc',
          'Tìm thấy ${venueList.length} venue từ ${_formatPrice(minPrice)} - ${_formatPrice(maxPrice)}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withOpacity(0.1),
          colorText: Colors.blue.shade700,
          icon: const Icon(Icons.filter_list, color: Colors.blue),
        );
      }
    } catch (e) {
      print('❌ Error filtering venues: $e');

      Get.snackbar(
        'Lỗi lọc',
        'Không thể lọc địa điểm theo giá',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Filter by capacity
  Future<void> filterByCapacity(int minCapacity) async {
    try {
      isLoading.value = true;
      currentPage.value = 0;
      venues.clear();

      print('👥 Filtering by capacity: $minCapacity+');

      final response = await VenueService.filterByCapacity(
        minCapacity: minCapacity,
        page: 0,
        size: 20,
      );

      if (response != null) {
        final List<VenueDetailResponse> venueList =
            response['venues'] as List<VenueDetailResponse>;

        venues.assignAll(venueList);

        print('✅ Filter results: ${venueList.length} venues found');

        Get.snackbar(
          'Kết quả lọc',
          'Tìm thấy ${venueList.length} venue với sức chứa từ $minCapacity khách',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withOpacity(0.1),
          colorText: Colors.blue.shade700,
        );
      }
    } catch (e) {
      print('❌ Error filtering by capacity: $e');

      Get.snackbar(
        'Lỗi lọc',
        'Không thể lọc địa điểm theo sức chứa',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Load featured venues (popular)
  Future<void> loadFeaturedVenues() async {
    try {
      isLoading.value = true;
      currentPage.value = 0;
      venues.clear();

      print('🔥 Loading popular venues...');

      final response = await VenueService.getPopularVenues(
        page: 0,
        size: 10,
      );

      if (response != null) {
        final List<VenueDetailResponse> venueList =
            response['venues'] as List<VenueDetailResponse>;

        venues.assignAll(venueList);

        print('✅ Popular venues loaded: ${venueList.length}');
      }
    } catch (e) {
      print('❌ Error loading popular venues: $e');

      Get.snackbar(
        'Lỗi',
        'Không thể tải venues phổ biến',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load trending venues
  Future<void> loadTrendingVenues() async {
    try {
      isLoading.value = true;
      currentPage.value = 0;
      venues.clear();

      print('📈 Loading trending venues...');

      final response = await VenueService.getTrendingVenues(
        page: 0,
        size: 10,
      );

      if (response != null) {
        final List<VenueDetailResponse> venueList =
            response['venues'] as List<VenueDetailResponse>;

        venues.assignAll(venueList);

        print('✅ Trending venues loaded: ${venueList.length}');
      }
    } catch (e) {
      print('❌ Error loading trending venues: $e');

      Get.snackbar(
        'Lỗi',
        'Không thể tải venues trending',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Load favorite venues
  Future<void> loadFavoriteVenues() async {
    try {
      isLoading.value = true;
      currentPage.value = 0;
      venues.clear();

      print('❤️ Loading favorite venues...');

      final response = await VenueService.getFavoriteVenues(
        page: 0,
        size: 20,
      );

      if (response != null) {
        final List<VenueDetailResponse> venueList =
            response['venues'] as List<VenueDetailResponse>;

        venues.assignAll(venueList);

        print('✅ Favorite venues loaded: ${venueList.length}');

        if (venueList.isEmpty) {
          Get.snackbar(
            'Chưa có yêu thích',
            'Bạn chưa có venue yêu thích nào',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.withOpacity(0.1),
            colorText: Colors.orange.shade700,
            icon: const Icon(Icons.favorite_border, color: Colors.orange),
          );
        }
      }
    } catch (e) {
      print('❌ Error loading favorite venues: $e');

      Get.snackbar(
        'Lỗi',
        'Không thể tải venues yêu thích',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh venues
  Future<void> refreshVenues() async {
    print('🔄 Refreshing venues...');

    currentPage.value = 0;
    await loadVenues();

    Get.snackbar(
      '✅ Đã cập nhật',
      'Danh sách venue đã được làm mới',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.refresh, color: Colors.green),
    );
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    loadVenues();
  }

  // Getters
  int get venuesCount => venues.length;
  int get favoriteCount => venues.where((v) => v.isFavorite == true).length;
  bool get hasError => errorMessage.value.isNotEmpty;
  bool get canLoadMore => hasMore.value && !isLoading.value;

  // Format price helper
  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)} triệu';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return '${price.toStringAsFixed(0)}đ';
  }
}
