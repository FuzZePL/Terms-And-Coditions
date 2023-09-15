import 'package:donotnote/models/note.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:flutter/material.dart';

class AdminNoteItem extends StatelessWidget {
  const AdminNoteItem({
    Key? key,
    required this.note,
    required this.delete,
    required this.pos,
    required this.username,
    required this.dismiss,
  }) : super(key: key);
  final Note note;
  final void Function(Note note, int pos) delete;
  final void Function(Note note, int pos) dismiss;
  final int pos;
  final String username;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double defaultSize = SizeConfig.defaultSize!;
    final uri = note.pictures[0];

    return GestureDetector(
      /* onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteScreen(
              note: note,
              username: username,
              isLiked: false,
              isYourNote: false,
            ),
          ),
        );
      }, */
      child: Container(
        padding: const EdgeInsets.all(10),
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: defaultSize * 9,
              width: defaultSize * 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: defaultSize * 0.5,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(uri),
                ),
              ),
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
                      color: Colors.black,
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
                        color: Colors.black54,
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
            IconButton(
              onPressed: () {
                delete(note, pos);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 34,
              ),
            ),
            SizedBox(
              width: defaultSize * 3,
            ),
            IconButton(
              onPressed: () {
                dismiss(note, pos);
              },
              icon: const Icon(
                Icons.done,
                color: Colors.green,
                size: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
