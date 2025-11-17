import 'package:booking_app/features/controller/detailvenue_controller.dart';
import 'package:booking_app/model/commentmodel.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ReviewsSection extends StatelessWidget {
  final DetailVenueController controller;
  final VoidCallback onShowAllComments;
  final String? venueId;

  const ReviewsSection({
    super.key,
    required this.controller,
    required this.onShowAllComments,
    this.venueId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đánh giá và nhận xét',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: onShowAllComments,
                style: TextButton.styleFrom(
                  foregroundColor: WColors.primary,
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Đánh giá'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingComments.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: WColors.primary),
                ),
              );
            }

            if (controller.comments.isEmpty) {
              return EmptyReviewsWidget(
                onWriteReview: onShowAllComments,
              );
            }

            return Column(
              children: [
                ...controller.comments
                    .take(3)
                    .map((comment) => ReviewCard(comment: comment)),
                if (controller.comments.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: OutlinedButton(
                      onPressed: onShowAllComments,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: WColors.primary,
                        side: const BorderSide(color: WColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Xem thêm ${controller.comments.length - 3} đánh giá',
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class EmptyReviewsWidget extends StatelessWidget {
  final VoidCallback onWriteReview;

  const EmptyReviewsWidget({
    super.key,
    required this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Iconsax.star, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Chưa có đánh giá nào',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hãy là người đầu tiên đánh giá!',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onWriteReview,
            icon: const Icon(Iconsax.edit, size: 18),
            label: const Text('Viết đánh giá'),
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Comment comment;

  const ReviewCard({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
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
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      comment.formattedDate,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < comment.rating.floor() ? Iconsax.star5 : Iconsax.star,
                size: 14,
                color: Colors.orange,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (comment.images?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: comment.images!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        comment.images![index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, size: 32),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
