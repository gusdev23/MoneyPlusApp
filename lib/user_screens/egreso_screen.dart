import 'package:flutter/material.dart';
import 'package:money_plus_app/user_views/egreso_add_view.dart';
import 'package:money_plus_app/user_views/egreso_dashboard_view.dart';
import 'package:money_plus_app/user_views/egreso_update_view.dart';

class EgresoScreen extends StatelessWidget{
  final String DocId;
  EgresoScreen({required this.DocId});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Aquí desactivamos la etiqueta de depuración
      home: DefaultTabController(
        length: 3, // Número de pestañas (Inicio de sesión y Registro)
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF041F33),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home),),
                Tab(icon: Icon(Icons.add_circle_outline_sharp),),
                Tab(icon: Icon(Icons.edit_note_outlined),),
              ],
            ),
            toolbarHeight: 5.0,
          ),
          body: TabBarView(
            children: [
              EgresoDashboardView(DocId: DocId),
              EgresoAddView(DocId: DocId),
              EgresoUpdateView(DocId: DocId),
            ],
          ),
        ),
      ),
    );
  }
}