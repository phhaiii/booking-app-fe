import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';

class PhotographyScreen extends StatefulWidget {
  const PhotographyScreen({super.key});

  @override
  State<PhotographyScreen> createState() => _PhotographyScreenState();
}

class _PhotographyScreenState extends State<PhotographyScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<PhotographyPackage> _packages = [
    PhotographyPackage(
      id: 'basic',
      name: 'Gói Cơ Bản',
      price: '5.000.000đ',
      originalPrice: '6.000.000đ',
      rating: 4.5,
      photographer: 'Studio ABC',
      duration: '4 giờ',
      photos: '200 ảnh',
      features: [
        'Chụp ảnh cưới tại studio',
        '200 ảnh đã chỉnh sửa',
        '1 album 20x30cm (50 trang)',
        'USB chứa toàn bộ ảnh',
        'Trang phục cưới miễn phí',
      ],
      image: 'assets/images/photo1.jpg',
    ),
    PhotographyPackage(
      id: 'premium',
      name: 'Gói Premium',
      price: '12.000.000đ',
      originalPrice: '15.000.000đ',
      rating: 4.8,
      photographer: 'Wedding Studio XYZ',
      duration: '8 giờ',
      photos: '500 ảnh',
      features: [
        'Chụp ảnh cưới ngoại cảnh + studio',
        '500 ảnh đã chỉnh sửa chuyên nghiệp',
        '2 album cao cấp 30x40cm',
        'Video highlight 3-5 phút',
        'Makeup + trang phục miễn phí',
        'Photographer phụ hỗ trợ',
      ],
      image: 'assets/images/photo2.jpg',
    ),
    PhotographyPackage(
      id: 'luxury',
      name: 'Gói Luxury',
      price: '25.000.000đ',
      originalPrice: '30.000.000đ',
      rating: 5.0,
      photographer: 'Elite Wedding Studio',
      duration: 'Cả ngày',
      photos: '1000+ ảnh',
      features: [
        'Chụp ảnh cưới đa địa điểm',
        '1000+ ảnh chất lượng 4K',
        '3 album luxury + slideshow',
        'Video cinematic đầy đủ',
        'Drone quay flycam',
        'Team 3 photographer chuyên nghiệp',
        'Makeup artist riêng',
        'Trang phục cao cấp không giới hạn',
      ],
      image: 'assets/images/photo3.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gói chụp ảnh cưới',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: WColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Gói chụp ảnh'),
            Tab(text: 'Đã đặt'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPackagesList(),
          _buildBookedList(),
        ],
      ),
    );
  }

  Widget _buildPackagesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _packages.length,
      itemBuilder: (context, index) {
        final package = _packages[index];
        return _buildPackageCard(package);
      },
    );
  }

  Widget _buildPackageCard(PhotographyPackage package) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showPackageDetail(package),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Package Image
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      color: Colors.grey[300],
                    ),
                    child: const Icon(Icons.photo_camera, size: 60, color: Colors.grey),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            package.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Package Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          package.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (package.originalPrice != null)
                            Text(
                              package.originalPrice!,
                              style: const TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          Text(
                            package.price,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: WColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    package.photographer,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Quick Info
                  Row(
                    children: [
                      _buildQuickInfo(Iconsax.clock, package.duration),
                      const SizedBox(width: 20),
                      _buildQuickInfo(Iconsax.camera, package.photos),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Features Preview
                  Column(
                    children: package.features.take(3).map((feature) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(feature, style: const TextStyle(fontSize: 13))),
                          ],
                        ),
                      ),
                    ).toList(),
                  ),
                  if (package.features.length > 3)
                    Text(
                      'Và ${package.features.length - 3} dịch vụ khác...',
                      style: TextStyle(
                        fontSize: 12,
                        color: WColors.primary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _bookPackage(package),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Đặt gói ngay',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBookedList() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.camera_slash, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Chưa có gói nào được đặt',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showPackageDetail(PhotographyPackage package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        package.photographer,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Price
                      Row(
                        children: [
                          Text(
                            package.price,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: WColors.primary,
                            ),
                          ),
                          if (package.originalPrice != null) ...[
                            const SizedBox(width: 12),
                            Text(
                              package.originalPrice!,
                              style: const TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Features
                      const Text(
                        'Dịch vụ bao gồm:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...package.features.map((feature) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom Actions
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Đóng'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _bookPackage(package);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Đặt gói này',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _bookPackage(PhotographyPackage package) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đặt gói'),
        content: Text('Bạn có muốn đặt ${package.name} với giá ${package.price}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar(
                'Thành công',
                'Đã đặt ${package.name}. Chúng tôi sẽ liên hệ với bạn sớm!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 3),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}

class PhotographyPackage {
  final String id;
  final String name;
  final String price;
  final String? originalPrice;
  final double rating;
  final String photographer;
  final String duration;
  final String photos;
  final List<String> features;
  final String image;

  PhotographyPackage({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.photographer,
    required this.duration,
    required this.photos,
    required this.features,
    required this.image,
  });
}