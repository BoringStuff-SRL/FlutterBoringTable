import 'package:flutter/widgets.dart';

class SliverPersistentRow extends SliverPersistentHeaderDelegate {
  const SliverPersistentRow({
    required this.child,
    required this.height,
  });

  final Widget child;
  final double height;

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;
}
