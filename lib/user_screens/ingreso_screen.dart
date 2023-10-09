import 'package:flutter/material.dart';
import 'package:money_plus_app/user_views/ingreso_add_view.dart';
import 'package:money_plus_app/user_views/ingreso_dashboard_view.dart';
import 'package:money_plus_app/user_views/ingreso_update_view.dart';

class IngresoScreen extends StatelessWidget{
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
              IngresoDashboardView(),
              IngresoAddView(),
              IngresoUpdateView(),
            ],
          ),
        ),
      ),
    );
  }
}