import 'package:calendar_meeting_creator/ui/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:calendar_meeting_creator/ui/pages/home/home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Meeting Creator',
      theme: AppStyles.defaultTheme, 
      home: const HomePage(),
    );
  }
}
