import 'dart:io';
import 'package:donotnote/databases/subject_type.dart';
import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/models/filter.dart';
import 'package:donotnote/models/note.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';
import 'package:donotnote/widgets/buttons/default_button.dart';
import 'package:donotnote/widgets/buttons/outline_button.dart';
import 'package:donotnote/widgets/items/filter_item.dart';
import 'package:donotnote/widgets/others/three_scroll_widget.dart';
import 'package:donotnote/widgets/pickers/image_picker.dart';
import 'package:donotnote/widgets/pickers/scroll_image_picker.dart';
import 'package:donotnote/widgets/text_fields/rounded_input_field.dart';
import 'package:donotnote/widgets/text_fields/text_field_with_suggestions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNoteScreen extends StatefulWidget {
  static const routeName = '/add-note-detail-screen';

  const AddNoteScreen({
    Key? key,
    required this.appUser,
    required this.onCreate,
    this.note,
    this.deleteNote,
    this.editNote,
  }) : super(key: key);
  final AppUser appUser;
  final void Function(Note note) onCreate;
  final void Function(Note note)? deleteNote;
  final void Function(Note note)? editNote;
  final Note? note;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final double _defaultSize = SizeConfig.defaultSize!;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<dynamic> _imageList = [null, null, null, null];
  final List<dynamic> _copyImageList = [null, null, null, null];
  FilterOwn _filterOwn = FilterOwn(
    UniqueKey().toString(),
    [],
    false,
    '',
    '',
  );
  final ValueNotifier<int> _toUpdate = ValueNotifier(0);
  final ValueNotifier<int> _toUpdate2 = ValueNotifier(0);

  void _deleteItem(Note note) async {
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
                      '${Strings.areYouSureToDelete} ${note.name}?',
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
                          onTap: () {
                            widget.deleteNote!(note);
                            Navigator.of(ctx).pop();
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

  void _getImage(int pos) async {
    List<File> helper = await Pickers.showCustomDialog(context, _defaultSize);
    if (helper.length == 1) {
      _imageList[pos] = helper[0];
    } else {
      int x = pos;
      for (File element in helper) {
        _imageList[x] = element;
        x++;
        if (x > 3) {
          break;
        }
      }
    }
    setState(() {});
  }

  // i think that its working now
  void _editNote(BuildContext context) async {
    final bool isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    final Note previousNote = widget.note!;

    if (isValid &&
        _descriptionController.text.isNotEmpty &&
        _titleController.text.isNotEmpty &&
        _filterOwn.level.isNotEmpty &&
        _imageList.any((element) => element != null)) {
      ConstantFunctions.showLoadingDialog(context);
      List<String> imageList = [];
      final AppUser user = widget.appUser;
      if (_imageList.isEmpty ||
          _titleController.text.isEmpty ||
          _descriptionController.text.isEmpty) {
        Navigator.of(context).pop();
        ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
            KColors.kWhiteColor, Strings.mustAddPhotoAndFilters);
        return;
      }

      if (_imageList != _copyImageList) {
        List<int> listToDelete = [];
        final String dateTime = DateTime.now().toString();
        for (int i = 0; i < _imageList.length; i++) {
          if (_imageList[i] is File) {
            imageList.add(await Server.putNoteImage(
                user.id, dateTime, i, _imageList[i]!));
            if (_copyImageList[i] != null) {
              listToDelete.add(i);
            }
          } else if (_imageList[i] is String) {
            imageList.add(_imageList[i]);
          }
        }
        for (int element in listToDelete) {
          Server.deleteImageFromDatabase(_copyImageList[element]);
        }
      } else {
        for (dynamic element in _imageList) {
          if (element is String) {
            imageList.add(element);
          }
        }
      }

      _formKey.currentState!.save();
      final Note note = Note(
        id: previousNote.id,
        name: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        pictures: imageList,
        filter: _filterOwn,
        createdBy: previousNote.createdBy,
        idCreatedBy: previousNote.idCreatedBy,
        school: user.school,
      );
      final String titleDesc =
          '${note.name.toLowerCase()} ${note.description.toLowerCase()}';
      List<String> splitList = titleDesc.split(" ");
      List<String> indexList = [];
      for (int i = 0; i < splitList.length; i++) {
        for (int y = 1; y < splitList[i].length + 1; y++) {
          if (y > 3 && y < 12) {
            indexList.add(splitList[i].substring(0, y).toLowerCase());
          }
        }
      }
      Server.editNote(note, indexList).then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });

      widget.editNote!(note);
    } else {
      ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
          KColors.kWhiteColor, Strings.mustChooseASubject);
    }
  }

  void _addCollageFilter(String text) {
    for (String element in SubjectType.collageTypes) {
      if (element.toLowerCase() == text.toLowerCase()) {
        text = element;
        _filterOwn.listOfType.add(text);
        _toUpdate2.value += 1;
        return;
      }
    }

    ConstantFunctions.showSnackBar(
        context, KColors.kErrorColor, KColors.kWhiteColor, Strings.wrongData);
    return;
  }

  void _swapImageInArray(int pos1, int pos2) {
    final dynamic x = _imageList[pos1];
    _imageList[pos1] = _imageList[pos2];
    _imageList[pos2] = x;
    setState(() {});
  }

  void _createNote(BuildContext context) async {
    final bool isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid &&
        _descriptionController.text.isNotEmpty &&
        _titleController.text.isNotEmpty &&
        _filterOwn.level.isNotEmpty &&
        _imageList.any((element) => element != null)) {
      ConstantFunctions.showLoadingDialog(context);

      List<String> stringPicture = [];
      final String uniqueKey = UniqueKey().toString();
      final String dateTime = DateTime.now().toString();
      final AppUser user = widget.appUser;

      _formKey.currentState!.save();
      final Note note = Note(
        id: '${user.id}*~~@(*%&%#$dateTime$uniqueKey',
        name: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        pictures: stringPicture,
        filter: _filterOwn,
        createdBy: user,
        idCreatedBy: user.id,
        school: user.school,
      );
      final String titleDesc =
          '${note.name.toLowerCase()} ${note.description.toLowerCase()}';
      List<String> splitList = titleDesc.split(" ");
      List<String> indexList = [];
      for (int i = 0; i < splitList.length; i++) {
        for (int y = 1; y < splitList[i].length + 1; y++) {
          if (y > 2 && y < 12) {
            indexList.add(splitList[i].substring(0, y).toLowerCase());
          }
        }
      }
      if (_imageList.isNotEmpty && note.filter.listOfType.isNotEmpty) {
        for (int i = 0; i < _imageList.length; i++) {
          if (_imageList[i] != null) {
            stringPicture.add(await Server.putNoteImage(
                user.id, dateTime, i, _imageList[i]!));
          }
        }
        await Server.createNote(note, indexList).then((value) async {
          const String isShownKey = 'isShownKey';

          await SharedPreferences.getInstance().then((value) {
            value.setInt(isShownKey, 2);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            widget.onCreate(note);
          });
        }).onError((error, stackTrace) {
          Navigator.of(context).pop();
          ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
              KColors.kWhiteColor, Strings.anErrorOccurred);
        });
      } else {
        Navigator.of(context).pop();
        ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
            KColors.kWhiteColor, Strings.mustAddPhotoAndFilters);
        return;
      }
    } else {
      ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
          KColors.kWhiteColor, Strings.mustChooseASubject);
    }
  }

  void _setData() async {
    final Note? note = widget.note;
    _filterOwn.school = widget.appUser.school;
    if (note != null) {
      _titleController.text = note.name;
      _descriptionController.text = note.description;
      _filterOwn = note.filter;
      int x = 0;
      for (String element in note.pictures) {
        _imageList[x] = element;
        _copyImageList[x] = element;
        x++;
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _setData();
  }

  void _openLevelDialog(Size size) async {
    FocusScope.of(context).unfocus();
    String listOfLevel = _filterOwn.level;
    final ValueNotifier<int> valueNotifier = ValueNotifier(0);
    await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (ctx, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: size.height * 0.5,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              color: KColors.kBackgroundColor,
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.all(20),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    Strings.chooseLevelOfNote,
                    style: TextStyle(
                      color: KColors.kTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: _defaultSize * 3),
                  ValueListenableBuilder(
                    valueListenable: valueNotifier,
                    builder: (_, __, ___) {
                      return Column(
                        children: [
                          CheckboxListTile(
                            value: listOfLevel == Strings.primarySchool,
                            onChanged: (value) {
                              if (value != null) {
                                if (value) {
                                  listOfLevel = Strings.primarySchool;
                                } else {
                                  listOfLevel = '';
                                }
                              }
                              valueNotifier.value += 1;
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            checkColor: KColors.kButtonColorPurple,
                            tileColor: KColors.kBlackColor,
                            activeColor: KColors.kBackgroundColor,
                            title: const Text(
                              Strings.primarySchool,
                              style: TextStyle(
                                fontSize: 16,
                                color: KColors.kTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CheckboxListTile(
                            value: listOfLevel == Strings.secondarySchool,
                            onChanged: (value) {
                              if (value != null) {
                                if (value) {
                                  listOfLevel = Strings.secondarySchool;
                                } else {
                                  listOfLevel = '';
                                }
                              }
                              valueNotifier.value -= 1;
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            tileColor: KColors.kBlackColor,
                            activeColor: KColors.kBackgroundColor,
                            checkColor: KColors.kButtonColorPurple,
                            title: const Text(
                              Strings.secondarySchool,
                              style: TextStyle(
                                fontSize: 16,
                                color: KColors.kTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CheckboxListTile(
                            value: listOfLevel == Strings.highSchool,
                            onChanged: (value) {
                              if (value != null) {
                                if (value) {
                                  listOfLevel = Strings.highSchool;
                                } else {
                                  listOfLevel = '';
                                }
                              }
                              valueNotifier.value += 1;
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            tileColor: KColors.kBlackColor,
                            activeColor: KColors.kBackgroundColor,
                            checkColor: KColors.kButtonColorPurple,
                            title: const Text(
                              Strings.highSchool,
                              style: TextStyle(
                                fontSize: 16,
                                color: KColors.kTextColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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

    _toUpdate.value += 1;
    _toUpdate2.value += 1;
    _filterOwn.level = listOfLevel;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: KColors.kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          Strings.addNote,
          style: TextStyle(
            color: KColors.kWhiteColor,
          ),
        ),
        elevation: 0,
        backgroundColor: KColors.kPrimaryColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: KColors.kWhiteColor,
          ),
        ),
        actions: [
          if (widget.deleteNote != null)
            IconButton(
              onPressed: () {
                if (widget.note != null) {
                  _deleteItem(widget.note!);
                }
              },
              icon: const Icon(
                Icons.delete_forever_outlined,
                color: KColors.kErrorColor,
                size: 28,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Container(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.55,
                    width: size.width,
                    child: ScrollImagePicker(
                      size: size,
                      imageList: _imageList,
                      getImage: _getImage,
                      swapImage: _swapImageInArray,
                    ),
                  ),
                  SizedBox(
                    height: _defaultSize * 2,
                  ),
                  RoundedInputField(
                    hintText: Strings.title,
                    icon: Icons.title,
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                    },
                    controller: _titleController,
                    type: 'Title',
                    onSaved: (value) {},
                    textInputAction: TextInputAction.next,
                    inputType: TextInputType.name,
                    isPassword: false,
                  ),
                  SizedBox(
                    height: _defaultSize,
                  ),
                  RoundedInputField(
                    hintText: Strings.description,
                    icon: Icons.description,
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                    },
                    controller: _descriptionController,
                    type: 'Description',
                    onSaved: (value) {},
                    textInputAction: TextInputAction.newline,
                    inputType: TextInputType.multiline,
                    maxLines: 5,
                    isPassword: false,
                    i: 1,
                  ),
                  SizedBox(
                    height: _defaultSize * 3,
                  ),
                  OutlineButtonOwn(
                    defaultSize: _defaultSize,
                    onTap: () {
                      _openLevelDialog(size);
                    },
                    text: Strings.addLevel,
                    icon: Icons.add_chart_rounded,
                    width: size.width * 0.8,
                  ),
                  SizedBox(
                    height: _defaultSize * 3,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _toUpdate2,
                    builder: (_, __, ___) {
                      List<dynamic> listText = _filterOwn.listOfType
                          .where((element) =>
                              SubjectType.collageTypes.contains(element))
                          .toList();
                      if (!_filterOwn.level.contains(Strings.highSchool)) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          TextFieldWithSuggestions(
                            onChange: _addCollageFilter,
                            text: Strings.addDepartament,
                            onAdd: _addCollageFilter,
                          ),
                          SizedBox(
                            height: _defaultSize * 1.8,
                          ),
                          SizedBox(
                            width: size.width,
                            height: 50,
                            child: ListView.builder(
                              itemCount: listText.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, i) {
                                return FilterItem(
                                  text: listText[i],
                                  onTap: (text) {
                                    _filterOwn.listOfType.remove(text);
                                    _toUpdate2.value -= 1;
                                  },
                                  isInList: true,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: _defaultSize * 3,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _toUpdate,
                    builder: (_, __, ___) {
                      List<String> list = [];
                      if (_filterOwn.level.contains(Strings.secondarySchool) ||
                          _filterOwn.level.contains(Strings.primarySchool)) {
                        for (String element in SubjectType.subjectTypes) {
                          list.add(element);
                        }
                      }
                      return SizedBox(
                        height: list.isEmpty ? 0 : 210,
                        child: ThreeScrollWidget(
                          list: list,
                          widget: (i) {
                            return FilterItem(
                              onTap: (String text) {
                                if (_filterOwn.listOfType.contains(text)) {
                                  _filterOwn.listOfType.remove(text);
                                } else {
                                  _filterOwn.listOfType.add(text);
                                }
                                _toUpdate.value += 1;
                              },
                              text: list[i],
                              isInList: _filterOwn.listOfType.contains(
                                list[i],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: _defaultSize * 3,
                  ),
                  DefaultButton(
                    defaultSize: _defaultSize,
                    onTap: () {
                      if (widget.note == null) {
                        _createNote(context);
                      } else {
                        _editNote(context);
                      }
                    },
                    text: widget.note == null
                        ? Strings.addNote
                        : Strings.editNote,
                    icon: Icons.add_rounded,
                    gradient: ConstantFunctions.defaultGradient(),
                  ),
                  SizedBox(
                    height: _defaultSize * 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
