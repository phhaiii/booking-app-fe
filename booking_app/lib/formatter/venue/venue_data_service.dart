import 'package:booking_app/formatter/venue/venue_model.dart';

class VenueDataService {
  // Mock data cho wedding venues tại Hà Nội
  static List<VenueModel> getMockVenues() {
    return [
      VenueModel(
        venueId: 'wedding_001',
        title: 'Grand Palace Wedding Center',
        subtitle:
            'Trung tâm tiệc cưới sang trọng bậc nhất Hà Nội với thiết kế cung điện hoàng gia, sảnh lớn chứa đến 1000 khách mời. Phong cách Châu Âu kết hợp kiến trúc Việt Nam.',
        imagePath: 'assets/images/dashboard1.jpg',
        location: 'Số 123 Phạm Văn Đồng, Bắc Từ Liêm, Hà Nội',
        price: 18000000,
        amenities: [
          'Sảnh lớn 1000 khách',
          'Âm thanh LED 5D',
          'Trang trí miễn phí',
          'Bãi đỗ xe 200 chỗ',
          'Phòng cô dâu VIP',
          'Menu cao cấp'
        ],
        rating: 4.9,
        reviewCount: 312,
        isFavorite: false,
      ),
      VenueModel(
        venueId: 'wedding_002',
        title: 'Lotte Wedding Center',
        subtitle:
            'Trung tâm tiệc cưới cao cấp tại tòa nhà Lotte với view toàn cảnh thủ đô, thiết kế hiện đại và dịch vụ 5 sao. Không gian lãng mạn nhất Hà Nội.',
        imagePath: 'assets/images/dashboard2.jpg',
        location: 'Tầng 65 Lotte Center, Ba Đình, Hà Nội',
        price: 35000000,
        amenities: [
          'View toàn thành phố',
          'Sảnh 800 khách',
          'Thiết kế Hàn Quốc',
          'Wedding planner',
          'Helicopter landing',
          'Menu quốc tế'
        ],
        rating: 5.0,
        reviewCount: 198,
        isFavorite: true,
      ),
      VenueModel(
        venueId: 'wedding_003',
        title: 'Hoa Sen Wedding Garden',
        subtitle:
            'Trung tâm tiệc cưới ngoài trời bên hồ Tây, không gian xanh mát với vườn hoa sen rộng 3000m². Phong cách rustic kết hợp văn hóa Việt Nam.',
        imagePath: 'assets/images/dashboard3.jpg',
        location: 'Bên hồ Tây, Tây Hồ, Hà Nội',
        price: 14000000,
        amenities: [
          'Vườn hoa sen',
          'View hồ Tây',
          'Sảnh trong nhà 500 khách',
          'Tiệc ngoài trời',
          'Thuyền rồng',
          'Menu cung đình'
        ],
        rating: 4.8,
        reviewCount: 267,
        isFavorite: false,
      ),
      VenueModel(
        venueId: 'wedding_004',
        title: 'Metropole Wedding Palace',
        subtitle:
            'Khách sạn lịch sử với hơn 120 năm tuổi, không gian cổ điển Pháp được bảo tồn nguyên vẹn. Nơi tổ chức tiệc cưới của giới thượng lưu Hà Nội.',
        imagePath: 'assets/images/dashboard4.jpg',
        location: 'Số 15 Ngô Quyền, Hoàn Kiếm, Hà Nội',
        price: 42000000,
        amenities: [
          'Kiến trúc Pháp cổ',
          'Sảnh lịch sử',
          'Butler riêng',
          'Phòng Opera',
          'Vườn xanh',
          'Menu Michelin'
        ],
        rating: 5.0,
        reviewCount: 89,
        isFavorite: true,
      ),
      VenueModel(
        venueId: 'wedding_005',
        title: 'Temple of Literature Wedding',
        subtitle:
            'Không gian tiệc cưới độc đáo tại khuôn viên Văn Miếu, kết hợp giữa nét đẹp cổ kính và hiện đại. Mang đậm bản sắc văn hóa Việt Nam.',
        imagePath: 'assets/images/dashboard6.jpg',
        location: 'Khuôn viên Văn Miếu, Đống Đa, Hà Nội',
        price: 25000000,
        amenities: [
          'Di tích lịch sử',
          'Kiến trúc cổ',
          'Sảnh 400 khách',
          'Vườn cổ',
          'Nhã nhạc cung đình',
          'Menu hoàng gia'
        ],
        rating: 4.9,
        reviewCount: 156,
        isFavorite: true,
      ),
      VenueModel(
        venueId: 'wedding_006',
        title: 'Diamond Wedding Resort',
        subtitle:
            'Resort tiệc cưới ven hồ tại ngoại ô Hà Nội, không gian thoáng đãng với vườn hoa lavender. Phù hợp cho tiệc cưới destination wedding.',
        imagePath: 'assets/images/venues/wedding_6.jpg',
        location: 'Khu nghỉ dưỡng Sóc Sơn, Hà Nội',
        price: 22000000,
        amenities: [
          'Resort ven hồ',
          'Vườn lavender',
          'Sảnh kính 600 khách',
          'Villa nghỉ dưỡng',
          'Spa cô dâu',
          'Menu farm-to-table'
        ],
        rating: 4.7,
        reviewCount: 234,
        isFavorite: false,
      ),
      VenueModel(
        venueId: 'wedding_007',
        title: 'Royal Wedding Hall',
        subtitle:
            'Sảnh tiệc hoàng gia với thiết kế cung đình Huế, trần họa tiết rồng phượng và hệ thống đèn chùm vàng. Không gian tráng lệ cho đám cưới truyền thống.',
        imagePath: 'assets/images/venues/wedding_7.jpg',
        location: 'Số 456 Kim Mã, Ba Đình, Hà Nội',
        price: 28000000,
        amenities: [
          'Thiết kế cung đình',
          'Trần rồng phượng',
          'Sảnh 700 khách',
          'Trang phục cổ trang',
          'Lễ tea ceremony',
          'Menu cung đình'
        ],
        rating: 4.8,
        reviewCount: 178,
        isFavorite: false,
      ),
      VenueModel(
        venueId: 'wedding_008',
        title: 'Sky Wedding Keangnam',
        subtitle:
            'Trung tâm tiệc cưới trên không tại tòa nhà cao nhất Hà Nội, view 360 độ toàn thành phố. Không gian hiện đại với công nghệ hologram.',
        imagePath: 'assets/images/venues/wedding_8.jpg',
        location: 'Tầng 70 Keangnam, Cầu Giấy, Hà Nội',
        price: 38000000,
        amenities: [
          'View 360 độ',
          'Công nghệ hologram',
          'Sảnh trên không',
          'LED ceiling',
          'Robot phục vụ',
          'Menu fusion'
        ],
        rating: 4.9,
        reviewCount: 145,
        isFavorite: true,
      ),
      VenueModel(
        venueId: 'wedding_009',
        title: 'Old Quarter Wedding House',
        subtitle:
            'Nhà cổ phố cổ được cải tạo thành trung tâm tiệc cưới, giữ nguyên kiến trúc truyền thống. Không gian ấm cúng cho tiệc cưới nhỏ và vừa.',
        imagePath: 'assets/images/venues/wedding_9.jpg',
        location: 'Số 78 Hàng Gai, Hoàn Kiếm, Hà Nội',
        price: 12000000,
        amenities: [
          'Kiến trúc truyền thống',
          'Sảnh 300 khách',
          'Góc chụp hình cổ điển',
          'Menu truyền thống',
          'Phục vụ chuyên nghiệp'
        ],
        rating: 4.7,
        reviewCount: 98,
        isFavorite: false,
      ),
    ];
  }

