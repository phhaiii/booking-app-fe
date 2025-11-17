import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/image_strings.dart';
import 'dart:io';

class ProfileAvatar extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final bool isLoading;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ProfileAvatar({
    super.key,
    required this.imagePath,
    this.width = 80,
    this.height = 80,
    this.isLoading = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          // Avatar container
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: WColors.primary.withOpacity(0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: _buildAvatarImage(),
            ),
          ),

          // Loading overlay
          if (isLoading)
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),

          // Edit icon
          if (!isLoading)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: WColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Iconsax.camera,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage() {
    // Check if it's a file path (custom image)
    if (imagePath.isNotEmpty && !imagePath.startsWith('assets/')) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    }
    
    // Use asset image or default
    return Image.asset(
      imagePath.isNotEmpty ? imagePath : WImages.splash,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildDefaultAvatar();
      },
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: WColors.primary.withOpacity(0.1),
      child: Icon(
        Iconsax.user,
        size: width * 0.4,
        color: WColors.primary,
      ),
    );
  }
}