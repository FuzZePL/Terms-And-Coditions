import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/models/note.dart';
import 'package:donotnote/screens/note_screen.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/widgets/items/note_item/note_item_small.dart';
import 'package:donotnote/widgets/morpheus/morpheus_page_route.dart';
import 'package:flutter/material.dart';

class ItemCardNote extends StatefulWidget {
  const ItemCardNote({
    Key? key,
    required this.notes,
    required this.notesName,
    this.onSearch = '',
    required this.appUser,
  }) : super(key: key);
  final List<Note> notes;
  final String notesName;
  final String onSearch;
  final AppUser appUser;

  @override
  State<ItemCardNote> createState() => _ItemCardNoteState();
}

class _ItemCardNoteState extends State<ItemCardNote> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AppUser appUser = widget.appUser;
    final List<Note> notes = widget.notes;
    final String onSearch = widget.onSearch;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: size.width * 0.075,
            ),
            Text(
              onSearch.isNotEmpty
                  ? '${widget.notesName} ${Strings.for1} $onSearch'
                  : widget.notesName,
              style: const TextStyle(
                fontSize: 22,
                color: KColors.kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        SizedBox(
          height: size.height * 0.4,
          width: size.width,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: notes.isNotEmpty ? notes.length : 5,
              shrinkWrap: true,
              itemBuilder: (_, i) {
                bool isYourSchool = false;
                if (notes.length > i) {
                  if (appUser.school == notes[i].school) {
                    isYourSchool = true;
                  }
                }

                final GlobalKey key = GlobalKey();
                return NoteItemSmall(
                  key: key,
                  note: notes.length > i ? notes[i] : null,
                  isYourSchool: isYourSchool,
                  i: i,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).push(
                      MorpheusPageRoute(
                        builder: (ctx) {
                          return NoteScreen(
                            note: notes[i],
                            appUser: appUser,
                          );
                        },
                        parentKey: key,
                      ),
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}
