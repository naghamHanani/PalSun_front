import 'package:flutter/widgets.dart';


class MenuModel{
  final IconData icon;
  final String title;
  final Widget page;

  const MenuModel({required this.icon, required this.title, required this.page});
}