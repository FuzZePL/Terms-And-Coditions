import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:flutter/material.dart';

class UserAccoutDetailItem extends StatefulWidget {
  const UserAccoutDetailItem({
    Key? key,
    required this.name,
    required this.onClick,
    required this.icon,
    required this.i,
  }) : super(key: key);

  final String name;
  final VoidCallback onClick;
  final Icon icon;
  final int i;

  @override
  State<UserAccoutDetailItem> createState() => _UserAccoutDetailItemState();
}

class _UserAccoutDetailItemState extends State<UserAccoutDetailItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(-1, 0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.decelerate),
  );

  void _playAnimation() {
    Future.delayed(Duration(milliseconds: 100 + (50 * widget.i))).then((value) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _playAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double defaultSize = SizeConfig.defaultSize!;
    return SlideTransition(
      position: _offsetAnimation,
      child: InkWell(
        onTap: widget.onClick,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: defaultSize * 2,
            vertical: defaultSize * 3,
          ),
          child: Row(
            children: [
              widget.icon,
              SizedBox(
                width: defaultSize * 2,
              ),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: defaultSize * 1.7,
                  color: KColors.kTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: defaultSize * 1.6,
                color: KColors.kTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
