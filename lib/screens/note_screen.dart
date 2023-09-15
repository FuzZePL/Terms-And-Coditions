import 'package:donotnote/databases/favorite_database.dart';
import 'package:donotnote/models/note.dart';
import 'package:donotnote/widgets/buttons/on_back_pressed.dart';
import 'package:donotnote/widgets/buttons/options_item.dart';
import 'package:donotnote/widgets/buttons/outline_button.dart';
import 'package:donotnote/widgets/others/image_swipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  final AppUser appUser;
  const NoteScreen({
    Key? key,
    required this.note,
    required this.appUser,
  }) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final double _defaultSize = SizeConfig.defaultSize!;
  bool _isLiked = false;
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await Future.delayed(const Duration(milliseconds: 500));
        await _checkIsLiked();
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }

  Future<void> _checkIsLiked() async {
    if (await SharedPref.hasData(widget.note.id)) {
      _isLiked = true;
    } else {
      _isLiked = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

/*   void _onDownload(Note note) async {
    dynamic pictures = note.pictures;
    for (int i = 0; i < pictures.length; i++) {
      Response response = await Dio()
          .get(pictures[i], options: Options(responseType: ResponseType.bytes));
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
          quality: 100, name: note.name);
    }
    ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
        KColors.kWhiteColor, Strings.imageDownloaded);
  } */

  void _copyToClipBoard(Note note) async {
    Clipboard.setData(ClipboardData(text: note.id)).then((value) {
      ConstantFunctions.showSnackBar(
          context, KColors.kErrorColor, KColors.kWhiteColor, Strings.idCopied);
    });
  }

  void _reportNote(Note note) async {
    FocusScope.of(context).unfocus();
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (ctx, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: _defaultSize * 20,
            width: _defaultSize * 38,
            decoration: BoxDecoration(
              color: KColors.kBackgroundColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: _defaultSize * 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Text(
                      '${Strings.areYouSureToReport} ${note.name}?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: KColors.kTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _defaultSize * 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlineButtonOwn(
                          defaultSize: _defaultSize,
                          onTap: () {
                            Navigator.of(ctx).pop();
                          },
                          text: Strings.no,
                          icon: Icons.not_interested_rounded,
                          width: _defaultSize * 15,
                        ),
                        SizedBox(
                          width: _defaultSize * 3,
                        ),
                        OutlineButtonOwn(
                          defaultSize: _defaultSize,
                          onTap: () async {
                            await Server.reportNote(note).then((value) {
                              Navigator.of(ctx).pop();
                              ConstantFunctions.showSnackBar(
                                  context,
                                  KColors.kErrorColor,
                                  KColors.kWhiteColor,
                                  Strings.noteReported);
                            });
                          },
                          text: Strings.yes,
                          icon: Icons.done,
                          width: _defaultSize * 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, -0.06),
          ).animate(anim),
          child: child,
        );
      },
    );
  }

  Future<bool> _onLikeButtonTapped(bool isLiked) async {
    final Note note = widget.note;
    if (!isLiked) {
      SharedPref.writeData(note.id);
    } else {
      SharedPref.editData(note.id);
    }
    return !isLiked;
  }

  bool _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Note note = widget.note;
    final AppUser creator = note.createdBy;

    return _isLoading
        ? Scaffold(
            backgroundColor: KColors.kBackgroundColor,
            body: Container(
              width: size.width,
              height: size.height,
              alignment: Alignment.center,
              child: SizedBox(
                width: size.width * 0.12,
                height: size.width * 0.12,
                child: const CircularProgressIndicator(
                  color: KColors.kButtonColorGreen,
                  strokeWidth: 5,
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: KColors.kBackgroundColor,
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                children: [
                  Hero(
                    tag: note.id,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: size.width,
                      height: _isFullScreen ? size.height : size.height * 0.55,
                      child: Stack(
                        children: [
                          ImageSwipe(
                            imageList: note.pictures,
                            isNetwork: true,
                            height: _isFullScreen
                                ? size.height
                                : size.height * 0.55,
                            contextF: context,
                            fullscreen: _isFullScreen,
                          ),
                          Positioned(
                            left: 20,
                            top: 20,
                            child: SafeArea(
                              child: OnBackPressed(
                                icon: Icons.arrow_back_ios_new_rounded,
                                onBackPressed: () {
                                  if (_isFullScreen) {
                                    setState(() {
                                      _isFullScreen = false;
                                    });
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    bottom: _isFullScreen ? -size.height : 0,
                    child: Container(
                      height: size.height * 0.52,
                      width: size.width,
                      decoration: const BoxDecoration(
                        color: KColors.kPrimaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: _defaultSize * 3,
                              ),
                              SizedBox(
                                width: size.width,
                                child: Text(
                                  note.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 27,
                                    color: KColors.kTextColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: _defaultSize,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                width: size.width * 0.7,
                                child: SizedBox(
                                  child: Text(
                                    note.description,
                                    style: const TextStyle(
                                      color: KColors.kTextColor,
                                      fontSize: 15.4,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: _defaultSize * 3,
                              ),
                              SizedBox(
                                width: size.width,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      Strings.subject,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: KColors.kTextColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount:
                                            note.filter.listOfType.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (_, i) {
                                          return TextListWidget(
                                              text: note.filter.listOfType[i]);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: _defaultSize * 2,
                              ),
                              SizedBox(
                                width: size.width,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      Strings.level,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: KColors.kTextColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: note.filter.level.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (_, i) {
                                          return TextListWidget(
                                              text: note.filter.level[i]);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: _defaultSize * 3,
                              ),
                              Container(
                                width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: KColors.kPrimaryColor,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: KColors.kBlackColor,
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: Offset.zero,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 3),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.topCenter,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            creator.image,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.6,
                                          child: Text(
                                            creator.username,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: KColors.kButtonColorGreen,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.6,
                                          child: Text(
                                            creator.school.toString(),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.clip,
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
                    ),
                  ),
                  if (!_isFullScreen)
                    Positioned(
                      bottom: 0,
                      top: -20,
                      left: 15,
                      right: 15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width * 0.42,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                OptionsItem(
                                  onClick: () {
                                    _copyToClipBoard(note);
                                  },
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    size: 32,
                                    color: KColors.kButtonColorBlue,
                                  ),
                                  i: 0,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                OptionsItem(
                                  onClick: () {
                                    _onLikeButtonTapped(!_isLiked);
                                  },
                                  icon: LikeButton(
                                    isLiked: _isLiked,
                                    onTap: _onLikeButtonTapped,
                                    size: 32,
                                    padding: const EdgeInsets.only(left: 3.5),
                                    circleColor: const CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc),
                                    ),
                                    likeBuilder: (bool isLiked) {
                                      _isLiked = isLiked;
                                      if (!isLiked) {
                                        return const Icon(
                                          Icons.favorite_outline,
                                          color: KColors.kButtonColorPurple,
                                          size: 32,
                                        );
                                      } else {
                                        return const Icon(
                                          Icons.favorite,
                                          color: KColors.kButtonColorPurple,
                                          size: 32,
                                        );
                                      }
                                    },
                                  ),
                                  i: 1,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.42,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OptionsItem(
                                  onClick: () {
                                    setState(() {
                                      _isFullScreen = true;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.aspect_ratio_rounded,
                                    size: 32,
                                    color: KColors.kButtonColorGreen,
                                  ),
                                  i: 2,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                OptionsItem(
                                  onClick: () {
                                    _reportNote(note);
                                  },
                                  icon: const Icon(
                                    Icons.report_outlined,
                                    color: KColors.kButtonColorYellow,
                                    size: 32,
                                  ),
                                  i: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
  }

  getApplicationDocumentDirectory() {}
}

class TextListWidget extends StatelessWidget {
  const TextListWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: KColors.kButtonColorGreen,
        boxShadow: const [
          BoxShadow(
            color: KColors.kBlackColor,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset.zero,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: KColors.kTextColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

  /* void _showCommentsSheet(BuildContext context, double width, double height) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String comment = '';
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: KColors.kBackgroundColor,
      builder: (context) {
        return Container(
          alignment: Alignment.topCenter,
          height: height * 0.75,
          child: Column(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Form(
                    key: formKey,
                    child: RoundedInputField(
                      hintText: 'Twój Komentarz',
                      icon: Icons.comment,
                      onChanged: (value) {
                        formKey.currentState!.validate();
                      },
                      type: 'Comment',
                      onSaved: (value) {
                        if (value != null) {
                          comment = value;
                        }
                      },
                      controller: _controller,
                      textInputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      isPassword: false,
                      limit: 150,
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                margin: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                ),
                child: CommentColumn(
                  commentList: _comments,
                ),
              ),
            ],
          ),
        );
      },
    );
  } */

/*   void _addComment(String comment) async {
    if (_comments.length < 15) {
      final String noteId = widget.note.id;
      final String dateTime = DateTime.now().toString();
      final User? user = FirebaseAuth.instance.currentUser;
      bool isAlready = false;
      for (int i = 0; i < _comments.length; i++) {
        if (_comments[i].createdBy == user!.uid) {
          isAlready = true;
        }
      }
      if (!isAlready) {
        Comment cmnt = Comment(
          UniqueKey().toString(),
          user!.uid,
          widget.appUser.username,
          comment,
        );
        await Server.createComment(noteId, dateTime, cmnt, _comments.length);
        _comments.add(cmnt);
      } else {
        Navigator.of(context).pop();
        ConstantFunctions.showSnackBar(
          context,
          KColors.kErrorColor,
          KColors.kWhiteColor,
          Strings.youCantComment2Time,
        );
      }
    } else {
      ConstantFunctions.showSnackBar(
        context,
        KColors.kErrorColor,
        KColors.kWhiteColor,
        Strings.youCantMoreComment15,
      );
    }

    _controller.clear();

    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {});
  }

  void _getComments() async {
    try {
      _comments = await Server.getComment(widget.note.id);
    } catch (e) {
      print(e);
    }
  } */