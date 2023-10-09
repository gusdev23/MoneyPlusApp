import 'package:flutter/material.dart';
import 'package:money_plus_app/user_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money+',
      home: MiCuentaView(),
    );
  }
}






class MiCuentaView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Aquí desactivamos la etiqueta de depuración
      home: DefaultTabController(
        length: 2, // Número de pestañas (Inicio de sesión y Registro)
        child: Scaffold(
          appBar: AppBar(
            title: Text('Money+',
            style: TextStyle(color: Color.fromARGB(255, 175, 169, 84), 
            ),),
            backgroundColor: Color(0xFF041F33),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(text: 'Iniciar sesión'),
                Tab(text: 'Registrarse'),
              ],
            ),
            toolbarHeight: 40.0,
          ),
          body: TabBarView(
            children: [
              LoginForm(),
              RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}


class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
        crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Usuario'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserMain(),
                ),
              );
            },
            child: Text('Ingresar'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black), // Color de fondo del botón
            ),
          ),
          TextButton(
            onPressed: () {
              // Lógica para recuperar contraseña
            },
            
            child: Text('¿Olvidaste tu contraseña?'),
          ),
        ],
      ),
    );
  }
} 


class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
        crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Usuario'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Confirmar contraseña'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              // Lógica para registrar usuario
            },
            child: Text('Registrar usuario'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black), // Color de fondo del botón
            ),
          ),
        ],
      ),
    );
  }
}