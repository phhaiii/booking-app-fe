import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';

class ClothingScreen extends StatefulWidget {
  const ClothingScreen({super.key});

  @override
  State<ClothingScreen> createState() => _ClothingScreenState();
}

class _ClothingScreenState extends State<ClothingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<ClothingItem> weddingDresses = [
    ClothingItem(
      id: '1',
      name: 'Váy cưới công chúa',
      brand: 'Bridal House',
      price: '25.000.000đ',
      originalPrice: '30.000.000đ',
      rating: 4.8,
      category: ClothingCategory.brideGown,
      size: ['S', 'M', 'L'],
      color: ['Trắng', 'Kem'],
      description: 'Váy cưới phong cách công chúa với chất liệu ren cao cấp',
      features: [
        'Chất liệu ren Pháp cao cấp',
        'Đính kết pha lê Swarovski',
        'Tùng váy dài 3m',
        'Có thể điều chỉnh size',
        'Bao gồm phụ kiện đầy đủ',
      ],
      image: 'assets/images/dress1.jpg',
      isAvailable: true,
    ),
    ClothingItem(
      id: '2',
      name: 'Váy cưới mermaid',
      brand: 'Elite Bridal',
      price: '35.000.000đ',
      originalPrice: '40.000.000đ',
      rating: 5.0,
      category: ClothingCategory.brideGown,
      size: ['XS', 'S', 'M'],
      color: ['Trắng', 'Ivory'],
      description: 'Váy cưới ôm dáng mermaid sang trọng',
      features: [
        'Thiết kế ôm body tôn dáng',
        'Chất liệu silk cao cấp',
        'Đuôi váy đính sequin',
        'Thiết kế độc quyền',
        'Thời gian may 2 tuần',
      ],
      image: 'assets/images/dress2.jpg',
      isAvailable: true,
    ),
    ClothingItem(
      id: '3',
      name: 'Áo dài cưới truyền thống',
      brand: 'Việt Huyền Trang',
      price: '8.000.000đ',
      originalPrice: '10.000.000đ',
      rating: 4.9,
      category: ClothingCategory.aoDai,
      size: ['S', 'M', 'L', 'XL'],
      color: ['Đỏ', 'Hồng', 'Vàng'],
      description: 'Áo dài cưới truyền thống với họa tiết thêu tay',
      features: [
        'Thêu tay họa tiết rồng phượng',
        'Chất liệu gấm cao cấp',
        'Thiết kế truyền thống',
        'Có thể thuê hoặc mua',
        'Bao gồm khăn đóng',
      ],
      image: 'assets/images/aodai1.jpg',
      isAvailable: true,
    ),
  ];

  final List<ClothingItem> groomSuits = [
    ClothingItem(
      id: '4',
      name: 'Vest cưới cao cấp',
      brand: 'Gentleman Suit',
      price: '15.000.000đ',
      originalPrice: '18.000.000đ',
      rating: 4.7,
      category: ClothingCategory.groomSuit,
      size: ['M', 'L', 'XL', 'XXL'],
      color: ['Đen', 'Xám đậm', 'Navy'],
      description: 'Vest cưới nam cao cấp phong cách Ý',
      features: [
        'Chất liệu wool 100%',
        'May đo theo yêu cầu',
        'Thiết kế Italia',
        'Bao gồm áo vest + quần + gile',
        'Phụ kiện đầy đủ',
      ],
      image: 'assets/images/suit1.jpg',
      isAvailable: true,
    ),
    ClothingItem(
      id: '5',
      name: 'Áo dài cưới nam',
      brand: 'Nam Phong',
      price: '6.000.000đ',
      originalPrice: '7.500.000đ',
      rating: 4.6,
      category: ClothingCategory.groomAoDai,
      size: ['M', 'L', 'XL'],
      color: ['Đỏ', 'Vàng', 'Nâu'],
      description: 'Áo dài cưới nam truyền thống',
      features: [
        'Chất liệu gấm thêu',
        'Họa tiết rồng phượng',
        'Thiết kế truyền thống',
        'Bao gồm mũ và giày',
        'Có thể thuê theo ngày',
      ],
      image: 'assets/images/aodai_nam.jpg',
      isAvailable: true,
    ),
  ];

  final List<ClothingItem> accessories = [
    ClothingItem(
      id: '6',
      name: 'Vương miện cô dâu',
      brand: 'Royal Crown',
      price: '3.000.000đ',
      rating: 4.9,
      category: ClothingCategory.accessories,
      size: ['One Size'],
      color: ['Bạc', 'Vàng'],
      description: 'Vương miện cô dâu đính kim cương',
      features: [
        'Đính kim cương Swarovski',
        'Chất liệu bạc 925',
        'Thiết kế tinh xảo',
        'Bảo hành 1 năm',
        'Hộp đựng cao cấp',
      ],
      image: 'assets/images/crown.jpg',
      isAvailable: true,
    ),
    ClothingItem(
      id: '7',
      name: 'Giày cưới cao gót',
      brand: 'Bridal Shoes',
      price: '2.500.000đ',
      rating: 4.5,
      category: ClothingCategory.accessories,
      size: ['35', '36', '37', '38', '39'],
      color: ['Trắng', 'Kem', 'Bạc'],
      description: 'Giày cưới cao gót êm chân',
      features: [
        'Đế êm chống trượt',
        'Cao 7cm',
        'Chất liệu da thật',
        'Đính ngọc trai',
        'Thiết kế thoáng khí',
      ],
      image: 'assets/images/shoes.jpg',
      isAvailable: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          'Trang phục cưới',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: WColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Váy cưới'),
            Tab(text: 'Vest nam'),
            Tab(text: 'Phụ kiện'),
            Tab(text: 'Đã chọn'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildClothingList(weddingDresses),
          _buildClothingList(groomSuits),
          _buildClothingList(accessories),
          _buildSelectedList(),
        ],
      ),
    );
  }

  Widget _buildClothingList(List<ClothingItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildClothingCard(item);
      },
    );
  }

  Widget _buildClothingCard(ClothingItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showItemDetail(item),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                color: Colors.grey[300],
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      color: Colors.grey[300],
                    ),
                    child: Icon(
                      _getCategoryIcon(item.category),
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                            item.rating.toString(),
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
                  if (!item.isAvailable)
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: const Center(
                        child: Text(
                          'HẾT HÀNG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Item Info
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
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (item.originalPrice != null)
                            Text(
                              item.originalPrice!,
                              style: const TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          Text(
                            item.price,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: WColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.brand,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Size and Color
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoChip('Size', item.size.join(', ')),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoChip('Màu', item.color.join(', ')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: item.isAvailable
                              ? () => _addToFavorites(item)
                              : null,
                          icon: const Icon(Iconsax.heart, size: 18),
                          label: const Text('Yêu thích'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: WColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              item.isAvailable ? () => _selectItem(item) : null,
                          icon: const Icon(Iconsax.shopping_cart, size: 18),
                          label: const Text('Chọn'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: item.isAvailable
                                ? WColors.primary
                                : Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedList() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.shopping_bag, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Chưa có trang phục nào được chọn',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Hãy chọn trang phục yêu thích của bạn',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(ClothingCategory category) {
    switch (category) {
      case ClothingCategory.brideGown:
      case ClothingCategory.aoDai:
        return Iconsax.lovely;
      case ClothingCategory.groomSuit:
      case ClothingCategory.groomAoDai:
        return Iconsax.man;
      case ClothingCategory.accessories:
        return Iconsax.crown;
    }
  }

  void _showItemDetail(ClothingItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
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
                        item.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.brand,
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
                            item.price,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: WColors.primary,
                            ),
                          ),
                          if (item.originalPrice != null) ...[
                            const SizedBox(width: 12),
                            Text(
                              item.originalPrice!,
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

                      // Description
                      Text(
                        item.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Features
                      const Text(
                        'Đặc điểm:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...item.features.map(
                        (feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 20),
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

                      const SizedBox(height: 20),

                      // Size and Color options
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Size có sẵn:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: item.size
                                      .map(
                                        (size) => Chip(
                                          label: Text(size),
                                          backgroundColor: Colors.grey[200],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Màu sắc:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: item.color
                                      .map(
                                        (color) => Chip(
                                          label: Text(color),
                                          backgroundColor: Colors.grey[200],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                      onPressed: item.isAvailable
                          ? () {
                              Navigator.pop(context);
                              _selectItem(item);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            item.isAvailable ? WColors.primary : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        item.isAvailable ? 'Chọn trang phục này' : 'Hết hàng',
                        style: const TextStyle(fontWeight: FontWeight.bold),
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

  void _addToFavorites(ClothingItem item) {
    Get.snackbar(
      'Đã thêm',
      'Đã thêm ${item.name} vào danh sách yêu thích',
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.favorite, color: Colors.white),
    );
  }

  void _selectItem(ClothingItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận chọn trang phục'),
        content: Text('Bạn có muốn chọn "${item.name}" với giá ${item.price}?'),
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
                'Đã chọn ${item.name}. Chúng tôi sẽ liên hệ để tư vấn size!',
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

// Models
class ClothingItem {
  final String id;
  final String name;
  final String brand;
  final String price;
  final String? originalPrice;
  final double rating;
  final ClothingCategory category;
  final List<String> size;
  final List<String> color;
  final String description;
  final List<String> features;
  final String image;
  final bool isAvailable;

  ClothingItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.category,
    required this.size,
    required this.color,
    required this.description,
    required this.features,
    required this.image,
    required this.isAvailable,
  });
}

enum ClothingCategory {
  brideGown, // Váy cưới
  aoDai, // Áo dài
  groomSuit, // Vest nam
  groomAoDai, // Áo dài nam
  accessories, // Phụ kiện
}
