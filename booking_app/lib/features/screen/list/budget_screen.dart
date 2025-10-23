import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  double totalBudget = 500000000; // 500 triệu
  double spentAmount = 120000000; // 120 triệu đã chi

  final List<BudgetCategory> budgetCategories = [
    BudgetCategory(
      id: 'venue',
      name: 'Địa điểm tổ chức',
      icon: Iconsax.building,
      budgetAmount: 150000000,
      spentAmount: 50000000,
      color: Colors.blue,
      items: [
        BudgetItem('Trống Đồng Palace - Cọc', 50000000, true),
        BudgetItem('Trang trí sảnh', 0, false),
        BudgetItem('Âm thanh ánh sáng', 0, false),
      ],
    ),
    BudgetCategory(
      id: 'food',
      name: 'Tiệc cưới & Ẩm thực',
      icon: Iconsax.cake,
      budgetAmount: 120000000,
      spentAmount: 30000000,
      color: Colors.orange,
      items: [
        BudgetItem('Menu tiệc cưới', 0, false),
        BudgetItem('Bánh cưới', 5000000, true),
        BudgetItem('Rượu nước uống', 25000000, true),
      ],
    ),
    BudgetCategory(
      id: 'photography',
      name: 'Chụp ảnh & Quay phim',
      icon: Iconsax.camera,
      budgetAmount: 80000000,
      spentAmount: 40000000,
      color: Colors.purple,
      items: [
        BudgetItem('Gói chụp ảnh cưới', 40000000, true),
        BudgetItem('Album ảnh', 0, false),
        BudgetItem('Video highlight', 0, false),
      ],
    ),
    BudgetCategory(
      id: 'clothing',
      name: 'Trang phục',
      icon: Iconsax.shopping_bag,
      budgetAmount: 60000000,
      spentAmount: 0,
      color: Colors.pink,
      items: [
        BudgetItem('Váy cưới cô dâu', 0, false),
        BudgetItem('Vest chú rể', 0, false),
        BudgetItem('Phụ kiện', 0, false),
      ],
    ),
    BudgetCategory(
      id: 'decoration',
      name: 'Trang trí & Hoa',
      icon: Iconsax.lovely,
      budgetAmount: 40000000,
      spentAmount: 0,
      color: Colors.green,
      items: [
        BudgetItem('Hoa cưới', 0, false),
        BudgetItem('Trang trí bàn tiệc', 0, false),
        BudgetItem('Backdrop sân khấu', 0, false),
      ],
    ),
    BudgetCategory(
      id: 'other',
      name: 'Chi phí khác',
      icon: Iconsax.more,
      budgetAmount: 50000000,
      spentAmount: 0,
      color: Colors.grey,
      items: [
        BudgetItem('Thiệp cưới', 0, false),
        BudgetItem('Quà cảm ơn', 0, false),
        BudgetItem('Phí dự phòng', 0, false),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _updateSpentAmount();
  }

  void _updateSpentAmount() {
    double total = 0;
    for (var category in budgetCategories) {
      total += category.spentAmount;
    }
    setState(() {
      spentAmount = total;
    });
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
          'Ngân sách đám cưới',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: WColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _showAddExpenseDialog,
            icon: const Icon(Iconsax.add_circle),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Tổng quan'),
            Tab(text: 'Chi tiết'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildDetailTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final remainingBudget = totalBudget - spentAmount;
    final budgetProgress = spentAmount / totalBudget;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Budget Card
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [WColors.primary, WColors.primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng ngân sách',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatCurrency(totalBudget),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: budgetProgress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              budgetProgress > 0.8 ? Colors.red : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đã chi: ${_formatCurrency(spentAmount)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Còn lại: ${_formatCurrency(remainingBudget)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Categories Overview
          const Text(
            'Phân bổ ngân sách',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...budgetCategories
              .map((category) => _buildCategoryOverviewCard(category)),
        ],
      ),
    );
  }

  Widget _buildCategoryOverviewCard(BudgetCategory category) {
    final progress = category.budgetAmount > 0
        ? category.spentAmount / category.budgetAmount
        : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatCurrency(category.spentAmount)} / ${_formatCurrency(category.budgetAmount)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: progress > 0.8 ? Colors.red : category.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.8 ? Colors.red : category.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: budgetCategories.length,
      itemBuilder: (context, index) {
        final category = budgetCategories[index];
        return _buildCategoryDetailCard(category);
      },
    );
  }

  Widget _buildCategoryDetailCard(BudgetCategory category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: category.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            category.icon,
            color: category.color,
            size: 20,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${_formatCurrency(category.spentAmount)} / ${_formatCurrency(category.budgetAmount)}',
        ),
        children: [
          ...category.items.map((item) => ListTile(
                leading: Icon(
                  item.isPaid ? Iconsax.tick_circle : Iconsax.clock,
                  color: item.isPaid ? Colors.green : Colors.orange,
                  size: 20,
                ),
                title: Text(item.name),
                trailing: Text(
                  item.amount > 0 ? _formatCurrency(item.amount) : 'Chưa có',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: item.isPaid ? Colors.green : Colors.grey,
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _showAddItemDialog(category),
              icon: const Icon(Iconsax.add),
              label: const Text('Thêm chi phí'),
              style: ElevatedButton.styleFrom(
                backgroundColor: category.color,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm chi phí'),
        content: const Text('Chọn danh mục để thêm chi phí mới'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Show category selection
            },
            child: const Text('Tiếp tục'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BudgetCategory category) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    bool isPaid = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Thêm chi phí - ${category.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên chi phí',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền (VNĐ)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('Đã thanh toán'),
                value: isPaid,
                onChanged: (value) {
                  setDialogState(() {
                    isPaid = value ?? false;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  final amount = double.tryParse(amountController.text) ?? 0;

                  setState(() {
                    category.items
                        .add(BudgetItem(nameController.text, amount, isPaid));
                    if (isPaid) {
                      category.spentAmount += amount;
                    }
                  });

                  _updateSpentAmount();
                  Navigator.pop(context);

                  Get.snackbar(
                    'Thành công',
                    'Đã thêm chi phí mới',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: WColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} tỷ';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(0)} triệu';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}k';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}

// Models
class BudgetCategory {
  final String id;
  final String name;
  final IconData icon;
  final double budgetAmount;
  double spentAmount;
  final Color color;
  final List<BudgetItem> items;

  BudgetCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.budgetAmount,
    required this.spentAmount,
    required this.color,
    required this.items,
  });
}

class BudgetItem {
  final String name;
  final double amount;
  final bool isPaid;

  BudgetItem(this.name, this.amount, this.isPaid);
}
