import 'package:api_learn/utils/color/my_app_color.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color? bgColor;
  final bool centerTitle;
  final bool isBack;
  final double? elevation;
  final String? title;
  final Widget? titleWidget;
  final Color? titleColor;
  final double? titleFontSize;
  final List<Widget>? actions;
  final VoidCallback? backOnTap;

  const MyAppBar({
    super.key,
    this.title,
    this.centerTitle = false,
    this.isBack = true,
    this.elevation = 0.0,
    this.bgColor,
    this.titleFontSize,
    this.titleColor,
    this.actions,
    this.backOnTap,
    this.titleWidget,
  });

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(57);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.bgColor ?? MyAppColor.primaryColor,
      centerTitle: widget.centerTitle,
      elevation: widget.elevation,
      titleSpacing: 6,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          children: [
            if (widget.isBack)
              InkWell(
                onTap: widget.backOnTap ??
                    () {
                      Navigator.of(context).pop();
                    },
                child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back)),
              ),
          ],
        ),
      ),
      title: widget.titleWidget ??
          Text(
            widget.title ?? '',
            style: TextStyle(
              fontSize: widget.titleFontSize ?? 16,
              fontWeight: FontWeight.w600,
              color: widget.titleColor ?? MyAppColor.whiteColor,
            ),
          ),
      actions: widget.actions ?? [],
    );
  }
}
