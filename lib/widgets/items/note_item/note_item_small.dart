import 'package:cached_network_image/cached_network_image.dart';
import 'package:donotnote/models/note.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/widgets/shimmer/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class NoteItemSmall extends StatefulWidget {
  const NoteItemSmall({
    Key? key,
    required this.isYourSchool,
    required this.note,
    required this.onTap,
    required this.i,
  }) : super(key: key);
  final Note? note;
  final bool isYourSchool;
  final VoidCallback onTap;
  final int i;

  @override
  State<NoteItemSmall> createState() => _NoteItemSmallState();
}

class _NoteItemSmallState extends State<NoteItemSmall>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.fastOutSlowIn,
  );

  void _playAnimation() {
    Future.delayed(Duration(milliseconds: (15 * widget.i))).then((value) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _playAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Note? note = widget.note;
    final double height = size.height * 0.3;
    final double width = size.width * 0.52;
    const double heightText = 45;
    Widget image = SizedBox(
      height: height,
      width: width,
    );

    if (note != null) {
      image = CachedNetworkImage(
        imageUrl: note.pictures[0],
        alignment: Alignment.center,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        height: height,
        width: width,
        errorWidget: (context, error, stackTrace) {
          return const Text(
            Strings.errorWhileLoadingImage,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          );
        },
        progressIndicatorBuilder: (context, child, loadingProgress) {
          return Container(
            width: width,
            height: height,
            color: KColors.kPrimaryColor,
            child: LoadingJumpingLine.circle(),
          );
        },
      );
    }

    return note != null && mounted
        ? ScaleTransition(
            scale: _animation,
            child: Container(
              height: height + heightText + 12,
              width: width,
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              color: KColors.kBackgroundColor,
              child: GestureDetector(
                onTap: widget.onTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: KColors.kShadowColor,
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset.zero,
                              ),
                            ],
                          ),
                          child: Hero(
                            tag: note.id,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: image,
                            ),
                          ),
                        ),
                        if (widget.isYourSchool)
                          const Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              children: [
                                ItemInImage(
                                  child: Icon(
                                    Icons.school_rounded,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: width,
                      height: heightText,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: KColors.kPrimaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.8,
                                child: Text(
                                  note.name,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: KColors.kTextColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontSize: 18,
                                    fontFamily: 'Gramatika',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : ShimmerLoading(
            isLoading: true,
            child: Container(
              height: height + heightText + 12,
              width: width,
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          );
  }
}

class ItemInImage extends StatelessWidget {
  const ItemInImage({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 45,
      height: 45,
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: KColors.kShadowColor,
            spreadRadius: 0.2,
            blurRadius: 4,
            offset: Offset.zero,
          )
        ],
      ),
      child: child,
    );
  }
}
