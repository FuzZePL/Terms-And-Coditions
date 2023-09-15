import 'package:donotnote/databases/favorite_database.dart';
import 'package:donotnote/models/note.dart';
import 'package:donotnote/widgets/items/note_item/your_note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';

class SavedScreen extends StatefulWidget {
  static const String routeName = '/saved-screen';
  const SavedScreen({
    Key? key,
    required this.user,
  }) : super(key: key);
  final AppUser user;

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Note> _notes = [];
  bool _isLoading = true;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _getFavorite();
  }

  void _getFavorite() async {
    List<String>? list = await SharedPref.readAllData();
    if (list != null) {
      _notes = await Server.getFavourite(list);
    }

    setState(() {
      _isLoading = false;
    });
  }

  /* Future refreshFavorite() async {
    setState(() {
      _isLoading = true;
    });

    _notes = [];
    for (Note element in notesSnap) {
      List<String> list = element.pictures.toString().split(', ');
      if (list.isNotEmpty) {
        _isSomeFavorite = true;
        List<String> listPictures = [];
        for (String element in list) {
          element = element.substring(1, element.length - 1);
          listPictures.add(element);
        }
        _notes.add(
          Note(
            id: element.id,
            name: element.name,
            description: element.description,
            pictures: listPictures,
            filter: element.filter,
            createdBy: element.createdBy,
            school: element.school,
          ),
        );
      } else {
        element.pictures = element.pictures
            .toString()
            .substring(1, element.pictures.toString().length - 1);
        _notes.add(
          Note(
            id: element.id,
            name: element.name,
            description: element.description,
            pictures: element.pictures,
            filter: element.filter,
            createdBy: element.createdBy,
            school: element.school,
          ),
        );
      }
    }
    if (_notes.isEmpty) {
      _isSomeFavorite = false;
    } else {
      _isSomeFavorite = true;
    }
    setState(() {
      _isLoading = false;
    });
  } */

  void _deleteItem(Note note) async {
    SharedPref.editData(note.id);
    _notes.remove(note);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final size = SizeConfig.defaultSize!;
    return Scaffold(
      backgroundColor: KColors.kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          Strings.saved,
          style: TextStyle(
            color: KColors.kWhiteColor,
          ),
        ),
        elevation: 2,
        backgroundColor: KColors.kPrimaryColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: KColors.kWhiteColor,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _notes.isNotEmpty
              ? AnimatedList(
                  key: listKey,
                  scrollDirection: Axis.vertical,
                  initialItemCount: _notes.length,
                  itemBuilder: (ctx, i, animation) {
                    return YourNoteItem(
                      note: _notes[i],
                      suffixIcon: IconButton(
                        onPressed: () {
                          _deleteItem(_notes[i]);
                        },
                        icon: const Icon(
                          Icons.delete_forever_outlined,
                          color: KColors.kErrorColor,
                          size: 34,
                        ),
                      ),
                      appUser: widget.user,
                      i: i,
                    );
                  },
                )
              : Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/favorite.png',
                        width: size * 50,
                        height: size * 16,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        Strings.youDontFavorite,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: KColors.kTextColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
