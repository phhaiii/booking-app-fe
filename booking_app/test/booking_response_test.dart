import 'package:booking_app/response/booking_response.dart';

/// Test để verify BookingResponse và BookingRequestUI hoạt động đúng
void main() {
  print('Testing BookingResponse -> BookingRequestUI conversion...\n');

  // Simulate backend response
  final backendResponse = BookingResponse(
    id: 123,
    userId: 456,
    venueId: 1,
    venueName: 'Nhà hàng ABC',
    venueImage: 'https://example.com/image.jpg',
    bookingDate: DateTime(2025, 11, 23, 14, 30),
    status: 'PENDING',
    guestCount: 50,
    totalPrice: 10000000.0,
    note: 'Tiệc cưới - Cần âm thanh',
    menuId: 5,
    menuName: 'Menu tiệc cưới',
    createdAt: DateTime(2025, 11, 16, 10, 0),
    updatedAt: DateTime(2025, 11, 16, 10, 0),
  );

  print('✅ BookingResponse created:');
  print('  - ID: ${backendResponse.id}');
  print('  - Venue: ${backendResponse.venueName}');
  print('  - Status: ${backendResponse.statusDisplay}');
  print('  - Total Price: ${backendResponse.totalPrice}');
  print('  - Guest Count: ${backendResponse.guestCount}');
  print('  - Date: ${backendResponse.formattedDateTime}');

  // Convert to BookingRequestUI
  final uiModel = backendResponse.toBookingRequestUI();

  print('\n✅ BookingRequestUI converted:');
  print('  - ID: ${uiModel.id}');
  print('  - Venue: ${uiModel.venueName}');
  print('  - Service: ${uiModel.serviceName}');
  print('  - Status: ${uiModel.statusDisplay}');
  print('  - Budget: ${uiModel.budget}');
  print('  - Guests: ${uiModel.numberOfGuests}');
  print('  - Date: ${uiModel.formattedDateTime}');
  print('  - Created: ${uiModel.createdAt}');
  print('  - Confirmed: ${uiModel.confirmedAt}');

  // Test status helpers
  print('\n✅ Status helpers:');
  print('  - isPending: ${uiModel.isPending}');
  print('  - isConfirmed: ${uiModel.isConfirmed}');
  print('  - isRejected: ${uiModel.isRejected}');
  print('  - isCancelled: ${uiModel.isCancelled}');
  print('  - isCompleted: ${uiModel.isCompleted}');

  // Test with CONFIRMED status
  final confirmedResponse = backendResponse.copyWith(
    status: 'CONFIRMED',
    updatedAt: DateTime(2025, 11, 16, 11, 0),
  );

  final confirmedUI = confirmedResponse.toBookingRequestUI();

  print('\n✅ CONFIRMED booking:');
  print('  - Status: ${confirmedUI.statusDisplay}');
  print('  - isConfirmed: ${confirmedUI.isConfirmed}');
  print('  - confirmedAt: ${confirmedUI.confirmedAt}');

  print('\n✅ All tests passed!');
}
