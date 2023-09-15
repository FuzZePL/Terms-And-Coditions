import 'dart:io';
import 'package:donotnote/values/colors.dart';
import 'package:flutter/material.dart';

class ScrollImagePicker extends StatefulWidget {
  const ScrollImagePicker({
    super.key,
    required this.size,
    required this.imageList,
    required this.getImage,
    required this.swapImage,
  });
  final Size size;
  final List<dynamic> imageList;
  final Function(int) getImage;
  final Function(int, int) swapImage;

  @override
  State<ScrollImagePicker> createState() => _ScrollCenterWidgetState();
}

class _ScrollCenterWidgetState extends State<ScrollImagePicker> {
  final ScrollController _scrollController = ScrollController();
  final PageController _controller =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 0.85);

  @override
  Widget build(BuildContext context) {
    final Size size = widget.size;
    final List<dynamic> imageList = widget.imageList;
    final PageView pageView = PageView.builder(
      onPageChanged: (page) {},
      controller: _controller,
      scrollDirection: Axis.horizontal,
      allowImplicitScrolling: true,
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: size.width * 0.9,
              height: size.height * 0.4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageList[index] == null)
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        widget.getImage(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: KColors.kShadowColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            width: 2,
                            color: KColors.kPrimaryColor,
                          ),
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 69,
                          color: KColors.kBackgroundColor,
                        ),
                      ),
                    )
                  else
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: imageList[index] is File
                              ? Image.file(
                                  imageList[index],
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.center,
                                )
                              : Image.network(
                                  imageList[index],
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.center,
                                ),
                        ),
                        Positioned(
                          right: 20,
                          top: 30,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      KColors.kPrimaryColor.withOpacity(0.75),
                                ),
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    widget.getImage(index);
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 24,
                                    color: KColors.kWhiteColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (index != 0)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        KColors.kPrimaryColor.withOpacity(0.6),
                                  ),
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    onPressed: () {
                                      widget.swapImage(index, index - 1);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_upward_rounded,
                                      size: 24,
                                      color: KColors.kWhiteColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
    return SizedBox(
      child: pageView,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    const int itemCount = 50;
    const int centerIndex = itemCount ~/ 2;
    const double itemExtent = 80.0;

    const double offsetToCenter = (centerIndex * itemExtent) - (itemExtent * 2);
    _scrollController.jumpTo(offsetToCenter);
  }
}
