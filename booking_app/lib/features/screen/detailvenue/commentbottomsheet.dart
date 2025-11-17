import 'package:booking_app/model/commentmodel.dart';
import 'package:booking_app/service/comment_service.dart';
import 'package:booking_app/service/api_constants.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CommentBottomSheet extends StatefulWidget {
  final String venueId;
  final Function(String content, double rating, List<String>? imagePaths)
      onCommentAdded;

  const CommentBottomSheet({
    super.key,
    required this.venueId,
    required this.onCommentAdded,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  double _rating = 5.0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Submit comment
  Future<void> _submitComment() async {
    final content = _commentController.text.trim();

    // Validation
    if (content.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng nhập nội dung đánh giá',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.warning, color: Colors.red),
      );
      return;
    }

    if (content.length < 10) {
      Get.snackbar(
        'Lỗi',
        'Nội dung đánh giá phải có ít nhất 10 ký tự',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Call API to create comment
      await CommentService.createComment(
        postId: widget.venueId,
        content: content,
        rating: _rating,
      );

      // Call the callback to refresh comments list
      widget.onCommentAdded(content, _rating, null);

      // Close bottom sheet
      Get.back();

      // Show success message
      Get.snackbar(
        'Thành công',
        'Đánh giá của bạn đã được gửi',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.green),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      // Extract clean error message
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }

      // Determine icon and color based on error type
      IconData errorIcon = Icons.error_outline;
      Color bgColor = Colors.red.shade100;
      Color textColor = Colors.red.shade900;

      if (errorMessage.contains('đã đánh giá') || 
          errorMessage.contains('already commented')) {
        errorIcon = Icons.info_outline;
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
      }

      Get.snackbar(
        errorMessage.contains('đã đánh giá') ? 'Thông báo' : 'Lỗi',
        errorMessage,
        backgroundColor: bgColor,
        colorText: textColor,
        snackPosition: SnackPosition.TOP,
        icon: Icon(errorIcon, color: textColor.withOpacity(0.8)),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Viết đánh giá',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: WColors.primary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Chia sẻ trải nghiệm của bạn',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating section
                  _buildRatingSection(),
                  const SizedBox(height: 24),

                  // Comment input
                  _buildCommentInput(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Submit button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Gửi đánh giá',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Rating section widget
  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            WColors.primary.withOpacity(0.1),
            WColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: WColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đánh giá của bạn',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: WColors.primary,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Star rating
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = (index + 1).toDouble();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < _rating ? Iconsax.star1 : Iconsax.star,
                        size: 32,
                        color: index < _rating
                            ? Colors.amber
                            : Colors.grey.shade400,
                      ),
                    ),
                  );
                }),
              ),
              // Rating text
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: WColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_rating.toStringAsFixed(1)}/5',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getRatingText(_rating),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Comment input widget
  Widget _buildCommentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nội dung đánh giá',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _commentController,
          maxLines: 6,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: 'Chia sẻ trải nghiệm của bạn về venue này...\n\n'
                'Ví dụ: Không gian rộng rãi, thoáng mát, nhân viên nhiệt tình...',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
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
            contentPadding: const EdgeInsets.all(16),
            counterStyle: TextStyle(color: Colors.grey.shade600),
          ),
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }

  // Get rating text based on rating value
  String _getRatingText(double rating) {
    if (rating >= 5.0) {
      return 'Tuyệt vời! Bạn rất hài lòng với venue này';
    } else if (rating >= 4.0) {
      return 'Rất tốt! Bạn khá hài lòng với venue này';
    } else if (rating >= 3.0) {
      return 'Tốt! Venue này đáp ứng được mong đợi';
    } else if (rating >= 2.0) {
      return 'Trung bình! Còn nhiều điều cần cải thiện';
    } else {
      return 'Không hài lòng! Venue cần cải thiện nhiều';
    }
  }
}

// SỬA: Comment List Bottom Sheet (để xem tất cả comments)
class CommentsListBottomSheet extends StatelessWidget {
  final String venueId;
  final List<Comment> comments;
  final VoidCallback? onWriteReview;

  const CommentsListBottomSheet({
    super.key,
    required this.venueId,
    required this.comments,
    this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tất cả đánh giá',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: WColors.primary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${comments.length} đánh giá',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
                if (onWriteReview != null)
                  TextButton.icon(
                    onPressed: onWriteReview,
                    icon: const Icon(Iconsax.edit, size: 18),
                    label: const Text('Viết đánh giá'),
                    style: TextButton.styleFrom(
                      foregroundColor: WColors.primary,
                    ),
                  ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Comments list
          Expanded(
            child: comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.message,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Chưa có đánh giá nào',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (onWriteReview != null)
                          TextButton(
                            onPressed: onWriteReview,
                            child:
                                const Text('Hãy là người đầu tiên đánh giá!'),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return _buildCommentCard(comment);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and rating
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: WColors.primary.withOpacity(0.1),
                backgroundImage: comment.userAvatar?.isNotEmpty == true
                    ? NetworkImage(comment.userAvatar!)
                    : null,
                child: comment.userAvatar?.isEmpty != false
                    ? Text(
                        comment.userName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: WColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            comment.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (comment.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  size: 12,
                                  color: Colors.green.shade700,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Đã xác thực',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Star rating
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < comment.rating.floor()
                                  ? Iconsax.star1
                                  : Iconsax.star,
                              size: 14,
                              color: Colors.amber,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          comment.formattedDate,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Comment content
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),

          // Images with null safety
          if (comment.images?.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: comment.images!.length,
                itemBuilder: (context, index) {
                  final imageUrl =
                      '${ApiConstants.uploadsUrl}/${comment.images![index]}';
                  return GestureDetector(
                    onTap: () {
                      // Show full screen image
                      _showFullScreenImage(comment.images!, index);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Helpful button
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  // Mark as helpful functionality
                },
                icon: const Icon(
                  Iconsax.like_1,
                  size: 16,
                ),
                label: Text(
                  'Hữu ích${comment.helpfulCount > 0 ? ' (${comment.helpfulCount})' : ''}',
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(List<String> images, int initialIndex) {
    Get.to(
      () => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            '${initialIndex + 1}/${images.length}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: PageView.builder(
          controller: PageController(initialPage: initialIndex),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return InteractiveViewer(
              child: Center(
                child: Image.network(
                  images[index],
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 64,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      fullscreenDialog: true,
    );
  }
}
