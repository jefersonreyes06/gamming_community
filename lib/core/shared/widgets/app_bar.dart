import 'package:flutter/material.dart';

class Encabezado extends StatelessWidget implements PreferredSizeWidget
{
  final Color backgroundColor;
  final String title;
  final List<Widget>? actions;
  final bool haveDrawer;

  const Encabezado({
    super.key,
    required this.backgroundColor,
    required this.title,
    this.actions,
    this.haveDrawer = false,
  }); //: super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Text(title, style: TextStyle(color: Colors.white),),
      actions: actions,
      leading: haveDrawer ? IconButton(onPressed: () {Scaffold.of(context).openDrawer();}, icon: Icon(Icons.message_rounded)) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}