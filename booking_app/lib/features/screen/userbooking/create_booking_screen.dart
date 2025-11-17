import 'package:booking_app/features/controller/userbooking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/formatter/date_formatter.dart';
import 'package:booking_app/formatter/currency_formatter.dart';

class CreateBookingScreen extends StatefulWidget {
  const CreateBookingScreen({super.key});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  late final TextEditingController _guestCountController;

  @override
  void initState() {
    super.initState();
    _guestCountController = TextEditingController();
  }

  @override
  void dispose() {
    _guestCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserBookingController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đặt lịch mới',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: WColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(WSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepHeader('1', 'Chọn địa điểm tổ chức'),
              const SizedBox(height: WSizes.spaceBtwItems),
              _buildVenueSelector(controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              _buildStepHeader('2', 'Chọn ngày & giờ'),
              const SizedBox(height: WSizes.spaceBtwItems),
              _buildDateTimePicker(controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              _buildStepHeader('3', 'Số lượng khách'),
              const SizedBox(height: WSizes.spaceBtwItems),
              _buildGuestCountSelector(controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              _buildStepHeader('4', 'Chọn menu (tùy chọn)'),
              const SizedBox(height: WSizes.spaceBtwItems),
              _buildMenuSelector(controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              _buildStepHeader('5', 'Yêu cầu đặc biệt'),
              const SizedBox(height: WSizes.spaceBtwItems),
              _buildSpecialRequestsField(controller),
              const SizedBox(height: WSizes.spaceBtwSections),
              _buildConfirmButton(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepHeader(String step, String title) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: WColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildVenueSelector(UserBookingController controller) {
    return Obx(() {
      if (controller.venues.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('Đang tải danh sách địa điểm...'),
          ),
        );
      }

      return Column(
        children: controller.venues.map((venue) {
          final isSelected = controller.selectedVenue.value?.id == venue.id;

          final imageUrl = venue.images.isNotEmpty
              ? venue.images.first
              : ''; // ← KHÔNG CÓ imagePath

          return GestureDetector(
            onTap: () => controller.selectVenue(venue),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? WColors.primary.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? WColors.primary : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          venue.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isSelected ? WColors.primary : Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Iconsax.location,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                venue.location,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Iconsax.star1,
                                size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${venue.rating.toStringAsFixed(1)} (${venue.reviewCount} reviews)',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              // ✅ SỬ DỤNG: CurrencyFormatter
                              CurrencyFormatter.formatVND(venue.price),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: WColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Iconsax.tick_circle5,
                      color: WColors.primary,
                      size: 24,
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildDateTimePicker(UserBookingController controller) {
    return Obx(() => GestureDetector(
          onTap: () => _showDateTimePicker(controller),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.calendar, color: WColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ngày & giờ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.selectedTimeSlot.value != null
                            ? '${DateFormatter.formatDate(controller.selectedDate.value)} - ${controller.selectedTimeSlot.value!.label}'
                            : DateFormatter.formatDate(
                                controller.selectedDate.value),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (controller.selectedTimeSlot.value == null)
                        const Text(
                          'Chưa chọn khung giờ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Iconsax.arrow_right_3, color: WColors.primary),
              ],
            ),
          ),
        ));
  }

  Future<void> _showDateTimePicker(UserBookingController controller) async {
    // Step 1: Chọn ngày
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDate.value.isAfter(DateTime.now())
          ? controller.selectedDate.value
          : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: WColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      // Cập nhật ngày trước
      controller.updateSelectedDate(date);

      // Step 2: Hiển thị dialog chọn khung giờ
      await _showTimeSlotPicker(controller);
    }
  }

  Future<void> _showTimeSlotPicker(UserBookingController controller) async {
    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Chọn khung giờ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() {
            if (controller.availableTimeSlots.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Không có khung giờ nào khả dụng'),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.availableTimeSlots.length,
              itemBuilder: (context, index) {
                final slot = controller.availableTimeSlots[index];
                final isSelected = controller.selectedTimeSlot.value == slot;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isSelected ? WColors.primary : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? WColors.primary.withOpacity(0.1)
                        : Colors.white,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Iconsax.clock,
                      color: isSelected ? WColors.primary : Colors.grey,
                    ),
                    title: Text(
                      slot.label,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? WColors.primary : Colors.black,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Iconsax.tick_circle,
                            color: WColors.primary)
                        : null,
                    onTap: () {
                      controller.selectTimeSlot(slot);
                      Get.back();
                    },
                  ),
                );
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestCountSelector(UserBookingController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Iconsax.people, color: WColors.primary),
              const SizedBox(width: 12),
              const Text(
                'Số lượng khách',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: WColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // TextField để nhập số khách
          TextField(
            controller: _guestCountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Nhập số lượng khách',
              prefixIcon: const Icon(Iconsax.user, color: WColors.primary),
              suffixText: 'khách',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: WColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              final count = int.tryParse(value) ?? 0;
              if (count >= 0) {
                controller.updateGuestCount(count);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSelector(UserBookingController controller) {
    return Obx(() {
      if (controller.selectedVenue.value == null) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('Vui lòng chọn địa điểm trước'),
          ),
        );
      }

      if (controller.menus.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('Địa điểm này chưa có menu sẵn có'),
          ),
        );
      }

      return Column(
        children: [
          GestureDetector(
            onTap: () => controller.selectMenu(null),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: controller.selectedMenu.value == null
                    ? WColors.primary.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.selectedMenu.value == null
                      ? WColors.primary
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.close_circle, color: Colors.grey),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Không chọn menu (thương lượng sau)',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (controller.selectedMenu.value == null)
                    const Icon(Iconsax.tick_circle5, color: WColors.primary),
                ],
              ),
            ),
          ),
          ...controller.menus.map((menu) {
            final isSelected = controller.selectedMenu.value?.id == menu.id;

            return GestureDetector(
              onTap: () => controller.selectMenu(menu),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? WColors.primary.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? WColors.primary : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: WColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Iconsax.cake,
                        color: WColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  isSelected ? WColors.primary : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            // ✅ SỬ DỤNG: CurrencyFormatter
                            CurrencyFormatter.formatPerGuest(menu.price),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: WColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Iconsax.tick_circle5,
                        color: WColors.primary,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  Widget _buildSpecialRequestsField(UserBookingController controller) {
    return TextField(
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Nhập yêu cầu đặc biệt (nếu có)...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: WColors.primary),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) => controller.specialRequests.value = value,
    );
  }

  Widget _buildConfirmButton(UserBookingController controller) {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () => _showConfirmDialog(controller),
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Xác nhận đặt lịch',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ));
  }

  void _showConfirmDialog(UserBookingController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Xác nhận đặt lịch',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfirmRow(
              'Địa điểm',
              controller.selectedVenue.value?.title ?? 'Chưa chọn',
            ),
            _buildConfirmRow(
              'Ngày & giờ',
              // ✅ SỬ DỤNG: DateFormatter
              DateFormatter.formatDateTime(controller.selectedDate.value),
            ),
            _buildConfirmRow(
              'Số khách',
              '${controller.guestCount.value} người',
            ),
            _buildConfirmRow(
              'Menu',
              controller.selectedMenu.value?.name ?? 'Không chọn',
            ),
            if (controller.specialRequests.value.isNotEmpty)
              _buildConfirmRow(
                'Yêu cầu',
                controller.specialRequests.value,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.createBooking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ THÊM helper widget
  Widget _buildImagePlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade200,
      child: const Icon(Iconsax.building, size: 32, color: Colors.grey),
    );
  }
}
