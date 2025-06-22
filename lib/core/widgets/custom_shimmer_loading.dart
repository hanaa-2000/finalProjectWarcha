import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerLoadingContainer extends StatelessWidget {
  final double height;
  final double width;
  const CustomShimmerLoadingContainer(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.withValues(alpha: .1),
        highlightColor: Colors.white,
        child: Container(
          height: height,
          width: width,
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24), color: Colors.white),
        ));
  }
}
