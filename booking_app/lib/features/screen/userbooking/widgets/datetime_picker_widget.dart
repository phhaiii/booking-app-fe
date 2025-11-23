import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/formatter/date_formatter.dart';
import 'package:booking_app/features/controller/userbooking_controller.dart';

class DateTimePickerWidget extends StatelessWidget {
  final UserBookingController controller;

  const DateTimePickerWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => _showDateTimePicker(context),
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

  Future<void> _showDateTimePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
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
      controller.updateSelectedDate(date);
      await _showTimeSlotPicker();
    }
  }

  Future<void> _showTimeSlotPicker() async {
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
            if (controller.isLoadingTimeSlots.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              );
            }

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
}
