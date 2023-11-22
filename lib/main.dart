import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:money_plus_app/user_main.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  void _verificarCredenciales(BuildContext context) async {
    String usuario = usuarioController.text;
    String contrasena = contrasenaController.text;

    try {
      // Consultar Firestore para buscar un usuario con el nombre de usuario dado
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('usuario', isEqualTo: usuario)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Se encontró un usuario con el nombre de usuario proporcionado
        QueryDocumentSnapshot userDoc = querySnapshot.docs[0];
        print(userDoc.id);
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        if (userData['contrasena'] == contrasena) {
          // Contraseña válida
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserMain(userDocId:userDoc.id.toString()),
            ),
          );
        } else {
          // Contraseña incorrecta
          _mostrarMensaje('Contraseña incorrecta');
        }
      } else {
        // No se encontró un usuario con el nombre de usuario proporcionado
        _mostrarMensaje('Usuario no encontrado');
      }
    } catch (e) {
      // Manejar cualquier error
      print('Error: $e');
    }
  }

  void _mostrarMensaje(String mensaje) {
    Fluttertoast.showToast(
      msg: mensaje,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 165, 48, 39),
      textColor: Colors.white,
      fontSize: 23.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: usuarioController,
            decoration: InputDecoration(labelText: 'Usuario'),
          ),
          TextFormField(
            controller: contrasenaController,
            decoration: InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () => _verificarCredenciales(context),
            child: Text('Ingresar'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     // Lógica para recuperar contraseña
          //   },
          //   child: Text('¿Olvidaste tu contraseña?'),
          // ),
        ],
      ),
    );
  }
} 


class RegisterForm extends StatelessWidget {
  // Controladores para los TextFormField
  TextEditingController nombreController = TextEditingController();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  final emailValidator = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  @override
  Widget build(BuildContext context) {
    void _mostrarSnackBar(String mensaje) {
      Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blue, // Puedes ajustar el color de fondo
        textColor: Colors.white, // Puedes ajustar el color del texto
        fontSize: 16.0,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
        crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente
        children: [
          TextFormField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: usuarioController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                // Validar formato de correo electrónico
                if (!emailValidator.hasMatch(value!)) {
                  return 'Ingresa un correo electrónico válido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: contrasenaController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
              validator: (value) {
                // Validar longitud de la contraseña
                if (value!.length != 8) {
                  return 'La contraseña debe tener exactamente 8 caracteres';
                }
                return null;
              },
            ),
          ElevatedButton(
            onPressed: () {
              createUser(
                nombre: nombreController.text,
                usuario: usuarioController.text,
                email: emailController.text,
                contrasena: contrasenaController.text,
              ).then((guardadoCorrecto) {
                if (guardadoCorrecto) {
                  _mostrarSnackBar('Usuario guardado correctamente');
                  // Recargar la pantalla después de un breve retraso
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                    );
                  });
                } else {
                  _mostrarSnackBar('Error al guardar el usuario');
                }
              });
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
  Future <bool> createUser({
    required String nombre,
    required String usuario,
    required String email,
    required String contrasena,
  }) async {
    try {
      final docUser = FirebaseFirestore.instance.collection('users').doc();

      final json = {
        'nombre': nombre,
        'usuario': usuario,
        'email': email,
        'contrasena': contrasena
      };

      await docUser.set(json);

      // Usuario guardado correctamente
      return true;
    } catch (e) {
      // Error al guardar el usuario
      print('Error al guardar el usuario: $e');
      return false;
    }
  }
  

}