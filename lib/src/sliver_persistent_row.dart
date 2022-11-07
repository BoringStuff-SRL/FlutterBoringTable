import 'package:flutter/widgets.dart';

class SliverPersistentRow extends SliverPersistentHeaderDelegate {
  const SliverPersistentRow({
    required this.child,
    required this.heigth,
  });

  final Widget child;
  final double heigth;

  @override
  double get maxExtent => heigth;

  @override
  double get minExtent => heigth;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;
}
