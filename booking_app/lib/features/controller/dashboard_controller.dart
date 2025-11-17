import 'package:get/get.dart';
import 'package:booking_app/model/venue_model.dart';
import 'package:booking_app/service/venue_service.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DashboardController extends GetxController {
  // Observable variables
  final venues = <VenueModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final errorMessage = ''.obs;

  // Pagination
  final currentPage = 0.obs;
  final pageSize = 20.obs;
  final hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    // ✅ THÊM: Load venues khi controller khởi tạo
    loadVenues();
  }

  // ✅ THÊM METHOD NÀY - Load tất cả venues
  Future<void> loadVenues({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 0;
        venues.clear();
      }

      isLoading.value = true;
      errorMessage.value = '';

      print('═══════════════════════════════════════');
      print('LOADING VENUES');
      print('Page: ${currentPage.value}');
      print('Size: ${pageSize.value}');
      print('═══════════════════════════════════════');

      // ✅ Call API GET /api/posts
      final response = await VenueService.getAllVenues(
        page: currentPage.value,
        size: pageSize.value,
        sortBy: 'createdAt',
        sortDir: 'desc',
      );

      print('Raw response: $response');

      if (response != null) {
        print('Response received');
        print('Available keys: ${response.keys}');

        // ✅ TÌM KEY chứa danh sách venues
        // Backend có thể trả về 'content' (Spring Page) hoặc 'venues' (custom)
        final venuesKey = response.containsKey('content')
            ? 'content'
            : (response.containsKey('venues') ? 'venues' : null);

        if (venuesKey == null) {
          print('❌ No venues data found in response');
          print('Available keys: ${response.keys}');
          errorMessage.value = 'Dữ liệu không đúng định dạng';
          return;
        }

        final content = response[venuesKey];

        // ✅ CHECK if content is null
        if (content == null) {
          print('⚠️ $venuesKey is null');
          hasMore.value = false;

          if (venues.isEmpty) {
            errorMessage.value = 'Chưa có bài viết nào';
          }
          return;
        }

        // ✅ CHECK if content is List
        if (content is! List) {
          print('❌ $venuesKey is not a List, it is: ${content.runtimeType}');
          errorMessage.value = 'Dữ liệu không đúng định dạng';
          return;
        }

        print('✅ Found ${content.length} venues in "$venuesKey"');

        // ✅ Parse venues from List
        final List<VenueModel> venueList = (content as List)
            .map((json) {
              try {
                return VenueModel.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('❌ Error parsing venue: $e');
                print('JSON: $json');
                return null;
              }
            })
            .whereType<VenueModel>() // ✅ Remove null values
            .toList();

        if (isRefresh) {
          venues.value = venueList;
        } else {
          venues.addAll(venueList);
        }

        // ✅ Update pagination info
        // Kiểm tra cả 2 format: 'last' (Spring) hoặc 'hasNext' (custom)
        if (response.containsKey('last')) {
          hasMore.value = response['last'] == false;
        } else if (response.containsKey('hasNext')) {
          hasMore.value = response['hasNext'] == true;
        } else {
          // Nếu không có pagination info, check theo số lượng
          hasMore.value = venueList.length >= pageSize.value;
        }

        if (!hasMore.value) {
          print('⚠️ No more pages');
        }

        currentPage.value++;

        print('✅ Loaded ${venueList.length} venues');
        print('Total venues in list: ${venues.length}');
        print('Has more: ${hasMore.value}');

        // ✅ Log pagination info
        if (response.containsKey('totalElements')) {
          print('Total elements: ${response['totalElements']}');
        }
        if (response.containsKey('totalPages')) {
          print('Total pages: ${response['totalPages']}');
        }

        print('═══════════════════════════════════════');

        if (venueList.isEmpty && venues.isEmpty) {
          errorMessage.value = 'Chưa có bài viết nào';
        }
      } else {
        print('❌ Response is null');
        errorMessage.value = 'Không thể tải danh sách venue';
      }
    } catch (e, stackTrace) {
      print('❌ Error loading venues: $e');
      print('Stack trace: $stackTrace');
      errorMessage.value = 'Lỗi khi tải danh sách: $e';

      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách venue',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Load more venues (pagination)
  Future<void> loadMore() async {
    if (isLoading.value || !hasMore.value) return;
    await loadVenues(isRefresh: false);
  }

  // ✅ Refresh venues
  Future<void> refreshVenues() async {
    print('Refreshing venues...');
    await loadVenues(isRefresh: true);

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


  // ✅ Navigate - Convert int to String
  void navigateToVenueDetail(int venueId) {
    print('Navigating to venue detail: $venueId');

    Get.to(
      () => DetailVenueScreen(venueId: venueId.toString()),
      arguments: {'venueId': venueId.toString()},
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // ✅ Search venues
  Future<void> searchVenues(String query) async {
    try {
      isLoading.value = true;
      searchQuery.value = query;

      print('Searching venues: "$query"');

      if (query.isEmpty) {
        await loadVenues(isRefresh: true);
        return;
      }

      final response = await VenueService.searchVenues(
        query,
        page: 0,
        size: 20,
      );

      if (response != null) {
        // ✅ Parse JSON trên isolate (background thread)
        final List<VenueModel> venueList = await compute(
          _parseVenues,
          response['content'] as List,
        );

        // ✅ Update UI một lần duy nhất
        venues.value = venueList;

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

  // ✅ Static method để parse trên isolate
  static List<VenueModel> _parseVenues(List<dynamic> jsonList) {
    return jsonList
        .map((json) => VenueModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // ✅ Filter by price using /api/posts/filter/price
  Future<void> filterByPrice(double minPrice, double maxPrice) async {
    try {
      isLoading.value = true;
      venues.clear();

      print('Filtering by price: $minPrice - $maxPrice');

      final response = await VenueService.filterByPriceRange(
        minPrice: minPrice,
        maxPrice: maxPrice,
        page: 0,
        size: 20,
      );

      if (response != null) {
        final List<VenueModel> venueList = (response['venues'] as List)
            .map((json) => VenueModel.fromJson(json))
            .toList();

        venues.assignAll(venueList);

        print('✅ Filter results: ${venueList.length} venues found');

        Get.snackbar(
          'Kết quả lọc',
          'Tìm thấy ${venueList.length} venue từ ${_formatPrice(minPrice)} - ${_formatPrice(maxPrice)}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.transparent,
          colorText: Colors.blue.shade700,
          icon: const Icon(Icons.filter_list, color: Colors.blue),
        );
      }
    } catch (e) {
      print('❌ Error filtering venues: $e');

      Get.snackbar(
        'Lỗi lọc',
        'Không thể lọc địa điểm theo giá',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Filter by capacity using /api/posts/filter/capacity
  Future<void> filterByCapacity(int minCapacity) async {
    try {
      isLoading.value = true;
      venues.clear();

      print('Filtering by capacity: $minCapacity+');

      final response = await VenueService.filterByCapacity(
        minCapacity: minCapacity,
        page: 0,
        size: 20,
      );

      if (response != null) {
        final List<VenueModel> venueList = (response['venues'] as List)
            .map((json) => VenueModel.fromJson(json))
            .toList();

        venues.assignAll(venueList);

        print('✅ Filter results: ${venueList.length} venues found');

        Get.snackbar(
          'Kết quả lọc',
          'Tìm thấy ${venueList.length} venue với sức chứa từ $minCapacity khách',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.transparent,
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

  void clearSearch() {
    searchQuery.value = '';
    loadVenues(isRefresh: true);
  }

  // Getters
  int get venuesCount => venues.length;
  bool get hasError => errorMessage.value.isNotEmpty;
  bool get isEmpty => venues.isEmpty && !isLoading.value;

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)} triệu';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return '${price.toStringAsFixed(0)}đ';
  }
}
