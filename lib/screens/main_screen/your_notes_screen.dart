import 'package:donotnote/models/note.dart';
import 'package:donotnote/screens/add_note_screen/add_note_screen.dart';
import 'package:donotnote/widgets/items/note_item/your_note_item.dart';
import 'package:donotnote/widgets/morpheus/morpheus_page_route.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';

class YourNotesScreen extends StatefulWidget {
  final AppUser user;
  const YourNotesScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<YourNotesScreen> createState() => YourNoteScreenState();
}

class YourNoteScreenState extends State<YourNotesScreen>
    with AutomaticKeepAliveClientMixin {
  final double _defaultSize = SizeConfig.defaultSize!;
  List<Note>? _noteList;

  void _editItem(Note note) {
    Navigator.of(context).push(
      MorpheusPageRoute(
        builder: (ctx) {
          return AddNoteScreen(
            appUser: widget.user,
            onCreate: (note) {},
            note: note,
            deleteNote: _removeItem,
            editNote: _editNote,
          );
        },
      ),
    );
  }

  void _editNote(Note note) {
    if (_noteList != null) {
      int? i = _noteList?.indexWhere((element) => element.id == note.id);
      if (i != null) {
        _noteList?.removeAt(i);
        _noteList?.insert(i, note);
      }
    }
    setState(() {});
  }

  void _removeItem(Note note) {
    Server.deleteItemsFromDatabase(note).then((value) {
      _noteList!.remove(note);
      Navigator.of(context).pop();
      setState(() {});
    });
  }

  void _reset(Note note) async {
    _noteList!.add(note);
    setState(() {});
  }

  void _getData(AppUser user) async {
    _noteList = await Server.getUserNotes(user);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getData(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AppUser user = widget.user;
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: KColors.kPrimaryColor,
          title: const Text(
            Strings.yourNotes,
            style: TextStyle(
              color: KColors.kWhiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: KColors.kBackgroundColor,
        body: _noteList != null
            ? Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: CustomShape(),
                      child: Container(
                        height: _defaultSize * 16,
                        color: KColors.kPrimaryColor,
                      ),
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _noteList!.length,
                      itemBuilder: (ctx, i) {
                        return YourNoteItem(
                          note: _noteList![i],
                          suffixIcon: IconButton(
                            onPressed: () {
                              _editItem(_noteList![i]);
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: KColors.kButtonColorGreen,
                              size: 34,
                            ),
                          ),
                          i: i,
                          appUser: user,
                        );
                      },
                    ),
                  ],
                ),
              )
            : Container(
                width: size.width,
                height: size.height,
                alignment: Alignment.center,
                child: LoadingJumpingLine.circle(
                    backgroundColor: KColors.kButtonColorPurple),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => AddNoteScreen(
                  appUser: user,
                  onCreate: _reset,
                ),
              ),
            );
          },
          backgroundColor: KColors.kButtonColorGreen,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 15);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
