# Comment Feature - Hướng dẫn sử dụng

## 📋 Tổng quan

Tính năng comment/đánh giá cho phép người dùng:
- Xem tất cả đánh giá của một venue
- Viết đánh giá mới với rating (1-5 sao)
- Upload tối đa 5 ảnh kèm theo
- Phân trang khi có nhiều comments
- Đánh dấu comment hữu ích

## 🏗️ Cấu trúc File

### 1. Model
**File:** `lib/model/commentmodel.dart`
- `Comment` class: Chứa thông tin comment (id, content, rating, images, user info, etc.)
- `CommentRequest` class: Request data khi tạo comment
- `CommentsResponse` class: Response wrapper với pagination

### 2. Service
**File:** `lib/service/comment_service.dart`

**API Methods:**
```dart
// Load comments với phân trang
CommentService.getComments(
  postId: String,
  page: int = 1,
  size: int = 10
) -> Future<CommentsResponse>

// Tạo comment mới với images
CommentService.createComment(
  postId: String,
  content: String,
  rating: double,
  imagePaths: List<String>?
) -> Future<Comment>

// Cập nhật comment
CommentService.updateComment(
  postId: String,
  commentId: String,
  content: String,
  rating: double
) -> Future<Comment>

// Xóa comment
CommentService.deleteComment(
  postId: String,
  commentId: String
) -> Future<void>

// Đánh dấu helpful
CommentService.markAsHelpful(
  postId: String,
  commentId: String
) -> Future<void>

// Lấy thống kê
CommentService.getCommentStatistics(
  postId: String
) -> Future<Map<String, dynamic>>
```

### 3. Controller
**File:** `lib/features/controller/detailvenue_controller.dart`

**Properties:**
```dart
var comments = <Comment>[].obs          // Danh sách comments
var isLoadingComments = false.obs       // Loading state
var currentPage = 1.obs                 // Trang hiện tại
var totalPages = 0.obs                  // Tổng số trang
var hasMoreComments = true.obs          // Còn comments không?
var isLoadingMoreComments = false.obs   // Loading more state
```

**Methods:**
```dart
loadComments(String venueId, {bool isRefresh = false})  // Load comments
loadMoreComments()                                       // Load thêm comments
addComment(content, rating, imagePaths)                  // Thêm comment mới
```

### 4. UI Components

#### CommentBottomSheet
**File:** `lib/features/screen/detailvenue/commentbottomsheet.dart`

Bottom sheet để viết đánh giá mới:
- Rating slider (1-5 sao)
- Text input (10-500 ký tự)
- Image picker (max 5 ảnh)
- Preview ảnh đã chọn
- Submit button với loading state

**Sử dụng:**
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => CommentBottomSheet(
    venueId: venueId,
    onCommentAdded: (content, rating, imagePaths) {
      // Refresh comments list
      controller.loadComments(venueId, isRefresh: true);
    },
  ),
);
```

#### CommentsListBottomSheet
**File:** `lib/features/screen/detailvenue/commentbottomsheet.dart`

Bottom sheet hiển thị tất cả comments:
- Danh sách comments với scroll
- User avatar, name, rating
- Comment content
- Images preview
- Helpful button

**Sử dụng:**
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => CommentsListBottomSheet(
    venueId: venueId,
    comments: controller.comments,
    onWriteReview: () {
      Get.back(); // Close list
      // Show write review sheet
    },
  ),
);
```

## 🔧 Backend Requirements

Backend cần có các API endpoints sau:

### 1. Get Comments (Public)
```
GET /api/posts/{postId}/comments?page=1&size=10

Response:
{
  "comments": [
    {
      "id": "1",
      "userId": "user123",
      "userName": "John Doe",
      "userAvatar": "avatar.jpg",
      "content": "Great venue!",
      "rating": 5.0,
      "images": ["image1.jpg", "image2.jpg"],
      "createdAt": "2025-11-15T10:00:00Z",
      "updatedAt": "2025-11-15T10:00:00Z",
      "isVerified": true,
      "helpfulCount": 5
    }
  ],
  "currentPage": 1,
  "totalPages": 5,
  "totalCount": 45,
  "hasMore": true
}
```

### 2. Create Comment (Authenticated)
```
POST /api/posts/{postId}/comments
Content-Type: multipart/form-data

Body:
- content: string (required)
- rating: number (required, 1.0-5.0)
- images: file[] (optional, max 5)

Response:
{
  "id": "123",
  "userId": "user123",
  "userName": "John Doe",
  ...
}
```

### 3. Update Comment (Authenticated)
```
PUT /api/posts/{postId}/comments/{commentId}
Content-Type: application/json

Body:
{
  "content": "Updated content",
  "rating": 4.5
}
```

### 4. Delete Comment (Authenticated)
```
DELETE /api/posts/{postId}/comments/{commentId}
```

