import 'package:donotnote/databases/school_data.dart';
import 'package:donotnote/databases/subject_type.dart';
import 'package:donotnote/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TextFieldWithSuggestions extends StatefulWidget {
  const TextFieldWithSuggestions({
    Key? key,
    required this.onChange,
    required this.text,
    this.onAdd,
  }) : super(key: key);
  final void Function(String school) onChange;
  final String text;
  final void Function(String text)? onAdd;

  @override
  State<TextFieldWithSuggestions> createState() =>
      _TextFieldWithSuggestionsState();
}

class _TextFieldWithSuggestionsState extends State<TextFieldWithSuggestions> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _controller,
          autofocus: false,
          style: const TextStyle(color: KColors.kWhiteColor),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.text,
            hintStyle: const TextStyle(color: KColors.kTextColor),
            icon: const Icon(
              Icons.school_outlined,
              color: KColors.kTextColor,
            ),
            suffixIcon: widget.onAdd == null
                ? null
                : IconButton(
                    onPressed: () {
                      widget.onAdd!(widget.text);
                    },
                    icon: const Icon(
                      Icons.add_rounded,
                      color: KColors.kTextColor,
                      size: 28,
                    ),
                  ),
          ),
        ),
        suggestionsCallback: (pattern) async {
          if (widget.onAdd == null) {
            return await BackendService.getSuggestions(pattern);
          }
          return await SubjectType.getSuggestions(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(
              suggestion.toString(),
              style: const TextStyle(color: KColors.kWhiteColor),
            ),
            tileColor: KColors.kBackgroundColor.withOpacity(0.85),
          );
        },
        onSuggestionSelected: (suggestion) {
          _controller.clear();
          widget.onChange(suggestion.toString());
        },
      ),
    );
  }
}
