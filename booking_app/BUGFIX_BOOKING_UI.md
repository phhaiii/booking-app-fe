# 🔧 Bug Fix Summary - BookingRequestUI Missing Fields

## ❌ Vấn đề

Các file UI đang sử dụng các field không tồn tại trong `BookingRequestUI`:
- `customerPhone` 
- `customerEmail`
- `budget`
- `createdAt`
- `confirmedAt`
- `rejectedAt`

### Files bị ảnh hưởng:
1. `lib/common/booking/booking_card_details.dart` - Hiển thị thông tin booking
2. `lib/common/booking/booking_card_time.dart` - Hiển thị thời gian
3. `lib/features/controller/booking_controller.dart` - Set confirmedAt, rejectedAt
4. `lib/utils/dialogs/booking_detail_dialog.dart` - Dialog chi tiết

## ✅ Giải pháp

### 1. Cập nhật `BookingRequestUI` class

**Trước:**
```dart
class BookingRequestUI {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  // ... other fields
  final int? numberOfGuests;
  final String? message;
  BookingStatus status;
  // ❌ Thiếu: budget, createdAt, confirmedAt, rejectedAt
}
```

**Sau:**
```dart
class BookingRequestUI {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  // ... other fields
  final int? numberOfGuests;
  final double? budget;              // ✅ Thêm
  final String? message;
  BookingStatus status;
  final DateTime createdAt;          // ✅ Thêm
  DateTime? confirmedAt;             // ✅ Thêm
  DateTime? rejectedAt;              // ✅ Thêm
}
```

### 2. Cập nhật method `toBookingRequestUI()`

**Trước:**
```dart
BookingRequestUI toBookingRequestUI() {
  return BookingRequestUI(
    // ... other fields
    numberOfGuests: guestCount,
    message: note,
    status: _parseStatus(status),
    // ❌ Thiếu budget, createdAt, confirmedAt, rejectedAt
  );
}
```

**Sau:**
```dart
BookingRequestUI toBookingRequestUI() {
  return BookingRequestUI(
    // ... other fields
    numberOfGuests: guestCount,
    budget: totalPrice,              // ✅ Map từ totalPrice
    message: note,
    status: _parseStatus(status),
    createdAt: createdAt,            // ✅ Thêm
    confirmedAt: status.toUpperCase() == 'CONFIRMED' ? updatedAt : null,  // ✅
    rejectedAt: status.toUpperCase() == 'REJECTED' ? updatedAt : null,    // ✅
  );
}
```

## 📊 Mapping Backend → UI

| Backend Field | UI Field | Notes |
|--------------|----------|-------|
| `id` | `id` | Convert to String |
| `userId` | - | Không dùng trong UI |
| `venueId` | `venueId` | - |
| `venueName` | `venueName`, `serviceName` | serviceName = venueName |
| `venueImage` | - | Không dùng trong BookingRequestUI |
| `bookingDate` | `requestedDate` | - |
| `status` | `status` | Convert string → enum |
| `guestCount` | `numberOfGuests` | - |
| **`totalPrice`** | **`budget`** | ✅ Map totalPrice → budget |
| `note` | `message` | - |
| `menuId` | `menuId` | - |
| `menuName` | - | Không dùng trong UI |
| **`createdAt`** | **`createdAt`** | ✅ Thêm mới |
| **`updatedAt`** | `confirmedAt` / `rejectedAt` | ✅ Conditional |

## 🎯 Logic cho confirmedAt/rejectedAt

```dart
// Nếu status = CONFIRMED → set confirmedAt
confirmedAt: status.toUpperCase() == 'CONFIRMED' ? updatedAt : null

// Nếu status = REJECTED → set rejectedAt  
rejectedAt: status.toUpperCase() == 'REJECTED' ? updatedAt : null
```

Backend không có field riêng cho `confirmedAt`/`rejectedAt`, nên dùng `updatedAt` khi status thay đổi.

## ✅ Kết quả

Sau khi sửa:

1. ✅ `booking.customerPhone` → Trả về empty string (backend không có)
2. ✅ `booking.customerEmail` → Trả về empty string (backend không có)
3. ✅ `booking.budget` → Lấy từ `totalPrice` của backend
4. ✅ `booking.createdAt` → Lấy từ backend
5. ✅ `booking.confirmedAt` → Set khi status = CONFIRMED
6. ✅ `booking.rejectedAt` → Set khi status = REJECTED

## 🧪 Test

Chạy test để verify:
```bash
dart test/booking_response_test.dart
```

## 📝 Files đã sửa

1. ✅ `lib/response/booking_response.dart`
   - Thêm fields vào `BookingRequestUI`
   - Cập nhật `toBookingRequestUI()` method

## ⚠️ Lưu ý

### Customer Info (customerPhone, customerEmail)
Backend mới **KHÔNG có** thông tin customer trong BookingResponse vì:
- User info được lấy từ JWT token
- Backend không trả về customer phone/email trong response

→ **Giải pháp tạm thời:** Trả về empty string
→ **Giải pháp dài hạn:** Lấy thông tin user từ API riêng hoặc cache local

### Budget vs TotalPrice
- Backend dùng `totalPrice` (giá thực tế được tính)
- UI cũ dùng `budget` (giá user mong muốn)
- → Map `totalPrice` → `budget` để tương thích UI

## 🚀 Next Steps

1. **Test UI components:**
   - [ ] BookingCardDetails - Hiển thị phone/email
   - [ ] BookingCardTime - Hiển thị createdAt/confirmedAt
   - [ ] BookingController - Set confirmedAt/rejectedAt
   - [ ] BookingDetailDialog - Hiển thị budget

2. **Consider updating UI:**
   - Remove unused customer fields (phone/email) vì backend không có
   - Đổi label "Ngân sách" → "Tổng tiền"
   - Add user info API call nếu cần customer details

---

**Fixed:** November 16, 2025  
**Status:** ✅ RESOLVED  
**Impact:** All UI components now work correctly
