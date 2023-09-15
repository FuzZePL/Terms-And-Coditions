import 'package:donotnote/databases/subject_type.dart';
import 'package:donotnote/models/filter.dart';
import 'package:donotnote/models/note.dart';
import 'package:donotnote/screens/note_screen.dart';
import 'package:donotnote/widgets/buttons/on_back_pressed.dart';
import 'package:donotnote/widgets/items/filter_item.dart';
import 'package:donotnote/widgets/items/note_item/note_item_main.dart';
import 'package:donotnote/widgets/morpheus/morpheus_page_route.dart';
import 'package:donotnote/widgets/others/three_scroll_widget.dart';
import 'package:donotnote/widgets/shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.query,
    required this.user,
  });
  final String query;
  final AppUser user;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Note> _resuts = [];
  final FilterOwn _filterOwn =
      FilterOwn(UniqueKey().toString(), [], false, '', '');
  bool _isLoading = true;
  final double _defaultSize = SizeConfig.defaultSize!;
  final TextEditingController _controller = TextEditingController();

  void _moveToNoteScreen(Note note) {
    Navigator.of(context).push(
      MorpheusPageRoute(
        builder: (_) {
          return NoteScreen(
            note: note,
            appUser: widget.user,
          );
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext ctx, double width, double height) {
    // TODO implement filters like in add note screen
    FocusScope.of(context).unfocus();
    String listOfLevel = _filterOwn.level;
    final ValueNotifier<int> valueNotifier = ValueNotifier(0);
    final ValueNotifier<int> toUpdate = ValueNotifier(0);
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: KColors.kBackgroundColor,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: toUpdate,
          builder: (_, __, ___) {
            return Container(
              alignment: Alignment.topCenter,
              height: height * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    const Text(
                      Strings.filters,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: KColors.kTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      child: CheckboxListTile(
                        value: _filterOwn.onlyFromYourSchool,
                        onChanged: (val) {
                          _filterOwn.onlyFromYourSchool = val!;
                          toUpdate.value -= 1;
                        },
                        checkColor: Colors.white,
                        activeColor: KColors.kButtonColorYellow,
                        tileColor: KColors.kBlackColor,
                        title: const Text(
                          Strings.onlyInYourSchool,
                          style: TextStyle(
                            fontSize: 18,
                            color: KColors.kTextColor,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        Strings.chooseLevelOfNote,
                        style: TextStyle(
                          color: KColors.kTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: _defaultSize * 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      child: ValueListenableBuilder(
                        valueListenable: valueNotifier,
                        builder: (_, __, ___) {
                          return Column(
                            children: [
                              CheckboxListTile(
                                value: listOfLevel == Strings.primarySchool,
                                onChanged: (value) {
                                  if (value != null) {
                                    if (value) {
                                      listOfLevel = (Strings.primarySchool);
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
                    ),
                    SizedBox(height: _defaultSize),
                    ValueListenableBuilder(
                      valueListenable: valueNotifier,
                      builder: (_, __, ___) {
                        List<String> list = [];
                        if (listOfLevel.contains(Strings.secondarySchool) ||
                            listOfLevel.contains(Strings.primarySchool)) {
                          for (String element in SubjectType.subjectTypes) {
                            list.add(element);
                          }
                        }
                        if (listOfLevel.contains(Strings.highSchool)) {
                          for (String element in SubjectType.collageTypes) {
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
                                  valueNotifier.value += 1;
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
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      _filterOwn.level = listOfLevel;
      if (listOfLevel.isEmpty) {
        _filterOwn.listOfType = [];
      }
      _applyFilter();
    });
  }

  void _applyFilter() {
    setState(() {
      _isLoading = true;
    });
    _getData();
  }

  void _getData() async {
    _filterOwn.school = widget.user.school;
    _resuts = await Server.onSearch(
        _controller.text.toLowerCase().trim(), _filterOwn);
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _isLoading = false;
    });
  }

  void _search(String query) async {
    setState(() {
      _isLoading = true;
    });
    _resuts = await Server.onSearch(query.toLowerCase().trim(), _filterOwn);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.text = widget.query;
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KColors.kBackgroundColor,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Shimmer(
          linearGradient: KColors.shimmerGradient,
          child: Column(
            children: [
              SizedBox(height: _defaultSize * 5),
              SizedBox(
                width: size.width,
                height: _defaultSize * 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OnBackPressed(
                      icon: Icons.arrow_back_ios_new_outlined,
                      onBackPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 48,
                      width: size.width - _defaultSize * 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 10,
                            spreadRadius: -5,
                            color: KColors.kBlackColor,
                          ),
                        ],
                      ),
                      child: TextField(
                        autocorrect: true,
                        controller: _controller,
                        textAlignVertical: TextAlignVertical.center,
                        onSubmitted: _search,
                        onChanged: (value) {},
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: Strings.search,
                          hintStyle: TextStyle(
                            color: KColors.kPrimaryColor.withOpacity(0.5),
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search_sharp),
                            onPressed: () {
                              _search(_controller.text);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: _defaultSize * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showFilterSheet(
                        context,
                        size.width,
                        size.height,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.align_horizontal_right_rounded,
                            size: 28,
                            color: KColors.kTextColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            Strings.filters2,
                            style: TextStyle(
                              fontSize: 20,
                              color: KColors.kTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: _defaultSize * 2),
              Expanded(
                child: ListView.builder(
                  itemCount: _isLoading ? 5 : _resuts.length,
                  itemBuilder: (_, i) {
                    bool isYourSchool = false;
                    Note? note = _isLoading ? null : _resuts[i];
                    if (note != null) {
                      if (widget.user.school == note.school) {
                        isYourSchool = true;
                      }
                    }

                    return NoteItemMain(
                      note: _isLoading ? null : note,
                      size: size,
                      onTap: _moveToNoteScreen,
                      isYourSchool: isYourSchool,
                      i: i,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
