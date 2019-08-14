import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:sportsfilter/screens/widgets/main_container.dart';
import 'package:sportsfilter/screens/widgets/my_appbar.dart';

class ScreenHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      // drawer: MainDrawer(),
      //bottomNavigationBar: MyBottomBar(),
      body: MainContainer(),
    );
  }
}
