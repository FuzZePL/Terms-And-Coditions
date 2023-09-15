import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;
  final bool isNetwork;
  final double height;
  final BuildContext contextF;
  final bool fullscreen;
  const ImageSwipe({
    Key? key,
    required this.imageList,
    required this.isNetwork,
    required this.height,
    required this.contextF,
    this.fullscreen = false,
  }) : super(key: key);

  @override
  State<ImageSwipe> createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectedPage = 0;
  late TransformationController _controller;
  TapDownDetails? _tapDownDetails;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> imageList = widget.imageList;
    final bool fullscreen = widget.fullscreen;
    final double height = widget.height;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          PageView(
            physics: _isZoomed
                ? const NeverScrollableScrollPhysics()
                : const ScrollPhysics(),
            onPageChanged: (val) {
              setState(() {
                _selectedPage = val;
              });
            },
            children: [
              if (imageList.isEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/icons/image_placeholder.png'),
                ),
              for (int i = 0; i < imageList.length; i++)
                Container(
                  child: widget.isNetwork
                      ? ClipRRect(
                          borderRadius: fullscreen
                              ? BorderRadius.circular(0)
                              : BorderRadius.circular(16),
                          child: fullscreen
                              ? GestureDetector(
                                  onDoubleTapDown: (details) {
                                    setState(() {
                                      _isZoomed = !_isZoomed;
                                    });
                                    _tapDownDetails = details;
                                  },
                                  onDoubleTap: () {
                                    final Offset position =
                                        _tapDownDetails!.localPosition;
                                    const double scale = 3;
                                    final double x = -position.dx * (scale - 1);
                                    final double y = -position.dy * (scale - 1);
                                    final zoomed = Matrix4.identity()
                                      ..translate(x, y)
                                      ..scale(scale);

                                    final Matrix4 value =
                                        _controller.value.isIdentity()
                                            ? zoomed
                                            : Matrix4.identity();
                                    _controller.value = value;
                                  },
                                  child: InteractiveViewer(
                                    clipBehavior: Clip.none,
                                    panEnabled: true,
                                    onInteractionStart: (details) {
                                      setState(() {
                                        _isZoomed = !_isZoomed;
                                      });
                                    },
                                    transformationController: _controller,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: ShowImage(
                                        imageList: imageList,
                                        i: i,
                                        boxFit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : ShowImage(
                                  imageList: imageList,
                                  i: i,
                                  boxFit: BoxFit.cover,
                                ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            imageList[i],
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
            ],
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(30),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: fullscreen ? 20 : height * 0.2,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < imageList.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    width: _selectedPage == i ? 25 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage({
    Key? key,
    required this.imageList,
    required this.i,
    required this.boxFit,
  }) : super(key: key);

  final List imageList;
  final int i;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageList[i],
      fit: boxFit,
      errorBuilder: (context, error, stackTrace) {
        return const Text(Strings.errorWhileLoadingImage);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: LoadingJumpingLine.circle(),
        );
      },
    );
  }
}
