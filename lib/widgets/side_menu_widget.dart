import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_back/data/side_menu_data.dart';
import '../const/constant.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Color.fromARGB(255, 7, 25, 40),
      child: ListView.builder(
        itemCount: data.menu.length,
        itemBuilder: (context, index) => buildMenuEntry(data, index),
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
        color: isSelected ? selectionColor : Colors.transparent,
      ),
      child: InkWell(
        onTap: () { 
          setState(() {
          selectedIndex = index;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => data.menu[index].page),
          );
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              child: Icon(
                data.menu[index].icon,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              data.menu[index].title,
               style:GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              ),
              // TextStyle(
              //   fontSize: 16,
              //   color: isSelected ? Colors.black : Colors.grey,
              //   fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              // ),
            )
          ],
        ),
      ),
    );
  }
}