import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealmate_dashboard/features/home/controllers/app_controller.dart';
import 'package:mealmate_dashboard/features/home/views/main/sidemenu/sections_enum.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            sectionName: Sections.dashboard,
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {

            },
          ),
          DrawerListTile(
            sectionName: Sections.recipes,
            svgSrc: "assets/icons/menu_recipe.svg",
            press: () {},
          ),
          DrawerListTile(
            sectionName: Sections.ingredients,
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {},
          ),
          DrawerListTile(
            sectionName: Sections.nutritional,
            svgSrc: "assets/icons/menu_task.svg",
            press: () {},
          ),

          DrawerListTile(
            sectionName: Sections.categoriesIngredients,
            svgSrc: "assets/icons/menu_task.svg",
            press: () {},
          ),
          DrawerListTile(
            sectionName: Sections.categories,
            svgSrc: "assets/icons/menu_task.svg",
            press: () {},
          ),
          DrawerListTile(
            sectionName: Sections.types,
            svgSrc: "assets/icons/menu_task.svg",
            press: () {},
          ),
          DrawerListTile(
            sectionName: Sections.units,
            svgSrc: "assets/icons/menu_task.svg",
            press: () {},
          ),

          DrawerListTile(
            sectionName: Sections.notifications,
            svgSrc: "assets/icons/menu_notifications.svg",
            press: () {},
          ),

        ],
      ),
    );
  }

}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.svgSrc,
    required this.press,
    required this.sectionName,
  }) : super(key: key);

  final String  svgSrc;
  final Sections sectionName;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    AppController menuAppController = Provider.of<AppController>(context);

    return ListTile(
      onTap: (){
        press();
        menuAppController.changeSelectedSection(newSection: sectionName);
      },
      horizontalTitleGap: 0.0,
      tileColor:menuAppController.selectedSection == sectionName ? Colors.white.withOpacity(0.2): Colors.transparent,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        upperFirstLetter(sectionName.name.tr()),
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
  String upperFirstLetter(String value) => value.length>0?"${value[0].toUpperCase()}${value.substring(1)}":"";

}
