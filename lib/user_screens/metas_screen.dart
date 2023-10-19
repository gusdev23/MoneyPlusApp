import 'package:flutter/material.dart';
import 'package:money_plus_app/user_views/meta_dashboard_view.dart';

class MetasceScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MetasView(),
    );
  }
}