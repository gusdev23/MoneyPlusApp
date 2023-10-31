import 'package:flutter/material.dart';
import 'package:money_plus_app/main.dart';
import 'package:money_plus_app/user_screens/balance_screen.dart';
import 'package:money_plus_app/user_screens/egreso_screen.dart';
import 'package:money_plus_app/user_screens/ingreso_screen.dart';
import 'package:money_plus_app/user_screens/metas_screen.dart';


class UserMain extends StatefulWidget {
  @override
  _UserMain createState() => _UserMain();
}

class _UserMain extends State<UserMain> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    IngresoScreen(),
    EgresoScreen(),
    BalanceScreen(),
    MetasceScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Money+',
            style: TextStyle(
              color: Color.fromARGB(255, 175, 169, 84),
              fontSize: 27.0,
            ),
          ),
          backgroundColor: Color(0xFF041F33),
          centerTitle: true,
          toolbarHeight: 40.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white, // Cambia el color del icono aquí
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
            ),
          ],
        ),
        
        body: AnimatedSwitcher(
        duration: Duration(milliseconds: 900),
        child: _widgetOptions[_selectedIndex],),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.money),
              label: 'Ingresos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money_off),
              label: 'Egresos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.balance),
              label: 'Balance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flag),
              label: 'Metas',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 175, 169, 84),
          unselectedItemColor: Color(0xFF041F35),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}