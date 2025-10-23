import 'package:get/get.dart';
import 'package:booking_app/formatter/venue/venue_model.dart';
import 'package:booking_app/formatter/venue/venue_data_service.dart';
import 'package:booking_app/features/screen/detailvenue/detailvenue.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController {
  // Observable variables
  final venues = <VenueModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadVenues();
  }

  // Load venues from data service
  Future<void> loadVenues() async {
    try {
      isLoading.value = true;
      final venueList = await VenueDataService.getVenues();
      venues.value = venueList;
      print('Loaded ${venues.length} venues');
    } catch (e) {
      print('Error loading venues: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách địa điểm',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle favorite status
  void toggleFavorite(String venueId) {
    final index = venues.indexWhere((venue) => venue.venueId == venueId);
    if (index != -1) {
      venues[index] = venues[index].copyWith(
        isFavorite: !venues[index].isFavorite,
      );
      
      final venue = venues[index];
      Get.snackbar(
        venue.isFavorite ? 'Đã thêm vào yêu thích' : 'Đã xóa khỏi yêu thích',
        venue.title,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: venue.isFavorite 
          ? Colors.green.withOpacity(0.1) 
          : Colors.grey.withOpacity(0.1),
        colorText: venue.isFavorite ? Colors.green : Colors.grey.shade700,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Navigate to venue detail
  void navigateToVenueDetail(String venueId) {
    final venue = venues.firstWhere((venue) => venue.venueId == venueId);
    
    Get.to(
      () => DetailVenueScreen(
        venueId: venue.venueId,
        title: venue.title,
        imagePath: venue.imagePath,
        description: venue.subtitle,
        location: venue.location,
        price: venue.price,
        amenities: venue.amenities,
        rating: venue.rating,
        reviewCount: venue.reviewCount,
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Search venues
  Future<void> searchVenues(String query) async {
    try {
      isLoading.value = true;
      searchQuery.value = query;
      
      final searchResults = await VenueDataService.searchVenues(query);
      venues.value = searchResults;
      
      print('Search results: ${venues.length} venues found');
    } catch (e) {
      print('Error searching venues: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tìm kiếm địa điểm',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Filter venues by price
  Future<void> filterByPrice(double minPrice, double maxPrice) async {
    try {
      isLoading.value = true;
      
      final filteredVenues = await VenueDataService.filterVenuesByPrice(
        minPrice, 
        maxPrice
      );
      venues.value = filteredVenues;
      
      print('Filtered by price: ${venues.length} venues found');
    } catch (e) {
      print('Error filtering venues: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get featured venues
  Future<void> loadFeaturedVenues() async {
    try {
      isLoading.value = true;
      
      final featuredVenues = await VenueDataService.getFeaturedVenues();
      venues.value = featuredVenues;
      
      print('Featured venues loaded: ${venues.length}');
    } catch (e) {
      print('Error loading featured venues: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get favorite venues
  Future<void> loadFavoriteVenues() async {
    try {
      isLoading.value = true;
      
      final favoriteVenues = await VenueDataService.getFavoriteVenues();
      venues.value = favoriteVenues;
      
      print('Favorite venues loaded: ${venues.length}');
    } catch (e) {
      print('Error loading favorite venues: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh venues
  Future<void> refreshVenues() async {
    await loadVenues();
  }

  // Clear search and reload all venues
  void clearSearch() {
    searchQuery.value = '';
    loadVenues();
  }

  // Get venues count
  int get venuesCount => venues.length;

  // Get favorite venues count
  int get favoriteCount => venues.where((venue) => venue.isFavorite).length;

  // Backward compatibility with old dashboard items
  List<DashboardItem> get dashboardItems {
    return venues.map((venue) => DashboardItem(
      id: venue.venueId,
      title: venue.title,
      subtitle: venue.subtitle,
      imagePath: venue.imagePath,
      isFavorite: venue.isFavorite,
    )).toList();
  }

  // Legacy methods for backward compatibility
  void onItemPressed(String venueId) {
    navigateToVenueDetail(venueId);
  }
}

// Legacy DashboardItem class for backward compatibility
class DashboardItem {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isFavorite;

  DashboardItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isFavorite,
  });
}