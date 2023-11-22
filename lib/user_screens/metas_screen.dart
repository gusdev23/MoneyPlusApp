import 'package:flutter/material.dart';
import 'package:money_plus_app/user_views/meta_dashboard_view.dart';

class MetasceScreen extends StatelessWidget{
  final String DocId;

  MetasceScreen({required this.DocId});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MetasView(DocId: DocId),
    );
  }
}