import 'package:cached_network_image/cached_network_image.dart';
import 'package:donotnote/models/note.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/widgets/shimmer/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class NoteItemMain extends StatefulWidget {
  const NoteItemMain({
    super.key,
    required this.note,
    required this.isYourSchool,
    required this.onTap,
    required this.size,
    required this.i,
  });
  final Note? note;
  final bool isYourSchool;
  final void Function(Note) onTap;
  final Size size;
  final int i;

  @override
  State<NoteItemMain> createState() => _NoteItemMainState();
}

class _NoteItemMainState extends State<NoteItemMain>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.fastOutSlowIn,
  );

  void _playAnimation() {
    Future.delayed(Duration(milliseconds: 50 + (100 * widget.i))).then((value) {
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
      duration: const Duration(milliseconds: 1000),
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
    final Size size = widget.size;
    final double width = size.width;
    final double height = size.height * 0.2;
    final Note? note = widget.note;
    return note != null
        ? ScaleTransition(
            scale: _animation,
            child: GestureDetector(
              onTap: () {
                widget.onTap(note);
              },
              child: Container(
                width: width,
                height: height,
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    ConstantFunctions.defaultLightShadow(),
                  ],
                  color: KColors.kPrimaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: note.id,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: note.pictures[0],
                          fit: BoxFit.cover,
                          height: height,
                          width: width * 0.5,
                          filterQuality: FilterQuality.medium,
                          progressIndicatorBuilder:
                              (context, child, loadingProgress) {
                            return Container(
                              width: size.width * 0.65,
                              height: size.height * 0.33,
                              color: KColors.kPrimaryColor,
                              child: LoadingJumpingLine.circle(),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              width: width * 0.4,
                              child: Text(
                                note.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: KColors.kTextColor,
                                ),
                                softWrap: true,
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
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
              width: width,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
  }
}