  // Simulate API call to get venues
  static Future<List<VenueModel>> getVenues() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockVenues();
  }

  // Get venue by ID
  static Future<VenueModel?> getVenueById(String venueId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final venues = getMockVenues();
    try {
      return venues.firstWhere((venue) => venue.venueId == venueId);
    } catch (e) {
      return null;
    }
  }

  // Search venues
  static Future<List<VenueModel>> searchVenues(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final venues = getMockVenues();

    if (query.isEmpty) return venues;

    return venues.where((venue) {
      return venue.title.toLowerCase().contains(query.toLowerCase()) ||
          venue.subtitle.toLowerCase().contains(query.toLowerCase()) ||
          venue.location.toLowerCase().contains(query.toLowerCase()) ||
          venue.amenities.any(
              (amenity) => amenity.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  // Filter venues by price range
  static Future<List<VenueModel>> filterVenuesByPrice(
      double minPrice, double maxPrice) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final venues = getMockVenues();

    return venues.where((venue) {
      return venue.price >= minPrice && venue.price <= maxPrice;
    }).toList();
  }

  // Get featured venues (high rating)
  static Future<List<VenueModel>> getFeaturedVenues() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final venues = getMockVenues();

    return venues.where((venue) => venue.rating >= 4.8).toList();
  }

  // Get favorite venues
  static Future<List<VenueModel>> getFavoriteVenues() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final venues = getMockVenues();

    return venues.where((venue) => venue.isFavorite).toList();
  }
}
