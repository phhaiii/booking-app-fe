class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://10.0.2.2:8089/api';
  static const String imageBaseUrl = 'http://10.0.2.2:8089/uploads';
  
  // ✅ Post/Venue endpoints
  static const String postsEndpoint = '/posts';
  static const String favoriteEndpoint = '/posts/{id}/favorite';
  static const String favoritesEndpoint = '/posts/favorites';
  static const String searchEndpoint = '/posts/search';
  
  // ✅ Auth endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  
  // Request timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Image processing
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['.jpg', '.jpeg', '.png', '.webp'];
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;
}