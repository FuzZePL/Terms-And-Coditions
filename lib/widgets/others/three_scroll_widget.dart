import 'package:flutter/material.dart';

class ThreeScrollWidget extends StatefulWidget {
  const ThreeScrollWidget({
    super.key,
    required this.list,
    required this.widget,
  });
  final List<String> list;
  final Widget Function(int) widget;

  @override
  State<ThreeScrollWidget> createState() => _ThreeScrollWidgetState();
}

class _ThreeScrollWidgetState extends State<ThreeScrollWidget> {
  List<String> _listOne = [];
  List<String> _listTwo = [];
  List<String> _listThree = [];

  void _setList() {
    final List<String> initialList = widget.list;

    _listOne =
        initialList.sublist(2 * (initialList.length ~/ 3), initialList.length);
    _listTwo = initialList.sublist(
        initialList.length ~/ 3, 2 * (initialList.length ~/ 3));
    _listThree = initialList.sublist(0, initialList.length ~/ 3);
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ThreeScrollWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setList();
  }

  @override
  void initState() {
    super.initState();
    _setList();
  }

  @override
  Widget build(BuildContext context) {
    final Widget Function(int) widgetBuild = widget.widget;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _listOne.length,
              itemBuilder: (_, index) {
                return widgetBuild(index);
              },
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 60,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _listTwo.length,
              itemBuilder: (_, index) {
                return widgetBuild(_listOne.length + index);
              },
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 60,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _listThree.length,
              itemBuilder: (_, index) {
                return widgetBuild(_listOne.length + _listTwo.length + index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
