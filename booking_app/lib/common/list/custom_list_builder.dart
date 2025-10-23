import 'package:flutter/material.dart';
import 'package:booking_app/common/list/custom_list_item.dart';

class ListItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  ListItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}

class CustomListBuilder extends StatelessWidget {
  final List<ListItemData> items;
  final EdgeInsets? padding;
  final double spacing;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const CustomListBuilder({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 12,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final item = items[index];
        return CustomListItem(
          icon: item.icon,
          title: item.title,
          subtitle: item.subtitle,
          color: item.color,
          onTap: item.onTap,
        );
      },
    );
  }
}