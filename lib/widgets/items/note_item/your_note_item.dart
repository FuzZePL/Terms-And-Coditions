import 'package:cached_network_image/cached_network_image.dart';
import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/models/note.dart';
import 'package:donotnote/screens/note_screen.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/widgets/morpheus/morpheus_page_route.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class YourNoteItem extends StatefulWidget {
  const YourNoteItem({
    Key? key,
    required this.note,
    required this.suffixIcon,
    required this.appUser,
    required this.i,
  }) : super(key: key);
  final Note note;
  final IconButton suffixIcon;
  final AppUser appUser;
  final int i;

  @override
  State<YourNoteItem> createState() => _YourNoteItemState();
}

class _YourNoteItemState extends State<YourNoteItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.fastOutSlowIn,
  );

  void _playAnimation() {
    Future.delayed(Duration(milliseconds: 50 + (100 * widget.i))).then((value) {
      _animationController.forward();
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
    final GlobalKey key = GlobalKey();
    final Size size = MediaQuery.of(context).size;
    final double defaultSize = SizeConfig.defaultSize!;
    final Note note = widget.note;

    return ScaleTransition(
      scale: _animation,
      child: InkWell(
        key: key,
        onTap: () {
          Navigator.push(
            context,
            MorpheusPageRoute(
              builder: (context) => NoteScreen(
                note: note,
                appUser: widget.appUser,
              ),
              parentKey: key,
            ),
          );
        },
        splashColor: KColors.kPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  height: defaultSize * 9,
                  width: defaultSize * 9,
                  imageUrl: note.pictures[0],
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  imageBuilder: (ctx, image) {
                    return Container(
                      height: defaultSize * 9,
                      width: defaultSize * 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        image: DecorationImage(image: image, fit: BoxFit.cover),
                      ),
                    );
                  },
                  progressIndicatorBuilder: (context, child, loadingProgress) {
                    return Container(
                      width: defaultSize * 9,
                      height: defaultSize * 9,
                      color: KColors.kPrimaryColor,
                      child: LoadingJumpingLine.circle(),
                    );
                  },
                ),
              ),
              SizedBox(
                width: defaultSize * 3.5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: defaultSize * 15,
                    child: Text(
                      note.name,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: KColors.kTextColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: defaultSize,
                  ),
                  SizedBox(
                    width: defaultSize * 15,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: note.description,
                        style: const TextStyle(
                          color: KColors.kTextColor,
                        ),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: defaultSize * 3,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: KColors.kPrimaryColor,
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: widget.suffixIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
