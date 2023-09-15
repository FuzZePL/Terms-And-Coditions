import 'package:donotnote/widgets/shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  void _onShimmerChange() {
    if (widget.isLoading) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final ShimmerState shimmer = Shimmer.of(context)!;
    if (!shimmer.isSized) {
      return const SizedBox();
    }
    final Size shimmerSize = shimmer.size;
    final LinearGradient gradient = shimmer.gradient;
    final Offset? offsetWithinShimmer = shimmer.getDescendantOffset(
        descendant: context.findRenderObject() as RenderBox?);

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            offsetWithinShimmer == null ? 0 : -offsetWithinShimmer.dx,
            offsetWithinShimmer == null ? 0 : -offsetWithinShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}