### 5. Mark Helpful (Authenticated)
```
POST /api/posts/{postId}/comments/{commentId}/helpful
```

### 6. Get Statistics (Public)
```
GET /api/posts/{postId}/comments/statistics

Response:
{
  "averageRating": 4.5,
  "totalComments": 45,
  "ratingDistribution": {
    "5": 20,
    "4": 15,
    "3": 8,
    "2": 2,
    "1": 0
  }
}
```

## 📱 Sử dụng trong App

### 1. Hiển thị Reviews Section
```dart
Widget _buildReviewsSection(DetailVenueController controller) {
  return Obx(() {
    if (controller.isLoadingComments.value) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Summary
        _buildReviewSummary(controller),
        
        // Recent reviews
        ...controller.comments.take(3).map((comment) => 
          _buildReviewCard(comment)
        ),
        
        // See all button
        if (controller.comments.length > 3)
          TextButton(
            onPressed: () => _showAllComments(controller),
            child: Text('Xem tất cả ${controller.comments.length} đánh giá'),
          ),
      ],
    );
  });
}
```

### 2. Show Write Review
```dart
void _showWriteReview(String venueId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CommentBottomSheet(
      venueId: venueId,
      onCommentAdded: (content, rating, imagePaths) {
        controller.loadComments(venueId, isRefresh: true);
      },
    ),
  );
}
```

### 3. Load More Comments
```dart
ListView.builder(
  itemCount: controller.comments.length + 1,
  itemBuilder: (context, index) {
    if (index == controller.comments.length) {
      // Load more indicator
      if (controller.hasMoreComments.value) {
        controller.loadMoreComments();
        return Center(child: CircularProgressIndicator());
      }
      return SizedBox.shrink();
    }
    return _buildReviewCard(controller.comments[index]);
  },
)
```

## 🎨 UI Features

### Comment Card
- ✅ User avatar với fallback (chữ cái đầu)
- ✅ Username và verified badge
- ✅ Star rating display
- ✅ Formatted date (vừa xong, 5 phút trước, etc.)
- ✅ Comment content
- ✅ Image gallery với full-screen view
- ✅ Helpful count
- ✅ Responsive layout

### Write Review Sheet
- ✅ Interactive star rating
- ✅ Rating description text
- ✅ Multi-line text input với character counter
- ✅ Image picker với preview
- ✅ Remove individual images
- ✅ Validation (min 10 chars, max 5 images)
- ✅ Loading state khi submit
- ✅ Success/Error snackbar

## ⚙️ Configuration

### API Base URL
File: `lib/service/api_constants.dart`
```dart
static const String baseUrl = 'http://10.0.2.2:8089';
static const String uploadsUrl = '$baseUrl/uploads';
```

### Image Upload Directory
Backend cần config:
```properties
app.upload.dir=uploads
```

### Validation Rules
- Content: 10-500 ký tự
- Rating: 1.0-5.0
- Images: Max 5 ảnh, mỗi ảnh max 5MB
- Allowed types: jpg, jpeg, png, webp

## 🐛 Troubleshooting

### Lỗi: "Column 'post_id' cannot be null"
Backend cần có bảng `comments` với foreign key đúng:
```sql
CREATE TABLE comments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  post_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  content TEXT NOT NULL,
  rating DECIMAL(2,1) NOT NULL,
  images JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Lỗi: "401 Unauthorized"
Check token trong StorageService:
```dart
final token = await StorageService.getToken();
print('Token: $token');
```

### Images không hiển thị
Check URL format:
```dart
final imageUrl = '${ApiConstants.uploadsUrl}/${imageName}';
// Should be: http://10.0.2.2:8089/uploads/uuid_image.jpg
```

### Comments không load
Check backend logs và response:
```dart
print('API Response: ${response.body}');
```

## 🚀 Testing

### Test Comment Creation
```dart
await CommentService.createComment(
  postId: '1',
  content: 'Test comment with very long content to test validation',
  rating: 5.0,
  imagePaths: ['/path/to/image1.jpg'],
);
```

### Test Pagination
```dart
// Page 1
await controller.loadComments('1', isRefresh: true);
// Page 2
await controller.loadMoreComments();
```

## 📝 Notes

- Comment list tự động refresh sau khi thêm comment mới
- Images được upload dưới dạng multipart/form-data
- Backend trả về full image path hoặc chỉ filename
- Frontend tự construct full URL từ `ApiConstants.uploadsUrl`
- Pagination bắt đầu từ page 1 (không phải 0)

## 🔐 Security

- Chỉ user đã đăng nhập mới tạo comment được
- User chỉ edit/delete comment của mình
- Public có thể xem tất cả comments
- Backend validate rating range (1-5)
- Backend limit image size và type

## 📚 References

- GetX Documentation: https://pub.dev/packages/get
- HTTP Multipart: https://pub.dev/packages/http
- Image Picker: https://pub.dev/packages/image_picker
